# 2026-07-22 — 時系列異常検知の論文読書リスト

## 目的

時系列異常検知を体系的に学ぶための論文の読み順を整理する
(圧力波形の異常検知プロジェクト → [2026-07-02 セッション](./2026-07-02-seasonal-anomaly-detection.md) の学習計画)。

## 読書リスト(読む順)

### Step 0: 教科書(論文の前に)

- 井手剛『入門 機械学習による異常検知』/ 井手・杉山『異常検知と変化検知』
  — Mahalanobis、ホテリング T²、部分空間法の理論的土台

### Step 1: 地図となるサーベイ

1. Ruff et al., "A Unifying Review of Deep and Shallow Anomaly Detection"
   (Proc. IEEE, 2021) — [arXiv:2009.11732](https://arxiv.org/abs/2009.11732)
   — 古典と深層を統一枠組みで整理した決定版
2. Blázquez-García et al., "A Review on Outlier/Anomaly Detection in Time Series Data"
   (ACM CSUR, 2021) — [arXiv:2002.04236](https://arxiv.org/abs/2002.04236)
   — 点異常 / 部分列異常 / 系列全体異常の分類。**本件は「系列全体(スニペット単位)の異常」**

### Step 2: 評価の落とし穴(必修)

3. Wu & Keogh, "Current TSAD Benchmarks are Flawed and are Creating the Illusion of
   Progress" (IEEE TKDE, 2021) — [arXiv:2009.13807](https://arxiv.org/abs/2009.13807)
4. Schmidl, Wenig & Papenbrock, "Anomaly Detection in Time Series: A Comprehensive
   Evaluation" (PVLDB, 2022) — [PDF](https://www.vldb.org/pvldb/vol15/p1779-wenig.pdf)
   — 71 手法比較。「万能手法なし、古典手法がしばしば勝つ」
5. Liu & Paparrizos, "The Elephant in the Room: Towards A Reliable TSAD Benchmark"
   (NeurIPS 2024) — [TSB-AD](https://thedatumorg.github.io/TSB-AD/)
   — 最新の是正版ベンチマーク。VUS-PR 推奨。コード公開あり(練習台に good)

### Step 3: 代表手法の原典(使うものだけ)

6. Liu et al., "Isolation Forest" (ICDM 2008)
7. Yeh et al., "Matrix Profile I" (ICDM 2016) — 部分列類似度の標準。実装は `stumpy`
8. Hundman et al., "Detecting Spacecraft Anomalies Using LSTMs and Nonparametric
   Dynamic Thresholding" (KDD 2018) — [arXiv:1802.04431](https://arxiv.org/abs/1802.04431)
   — 予測残差 + 動的しきい値の実務設計。深層系を 1 本だけ読むならこれ

### Step 4: 本件に直結

9. Cross et al., "Features for damage detection with insensitivity to environmental and
   operational variations" (Proc. R. Soc. A, 2012) — [DOI](https://doi.org/10.1098/rspa.2012.0031)
   — PCA マイナー主成分 / 共和分による環境トレンド除去の原典比較
10. DCASE 2025 Task 2 タスク解説 — [arXiv:2506.10097](https://arxiv.org/abs/2506.10097)

## 読み方のコツ

- サーベイは精読せず、分類枠組みと自分の課題の位置づけだけ持ち帰る
- Step 2(評価系)は精読の価値あり。この分野は評価設計が実務の成否を分ける
- 原典は使うと決めた手法だけ。TSB-AD / sklearn / tslearn / stumpy で動かしながら読む

## 次のアクション

- [ ] Step 0 の教科書に着手
- [ ] Ruff 2021 と Wu & Keogh 2021 を先に読む(短時間で相場観がつく組み合わせ)
- [ ] TSB-AD のリポジトリを clone して 2〜3 手法を動かす

## 出典

- [TSB-AD (NeurIPS 2024)](https://thedatumorg.github.io/TSB-AD/) — 参照日: 2026-07-22
- [TAB: Unified Benchmarking of TSAD Methods (PVLDB 2025)](https://doi.org/10.14778/3746405.3746407) — 参照日: 2026-07-22
- その他は本文リンク参照(arXiv / DOI)

## Your feedback

<!-- 自由記述 -->
