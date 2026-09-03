# 2026-09-03 — WLASL データセットを使った手話認識プロトタイプ実装ガイド

## 目的

WLASL（Word-Level American Sign Language）データセットを使用した手話認識システムのプロトタイプ実装方法について、データセット入手からモデル訓練まで具体的な手順を整理する。

## WLASL データセットの概要

### 基本情報

- **正式名称**: Word-Level American Sign Language Dataset
- **論文**: "Word-level Deep Sign Language Recognition from Video: A New Large-scale Dataset and Methods Comparison" (WACV 2020 Best Paper Honourable Mention)
- **公式リポジトリ**: https://github.com/dxli94/WLASL
- **プロジェクトページ**: https://dxli94.github.io/WLASL/
- **ライセンス**: C-UDA（Computational Use of Data Agreement）— 学術・研究用途のみ、商用利用不可

### データセット規模

| サブセット | 語彙数 | 動画数（概算） | 用途 |
|----------|--------|-------------|------|
| WLASL100 | 100語 | ~2,000 | プロトタイプ・学習テスト |
| WLASL300 | 300語 | ~6,000 | 中規模実験 |
| WLASL1000 | 1,000語 | ~10,000 | 本格的研究 |
| WLASL2000 | 2,000語 | ~21,000 | 最大規模・ベンチマーク |

**特徴**:
- 100人以上の異なる手話者
- 動画形式で収録（YouTube等から収集）
- 各動画にバウンディングボックス、手話者ID、光学フローなどのメタデータ付き
- JSONファイルでアノテーション管理

### データ構造

```json
{
  "gloss": "手話の単語",
  "instances": [
    {
      "video_id": "動画ID",
      "url": "YouTube URL",
      "start_time": "開始時刻",
      "end_time": "終了時刻",
      "bbox": [xmin, ymin, xmax, ymax],
      "signer_id": "手話者ID",
      "split": "train/test/val"
    }
  ]
}
```

## データセット入手方法

### 問題点と現状

- **リンク切れ**: 元のYouTube動画の約43%が削除されており、公式スクリプトでは完全なダウンロードが困難
- **前処理の手間**: 動画のダウンロード・切り出し・前処理に時間がかかる

### 推奨：キュレート済みデータセット（最速・確実）

#### オプション1: Kaggleのキュレート版（推奨）

**提供元**: risangbaskoro（旧版）、nadimsrabon6（最新版）

**最新版の特徴**:
- **1,910クラス**（利用可能な動画のみに絞り込み）
- **11,724動画** — すべて検証済み、破損ファイル0
- **70/15/15の決定論的split** — train/val/test すべてのクラスで利用可能
- 前処理済みで即訓練可能

**ダウンロード手順**:

```bash
# Kaggle APIのインストール
pip install kaggle

# Kaggle API認証設定（~/.kaggle/kaggle.json が必要）
# https://www.kaggle.com/settings/account で API Token を取得

# データセットダウンロード
kaggle datasets download -d nadimsrabon6/wlasl-complete-curated-dataset
unzip wlasl-complete-curated-dataset.zip -d data/wlasl/

# ディレクトリ構造
# data/wlasl/
# ├── videos/                    # 11,724動画ファイル
# ├── WLASL_custom_split.json    # 詳細メタデータ
# ├── nslt_custom.json           # シンプルな訓練用フォーマット
# ├── custom_class_list.txt      # クラスインデックス→単語マッピング
# └── dropped_classes.txt        # 除外されたクラスと理由
```

**使用するファイル**:
- 訓練: `nslt_custom.json` + `custom_class_list.txt` + `videos/`
- 詳細メタデータが必要な場合のみ: `WLASL_custom_split.json`

#### オプション2: FiftyOneからロード

```bash
pip install fiftyone

# Python内で
import fiftyone as fo
import fiftyone.utils.huggingface as fouh

# Hugging Faceからロード（11,980サンプル）
dataset = fouh.load_from_hub("Voxel51/WLASL")

# FiftyOne Appで可視化
session = fo.launch_app(dataset)
```

