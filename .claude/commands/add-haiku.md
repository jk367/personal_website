Add a new haiku entry to `content/writing/daily haikus.md`.

## Instructions

The user may pass the haiku lines directly as arguments: `$ARGUMENTS`

If arguments were provided, parse them as the three haiku lines (split by `/` or newline).
If no arguments were provided, ask the user for the three lines of the haiku.

## Steps

1. Get today's date (provided in the system context as `currentDate`). Format it as `Month Day, Year` with no leading zero on the day — e.g. `April 9, 2026`.

2. Read the file `content/writing/daily haikus.md` to see the current content.

3. Insert the new haiku entry immediately after the closing `---` of the front matter and before the existing content. The entry must follow this exact format (blank line after front matter, then date header, blank lines between lines):

```
**{Month Day, Year}**

{line 1}

{line 2}

{line 3}

```

4. Write the updated file.

5. Commit the change with a short, descriptive message (e.g. `Add haiku for April 9, 2026`) and push to the current branch.

6. Confirm to the user what was added and that the commit was pushed.
