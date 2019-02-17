#!/bin/bash
dir='image'
name=$dir'/2'
gnuplot <<EOF
set term tikz 
set output '$name.tex'
set xlabel '\\Huge{$\frac{\text{FP}}{\text{FP}+\text{TN}}$}' offset 0,-2.8
set ylabel '\\Huge{$\frac{\text{TP}}{\text{TP}+\text{FN}}$}' offset -3.2,0
set xtics offset 0,-1
set ytics offset 1,-0.5
set xrange [0.0:1.0]
set yrange [0.0:1.0]
set size square
set key right samplen 3 width 3.0 spacing 3.2 font ',8'	
set grid
set label '\\large{AUC(Area Under the Curve)}' at 0.2,0.3
plot 'sample/2.txt' using 1:2 notitle w lp lc rgb 'black'
EOF
texname=$name'.tex'
sed -i -e '1i \\\\documentclass[dvipdfmx]{standalone}' $texname
sed -i -e '2i \\\\usepackage{gnuplot-lua-tikz}' $texname
sed -i -e '3i \\\\usepackage{amsmath}' $texname
sed -i -e '4i \\\\begin{document}' $texname
for number in 0 0.2 0.4 0.6 0.8 1 ;do
    sed -i -e 's/\$'$number'\$/\\Huge{$'$number'$}/' $texname
done
sed -i -e '$ a \\\\end{document}' $texname
uplatex -output-directory=$dir $texname
dvipdfmx $name -o $name'.pdf'
rm $name'.dvi' $name'.log' $name'.aux' $name'.tex'
