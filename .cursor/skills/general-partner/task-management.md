# Task Management

## Two layers

| Layer | Tool / File | Lifetime |
|-------|-------------|----------|
| 会話内 | Cursor **TodoWrite** | このチャットセッションのみ |
| 永続 | **TASKS.md** | セッションをまたぐ |

両方を使う。重要なタスクは必ず TASKS.md にも書く。

## File locations

| Scope | Path |
|-------|------|
| プロジェクト固有 | `<project>/docs/partner/TASKS.md` |
| 個人横断 | `~/.cursor/partner/TASKS.md` |
| general-partner リポジトリ | `partner/TASKS.md` |

## TASKS.md format

```markdown
# Tasks

## Active

- [ ] タスク名 | 優先度: 高/中/低 | 期限: YYYY-MM-DD | 備考

## Waiting

- [ ] （外部待ち・ブロック中）

## Done（直近2週間）

- [x] タスク名 | 完了日: YYYY-MM-DD

## Someday

- [ ] （いつかやる）
```

## Priority guide

| 優先度 | 目安 |
|--------|------|
| 高 | 今日〜今週、ブロッカー解消 |
| 中 | 今月中、計画済み |
| 低 | あるとよい、期限なし |

## Session sync workflow

### セッション開始

1. 該当する `TASKS.md` を読む
2. Active のうち関連タスクを TodoWrite に載せる

### セッション中

- 新タスク出現 → TodoWrite + （重要なら）TASKS.md Active へ追記
- 完了 → TodoWrite を completed、TASKS.md を Done へ移動

### セッション終了

1. TodoWrite の未完了を TASKS.md に反映
2. 新規決定があれば DECISIONS.md も更新

## Slack / Cloud Agent

- Slack でタスクが出たら `partner/TASKS.md` に追記し、返信で確認する
- 長いタスクリストはファイルを更新し、Slack には要約のみ返す

## Anti-patterns

- TASKS.md に完了済みを大量に溜めない（Done は2週間で整理）
- 曖昧なタスク（「なんとかする」）— 次の物理的アクションまで分解する
- 会話だけでタスクを管理してファイルに残さない
