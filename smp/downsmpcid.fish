#!/usr/bin/fish
set mid $argv[1]
set cid $argv[2]
set pid 0
for pic in (wget -qO- http://smp.yoedge.com/smp-app/$cid/shinmangaplayer/smp_cfg.json | jq .pages.page[] | tr -d '"' | sort);
    set pid (expr $pid + 1)
    echo http://smp.yoedge.com/smp-app/$cid/shinmangaplayer/$pic;
    ./downimgup2bd.fish $mid $cid $pid http://smp.yoedge.com/smp-app/$cid/shinmangaplayer/$pic
end
