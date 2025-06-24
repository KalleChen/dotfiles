---
allowed-tools: Bash(git*, gh*)
description: Review a PR and automatically add review comment to GitHub
---

# Review PR and Auto-Comment

Review PR #$ARGUMENTS and analyze the changes:

## Context
- PR Details: !`gh pr view $ARGUMENTS --json number,title,body,author,url`
- Changed Files: !`git diff $(git merge-base HEAD main)..HEAD --stat`
- Full Changes: !`git diff $(git merge-base HEAD main)..HEAD`

## Your Task
1. **Check out the PR first**: !`gh pr checkout $ARGUMENTS`

2. **Analyze the code changes and provide a comprehensive review covering:**
   - Code quality and best practices
   - Security vulnerabilities
   - Performance implications  
   - Test coverage
   - Documentation needs
   - Breaking changes

3. **Generate a structured review comment using this template:**

```markdown
## 🔍 Code Review Summary

**Overall Assessment:** [Approve/Request Changes/Comment]

### ✅ Strengths
- [List positive aspects]

### ⚠️ Issues Found
- **Critical:** [Any blocking issues]
- **Minor:** [Suggestions for improvement]

### 🔧 Recommendations
- [Specific actionable suggestions]

### 📝 Additional Notes
- [Any other observations]

**Reviewed by Claude Code** 🤖
```

4. **Post the review comment**: !`gh pr comment $ARGUMENTS --body "[Generated review from template above]"`

Usage: `/project:review-pr 123`