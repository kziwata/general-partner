#!/usr/bin/env bash
# Data Science Osaka Summer 2026 — データ取得
set -euo pipefail

COMPETITION_SLUG="data-science-osaka-summer-2026"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${ROOT}/data/competition"

if [[ -f "${ROOT}/.venv/bin/activate" ]]; then
  # shellcheck disable=SC1091
  source "${ROOT}/.venv/bin/activate"
fi

if ! command -v kaggle >/dev/null 2>&1; then
  echo "error: kaggle CLI が見つかりません。先に scripts/setup_env.sh を実行してください。" >&2
  exit 1
fi

if [[ -z "${KAGGLE_API_TOKEN:-}" && ! -f "${HOME}/.kaggle/access_token" && ! -f "${HOME}/.kaggle/kaggle.json" ]]; then
  cat >&2 <<'EOF'
error: Kaggle 認証がありません。

次のいずれかで認証してください:

  1) API トークン（推奨・非対話）
       https://www.kaggle.com/settings/api で Generate New Token
       export KAGGLE_API_TOKEN='xxxxx'

  2) OAuth ログイン
       kaggle auth login

  3) 旧形式 kaggle.json
       ~/.kaggle/kaggle.json に {"username":"...","key":"..."} を配置

注意: このコンペは Invitation required です。
招待を受け取り、コンペページでルールに同意してから再実行してください。
EOF
  exit 1
fi

mkdir -p "${OUT_DIR}"
echo "Downloading ${COMPETITION_SLUG} -> ${OUT_DIR}"
kaggle competitions download -c "${COMPETITION_SLUG}" -p "${OUT_DIR}"

shopt -s nullglob
zips=("${OUT_DIR}"/*.zip)
if ((${#zips[@]})); then
  for z in "${zips[@]}"; do
    unzip -o "$z" -d "${OUT_DIR}"
  done
fi

# starter は train.csv / interactions.csv 等の非圧縮名を参照するため展開
for gz in "${OUT_DIR}"/*.gz; do
  [[ -f "$gz" ]] || continue
  gunzip -kf "$gz"
done

echo "Done. Files:"
ls -lh "${OUT_DIR}"
