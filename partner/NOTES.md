# Notes

整理済みの参考情報。

---

## 手話AI認識の事例

**更新:** 2026-09-03

### 調査目的

手話のAI認識技術について、実用化事例と最新の研究動向を収集し、技術的アプローチと応用分野を整理する。

### 結論（要約）

手話AI認識技術は2026年時点で実用化が進み、自治体窓口、交通施設、宿泊施設、モバイルデバイスなど多様な場面で導入されている。技術的には、MediaPipeによる骨格追跡とLSTM/Transformer/状態空間モデルを組み合わせたアプローチが主流で、リアルタイム認識精度は継続的に向上している。日本ではソフトバンクのSureTalkが複数自治体で実証実験中、海外ではGoogle DeepMindのSL2T がPixel 11に搭載され初の商用展開を達成した。

### 詳細

#### 1. 日本国内の実用化事例

**ソフトバンク SureTalk（シュアトーク）**
- 手話をリアルタイムでテキストに変換するコミュニケーションツール
- 骨格ベースの手話認識技術を採用（映像ではなく骨格の動きを追跡）
- 導入実績：
  - 神奈川県藤沢市役所（2025年1月〜9月実証実験）
  - 東京都豊島区など10〜20の自治体で実証
  - 2025デフリンピック東京大会の宿泊施設に配備予定
- 開発体制：ソフトバンク、電気通信大学（2017年開始）、SiLa協議会（全日本ろうあ連盟を特別会員に含む）
- データ：現在7万以上の手話データを登録
- 2025年度後半の実用化を目指している
- 国際手話・米国手話への対応も進行中

**NHKエンタープライズ 手話CGコンシェルジュ**
- デジタルヒューマン「KIKI」による手話での案内サービス
- 実装場所：羽田空港第1ターミナル（2026年3月25日〜2027年3月31日）
- 特徴：FAQ形式で質問に手話で回答
- 筑波技術大学の聴覚障害学生が手話表現を監修
- 2026年夏頃に多言語化・国際手話対応予定

**京セラ 手話認識システム**
- AIで手話表現を文字に変換
- 既存の音声文字変換システム「コトパット」のオプションとして提供予定
- 2027年度に自治体窓口向けに提供開始
- 特徴：自動運転車・ロボット向けに蓄積した認識技術を応用
- コトパットは134言語翻訳対応、300件以上の導入実績

**株式会社タップ 宿泊施設向けシステム**
- 沖縄工業高等専門学校と共同開発
- 画像認識技術で手話を読み取り文字に変換
- ホテルシステム（PMS）と連携可能
- 将来的にはロボットとの連携も視野

#### 2. 海外の実用化事例

**Google DeepMind SL2T**
- Pixel 11のGboardとLive Transcribeに搭載（2026年8月）
- 初の商用実装手話AIシステム
- 機能：カメラを使ってASLをリアルタイムで英語テキストに変換
- 学習データ：100,000時間以上、50以上の手話言語（ASLは約25%）
- 精度：FLEURS-ASLベンチマークで70 BLEURT
- 課題：稀な手話、高速指文字、受動構文、時制推論などで誤認識あり
- 今後、他デバイスや追加言語への展開予定

**Signapse（英国・米国・ドイツ）**
- フォトリアリスティックなデジタル手話者「Kim」を開発
- 実績：
  - 英国：National Railで英国手話（BSL）対応
  - 米国：大手ストリーミングサービスでASL対応
  - ドイツ：G&L Systemhausと提携してドイツ手話（DGS）対応（2026年秋予定）
- API/SDK経由でストリーミング配信に統合可能
- 王立聴覚障害者協会と協力して開発

#### 3. 学術研究・技術動向

**主要技術スタック**
- 骨格追跡：Google MediaPipe（手指・体・顔のランドマーク抽出）
- モデル：LSTM、CNN、Transformer、状態空間モデル（Mamba）
- データセット：WLASL、RWTH-PHOENIX-Weather、CSL、Isharahなど

**最新研究成果（2026年）**

1. **PhonSSM（音韻論的状態空間モデル）**
   - 手話の音韻論的構成要素（手形・位置・動き・向き）を明示的にモデル化
   - WLASL2000で72.1%精度（従来の骨格ベース手法より+18.4pp）
   - 5,565語彙で53.3%精度
   - Few-shot学習で+225%の相対改善
   - MediaPipeランドマークのみ使用（RGB不要）

