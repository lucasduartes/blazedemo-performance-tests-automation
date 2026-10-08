#!/usr/bin/env bash

set -e

RESULT_DIR="results/spike"
REPORT_DIR="reports/spike"

rm -rf "$RESULT_DIR"
rm -rf "$REPORT_DIR"

mkdir -p "$RESULT_DIR"
mkdir -p "$REPORT_DIR"

echo "Running BlazeDemo spike test..."

jmeter -n \
  -t jmeter/spike-test.jmx \
  -JbaseRate=63 \
  -JtotalDuration=150 \
  -JgracePeriod=30 \
  -JspikeStart=60 \
  -JspikeExtraRate=62 \
  -JspikeDuration=30 \
  -JspikeTail=90 \
  -l "$RESULT_DIR/results.jtl" \
  -e \
  -o "$REPORT_DIR"

echo
echo "Spike test finished."
echo "JTL: $RESULT_DIR/results.jtl"
echo "HTML report: $REPORT_DIR/index.html"