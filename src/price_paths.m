clear;
clearvars;
close all;

addpath('./data')

path = "/DCOILBRENTEU.csv";
data = readtable(path);
plot(data, "DATE", "DCOILBRENTEU")