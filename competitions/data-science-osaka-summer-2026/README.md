# Data Science Osaka Summer 2026

[Kaggle コンペページ](https://www.kaggle.com/competitions/data-science-osaka-summer-2026)

**Beyond the Neighborhood: Predicting Ratings Across Users and Places**

招待制（Invitation required）の Community Prediction Competition。評価指標は Normalized Gini Index。

## ディレクトリ

```
data/competition/   # コンペデータ（gitignore）
notebooks/          # starter / guide
scripts/            # 環境構築・データ取得
submissions/        # 提出用
src/                # 実験コード用
.venv/              # ローカル Python 環境（gitignore）
```

## セットアップ

```bash
cd competitions/data-science-osaka-summer-2026
./scripts/setup_env.sh
source .venv/bin/activate
```

## Kaggle 認証（データ取得に必須）

この環境には API トークンが入っていないため、データ DL 前に認証が必要です。

```bash
# 推奨: https://www.kaggle.com/settings/api でトークン発行
export KAGGLE_API_TOKEN='xxxxx'
```

または:

```bash
kaggle auth login
```

その後、コンペページで招待を受け取り **Rules に同意** してから:

```bash
./scripts/download_data.sh
```

データは `data/competition/` に展開されます（starter ノートのローカルパスと一致）。

## ノートブック

| ファイル | 出典 |
|----------|------|
| `notebooks/data-science-osaka-summer-2026-starter.ipynb` | [YuyaYamamoto / nejumi](https://www.kaggle.com/code/nejumi/data-science-osaka-summer-2026-starter) |
| `notebooks/dsos2026-guide.ipynb` | [mugen88](https://www.kaggle.com/code/mugen88/dsos2026-guide) |

```bash
jupyter lab notebooks/
```

## データ一覧（要招待）

| ファイル | 内容 |
|----------|------|
| `train.csv.gz` | 学習データ（rating あり） |
| `test.csv` | テストデータ |
| `businesses.csv` | 店舗情報 |
| `business_categories.csv` | カテゴリ |
| `business_attributes.csv` | 属性 |
| `reviews.csv.gz` | レビュー文 |
| `interactions.csv.gz` | インタラクション（時刻付き） |
| `sample_submission.csv` | 提出フォーマット |

合計約 108 MB。
EOF