**利点**:
- データ探索・可視化が容易
- フィルタリング・サンプリングが簡単
- 品質チェックがインタラクティブ

#### オプション3: 公式リポジトリから（参考）

```bash
git clone https://github.com/dxli94/WLASL.git
cd WLASL/start_kit

# YouTube-dlインストール
pip install yt-dlp  # youtube-dlの後継

# 動画ダウンロード（時間がかかる & リンク切れ多数）
python video_downloader.py

# 前処理
python preprocess.py
```

**注意**: リンク切れが多いため、欠損動画リクエストフォームから著者に依頼が必要（最大7日待ち）。プロトタイプには**Kaggle版を強く推奨**。

## 実装アプローチ

### アプローチ1: MediaPipe + 軽量分類器（最速プロトタイプ）

**概要**: 骨格ベースの手話認識。計算コスト低、CPU動作可能。

**技術スタック**:
- MediaPipe Hands: 21ランドマーク抽出
- 分類器: Random Forest / MLP / LSTM
- フレームワーク: scikit-learn / TensorFlow Lite / PyTorch

#### ステップ1: 環境構築

```bash
# 必要なライブラリ
pip install mediapipe opencv-python numpy scikit-learn

# TensorFlow使用の場合
pip install tensorflow

# PyTorch使用の場合
pip install torch torchvision
```

#### ステップ2: ランドマーク抽出

```python
import cv2
import mediapipe as mp
import numpy as np

# MediaPipe初期化
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.5
)

def extract_landmarks(video_path):
    """動画から手の21ランドマーク（x, y, z）を抽出"""
    cap = cv2.VideoCapture(video_path)
    landmarks_sequence = []
    
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        
        # BGR→RGB変換
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = hands.process(image)
        
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                # 21ランドマーク × (x, y, z) = 63次元
                landmarks = []
                for lm in hand_landmarks.landmark:
                    landmarks.extend([lm.x, lm.y, lm.z])
                landmarks_sequence.append(landmarks)
    
    cap.release()
    return np.array(landmarks_sequence)

# 正規化
def normalize_landmarks(landmarks):
    """手首（ランドマーク0）を原点とした相対座標に変換"""
    if len(landmarks) == 0:
        return landmarks
    
    # 手首の座標を減算
    wrist_x, wrist_y, wrist_z = landmarks[:, 0], landmarks[:, 1], landmarks[:, 2]
    normalized = landmarks.copy()
    normalized[:, 0::3] -= wrist_x[:, np.newaxis]  # x座標
    normalized[:, 1::3] -= wrist_y[:, np.newaxis]  # y座標
    normalized[:, 2::3] -= wrist_z[:, np.newaxis]  # z座標
    
    # スケール正規化（手のひらサイズで割る）
    palm_size = np.linalg.norm([
        landmarks[:, 9*3:9*3+3] - landmarks[:, 0:3]  # 中指MCP - 手首
    ], axis=-1, keepdims=True)
    normalized = normalized / (palm_size + 1e-8)
    
    return normalized
```

#### ステップ3: 特徴量生成

```python
# オプション1: フレームごとの特徴（静的ジェスチャー向け）
def frame_features(landmarks_seq):
    """各フレームの63次元特徴"""
    return landmarks_seq

# オプション2: 統計的特徴（動的ジェスチャー向け）
def statistical_features(landmarks_seq):
    """平均・標準偏差・最大・最小を計算"""
    features = []
    features.extend(np.mean(landmarks_seq, axis=0))   # 平均
    features.extend(np.std(landmarks_seq, axis=0))    # 標準偏差
    features.extend(np.max(landmarks_seq, axis=0))    # 最大
    features.extend(np.min(landmarks_seq, axis=0))    # 最小
    return np.array(features)  # 63 × 4 = 252次元

# オプション3: LSTM用の時系列そのまま
def sequence_features(landmarks_seq, max_len=64):
    """固定長にパディング/トリミング"""
    if len(landmarks_seq) > max_len:
        return landmarks_seq[:max_len]
    else:
        # ゼロパディング
        padded = np.zeros((max_len, landmarks_seq.shape[1]))
        padded[:len(landmarks_seq)] = landmarks_seq
        return padded
```

