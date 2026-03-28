#!/usr/bin/env sh
# ──────────────────────────────────────────────────────────────
# scripts/run_data_pipeline.sh
#
# Run the full data-team cleaning pipeline in sequence:
#   1. validate_raw_telemetry.py
#   2. clean_raw_telemetry.py
#   3. build_sessions_csv.py
#   4. build_states_csv.py
#
# Usage:  sh scripts/run_data_pipeline.sh
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────
set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "▶ Running data pipeline..."

echo "  Step 1/4: Validate raw telemetry"
python "$REPO_ROOT/data_team/processing/validate_raw_telemetry.py"

echo "  Step 2/4: Clean raw telemetry"
python "$REPO_ROOT/data_team/processing/clean_raw_telemetry.py"

echo "  Step 3/4: Build sessions CSV"
python "$REPO_ROOT/data_team/processing/build_sessions_csv.py"

echo "  Step 4/4: Build states CSV"
python "$REPO_ROOT/data_team/processing/build_states_csv.py"

echo "✓ Pipeline complete."
