#!/bin/sh

echo "请输入内容："
stty -icanon  # 关闭终端的行缓冲
#stty erase ^? # 设置删除键
input=""
while true; do
    # 读取单个字符
    char=$(dd bs=1 count=1 2>/dev/null)

    # 检查是否是回车键
    if [ "$char" = "$(echo -n '\n')" ]; then
        break
    fi

    # 检查是否是删除键
    if [ "$char" = "" ]; then
	#读取输入最后3字节
	last_char=$(echo -n "$input" | tail -c 3)
	#读取3字节中首字节
	first_byte=$(echo -n "$last_char" | od -An -t u1 | awk '{print $1}')
	if [ "$first_byte" -le 127 ]; then
        	# ASCII字符，删除1字节
        	input="${input%?}"
        	echo -n "\b\b\b   \b\b\b"
	else
		#utf-8中文，删除3字节
        	input="${input%???}"
        	echo -n "\b\b\b\b    \b\b\b\b"
	fi
    else
        # 将输入的字符添加到input变量中
        input="$input$char"
    fi
done

stty sane  # 恢复终端原本设置
echo -n "$input"|hexdump -e '"%04_ad|" 8/1 "%02x " "\n"'
echo "----------------------------"
echo -n "$input"|hexdump -e '"%04_ad|" 8/1 "% 2c " "\n"'
