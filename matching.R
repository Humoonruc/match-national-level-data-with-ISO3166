#####################################################################################################
# matching.R
# match national-level data with ISO3166

library(tidyverse)
library(data.table)
library(magrittr)


ISO3166 <-
  # 一般只需保留国名、三位字母编码和数字编码
  fread("./ISO3166/ISO-3166.csv", select = list(character = c(1, 3, 4)), encoding = "UTF-8") %>%
  # 加入中文国名，以三位字母编码左连接
  left_join(fread("./ISO3166/ISO-3166-chineseName.csv", encoding = "UTF-8"), by = "alpha-3") %>%
  # 将三位字母编码称为 code, 数字编码称为 id, 以便于同 topojson、geojson 等格式的数据匹配
  setnames(c("alpha-3", "country-code"), c("code", "id")) %>%
  select(name, chineseName, everything())


fread("./data/WorldBank-GDP.csv", drop = c(3, 4), encoding = "UTF-8", ) %>%
  # 简化列名
  setnames(c("Country Name", "Country Code"), c("name", "code")) %>%
  # 宽转长以更改列名，缺失值全部用0替换，然后转回宽数据
  melt(
    id.vars = c("name", "code"),
    variable.name = "year",
    value.name = "GDP"
  ) %>%
  mutate(year = str_sub(year, 1, 4)) %>%
  replace_na(list(GDP = 0)) %>%
  dcast(
    name + code ~ year,
    value.var = "GDP"
  ) %>%
  # 合并台湾省数据
  rbind(fread("./data/Taiwan-GDP.csv", encoding = "UTF-8", header = T)) %>%
  # 匹配 ISO3166
  select(-name) %>%
  left_join(ISO3166, ., by = "code") %>%
  # 宽转长，缺失值全部用0替换，然后转回宽数据
  melt(
    id.vars = c("name", "chineseName", "code", "id"),
    variable.name = "year",
    value.name = "GDP"
  ) %>%
  replace_na(list(GDP = 0)) %>%
  dcast(
    name + chineseName + code + id ~ year,
    value.var = "GDP"
  ) %>%
  # 最终得到所有249个国家和地区不含缺失值的宽数据
  fwrite("./output/GDP.csv")
