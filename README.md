# BlazeDemo Performance Tests

Projeto de teste de performance desenvolvido com Apache JMeter para o fluxo de compra de passagem aérea do [BlazeDemo](https://www.blazedemo.com).

Foram implementados dois cenários:

- teste de carga próximo a 250 requisições por segundo;
- teste de pico, elevando temporariamente a carga para aproximadamente 500 requisições por segundo.

## Critério de aceitação

O critério definido para o teste é:

```text
Throughput >= 250 requisições/s
90º percentil < 2000 ms
```

Também foi observada a taxa de erros durante as execuções.

## Fluxo testado

Cada compra executa quatro requisições:

```text
GET  /
POST /reserve.php
POST /purchase.php
POST /confirmation.php
```

O último passo valida a confirmação:

```text
Thank you for your purchase today!
```

Os dados do voo são extraídos dinamicamente da resposta da pesquisa e reutilizados nas etapas seguintes.

Como cada compra gera quatro requisições HTTP, a carga-base foi configurada em aproximadamente:

```text
63 fluxos/s × 4 requests
≈ 252 requests/s
```

## Estrutura

```text
.
├── jmeter/
│   ├── functional-validation.jmx
│   ├── load-test.jmx
│   └── spike-test.jmx
│
├── scripts/
│   ├── run-load.sh
│   ├── run-load.bat
│   ├── run-spike.sh
│   └── run-spike.bat
│
├── execution-evidence/
│   ├── load/
│   │   ├── report/
│   │   └── results.jtl
│   └── spike/
│       ├── report/
│       └── results.jtl
│
├── reports/
├── results/
└── README.md
```

`jmeter/` contém os planos de teste, `scripts/` contém os comandos de execução e `execution-evidence/` preserva os resultados utilizados na análise final.

## Pré-requisitos

- Java 11 ou superior compatível com o JMeter
- Apache JMeter 5.6.3
- comando `jmeter` disponível no `PATH`

Verificação:

```bash
jmeter -v
```

## Executando

### Git Bash / Linux / macOS

Carga:

```bash
./scripts/run-load.sh
```

Pico:

```bash
./scripts/run-spike.sh
```

### Windows CMD

Carga:

```cmd
scripts\run-load.bat
```

Pico:

```cmd
scripts\run-spike.bat
```

Os scripts executam o JMeter em modo não gráfico e geram:

```text
results/<teste>/results.jtl
reports/<teste>/index.html
```

## Teste de carga

Configuração principal:

```text
63 fluxos/s
≈ 252 requests/s

Duração:
180 segundos
```

Resultado:

| Métrica | Resultado |
|---|---:|
| Samples | 45.360 |
| Falhas | 7.164 |
| Error % | 15,79% |
| Average | 4.565,85 ms |
| Median | 1.507 ms |
| p90 | 10.988 ms |
| p95 | 11.573 ms |
| p99 | 11.867 ms |
| Max | 21.777 ms |
| Throughput | 227,56 req/s |

### Conclusão

O critério de aceitação **não foi atendido**.

```text
Throughput esperado >= 250 req/s
Obtido            = 227,56 req/s

p90 esperado      < 2000 ms
Obtido            = 10988 ms
```

Também foram observados **15,79% de erros**, indicando degradação significativa sob a carga-alvo.

## Teste de pico

O cenário foi configurado com:

```text
0–60 s
≈ 252 req/s

60–90 s
≈ 500 req/s

90–150 s
≈ 252 req/s
```

Resultado:

| Métrica | Resultado |
|---|---:|
| Samples | 45.240 |
| Falhas | 7.746 |
| Error % | 17,12% |
| Average | 4.866,59 ms |
| Median | 5.276,5 ms |
| p90 | 11.750 ms |
| p95 | 11.883 ms |
| p99 | 12.130,99 ms |
| Max | 16.208 ms |
| Throughput | 269,93 req/s |

Durante o pico houve aumento expressivo de latência, erros e requisições simultaneamente em processamento.

Mesmo após o retorno à carga-base, a aplicação continuou apresentando taxas elevadas de erro enquanto processava o backlog acumulado, indicando recuperação não imediata após o pico.

## Resultado final

A aplicação testada **não satisfez o critério de aceitação no ambiente avaliado**.

O teste de carga apresentou throughput inferior ao esperado, p90 aproximadamente 5,5 vezes acima do limite e 15,79% de erros.

O teste de pico reforçou a degradação observada, com p90 de 11,75 segundos e 17,12% de erros.

Os testes permitem identificar o comportamento externo da aplicação, porém não permitem determinar isoladamente a causa interna do gargalo. Uma investigação de causa raiz exigiria métricas adicionais de infraestrutura, aplicação, banco de dados e demais dependências.

## Evidências

Os resultados utilizados nesta análise estão preservados em:

```text
execution-evidence/load/
execution-evidence/spike/
```

Cada execução contém o arquivo `.jtl` e o relatório HTML gerado pelo JMeter.