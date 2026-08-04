# Decisions

確定した判断と根拠を時系列で記録する。

---

<!-- 新しい決定は上に追記 -->

## 2026-08-04 — DSOS2026 作業場を competitions/ 配下に置く

**決定:** `competitions/data-science-osaka-summer-2026/` に venv・ノート・データ取得スクリプトを置く。データ本体は gitignore。

**理由:** general-partner リポジトリ上でコンペ参加準備を依頼されたため。starter のローカルパス `data/competition` に合わせる。

**代替案:** 別リポジトリ — 依頼スコープ外のため今回は見送り。

## 2026-06-28 — general-partner エージェント設計

**決定:** Subagent + Skill のハイブリッド構成。作業場はプロジェクトごとに `docs/partner/`、横断は `~/.cursor/partner/`。

**理由:** ローカル全プロジェクトで使いつつ、プロジェクト固有の文脈を分離するため。

**代替案:** プロジェクト単位のみ — 横断タスクの管理が難しいため却下。
