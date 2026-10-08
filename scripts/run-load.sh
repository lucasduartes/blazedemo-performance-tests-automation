#!/usr/bin/env bash

set -e

RESULT_DIR="results/load"
REPORT_DIR="reports/load"

rm -rf "$RESULT_DIR"
rm -rf "$REPORT_DIR"

mkdir -p "$RESULT_DIR"
mkdir -p "$REPORT_DIR"

echo "Running BlazeDemo load test..."

jmeter -n \
  -t jmeter/load-test.jmx \
  -JflowRate=63 \
  -Jduration=180 \
  -JgracePeriod=30 \
  -l "$RESULT_DIR/results.jtl" \
  -e \
  -o "$REPORT_DIR"

echo
echo "Load test finished."
echo "JTL: $RESULT_DIR/results.jtl"
echo "HTML report: $REPORT_DIR/index.html"