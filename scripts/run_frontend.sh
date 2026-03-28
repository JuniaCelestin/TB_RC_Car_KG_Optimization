#!/usr/bin/env sh
# ──────────────────────────────────────────────────────────────
# scripts/run_frontend.sh
#
# Start the Vite frontend (and its backend dependency) via Docker.
#
# Usage:  sh scripts/run_frontend.sh
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────
set -eu

echo "▶ Starting frontend (+ backend + neo4j)..."
docker compose up --build frontend
