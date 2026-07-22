# 2026-07-22 — 時系列クラスタリング・波形系の Kaggle 学習素材

## 目的

圧力波形の異常検知プロジェクト(→ [2026-07-02 セッション](./2026-07-02-seasonal-anomaly-detection.md))の
学習素材として、時系列クラスタリングや波形を題材にした Kaggle コンペを調べる。

## 結論

- 「時系列クラスタリング」そのものを課題にしたコンペはほぼ存在しない(教師なしは採点が困難)。
- 例外: [Tabular Playground Series – Jul 2022](https://www.kaggle.com/competitions/tabular-playground-series-jul-2022)
  (純粋なクラスタリングコンペ、Adjusted Rand Index。ただしタブラーで時系列ではない)
- クラスタリングの練習はコンペより Kaggle Datasets + `tslearn`(DTW k-means / K-Shape)が現実的。

## 波形・センサー系コンペ(推奨順)

| コンペ | 内容 | 今回との関連 |
|--------|------|--------------|
| [Ventilator Pressure Prediction](https://www.kaggle.com/competitions/ventilator-pressure-prediction) (2021) | 人工呼吸器の1呼吸ごとの圧力波形(80ステップ)を予測 | **動作単位の圧力プロファイル**という点で最も近い |
| [CareerCon 2019 – Help Navigate Robots](https://www.kaggle.com/competitions/career-con-2019) | IMU の短スニペット(128ステップ×10ch)から床面分類 | 「数秒スニペット→特徴抽出→判定」が同型 |
| [VSB Power Line Fault Detection](https://www.kaggle.com/c/vsb-power-line-fault-detection) | 送電線信号の部分放電検出 | 1位は**ピーク検出ベース9特徴量+LightGBM**。少数の物理特徴量で勝てる好例([1位解法](https://www.kaggle.com/competitions/vsb-power-line-fault-detection/writeups/mark4h-overview-of-1st-place-solution)) |
| [Ion Switching](https://www.kaggle.com/competitions/liverpool-ion-switching) | ドリフトを含む電気生理信号のイベント推定 | **ドリフト除去 ≒ 季節性補正**の練習 |
| [Detect Sleep States](https://www.kaggle.com/competitions/child-mind-institute-detect-sleep-states) / [Parkinson's FOG](https://www.kaggle.com/competitions/tlvmc-parkinsons-freezing-gait-prediction) | ウェアラブル長時系列のイベント検知 | 時系列 CV 設計の勉強(優先度低) |

## 使い分け

- **特徴量エンジニアリングの引き出し** → Kaggle(VSB、Ventilator)
- **教師なし異常検知の評価設計** → DCASE Task 2 / MIMII / NASA Bearing / CWRU
  (自分で「季節・条件をまたぐ分割」を設計して評価)
- PHM Society Data Challenge も産業設備系で毎年開催

## 次のアクション

- [ ] VSB 1位解法を読み、ピーク特徴量の設計を圧力波形向けに翻案できるか検討
- [ ] Ventilator Pressure の上位解法で圧力プロファイルの前処理を確認
- [ ] MIMII 等で「条件をまたぐ分割」の評価練習

## 出典

- [VSB Power Line Fault Detection 1位解法](https://www.kaggle.com/competitions/vsb-power-line-fault-detection/writeups/mark4h-overview-of-1st-place-solution) — 参照日: 2026-07-22
- 各コンペページ(表内リンク) — 参照日: 2026-07-22

## Your feedback

<!-- 自由記述 -->
