#!/usr/bin/env sh
# ──────────────────────────────────────────────────────────────
# scripts/run_backend.sh
#
# Start the FastAPI backend (and its Neo4j dependency) via Docker.
#
# Usage:  sh scripts/run_backend.sh
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────
set -eu

echo "▶ Starting backend + neo4j..."
docker compose up --build backend
