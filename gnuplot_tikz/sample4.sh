#!/bin/bash
dir='image'
txt="4"
mkdir -p $dir
name=$dir'/'$txt
gnuplot <<EOF
set term tikz
set output '$name.tex'
set parametric
set grid
set angle degree
set urange [0:90]
set vrange [0:90]
set isosample 36,36
set view equal xyz
set view 55,135
set xlabel '\$x$'
set ylabel '\$y$'
set zlabel '\$z$'
set ticslevel 0
a=1
splot a*cos(u)*cos(v),a*sin(u)*cos(v),a*sin(v) notitle,'sample/4.txt' notitle
EOF
texname=$name'.tex'
sed -i -e '1i \\\\documentclass[dvipdfmx]{standalone}' $texname
sed -i -e '2i \\\\usepackage{gnuplot-lua-tikz}' $texname
sed -i -e '3i \\\\begin{document}' $texname
sed -i -e '$ a \\\\end{document}' $texname
uplatex -output-directory=$dir $texname
dvipdfmx $name -o $name'.pdf'
rm $name'.dvi' $name'.log' $name'.aux' $name'.tex'
