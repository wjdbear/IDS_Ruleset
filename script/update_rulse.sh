#!/bin/bash

# 경로 설정
REPO_DIR="$HOME/IDS_Ruleset"
SNORT_RULE_SRC="$REPO_DIR/ruleset/snort"
OSSEC_RULE_SRC="$REPO_DIR/ruleset/ossec"

SNORT_RULE_DEST="/etc/snort/rules"
OSSEC_RULE_DEST="/var/ossec/rules"

echo "[+] Git 저장소 최신 상태로 업데이트 중..."
cd "$REPO_DIR" || { echo "[-] 저장소 경로 오류"; exit 1; }
git pull origin main || { echo "[-] git pull 실패"; exit 1; }

echo "[+] Snort 룰 복사 중..."
sudo cp "$SNORT_RULE_SRC"/*.rules "$SNORT_RULE_DEST"/ || { echo "[-] Snort 룰 복사 실패"; exit 1; }

echo "[+] Snort 설정 테스트 중..."
snort -T -c /etc/snort/snort.lua || { echo "[-] Snort 설정 오류"; exit 1; }

echo "[+] Snort 재시작 중..."
sudo systemctl restart snort || { echo "[-] Snort 재시작 실패"; exit 1; }

echo "[+] OSSEC 룰 복사 중..."
sudo cp "$OSSEC_RULE_SRC"/*.xml "$OSSEC_RULE_DEST"/ || { echo "[-] OSSEC 룰 복사 실패"; exit 1; }

echo "[+] OSSEC(Wazuh) 재시작 중..."
sudo systemctl restart wazuh-manager || { echo "[-] OSSEC 재시작 실패"; exit 1; }

echo "[✓] 룰셋 업데이트 및 재시작 완료"