2. **TinyMSLR（軽量ハイブリッドモデル）**
   - ConvNeXt-Tiny + Swin Transformer + 適応型融合ゲート
   - パラメータ数：2.7M未満
   - 精度：訓練99.28%、検証99.01%、F1スコア98.96%
   - 推論速度：CPU 24ms、エッジGPU 13.5ms未満
   - ドイツ手話・中国手話で多言語テスト済み

3. **CSLRTransformer（連続手話認識）**
   - 2D骨格（86関節）のみ使用
   - CVPR 2026 SignEval チャレンジで実績
   - Task 1（話者独立）：16.35% WER（26チーム中9位）
   - Task 2（未知文）：50.72% WER（22チーム中6位）

4. **多言語手話認識研究**
   - トルコ・アラビア・米国手話の横断的比較
   - Vision Mamba（SSM）が従来のCNN・Transformerを上回る性能
   - MediaPipeによる軽量な特徴抽出
   - ノルウェー手話（NSL）での数字認識研究も進行中

**実用化向け技術**
- SigniFi（オープンソース）：リアルタイムASL翻訳Webアプリ
  - Flask + OpenCV + MediaPipe + TensorFlow
  - 文字モード・単語モード対応
  - Gemini AIによる文字列のセグメンテーション
  - テキスト読み上げ機能
  - GitHub: arivvid27/SigniFi

- MP-GestLSTM：
  - MediaPipe + LSTM
  - カスタムMP-Gestデータセット（800動画、20クラス）
  - Webカメラベースのリアルタイムシステム
  - 中程度スペックのノートPC（Intel i5、8GB RAM）で動作

#### 4. 欧州・その他地域のプロジェクト

**INTERACT（国際手話・XR）**
- AI駆動のXRプラットフォーム
- 機能：
  - リアルタイム音声テキスト化（Whisper）
  - 国際手話（ISL）翻訳（3Dアバター経由）
  - 多言語サポート（NLLB）
  - 感情分析（RoBERTa）
  - ジェスチャー抽出（MediaPipe）
- Meta Quest 3ヘッドセット使用
- EU聴覚障害者連合が国際手話を推進

**RoGSiLT（独仏手話翻訳）**
- ドイツ手話（DGS）とフランス手話（LSF）の翻訳技術開発
- DFKI（ドイツ）とINRIA（フランス）の共同プロジェクト
- 期間：2026年4月〜2029年3月
- アプローチ：自己教師あり学習、マルチモーダルアーキテクチャ、大規模言語モデル
- 目標：グロスアノテーションへの依存を減らし、より自然な翻訳を実現

**ViSign（リトアニア手話）**
- カウナス工科大学（KTU）がリトアニア国営放送（LRT）と協力
- バーチャル手話アシスタント開発
- 音声・テキストを手話に変換
- 2,000以上の手話辞書を作成予定
- ライブTV放送でのテスト実施予定
- リトアニアの聴覚障害者3万人への支援を目指す

### 技術的課題と方向性

**共通課題**
1. データ不足：手話データ自体が少なく、地域方言や個人差への対応が困難
2. 語彙のスケーラビリティ：小規模語彙では高精度だが、大規模語彙では精度低下
3. 連続手話認識：単語レベルでは高精度だが、文レベルの連続認識は発展途上
4. 非手指要素：表情や口形など非手指文法要素の統合が技術的に複雑

**技術トレンド**
1. MediaPipeによる骨格抽出がデファクトスタンダード化（プライバシー保護、軽量、ドメイン不変性）
2. Transformer・状態空間モデル（Mamba）への移行
3. Few-shot学習・ゼロショット転移による語彙拡張
4. エッジデバイス向け軽量化（知識蒸留、モバイルアーキテクチャ）
5. 多言語・国際手話への展開
6. アバターによる逆方向翻訳（テキスト→手話）の並行発展

### 出典

