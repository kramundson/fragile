#!/usr/bin/Rscript
# Kirk Amundson
# hits_from_BED3.R

# USAGE Rscript hits_from_BED3.R {snakemake.input} {snakemake.output}

library(readr)
library(magrittr)
library(ggplot2)

args <- commandArgs(trailingOnly = T)
# print(args)
# file <- args[1]

plt <- read_tsv(args[1], col_names = c("chrom", "start", "end")) %>%
# setwd("~/Desktop/Comai_Lab/github-repositories/fragile/")
# plt <- read_tsv(file, col_names = c("chrom", "start", "end")) %>% 
  ggplot(., aes(x = start)) +
  geom_histogram(binwidth = 1e6) +
  facet_wrap(~chrom, strip.position = "r") +
  theme_bw()

ggsave(args[2], plot = plt, width = 12, height = 5, units = "in", device = "pdf")