# GitHub セットアップ

ローカルリポジトリは `C:\Users\kziwa\Projects\general-partner` に作成済みです。GitHub へ push する手順です。

## 1. GitHub CLI でログイン

PowerShell で:

```powershell
gh auth login
```

- GitHub.com を選択
- HTTPS を選択
- Login with a web browser を選択

## 2. リポジトリ作成と push

```powershell
cd C:\Users\kziwa\Projects\general-partner
.\scripts\setup-github.ps1
```

または手動:

```powershell
cd C:\Users\kziwa\Projects\general-partner
gh repo create general-partner --public --source=. --remote=origin --description "General-purpose thinking partner agent for Cursor" --push
```

## 3. 確認

```powershell
gh repo view --web
```

リポジトリ URL: `https://github.com/<your-username>/general-partner`

## 4. Cloud Agent 連携

[cloud-agent-slack.md](./cloud-agent-slack.md) の手順に進んでください。リポジトリ URL の `<your-username>` を実際のユーザー名に置き換えてください。
