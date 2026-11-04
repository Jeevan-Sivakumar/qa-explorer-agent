# Structured report fields

Populate report.example.json without fabricating observations. Dates are ISO timestamps or null. Coverage and findings are independent: a failure might have multiple test observations but one deduplicated finding.

Each coverage item:

```json
{"id":"CHECK-001","feature":"Observed workflow","input":"Redacted inputs","expected":"UI-grounded expectation","actual":"Observed result","outcome":"pass","evidence":[]}
```

Allowed outcomes: pass, fail, blocked, not_tested. Evidence items are relative local paths, without secrets or absolute filesystem paths.

Each finding:

```json
{
  "id":"QA-001",
  "title":"Describe the observed defect",
  "status":"confirmed",
  "category":"functional",
  "severity":"medium",
  "impact":"Explain the affected user/business outcome",
  "url":"https://example.test/affected-page",
  "preconditions":["Required observed state"],
  "steps":["Reproduction step"],
  "expected":"What should happen",
  "expected_basis":"Visible rule or supplied requirement",
  "actual":"What happened",
  "comparison":"Working comparison, or not tested",
  "attempts":2,
  "reproduced":2,
  "confidence":"high",
  "network":[{"method":"GET","path":"/observed-api-path","status":500,"duration_ms":null,"request_id":null}],
  "evidence":[],
  "jira_url":null
}
```

Use suspected instead of confirmed when not established; observation for performance information without a defect conclusion. Hypotheses go in report.md and should not inflate confirmed counts. A normal invalid-input 4xx is not automatically a defect.
