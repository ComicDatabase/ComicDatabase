#!/usr/bin/env fish

set downdir comic;
set name $argv[1];

mkdir $downdir;
mkdir $downdir/$name;
for dmid in (wget -O- http://www.dmzj.com/info/$name.html | tr -d '\r' | grep list_con_zj | grep -oP '<a href="(.*?)" target="_blank" title="(.*?)">' | sed -r 's/<a href="(.*?)" target="_blank" title="(.*?)">/\1~\2/');
	set dmurl (echo $dmid | sed -r 's/(.*)~(.*)/\1/');
	set dmtitle (echo $dmid | sed -r 's/(.*)~(.*)/\2/');
	set dmcid (echo $dmurl | grep -oE [0-9]+);echo $dmcid\|$dmurl\|$dmtitle;echo $dmtitle>$downdir/$name/$dmcid;
	wget -O- $dmurl | grep 'function(p,a,c,k,e,d)' | sed -r 's/eval/console.log/' | nodejs | sed -r 's/.*(\{.*\}).*/\1/' | jq .page_url | tr -d '"' | grep -oE 'img/chapterpic/[0-9]+/[0-9]+/[0-9]+.jpg' >>$downdir/$name/$dmcid;
        python3 1.py -m $name -c $dmcid
end

