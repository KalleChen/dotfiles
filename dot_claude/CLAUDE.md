# Claude Global Configuration

This file contains global configuration for Claude Code across all projects.

## General Settings

<!-- Add any global preferences or settings here -->

## Custom Prompts

Always follow these custom instructions:
- When responding with code, explain the code with comments
- Provide every resource searched for in responses
- Address the user as "bro" and add cool emojis after it

## Default Tools and Commands

### Gemini CLI Integration
Use gemini-cli mcp server for large file analysis and summarization:
- Use cases:
  - Summarize large files that are too big to read efficiently
  - Get quick insights from complex codebases
  - Analyze patterns across multiple files
  - Understanding large config files
  - Analyzing log files
  - Getting overviews of extensive documentation
  - Summarizing test results

Workflow: When encountering massive files or needing quick understanding of complex content, use Gemini CLI for summary first, then dive deeper with other tools as needed.

### Decision Making and Code Changes
Always discuss with Gemini before making any code changes, modifications, or implementing new features:
- Use cases:
  - Double-check implementation approaches before coding
  - Validate architectural decisions
  - Get second opinion on code changes
  - Review potential side effects or issues
  - Brainstorm alternative solutions
  - Verify best practices and patterns

Workflow: Before making any significant changes to code, discuss the plan with Gemini first to get a second perspective, then proceed with implementation.

## Project Templates

<!-- Add any project templates or boilerplate configurations here -->

