# Partner Template — Project Setup

新しいプロジェクトに `docs/partner/` を作るときのテンプレート。

## セットアップ

プロジェクトルートで:

```powershell
New-Item -ItemType Directory -Force -Path docs\partner\sessions
Copy-Item path\to\general-partner\docs\partner-template\INBOX.md docs\partner\
Copy-Item path\to\general-partner\docs\partner-template\TASKS.md docs\partner\
Copy-Item path\to\general-partner\docs\partner-template\DECISIONS.md docs\partner\
Copy-Item path\to\general-partner\docs\partner-template\NOTES.md docs\partner\
Copy-Item path\to\general-partner\docs\partner-template\PROJECT_README.md docs\partner\README.md
```

（このテンプレートは general-partner リポジトリ内の `docs/partner-template/` にある）

## ファイル一覧

| File | Purpose |
|------|---------|
| README.md | 索引 |
| INBOX.md | 未整理入力 |
| TASKS.md | 永続タスク |
| DECISIONS.md | 決定事項 |
| NOTES.md | 参考情報 |
| sessions/ | セッションログ |

## エージェント連携

ローカル Cursor では `general-partner` スキルが `docs/partner/` を自動検出して使用する。
