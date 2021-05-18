#!/bin/bash
for seed in 0  1621108561 1621108837 1621109236; do
	./ccgmusic --seed $seed --structure "Random Structure" --arranger "Simple Ballad Style Arrangement" --filename ${seed}_ballad.mid
done
./ccgmusic  --structure "Random Structure" --arranger "Simple Instrumental March Arrangement" --tempo 30 --seed 0 --filename march_0.mid

for seed in 1621110759; do
	./ccgmusic --seed $seed --structure "Random Structure" --arranger "Simple Dance Style Arrangement" --filename ${seed}_dance.mid
done

