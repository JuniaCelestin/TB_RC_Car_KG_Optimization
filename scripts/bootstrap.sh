#!/usr/bin/env sh
# ──────────────────────────────────────────────────────────────
# scripts/bootstrap.sh
#
# First-time setup helper for new contributors.
# Checks prerequisites, builds images, and starts the stack.
#
# Usage:  sh scripts/bootstrap.sh
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────
set -eu

echo "=== RC Car Graph Chatbot — Bootstrap ==="
echo ""

# ── Preflight checks ────────────────────────────────────────
check_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: '$1' is not installed or not on PATH."
    echo "       Please install $1 before continuing."
    exit 1
  fi
  echo "  ✓ $1 found"
}

echo "Checking prerequisites..."
check_cmd docker
check_cmd git

# Verify Docker daemon is running.
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker daemon is not running. Start Docker Desktop and retry."
  exit 1
fi
echo "  ✓ Docker daemon is running"
echo ""

# ── Build and start ─────────────────────────────────────────
echo "Building images (this may take a minute the first time)..."
docker compose build

echo ""
echo "Starting services in the background..."
docker compose up -d

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "  Frontend:  http://localhost:5173"
echo "  Backend:   http://localhost:8000"
echo "  Neo4j UI:  http://localhost:7474"
echo ""
echo "Run 'docker compose logs -f' to follow logs."
