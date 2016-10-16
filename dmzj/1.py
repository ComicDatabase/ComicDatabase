import requests
import re
import json
import os
import sys
import argparse
import threading
from time import sleep

requestSession = requests.session()
UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) \
      AppleWebKit/537.36 (KHTML, like Gecko) \
      Chrome/52.0.2743.82 Safari/537.36'  # Chrome on win10
REFERER = """http://www.dmzj.com/"""
requestSession.headers.update({'User-Agent': UA,'Referer':REFERER})

class ErrorCode(Exception):
    '''自定义错误码:
        1: URL不正确
        2: URL无法跳转为移动端URL
        3: 中断下载'''
    def __init__(self, code):
        self.code = code

    def __str__(self):
        return repr(self.code)

def downloadImg(imgUrlList, contentPath, one_folder=False):
    count = len(imgUrlList)
    print('该集漫画共计{}张图片'.format(count))
    i = 1
    downloaded_num = 0
    
    def __download_callback():
        nonlocal downloaded_num
        nonlocal count
        downloaded_num += 1
        print('\r{}/{}... '.format(downloaded_num, count), end='')
        
    download_threads = []
    for imgUrl in imgUrlList:
        if not one_folder:
            imgPath = os.path.join(contentPath, '{0:0>3}.jpg'.format(i))
        else:
            imgPath = contentPath + '{0:0>3}.jpg'.format(i)
        i += 1
        
        #目标文件存在就跳过下载
        if os.path.isfile(imgPath):
            count -= 1
            continue
        download_thread = threading.Thread(target=__download_one_img, 
            args=(imgUrl,imgPath, __download_callback))
        download_threads.append(download_thread)
        download_thread.start()
    [ t.join() for t in download_threads ]
    print('完毕!\n')

def __download_one_img(imgUrl,imgPath, callback):
    retry_num = 0
    retry_max = 2
    while True:
      try:
          downloadRequest = requestSession.get(imgUrl, stream=True, timeout=2)
          with open(imgPath, 'wb') as f:
              for chunk in downloadRequest.iter_content(chunk_size=1024): 
                  if chunk: # filter out keep-alive new chunks
                      f.write(chunk)
                      f.flush()
          callback()
          break
      except (KeyboardInterrupt, SystemExit):
          print('\n\n中断下载，删除未下载完的文件！')
          if os.path.isfile(imgPath):
              os.remove(imgPath)
          raise ErrorCode(3)
      except:
          retry_num += 1
          if retry_num >= retry_max:
              raise
          print('下载失败，重试' + str(retry_num) + '次')
          sleep(2)


def main (path,ppath):
    #id = '50355'
    if not os.path.isdir(ppath):
           os.makedirs(ppath)

    a = open(path).readlines()
    #b = ''.join(a[1:])
    for m in range(1,len(a)):
        c = a[m].replace("\n","")
        if (c != ''):
            c = "http://images.dmzj.com/" + c;
            a[m] = c
    print(''.join(a[1:]))
    downloadImg(a[1:],ppath)
            

if __name__ == '__main__':
    defaultPath = os.path.join(os.path.expanduser('.'), 'comic')
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter,
                                     description='*下载漫画，仅供学习交流，请勿用于非法用途*\n')
    parser.add_argument('-m', '--mid', help='要下载的漫画的名字id \n')
    parser.add_argument('-c', '--cid', help='要下载的章节的id \n')
    #parser.add_argument('-p', '--path', help='漫画下载路径。 默认: {}'.format(defaultPath), default=defaultPath)

    args = parser.parse_args()
    mid = args.mid
    cid = args.cid
    path = os.path.join(defaultPath,mid,cid) 
    ppath = os.path.join('p',defaultPath,mid,cid)
    print(path)
    print(ppath)

    main(path,ppath)
    

