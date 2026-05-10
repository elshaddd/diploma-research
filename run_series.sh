#!/bin/bash

BASE_CMD="docker compose run --rm benchmark python run_benchmark.py --experiments 33 --archiver-url http://archiver-app:8000 --redis-url redis://redis:6379"

# Все сервисы
SERVICES=("gaze" "emotions" "sound" "cursor" "thermal-imager" "transcription", "breathing", "ecg")

echo "Серия 1: зависимость от числа модальностей"

for ((i=0; i<${#SERVICES[@]}; i++)); do
    current_services=$(IFS=,; echo "${SERVICES[*]:0:$((i+1))}")

    cmd="$BASE_CMD --services $current_services >> benchmark.log 2>&1"

    echo "Running: $cmd"
    eval $cmd
done

echo "Серия 2: зависимость от длительности"

FIXED_SERVICES="gaze,emotions,sound"
DURATIONS=(60 180 300 420 600)

for d in "${DURATIONS[@]}"; do
    cmd="$BASE_CMD --services $FIXED_SERVICES --duration $d"

    echo "Running: $cmd"
    eval $cmd
done
