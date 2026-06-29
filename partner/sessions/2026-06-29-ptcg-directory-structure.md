# 2026-06-29 — ptcg ディレクトリ構造確認

## 目的

Slack からの依頼「ptcgのディレクトリ構造を教えてください」に対して、現在のワークスペース内で `ptcg` ディレクトリまたは関連ファイルが存在するか確認する。

## 調査モード

Search

## 確認結果

- `/workspace` 配下で `ptcg` ディレクトリは見つからなかった。
- `/workspace` 配下で `ptcg` を含むファイル名・パス名も見つからなかった。
- ファイル内容検索でも `ptcg` という文字列は見つからなかった。

## 現在確認できる主な構造

```text
/workspace
├── .cursor/
│   ├── agents/
│   └── skills/general-partner/
├── docs/
│   └── partner-template/
├── partner/
│   ├── DECISIONS.md
│   ├── INBOX.md
│   ├── NOTES.md
│   ├── README.md
│   ├── TASKS.md
│   └── sessions/
├── scripts/
├── AGENTS.md
├── README.md
└── LICENSE
```

## Slack 返信方針

`ptcg` は現在のワークスペースでは見つからないため、その旨を短く伝え、別リポジトリ・別パスであれば対象パスを共有してもらうよう案内する。

## 不確実な点

- `ptcg` が別リポジトリ、未チェックアウトのサブディレクトリ、または Slack 上の略称を指している可能性がある。
