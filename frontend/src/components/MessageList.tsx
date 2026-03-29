/**
 * frontend/src/components/MessageList.tsx
 *
 * Renders the scrollable list of chat messages.
 *
 * What is already done for you:
 *   - The Message type and component props.
 *
 * What you need to implement:
 *   - Map over the messages array and render each one with visual
 *     distinction between "user" and "bot" messages.
 */

export interface Message {
  role: "user" | "bot";
  text: string;
}

interface MessageListProps {
  messages: Message[];
}

export default function MessageList({ messages }: MessageListProps) {
  // TODO-1 (Required): Render each message in the list.
  //
  // Steps:
  //   1. If messages is empty, show a short placeholder like
  //      "Ask a question to get started."
  //
  //   2. Use messages.map() to render each message. For each one:
  //      - Use the index (or a unique id) as the React key.
  //      - Apply different styling based on message.role:
  //          "user" messages → align right or use a different background.
  //          "bot"  messages → align left or use a different background.
  //      - Display message.text as the content.
  //
  // Example structure:
  //   return (
  //     <div>
  //       {messages.map((msg, i) => (
  //         <div key={i} style={{ textAlign: msg.role === "user" ? "right" : "left" }}>
  //           <strong>{msg.role === "user" ? "You" : "Bot"}:</strong> {msg.text}
  //         </div>
  //       ))}
  //     </div>
  //   );

  return <div>Message list not implemented yet</div>;
}
