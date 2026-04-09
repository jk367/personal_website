Bulk-add multiple haiku entries to `content/writing/daily haikus.md`.

## Instructions

The user may pass haikus as arguments: `$ARGUMENTS`

If no arguments were provided, ask the user to provide the haikus. Each haiku should include a date and three lines. Accept them in any reasonable format — numbered list, one per message, separated by `---`, etc.

**Expected input shape (flexible):**

```
April 7, 2026
line one
line two
line three

April 8, 2026
line one
line two
line three
```

Or with slashes: `April 7 / line one / line two / line three`

Parse generously. If a date is missing for any entry, ask the user to clarify before proceeding.

## Steps

1. Parse all haiku entries from the input. Each entry needs: a date and exactly three lines of verse.

2. Sort entries in **descending date order** (most recent first), since that is how `daily haikus.md` is ordered.

3. Read `content/writing/daily haikus.md`.

4. For each entry (most recent first), insert it immediately after the front matter `---` closing line and before existing content. The format for each entry:

```
**{Month Day, Year}**

{line 1}

{line 2}

{line 3}

```

   After inserting all entries the block at the top of the file (below front matter) should read: most-recent entry first, then the next, then the next, followed by the previously existing content.

5. Write the updated file.

6. Commit with a message summarizing the date range, e.g. `Add haikus for April 7–9, 2026`, and push to the current branch.

7. Confirm to the user: list each date added and confirm the push succeeded.
