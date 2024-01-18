#!/bin/bash

# Удаляем лог сборки от прошлой компиляции
rm -f logbuild.txt
rm -rf out

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/atl4nt/Build_drive/kernel_SP401/compiler/bin/arm-linux-androideabi-

# Выполняем команды make clean и make mrproper
make clean
make mrproper

# Создаем директорию "out", если её нет
mkdir -p out

# Получаем конфигурацию из первого аргумента (по умолчанию - "sp7731ceb_dt_defconfig")
config="${1:-sp7731ceb_dt_defconfig}"

# Если второй аргумент равен "menu", то вызываем утилиту menuconfig
if [ "$2" == "menu" ]; then
    make ARCH=arm O=out CROSS_COMPILE=/home/atl4nt/Build_drive/kernel_SP401/compiler/bin/arm-linux-androideabi- $config menuconfig
fi

# Запускаем сборку и записываем лог в файл logbuild.txt
start_time=$(date +%s)
make O=out ARCH=arm sp7731ceb_dt_defconfig && make -j$(nproc --all) ARCH=arm O=out CROSS_COMPILE=/home/atl4nt/Build_drive/kernel_SP401/compiler/bin/arm-linux-androideabi- 2>&1 | tee logbuild.txt
end_time=$(date +%s)

# Выводим время компиляции
elapsed_time=$((end_time - start_time))
echo "Compilation completed in: $(date -u -d @${elapsed_time} +"%T")"