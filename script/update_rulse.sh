#!/bin/bash

# Git 저장소와 룰셋 경로 설정
REPO_DIR="$HOME/IDS_Ruleset"
REMOTE_RULE="$REPO_DIR/ruleset/snort/ids.rules"
LOCAL_RULE="/home/noclass/capstone/snort3/ruleset/ids.rules"

echo "[+] Git 저장소에서 최신 룰셋 가져오는 중..."
cd "$REPO_DIR" || { echo "[-] 저장소 경로 오류"; exit 1; }
git pull origin main || { echo "[-] git pull 실패"; exit 1; }

echo "[+] ids.rules 덮어쓰기 중..."
cp "$REMOTE_RULE" "$LOCAL_RULE" || { echo "[-] 룰 복사 실패"; exit 1; }

echo "[+] Snort 설정 테스트 중..."
snort -T -c /etc/snort/snort.lua || { echo "[-] Snort 설정 오류"; exit 1; }

echo "[+] Snort 재시작 중..."
sudo systemctl restart snort || { echo "[-] Snort 재시작 실패"; exit 1; }

echo "[✓] 룰셋 덮어쓰기 및 Snort 적용 완료"
