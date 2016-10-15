#!/usr/bin/env fish
function uploadImg
    #妈的，百度账号好难弄，最后花了我0.25大洋买了个验证码注册成功了
    #set BDUSS h3UjVEUDdOYXZVbVRCb3cxNXhnQWNBY25ZaFIxeVdBY2tGaWhzYnFyYnQ3ZUZYQVFBQUFBJCQAAAAAAAAAAAEAAAB3SFygAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO1gulftYLpXbT
    set BDUSS    VludWcxa0ZQUXQ4MjdiSVpQaExQcH4yQkxTS3RXS2NvdXRCc3hiLVp6aVREUlpZQUFBQUFBJCQAAAAAAAAAAAEAAAD-Vg-aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJOA7leTgO5XS
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

function getpic;
    wget -T 20 "http://733dm.zgkouqiang.cn/"$argv[1] -O $argv[2]
    uploadImg $argv[2] $argv[3]
end

function getpicurl;
    curl -m20 $argv | grep packed | sed -r 's/.*"(.*)".*/\1/' | base64 -d | sed -r 's/eval/console.log/' | nodejs | tr ';' '\n' | sed -r 's/.*"(.*)".*/\1/' | grep -v \^\$;
end

set id 0;
for url in (wget -O- http://www.733dm.net/mh/23915/ | iconv -f GBK -t utf-8 | grep '<div class="plistBox">' | tr -d '\r' | tr -d '\n' | sed -r 's/<li>/\n<li>/g' | sed -r 's/.*<li><a href="(.*)" title="(.*)">(.*)<\/a><\/li>.*/\1|\2|\3/g' | grep -v div);
    set purl (echo $url | sed -r 's/(.*)\|(.*)\|(.*)/\1/');
    set id (expr $id + 1);
    set ptitle (echo $url | sed -r 's/(.*)\|(.*)\|(.*)/\2/' | tr -d '[:space:]' );
    echo $purl $ptitle;
    set index 0;
    for pic in (getpicurl "http://www.733dm.net"$purl);
        set index (expr $index + 1);
        mkdir $id;
        echo getpic $pic $id/$index.jpg $id.733.list;
    end;
    rm -rv $id;
    /app/comic/backup.fish "勇者约吗---"$ptitle;
end

