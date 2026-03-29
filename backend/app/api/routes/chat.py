"""
Chat endpoint: natural language → Gemini-generated Cypher → Neo4j → answer.

What is already done for you:
  - The router and route decorator are set up.
  - The ChatRequest/ChatResponse schemas are imported.
  - run_chat() is imported from chat_service (it does the heavy lifting).

What you need to implement:
  - Error handling so the API returns proper HTTP status codes instead of
    crashing with a generic 500.
"""

from fastapi import APIRouter, HTTPException
from neo4j.exceptions import Neo4jError

from app.models.schemas import ChatRequest, ChatResponse
from app.services.chat_service import run_chat

router = APIRouter(tags=["chat"])


@router.post("/chat", response_model=ChatResponse)
def post_chat(body: ChatRequest) -> ChatResponse:
    # TODO-1 (Required): Wrap the run_chat() call in a try/except block.
    #
    # Handle two error types:
    #   - ValueError  → return HTTP 503 with the error message as detail
    #                    (this fires when Gemini is not configured or returns bad output)
    #   - Neo4jError  → return HTTP 502 with "Neo4j error: <message>" as detail
    #                    (this fires when the generated Cypher fails against the database)
    #
    # Use FastAPI's HTTPException to return the right status code.
    # If no error occurs, just return the ChatResponse from run_chat().
    #
    # Hint:
    #   raise HTTPException(status_code=..., detail=str(...))

    return run_chat(body.message)
