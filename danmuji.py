# -*- coding:utf-8 -*-
import requests;
import time;

class Danmu():
    def __init__(self):
        # 弹幕url
        self.url = 'https://api.live.bilibili.com/xlive/web-room/v1/dM/gethistory';
        # 请求头
        self.headers = {
            'Host':'api.live.bilibili.com',
            'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0',
        }
        # 定义POST传递的参数
        self.data = {
            'roomid':'b站房间id',
            'csrf_token':'',
            'csrf':'',
            'visit_id':'',
        }
        # 日志写对象
        self.log_file_write = open('danmu.log',mode='a',encoding='utf-8');
        # 读取日志
        log_file_read = open('danmu.log',mode='r',encoding='utf-8');
        self.log = log_file_read.readlines();
        
    def get_danmu(self):
        # 获取直播间弹幕
        html = requests.post(url=self.url,headers=self.headers,data=self.data).json();
        # 解析弹幕列表
        for content in html['data']['room']:
            # 获取昵称
            nickname = content['nickname'];
            # 获取发言
            text = content['text'];
            # 获取发言时间
            timeline = content['timeline'];
            # 记录发言
            msg = timeline+' '+nickname+': '+text;
            # 判断对应消息是否存在于日志，如果和最后一条相同则打印并保存
            if msg+'\n' not in self.log:
                # 打印消息
                print (msg);
                # 保存日志
                self.log_file_write.write(msg+'\n');
                # 添加到日志列表
                self.log.append(msg+'\n');
            # 清空变量缓存
            nickname = '';
            text = '';
            timeline = '';
            msg = '';
            
        

# 创建bDanmu实例
bDanmu = Danmu();
while True:
    # 暂停0.5防止cpu占用过高
    time.sleep(0.5);
    # 获取弹幕
    bDanmu.get_danmu();
