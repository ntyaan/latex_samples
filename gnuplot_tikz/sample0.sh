#!/bin/bash
dir='image'
txt="0"
mkdir -p $dir
name=$dir'/'$txt
gnuplot <<EOF
set term tikz
set output '$name.tex'
set xlabel '\\Large{データ}' offset 0,1.5
set ylabel '\\Large{精度}' offset 1,0
set key right top samplen 1 spacing 0.9 font ',7'
set xrange [-0.8:*] 
set style fill solid
set yrange [0:1] 
set xtic rotate by -90 offset 0,0.7
set style data histogram
set bar 0.2 lw 0.2 lc rgb 'black'
set style histogram cluster gap 1 errorbars
plot 'sample/$txt.txt' using 2:3:xtic(1) title col(2), '' using 4:5 title col(3), '' using 6:7 title col(4)
EOF
texname=$name'.tex'
sed -i -e '1i \\\\documentclass[dvipdfmx]{standalone}' $texname
sed -i -e '2i \\\\usepackage{gnuplot-lua-tikz}' $texname
sed -i -e '3i \\\\begin{document}' $texname
sed -i -e '$ a \\\\end{document}' $texname
uplatex -output-directory=$dir $texname
dvipdfmx $name -o $name'.pdf'
rm $name'.dvi' $name'.log' $name'.aux' $name'.tex'
