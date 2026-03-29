/**
 * frontend/src/types/chat.ts
 *
 * TypeScript types shared between frontend components and the API layer.
 * These must match the backend's Pydantic schemas in backend/app/models/schemas.py.
 *
 * What is already done for you:
 *   - The file structure and exports.
 *
 * What you need to implement:
 *   - Define the shape of ChatRequest and ChatResponse so TypeScript
 *     knows what the API expects and returns.
 */

// TODO-1 (Required): Define the ChatRequest and ChatResponse types.
//
// Look at backend/app/models/schemas.py to see what fields exist:
//
//   ChatRequest  has:  message (string, required)
//   ChatResponse has:  answer  (string, required)
//                      cypher  (string or null, optional — used for debugging)
//
// Replace the `unknown` types below with proper object shapes.
//
// Example:
//   export type SomeType = {
//     fieldName: string;
//     optionalField?: string | null;
//   };

export type ChatRequest = unknown;
export type ChatResponse = unknown;
