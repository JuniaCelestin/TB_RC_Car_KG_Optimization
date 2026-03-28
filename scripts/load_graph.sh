#!/usr/bin/env sh
# ──────────────────────────────────────────────────────────────
# scripts/load_graph.sh
#
# Load graph-ready CSVs into the Neo4j database.
# Assumes Neo4j is already running (e.g. via `make up`).
#
# Usage:  sh scripts/load_graph.sh
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────
set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "▶ Loading graph-ready data into Neo4j..."
python "$REPO_ROOT/data_team/graph/load_to_neo4j.py"
echo "✓ Graph load complete."
