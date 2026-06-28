# Cloud Agent + Slack セットアップ

general-partner を Slack 上の Cloud Agent として動かす手順。

## 前提

- Cursor の [Cloud Agents](https://cursor.com/dashboard?tab=cloud-agents) が利用可能
- GitHub アカウント連携済み
- このリポジトリが GitHub に push 済み
- Slack ワークスペースを Cursor に接続済み

## 1. GitHub リポジトリ

リポジトリ: `https://github.com/kziwata/general-partner`（作成後に URL を確認）

Cloud Agent はこのリポジトリを clone して動作する。以下がエージェントの指示源:

- `AGENTS.md` — ルート指示
- `.cursor/agents/general-partner.md` — サブエージェント
- `.cursor/skills/general-partner/` — ワークフロー

## 2. Cloud Agent ダッシュボード

1. [Cloud Agents ダッシュボード](https://cursor.com/dashboard?tab=cloud-agents) を開く
2. GitHub 連携で `general-partner` リポジトリへのアクセスを許可
3. デフォルトブランチ: `main`

## 3. Cursor Automation（Slack トリガー）

Cursor の Automations で新規作成:

| 項目 | 推奨設定 |
|------|----------|
| 名前 | General Partner — Slack |
| トリガー | Slack — チャンネルの新規メッセージ |
| リポジトリ | `kziwata/general-partner` / `main` |
| ツール | Slack への返信（スレッド返信を推奨） |
| メモリ | 有効 |

### プロンプト例

```
あなたは general-partner です。AGENTS.md と .cursor/skills/general-partner/SKILL.md に従ってください。

Slack からの依頼に対して:
1. モード（Think / Organize / Search / Task）を判定
2. 簡潔に応答（長文はスレッドへ）
3. 重要な内容は partner/ 配下のファイルに保存してコミット
4. 日本語で返答

ユーザーメッセージ:
{{trigger.message}}
```

※ 実際の Automation エディタではトリガー変数の記法が異なる場合があります。エディタのプレースホルダーに合わせて調整してください。

### チャンネル

- 専用チャンネル（例: `#general-partner`）を作ると運用しやすい
- ボットメンションのみ反応にする設定があれば推奨

## 4. 動作確認

1. Slack でテストメッセージ: 「今日のタスクを整理して」
2. エージェントが Task モードで応答することを確認
3. `partner/TASKS.md` が更新されるか確認（ファイル変更をコミットする設定の場合）

## 5. 運用のコツ

| やること | 理由 |
|----------|------|
| 専用チャンネル | 他のボットと混ざらない |
| スレッド返信 | 長い壁打ちをチャンネル本体を汚さない |
| `partner/sessions/` に保存 | Slack 履歴とファイルの二重管理を避ける |
| 機密情報を送らない | リポジトリにコミットされる可能性がある |

## 6. ローカルとの同期

| 環境 | 作業場 |
|------|--------|
| Slack Cloud Agent | `partner/`（このリポジトリ） |
| 他プロジェクト（ローカル） | `docs/partner/` |
| 個人横断（ローカル） | `~/.cursor/partner/` |

Slack 経由のタスクは `partner/TASKS.md`、プロジェクト固有は各 repo の `docs/partner/TASKS.md` と使い分ける。

## トラブルシューティング

| 症状 | 対処 |
|------|------|
| 反応しない | Slack 連携・チャンネル設定・Automation の有効化を確認 |
| 日本語にならない | Automation プロンプトに「日本語で返答」を明記 |
| ファイルが更新されない | Cloud Agent の git 書き込み権限・ブランチ設定を確認 |
| コード実装してしまう | プロンプトに「実装は行わず整理のみ」を追記 |

## 関連リンク

- [Cloud Agents ドキュメント](https://cursor.com/docs/cloud-agent)
- [Automations](https://cursor.com/docs/automations)（Cursor 製品ドキュメント）
