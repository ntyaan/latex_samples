#!/bin/bash
dir='image'
txt="3"
mkdir -p $dir
name=$dir'/'$txt
gnuplot <<EOF
set term tikz
set output '$name.tex'
set view 55,135
set view equal xyz
set xrange [0:100]
set yrange [0:100]
set zrange [0:100]
set grid
set pm3d flush begin ftriangles
set ticslevel 0
set key
splot "sample/3.txt" using 1:2:3:5 with pm3d notitle
EOF
texname=$name'.tex'
sed -i -e '1i \\\\documentclass[dvipdfmx]{standalone}' $texname
sed -i -e '2i \\\\usepackage{gnuplot-lua-tikz}' $texname
sed -i -e '3i \\\\begin{document}' $texname
sed -i -e '$ a \\\\end{document}' $texname
uplatex -output-directory=$dir $texname
dvipdfmx $name -o $name'.pdf'
rm $name'.dvi' $name'.log' $name'.aux' $name'.tex'
