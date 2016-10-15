#!/usr/bin/fish
function uploadImg
    #妈的百度账号好难弄最后花了我0.25大洋买了个验证码注册成功了
    #set BDUSS h3UjVEUDdOYXZVbVRCb3cxNXhnQWNBY25ZaFIxeVdBY2tGaWhzYnFyYnQ3ZUZYQVFBQUFBJCQAAAAAAAAAAAEAAAB3SFygAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO1gulftYLpXbT
    set BDUSS VludWcxa0ZQUXQ4MjdiSVpQaExQcH4yQkxTS3RXS2NvdXRCc3hiLVp6aVREUlpZQUFBQUFBJCQAAAAAAAAAAAEAAAD-Vg-aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJOA7leTgO5XS
    set file $argv[1]
    set savefile $argv[2]
    set return (curl --cookie "BAIDUID=BaiduIsAGreatSB;BDUSS="$BDUSS -F file=@$file 'http://upload.tieba.baidu.com/upload/pic?tbs='(curl --cookie "BAIDUID=BaiduIsAGreatSB" http://tieba.baidu.com/dc/common/imgtbs | jq '.data.tbs' | tr -d '"'))
    #echo $return
    if expr 0 = (echo $return | jq '.err_no');
        #success
        echo http://imgsrc.baidu.com/forum/pic/item/(echo $return | jq '.info.pic_id_encode' | tr -d '"').jpg
        #echo http://imgsrc.baidu.com/forum/pic/item/(echo $return | jq '.info.pic_id_encode' | tr -d '"').jpg >>$savefile
        echo $return | jq '.info.pic_id_encode' | tr -d '"' >>$savefile
    else
        echo $return | jq '.err_msg'
    end
end
uploadImg $argv[1] $argv[2]
