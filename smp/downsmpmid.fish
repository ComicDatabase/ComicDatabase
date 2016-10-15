#!/usr/bin/fish
set mid $argv[1]
#set mid 1056492
for cidline in (wget -O- http://smp.yoedge.com/view/gotoAppLine/$mid | grep shinmangaplayer | sed -r 's/.*href=".*\/([0-9]+).*">([0-9]+)<.*/\2\t\1/' | grep -v '<a')
	set title (echo $cidline|sed -r 's/(.*)\t(.*)/\1/')	
	set cid   (echo $cidline|sed -r 's/(.*)\t(.*)/\2/')
        echo $title $cid
	./downsmpcid.fish $mid $cid
end
