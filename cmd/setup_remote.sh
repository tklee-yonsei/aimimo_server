#!/bin/bash

# Define the file where the user information will be stored
CONFIG_FILE="${PWD}/.env/remote_server_config"

# Prompt the user for input only if the config file does not exist
if [ ! -f "$CONFIG_FILE" ]; then
    # If the file does not exist, prompt the user for input
    read -p "서버 사용자 계정 : " REMOTE_USER
    read -p "서버 IP 주소 : " REMOTE_SERVER
    read -p "서버 SSH 포트 (예: 22): " SSH_PORT 
    read -p "서버 원격 경로 (절대 경로. 예: /home/tklee/aimimo_code/aimimo_server/): " REMOTE_PATH

    # Create the .env directory if it doesn't exist
    mkdir -p "${PWD}/.env"

    # Save the user input to the config file
    echo "REMOTE_USER=${REMOTE_USER}" > "$CONFIG_FILE"
    echo "REMOTE_SERVER=${REMOTE_SERVER}" >> "$CONFIG_FILE"
    echo "SSH_PORT=${SSH_PORT}" >> "$CONFIG_FILE"
    echo "REMOTE_PATH=${REMOTE_PATH}" >> "$CONFIG_FILE"
else
    echo "설정이 이미 존재합니다."
    echo "리셋하려면, ${CONFIG_FILE} 파일을 삭제하고 이 태스크를 다시 실행하세요."
fi