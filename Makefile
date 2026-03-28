# ──────────────────────────────────────────────────────────────
# Makefile
#
# Short commands for common repo workflows.
# Run any target with:  make <target>
#
# Instructor-owned file — students should NOT need to edit this.
# ──────────────────────────────────────────────────────────────

.PHONY: up down logs ps rebuild dev backend frontend neo4j pipeline graph-load clean

# ── Full stack ───────────────────────────────────────────────

up:
	@echo "▶ Starting all services (frontend + backend + neo4j)..."
	docker compose up --build -d
	@echo "✓ Services running.  Use 'make logs' to follow output."

down:
	@echo "▶ Stopping all services..."
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

rebuild:
	@echo "▶ Rebuilding images from scratch (no cache)..."
	docker compose build --no-cache

dev:
	@echo "▶ Starting all services in foreground (Ctrl+C to stop)..."
	docker compose up --build

# ── Individual services ──────────────────────────────────────

backend:
	@echo "▶ Starting backend + neo4j..."
	docker compose up --build backend

frontend:
	@echo "▶ Starting frontend (depends on backend)..."
	docker compose up --build frontend

neo4j:
	@echo "▶ Starting neo4j only..."
	docker compose up neo4j

# ── Data team targets ────────────────────────────────────────

pipeline:
	@echo "▶ Running data pipeline (validate → clean → build CSVs)..."
	python data_team/processing/validate_raw_telemetry.py
	python data_team/processing/clean_raw_telemetry.py
	python data_team/processing/build_sessions_csv.py
	python data_team/processing/build_states_csv.py
	@echo "✓ Pipeline complete."

graph-load:
	@echo "▶ Loading graph-ready CSVs into Neo4j..."
	python data_team/graph/load_to_neo4j.py
	@echo "✓ Graph load complete."

# ── Housekeeping ─────────────────────────────────────────────

clean:
	@echo "▶ Stopping containers and removing volumes..."
	docker compose down -v
