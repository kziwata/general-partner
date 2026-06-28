# general-partner

汎用パートナーエージェント — 思考の壁打ち、情報整理、調査、タスク管理。

## 構成

| パス | 用途 |
|------|------|
| [AGENTS.md](./AGENTS.md) | Cloud Agent 向けルート指示 |
| [.cursor/agents/](./.cursor/agents/) | サブエージェント定義 |
| [.cursor/skills/general-partner/](./.cursor/skills/general-partner/) | ワークフロー・テンプレート |
| [partner/](./partner/) | このリポジトリの永続作業場 |
| [docs/](./docs/) | セットアップ・テンプレート |

## ローカルでの使い方

1. Cursor でこのリポジトリを開く
2. 「壁打ちして」「タスクを整理して」などと話しかける — `general-partner` スキルが自動適用される
3. サブエージェントを明示的に使う場合: `general-partner` サブエージェントを指定

個人用のコピーは `~/.cursor/agents/` と `~/.cursor/skills/` にも配置済み（全プロジェクト共通）。

## Slack + Cloud Agent

[docs/cloud-agent-slack.md](./docs/cloud-agent-slack.md) を参照。

概要:

1. [Cloud Agents ダッシュボード](https://cursor.com/dashboard?tab=cloud-agents) で GitHub 連携を有効化
2. Cursor Automations で Slack トリガー + このリポジトリを指定
3. エージェントは `AGENTS.md` と `.cursor/skills/general-partner/` に従って動作

## ライセンス

MIT