#### ステップ4: モデル訓練

**Random Forest（最速）**:

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pickle

# データ準備（例: 統計的特徴）
X = []  # 特徴ベクトルのリスト
y = []  # ラベルのリスト

for video_path, label in dataset:
    landmarks = extract_landmarks(video_path)
    normalized = normalize_landmarks(landmarks)
    features = statistical_features(normalized)
    X.append(features)
    y.append(label)

X = np.array(X)
y = np.array(y)

# 訓練・テスト分割
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# 訓練
clf = RandomForestClassifier(n_estimators=200, max_depth=20, random_state=42)
clf.fit(X_train, y_train)

# 評価
accuracy = clf.score(X_test, y_test)
print(f"Test Accuracy: {accuracy:.2%}")

# 保存
with open('sign_recognition_model.pkl', 'wb') as f:
    pickle.dump(clf, f)
```

**MLP（TensorFlow Lite向け）**:

```python
import tensorflow as tf

# モデル構築
model = tf.keras.Sequential([
    tf.keras.layers.Input(shape=(252,)),  # 統計的特徴の次元
    tf.keras.layers.Dense(256, activation='relu'),
    tf.keras.layers.Dropout(0.3),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dropout(0.3),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

# コンパイル
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# 訓練
history = model.fit(
    X_train, y_train,
    validation_split=0.2,
    epochs=50,
    batch_size=32
)

# TFLite変換（モバイル展開用）
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

with open('model.tflite', 'wb') as f:
    f.write(tflite_model)
```

**LSTM（時系列モデリング）**:

```python
import torch
import torch.nn as nn

class SignLSTM(nn.Module):
    def __init__(self, input_size=63, hidden_size=128, num_layers=2, num_classes=100):
        super(SignLSTM, self).__init__()
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, num_classes)
    
    def forward(self, x):
        # x: (batch, seq_len, input_size)
        lstm_out, _ = self.lstm(x)
        # 最後のタイムステップを使用
        out = self.fc(lstm_out[:, -1, :])
        return out

# 訓練ループ
model = SignLSTM(num_classes=100)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

for epoch in range(50):
    for sequences, labels in train_loader:  # sequences: (batch, 64, 63)
        outputs = model(sequences)
        loss = criterion(outputs, labels)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
```

#### 参考実装リポジトリ

1. **dev-yuci/sign-language-recognizer**
   - GitHub: https://github.com/dev-yuci/sign-language-recognizer
   - 特徴: MediaPipe + Random Forest、完全オフライン動作
   - 精度: ASLアルファベット26文字で高精度

2. **Muhib-Mehdi/ASL-Recognition-System**
   - GitHub: https://github.com/Muhib-Mehdi/ASL-Recognition-System
   - 特徴: MediaPipe + TensorFlow Lite、リアルタイム推論
   - データ収集モード付き

### アプローチ2: I3D（Inflated 3D ConvNet）— WLASL公式ベースライン

**概要**: 動画全体から時空間特徴を抽出。WLASL論文の公式手法。

**技術スタック**:
- I3D（Inception3D）: Kinetics事前学習済み
- フレームワーク: PyTorch
- 精度: WLASL2000で約32.48%（ベースライン）

#### ステップ1: 環境構築

```bash
git clone https://github.com/dxli94/WLASL.git
cd WLASL

pip install torch torchvision opencv-python
```

#### ステップ2: 事前学習済み重みダウンロード

```bash
# Kinetics事前学習済みI3D重み
mkdir -p code/I3D/weights
# Google Driveから手動ダウンロード:
# https://drive.google.com/file/d/1JgTRHGBRCHyHRT_rAF0fOjnfiFefXkEd/view
# → code/I3D/weights/ に展開
```

#### ステップ3: データセット配置

```bash
mkdir -p data
# Kaggleからダウンロードしたvideos/をdata/以下に配置
cp -r /path/to/wlasl/videos data/

# アノテーションファイル
cp WLASL_v0.3.json start_kit/
```

#### ステップ4: 訓練

```bash
cd code/I3D

# train_i3d.py の設定を編集（オプション）
# - root: 動画ディレクトリパス
# - train_split: アノテーションJSONパス
# - configs.batch_size: バッチサイズ（デフォルト8）
# - configs.init_lr: 初期学習率（デフォルト0.0001）

# 訓練実行
python train_i3d.py

# 主要パラメータ:
# - 最適化: Adam（lr=1e-4, weight_decay=1e-7）
# - スケジューラ: ReduceLROnPlateau（patience=5, factor=0.3）
# - データ拡張: RandomCrop(224), RandomHorizontalFlip
# - 最大ステップ: 64K（約400エポック）
```

#### ステップ5: テスト

```bash
# 事前学習済みモデルダウンロード（オプション）
# https://drive.google.com/file/d/1jALimVOB69ifYkeT0Pe297S1z4U3jC48/view
# → code/I3D/archived/ に展開

# テスト実行
python test_i3d.py

# test_i3d.py の24, 270行目を編集してサブセット選択
# WLASL100/300/1000/2000
```

#### モデル構造の概要

```python
# I3Dアーキテクチャ
class InceptionI3d(nn.Module):
    def __init__(self, num_classes=400, in_channels=3):
        # 入力: (batch, 3, T, 224, 224)  T=フレーム数
        # Kinetics-400で事前学習（num_classes=400）
        
    def replace_logits(self, num_classes):
        # 最終層を2000クラスに置き換え（転移学習）
        self.logits = nn.Conv3d(1024, num_classes, kernel_size=1)

# 転移学習の流れ
i3d = InceptionI3d(400, in_channels=3)
i3d.load_state_dict(torch.load('weights/rgb_imagenet.pt'))
i3d.replace_logits(num_classes=2000)  # WLASLクラス数
```

#### 参考実装リポジトリ

1. **ahmad-sardar/wlasl-baseline-model**
   - GitHub: https://github.com/ahmad-sardar/wlasl-baseline-model
   - 特徴: 公式コードのバグ修正版、訓練済み重み付き
   - Seq2Seqモデル（グロス列→英語キャプション）も含む

2. **sumedhsp/Sign-Language-Recognition**
   - GitHub: https://github.com/sumedhsp/Sign-Language-Recognition
   - 特徴: I3D + Transformer、時系列モデリング強化
   - 6層Transformerエンコーダで依存関係を学習

### アプローチ3: Pose-TGCN（時間的グラフ畳み込み）

**概要**: 骨格グラフの時系列変化をモデル化。I3Dより軽量。

**技術スタック**:
- MediaPipe / OpenPose: 骨格抽出
- T-GCN: 時空間グラフ畳み込み
- フレームワーク: PyTorch

#### ステップ1: 骨格データダウンロード

```bash
# WLASLリポジトリから
cd WLASL
mkdir -p data/splits data/pose_per_individual_videos

# Google Driveから:
# Splits: https://drive.google.com/file/d/16CWkbMLyEbdBkrxAPaxSXFP_aSxKzNN4/view
# Keypoints: https://drive.google.com/file/d/1k5mfrc2g4ZEzzNjW6CEVjLvNTZcmPanB/view
# → data/ 以下に展開
```

#### ステップ2: 訓練

```bash
cd code/TGCN

# train_tgcn.py のパス設定を編集
# main()関数内で WLASL ルートパスを指定

python train_tgcn.py
```

#### モデル構造の概要

```python
# T-GCN: 時空間グラフ畳み込み
class TGCN(nn.Module):
    def __init__(self, num_class, num_point, num_person):
        # 入力: (batch, C, T, V, M)
        # C: チャネル（座標次元）
        # T: 時間ステップ
        # V: グラフノード数（関節数）
        # M: 人数
        
        self.graph = Graph()  # 骨格グラフ構造
        self.st_gcn_networks = nn.ModuleList([
            ST_GCN_Block(in_channels, out_channels, kernel_size, stride)
            for layer in layers
        ])
```

**利点**:
- I3Dより計算コスト低
- 骨格ベースでプライバシー保護
- 時空間関係を明示的にモデル化

## ベンチマーク精度（参考）

### WLASL100

| モデル | Top-1精度 | 備考 |
|--------|-----------|------|
| PhonSSM | 88.37% | 音韻論的状態空間モデル（2026年） |
| Siformer | 86.5% | Transformer系（2025年） |
| LA-Sign | 88.66% | 言語アシスト（2026年） |

### WLASL2000

| モデル | Top-1精度 | 備考 |
|--------|-----------|------|
| Logos-Pretraining | 66.82% | SOTA（2025年） |
| Uni-Sign | 63.52% | 統合型（2025年） |
| NLA-SLR | 61.26% | 自然言語アシスト（2023年） |
| SAM-SLR | 58.73% | スケルトンマルチモーダル（2021年） |
| I3D（ベースライン） | 32.48% | 公式手法（2020年） |

**参考**:
- 最新のベンチマークは https://paperswithcode.com/task/sign-language-recognition で確認
- WLASL2000は難易度が高く、50%超えで強力なモデル

## その他の主要データセット

### 連続手話認識向け

#### RWTH-PHOENIX-Weather 2014T

- **言語**: ドイツ手話（DGS）
- **規模**: 
  - Train: 7,096動画
  - Dev: 519動画
  - Test: 642動画
- **語彙**: 1,085グロス
- **タスク**: 連続手話認識 + ドイツ語翻訳
- **評価指標**: WER（Word Error Rate）
- **SOTA**: TwoStream-SLR（WER 18.8%）
- **入手**: https://www-i6.informatik.rwth-aachen.de/~koller/RWTH-PHOENIX/

#### CSL-Daily

- **言語**: 中国手話（CSL）
- **規模**:
  - Train: 18,401動画
  - Dev: 1,077動画
  - Test: 1,176動画
- **語彙**: 2,000グロス
- **トピック**: 日常会話（旅行、家族、銀行、買い物）
- **評価指標**: WER
- **SOTA**: TwoStream-SLR（WER 25.3%）
- **入手**: http://home.ustc.edu.cn/~zhouh156/dataset/csl-daily/

### 比較まとめ

| データセット | タスク | 語彙 | 動画数 | 評価指標 | 難易度 |
|------------|--------|------|--------|---------|--------|
| WLASL2000 | 孤立語認識 | 2,000 | ~21,000 | Top-1 Acc | 中 |
| Phoenix-2014T | 連続認識+翻訳 | 1,085 | ~8,000 | WER/BLEU | 高 |
| CSL-Daily | 連続認識+翻訳 | 2,000 | ~20,000 | WER/BLEU | 高 |

**選定ガイド**:
- **プロトタイプ**: WLASL100（小規模、計算コスト低）
- **孤立語認識研究**: WLASL2000（最大規模）
- **連続手話認識**: Phoenix-2014T（標準ベンチマーク）
- **多言語研究**: 複数データセット組み合わせ

## 推奨する学習ロードマップ

### フェーズ1: プロトタイプ（1-2週間）

1. **環境構築**
   - Python 3.8+、PyTorch/TensorFlow、MediaPipe、OpenCV
   
2. **データ準備**
   - Kaggleから WLASL Complete Curated Dataset ダウンロード
   - WLASL100サブセット（100語）に絞る
   
3. **MediaPipe + Random Forest 実装**
   - `dev-yuci/sign-language-recognizer` をベースに改造
   - 21ランドマーク抽出 → 統計的特徴 → Random Forest
   - 目標精度: 70-80%
   
4. **リアルタイム推論デモ**
   - Webカメラから手話入力
   - 予測結果をテキスト表示

### フェーズ2: 精度向上（2-4週間）

1. **LSTM モデル実装**
   - 時系列モデリングで動的ジェスチャーに対応
   - 目標精度: 80-85%
   
2. **データ拡張**
   - ノイズ追加、回転、スケール変換
   - 訓練データを2-3倍に増強
   
3. **WLASL300 へスケール**
   - 語彙を300語に拡張
   - 目標精度: 70%+

### フェーズ3: 本格研究（1-3ヶ月）

1. **I3D またはTransformer実装**
   - 公式ベースラインコードから開始
   - Kinetics事前学習を活用
   
2. **WLASL2000 でベンチマーク**
   - 最新手法（PhonSSM、Uni-Sign等）の論文を参考
   - 目標精度: 40-50%（改善手法なし）、60%+（SOTA手法適用）
   
3. **論文執筆・投稿**
   - 新規手法の提案
   - CVPR/ICCV/ECCV Workshop（Sign Language Recognition Track）

## トラブルシューティング

### 問題1: 動画が読み込めない

```python
# OpenCVのVideoCapture失敗チェック
cap = cv2.VideoCapture(video_path)
if not cap.isOpened():
    print(f"Failed to open: {video_path}")
    return None

ret, frame = cap.read()
if not ret or frame is None:
    print(f"Failed to read frame from: {video_path}")
    return None
```

### 問題2: メモリ不足

- **バッチサイズ削減**: 8 → 4 → 2
- **動画解像度削減**: 224x224 → 112x112
- **Mixed Precision Training**:
  ```python
  from torch.cuda.amp import autocast, GradScaler
  scaler = GradScaler()
  
  with autocast():
      outputs = model(inputs)
      loss = criterion(outputs, labels)
  ```

### 問題3: 精度が上がらない

- **学習率調整**: ReduceLROnPlateau で自動調整
- **クラス不均衡対応**:
  ```python
  from torch.utils.data import WeightedRandomSampler
  class_weights = compute_class_weight('balanced', classes=np.unique(y_train), y=y_train)
  sampler = WeightedRandomSampler(class_weights, len(train_dataset))
  ```
- **事前学習の活用**: BSL-1K、Kinetics等で事前学習したモデルを使用

## 参考文献

### 論文

1. Li et al. (2020). "Word-level Deep Sign Language Recognition from Video: A New Large-scale Dataset and Methods Comparison". WACV 2020.
2. Carreira & Zisserman (2017). "Quo Vadis, Action Recognition? A New Model and the Kinetics Dataset". CVPR 2017.
3. PhonSSM (2026). "State Space Models are Effective Sign Language Learners: Exploiting Phonological Compositionality for Vocabulary-Scale Recognition". ArXiv 2604.08761.

### 公式リソース

- WLASL公式: https://dxli94.github.io/WLASL/
- MediaPipe Hands: https://developers.google.com/mediapipe/solutions/vision/hand_landmarker
- PyTorch I3D: https://github.com/piergiaj/pytorch-i3d

### 実装例

- 軽量プロトタイプ: https://github.com/dev-yuci/sign-language-recognizer
- I3Dベースライン: https://github.com/ahmad-sardar/wlasl-baseline-model
- Webアプリ例: https://github.com/Ethan-vim/wlasl-to-word

## まとめ

### プロトタイプ実装の最短ルート

1. **Kaggleから WLASL Curated Dataset をダウンロード**（5分）
2. **MediaPipe + Random Forest で WLASL100 訓練**（1-2日）
3. **Webカメラでリアルタイムデモ作成**（半日）

### 次のステップ

- LSTM/Transformerで精度向上
- 連続手話認識への拡張（Phoenix-2014T）
- 多言語対応（国際手話・日本手話）

### 注意点

- **C-UDA契約を遵守**（学術用途のみ）
- **データ拡張で過学習防止**
- **定期的に最新SOTA論文をチェック**（Papers with Code）

---

**質問・追加調査が必要な項目があればお知らせください。**
