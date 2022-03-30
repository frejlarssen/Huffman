set terminal pdf
set output "bench.pdf"
set title ""
set xlabel "längd"
set ylabel "tid i ms"
plot "bench.dat" u 1:2 with lines title "dummy",\
    "bench.dat" u 1:3 with lines title "decode better",\