#!/usr/bin/fish
function downloadImg
    set mid $argv[1]
    set cid $argv[2]
    set pid $argv[3]
    set url $argv[4]

    echo 'mid='$mid',cid='$cid',pid='$pid',url='$url

    mkdir -p ./comic/$mid/$cid
    #cd ./comic/$mid/$cid
    if wget -T 10 -O './comic/'$mid'/'$cid'/'$pid'.jpg' $url;
        set err 0
        ./upload2bd.fish './comic/'$mid'/'$cid'/'$pid'.jpg' './comic/'$mid'/'$cid'.list'
    else
        rm './comic/'$mid'/'$cid'/'$pid'.jpg'
    end
    #cd -
end
downloadImg $argv
