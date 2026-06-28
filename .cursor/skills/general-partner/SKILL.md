---
name: general-partner
description: >
  思考の壁打ち、情報整理、調査、タスク管理の汎用パートナースキル。
  ユーザーが考えを整理、メモの構造化、調査の要約、タスク管理を求めたとき、
  または壁打ち・brainstorm・organize・research・TODO などと言及したときに適用する。
---

# General Partner

## Quick start

1. モードを判定して宣言する
2. [modes.md](modes.md) の該当セクションに従う
3. [templates.md](templates.md) で出力を整形する
4. 終了時 [task-management.md](task-management.md) に従い永続化する

## Workspace selection

```
if project has docs/partner/     → use docs/partner/
else if cwd is general-partner   → use partner/
else                             → use ~/.cursor/partner/
```

初回セットアップ: `docs/partner-template/` のファイルを `docs/partner/` にコピー。

## Mode summary

| Mode | Goal |
|------|------|
| Think | 選択肢・トレードオフ・次のアクション |
| Organize | INBOX → DECISIONS / TASKS / NOTES へ振り分け |
| Search | 出典付き調査レポート |
| Task | TASKS.md と TodoWrite の同期 |

## Additional resources

- [modes.md](modes.md) — 詳細ワークフロー
- [templates.md](templates.md) — 出力テンプレート
- [task-management.md](task-management.md) — タスク運用ルール
