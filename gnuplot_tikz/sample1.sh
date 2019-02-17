#!/bin/bash
dir='image'
mkdir -p $dir
name=$dir'/1'
gnuplot <<EOF
set term tikz
set output '$name.tex'
set xlabel '\\Huge{横軸}' offset 0,-1.6
set ylabel '\\Huge{精度}' offset -1.5,0
set xrange [500:7500]
set yrange [0.02:0.9]
set xtics offset 0,-1
set ytics offset 1,-0.5
set key center top samplen 4 width 2.0 spacing 3.0 font ',8'	
set grid
plot 'sample/1-0.txt' using 1:2 title '\\Huge{Method0}' w lp, 'sample/1-1.txt' using 1:2 title '\\Huge{Method1}' w lp, 'sample/1-2.txt' using 1:2 title '\\Huge{Method2}' w lp
EOF
texname=$name'.tex'
sed -i -e '1i \\\\documentclass[dvipdfmx]{standalone}' $texname
sed -i -e '2i \\\\usepackage{gnuplot-lua-tikz}' $texname
sed -i -e '3i \\\\begin{document}' $texname
for number in 0 1 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1000 3000 5000 7000;do
    sed -i -e 's/\$'$number'\$/\\Huge{$'$number'$}/' $texname
done
for number in 2000 4000 6000;do
    sed -i -e 's/\$'$number'\$//' $texname
done
sed -i -e '$ a \\\\end{document}' $texname
uplatex -output-directory=$dir $texname
dvipdfmx $name -o $name'.pdf'
rm $name'.dvi' $name'.log' $name'.aux' $name'.tex'
