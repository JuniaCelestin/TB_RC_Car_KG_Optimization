"""
Centralized configuration for the FastAPI backend (Neo4j + Google Gemini).
"""

from functools import lru_cache

from pydantic import AliasChoices, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


DEFAULT_GRAPH_SCHEMA = """
(Node labels and relationships will be filled in by the data team. Example placeholders:)
- (:Session {id, name, started_at})
- (:Lap {id, lap_number, duration_ms})
- (:Metric {name, unit})
Relationships might include: (Session)-[:HAS_LAP]->(Lap), (Lap)-[:HAS_VALUE]->(Metric)
Replace this text with your real schema in the GRAPH_SCHEMA environment variable.
""".strip()


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    neo4j_uri: str = "bolt://localhost:7687"
    neo4j_username: str = "neo4j"
    neo4j_password: str = "password"

    # Google AI Studio / Gemini API (free tier: https://aistudio.google.com/apikey)
    gemini_api_key: str = Field(
        default="",
        validation_alias=AliasChoices("GEMINI_API_KEY", "GOOGLE_API_KEY"),
        description="API key from Google AI Studio (Gemini Developer API)",
    )
    gemini_model: str = "gemini-2.0-flash"  # env: GEMINI_MODEL

    # Injected into the LLM system prompt so Cypher matches your graph
    graph_schema: str = DEFAULT_GRAPH_SCHEMA


@lru_cache
def get_settings() -> Settings:
    return Settings()
