#!/bin/bash
# 移除 USB Gadget 设备（通用，适用于任何 gadget 配置）

CONFIGFS="/sys/kernel/config/usb_gadget"

if [ ! -d "$CONFIGFS" ]; then
    echo "错误: $CONFIGFS 不存在，configfs 可能未挂载"
    exit 1
fi

for gadget in "$CONFIGFS"/*/; do
    [ -d "$gadget" ] || continue
    name=$(basename "$gadget")
    echo "正在移除 gadget: $name"

    # 1. 解绑 UDC
    if [ -f "$gadget/UDC" ]; then
        echo "" > "$gadget/UDC" 2>/dev/null && echo "  UDC 已解绑"
    fi

    # 2. 删除 configs 下的符号链接（functions 链接）
    for cfg in "$gadget"/configs/*/; do
        [ -d "$cfg" ] || continue
        for link in "$cfg"/*; do
            [ -L "$link" ] || continue
            rm "$link" && echo "  移除链接: $(basename "$link")"
        done
        # 删除 configs 下的 strings
        for lang in "$cfg"/strings/*/; do
            [ -d "$lang" ] || continue
            rmdir "$lang" 2>/dev/null
        done
        rmdir "$cfg/strings" 2>/dev/null
        rmdir "$cfg" 2>/dev/null && echo "  移除配置: $(basename "$cfg")"
    done

    # 3. 删除 functions
    for func in "$gadget"/functions/*/; do
        [ -d "$func" ] || continue
        rmdir "$func" 2>/dev/null && echo "  移除功能: $(basename "$func")"
    done

    # 4. 删除 os_desc 链接
    if [ -d "$gadget/os_desc" ]; then
        for link in "$gadget/os_desc"/*; do
            [ -L "$link" ] || continue
            rm "$link" && echo "  移除 os_desc 链接: $(basename "$link")"
        done
    fi

    # 5. 删除 strings
    for lang in "$gadget"/strings/*/; do
        [ -d "$lang" ] || continue
        rmdir "$lang" 2>/dev/null && echo "  移除字符串: $(basename "$lang")"
    done

    # 6. 删除 gadget 目录本身
    rmdir "$gadget" 2>/dev/null && echo "  gadget $name 已移除" || echo "  警告: 无法完全移除 $name（可能有残留）"
done

echo "完成"
