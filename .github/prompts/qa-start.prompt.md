---
name: qa-start
description: Start a QA assessment of a website.
argument-hint: Enter the website URL to test
agent: QA Explorer
---

Start the QA Explorer workflow using its existing testing
instructions and reporting templates.

If the user supplied a website URL, begin testing it.
Otherwise ask: "Which website URL should I test?"
Wait for the user's reply before starting.

Do not create Jira tickets during this initial run.