**日本国内事例**
- [手話と音声を、AIでつなぐ ―― ソフトバンクのコミュニケーションアプリ「SureTalk（シュアトーク）」](https://www.campuscreate.com/inclusive-x/column/249/) — 参照日: 2026-09-03
- [手話をAIで文章に　神奈川・藤沢市役所、窓口にシステム導入 | 毎日新聞](https://mainichi.jp/articles/20250226/k00/00m/040/303000c) — 参照日: 2026-09-03
- [デフリンピックで手話を翻訳、ソフトバンクの挑戦…キーワードはＡＩ : 読売新聞](https://www.yomiuri.co.jp/sports/para-sports/news/20251104-OYT1T50115/) — 参照日: 2026-09-03
- [きこえない・きこえにくい人の「旅での困る」をなくす「手話CGコンシェルジュ」による案内サービス　羽田空港などで実証実験を開始](https://prtimes.jp/main/html/rd/p/000000202.000019688.html) — 参照日: 2026-09-03
- [京セラ、手話表現を文字に変換　27年度にも自治体窓口に提供 - 日本経済新聞](https://www.nikkei.com/article/DGXZQOUF01DEK0R00C25A7000000/) — 参照日: 2026-09-03
- [宿泊施設の『おもてなし』を変える手話認識システム｜THL](https://www.thl.jp/demo/6333) — 参照日: 2026-09-03

**海外事例**
- [Google DeepMind's SL2T model brings real-time ASL sign-to-text input to Pixel 11](https://gcn.com/sign-to-text-google-deepmind-sl2t/21063/) — 参照日: 2026-09-03
- [More Sign Language in Video: AI as the Key to Accessibility](https://www.gl-systemhaus.de/en/blog/ai-sign-language-video-accessibility) — 参照日: 2026-09-03
- [INTERACT: AI-powered extended reality platform](https://open-research-europe.ec.europa.eu/articles/6-71) — 参照日: 2026-09-03
- [RoGSiLT – Robust and Generalizable Sign Language Translation](https://scaai.dfki.de/projects/rogsilt/) — 参照日: 2026-09-03
- [Real-Time Lithuanian Sign Language Translation (ViSign) - KTU](https://en.ktu.edu/projects/real-time-lithuanian-sign-language-translation-enhancing-media-accessibility-for-the-hearing-impaired-visign/) — 参照日: 2026-09-03

**学術研究**
- [State Space Models are Effective Sign Language Learners (PhonSSM)](https://arxiv.org/html/2604.08761v1) — 参照日: 2026-09-03
- [An explainable hybrid CNN–transformer model for sign language recognition (TinyMSLR)](https://link.springer.com/article/10.1038/s41598-026-38478-8) — 参照日: 2026-09-03
- [CSLRTransformer: A Pose-Only System for Continuous Sign Language Recognition](https://openaccess.thecvf.com/content/CVPR2026W/MSLR/papers/Licciardello_CSLRTransformer_A_Pose-Only_System_for_Continuous_Sign_Language_Recognition_CVPRW_2026_paper.pdf) — 参照日: 2026-09-03
- [Pose-Based Static Sign Language Recognition with Deep Learning for Turkish, Arabic, and American Sign Languages](https://www.mdpi.com/1424-8220/26/2/524) — 参照日: 2026-09-03
- [Real-Time Norwegian Sign Language Recognition Using MediaPipe and LSTM](https://www.mdpi.com/2414-4088/9/3/23) — 参照日: 2026-09-03
- [Mediapipe and CNNs for Real-Time ASL Gesture Recognition](https://arxiv.org/pdf/2305.05296) — 参照日: 2026-09-03
- [SigniFi - Real-time ASL translation application](https://github.com/arivvid27/SigniFi) — 参照日: 2026-09-03

### 不確実な点

1. 各システムの正確な認識精度（実用環境での実測値）は公開情報が限定的
2. SureTalkの具体的な実用化スケジュールとビジネスモデル
3. 欧州プロジェクト（RoGSiLT、ViSign等）の進捗状況と成果物
4. 商用システムの価格体系と導入コスト

### 推奨する次のステップ

1. **具体的導入を検討する場合**：
   - 用途・環境（自治体窓口/交通施設/宿泊施設/その他）を明確化
   - 対象手話言語（日本手話/国際手話）の選定
   - ソフトバンク・京セラなど国内ベンダーへの問い合わせ

2. **研究開発に関心がある場合**：
   - MediaPipeの技術ドキュメント精読
   - WLASLなどの公開データセットでプロトタイプ実装
   - 最新の状態空間モデル（Mamba系）の調査

3. **特定領域の深堀り**：
   - エッジデバイス向け軽量化技術
   - 多言語・国際手話対応アプローチ
   - アバター生成（テキスト→手話）技術

<!-- トピックごとにセクションを追加 -->
