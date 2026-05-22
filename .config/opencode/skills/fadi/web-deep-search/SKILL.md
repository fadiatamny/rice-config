---
name: web-deep-search
description: Perform thorough web searches using the ddg-search MCP server's search and fetch_content tools. Crawls from search results into inner pages and sub-links for comprehensive answers. Use when the user asks to "search the web", "look up", "find information", "research", or wants current/recent data.
---

# Web Deep Search Protocol

## Default Search Strategy

When asked to search the web, call the `search` tool from the `ddg-search` MCP server with optimal settings and then `fetch_content` the most promising results. Do not stop at the search snippet — follow links into inner pages.

## Procedure

### Step 1: Search Broadly

Start with a broad `search(query="<user's question>", max_results=8)`.

- Use `max_results: 8` for broad coverage
- Optionally set `region` for localized results (e.g. `"us-en"`, `"cn-zh"`)

If the first query returns weak results, try 1–2 reformulated queries before concluding nothing exists.

### Step 2: Parallel Subagents for Deep-Dives

For each relevant result URL from the search, launch a **subagent** via the `task` tool to deep-dive that specific page:

- **Each subagent's job:** `fetch_content` the URL, extract the answer relevant to the user's question, and return a concise summary.
- **Run them in parallel** (one subagent per URL) to maximize speed.
- Use the `explore` subagent type for these page reads.

Example prompt for each subagent:
```
Fetch content from <URL>. Extract anything relevant to "<user's question>". Return a concise summary of what you find.
```

### Step 3: Multi-Query for Complex Topics

For broad questions ("tell me about X"), search multiple angles in parallel using subagents:

Launch one subagent per search query:
```
search("X overview 2026")
search("X best practices")
search("X vs alternatives comparison")
```

Each subagent should `search`, then `fetch_content` the top 2-3 results from that query, and return a summary.

Use `general` subagent type for these.

### Step 4: Synthesize

Collect all subagent results and synthesize them into the final answer. Note any discrepancies across sources.

## Subagent Usage Rules

- **Independent tasks → parallel subagents.** If you need to search multiple queries or fetch multiple pages, each goes in its own subagent.
- **Dependent tasks stay sequential.** If one search depends on the results of another, keep them in the same agent.
- Use `explore` subagent type for simple page fetches, `general` for search + fetch combos.
- Give each subagent a clear 3-5 word description and a precise prompt so it doesn't wander.

## When to Search

Search proactively when:
- The user asks for current events or recent data (anything time-sensitive)
- The user says "search", "look up", "find", "research", "what is", "latest", "recent"
- You need to verify facts, get documentation for a library/API, or check pricing
- The question references a specific website, product, person, or project

## Limitations

- `search` returns text snippets + URLs. For full content, always `fetch_content` the URL.
- If `search` returns no results, try shortening the query or removing quotes/special chars.
- Some sites block automated fetching. If a page fails to load, try another source.
- Don't over-subagent. If the question is simple (one search + one fetch), do it directly. Subagents add overhead — use them for 3+ parallel tasks only.
