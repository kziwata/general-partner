#!/usr/bin/env bash
# Data Science Osaka Summer 2026 — Python 環境セットアップ
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

if [[ ! -d .venv ]]; then
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate
pip install -U pip wheel
pip install -r requirements-minimal.txt

echo
echo "環境準備完了: ${ROOT}/.venv"
echo "有効化: source ${ROOT}/.venv/bin/activate"
echo "次の手順:"
echo "  1. Kaggle 認証（KAGGLE_API_TOKEN または kaggle auth login）"
echo "  2. コンペ招待・ルール同意"
echo "  3. ./scripts/download_data.sh"
