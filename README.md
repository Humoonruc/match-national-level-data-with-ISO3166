# 国别数据与ISO3166国家代码表的匹配

国别数据，数据来源不同的文件，其中的国名简称往往五花八门，不统一，因此要按照 ISO3166[^ISO3166] 的规范来匹配。

> 比如刚果（布）、刚果（金）、北朝鲜和台湾省的英文写法，就比较混乱。

本项目中的 R 脚本即可匹配此类数据。

[^ISO3166]: 每个国家或地区，有唯一的三位字母编码或三位数字编码来标识。



#### Data Source

- 全球 GDP 数据来源：[World Development Indicators | DataBank (worldbank.org)](https://databank.worldbank.org/source/world-development-indicators#)

  - 最好下载现价美元数据，方便与台湾省数据进行匹配（台湾省没有不变美元数据，都是现价美元的）

  - 提前在文本编辑器中将 csv 中的缺失值 `..` 全部替换为 blank，这样读取时才方便把数字列直接读为数字类型，而非字符串类型。当然，也可以在下载数据时就在 download options 里选好。

    <img src="img/%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE%202022-03-07%20105101.png" alt="屏幕截图 2022-03-07 105101"  />

- 台湾省数据来源：[國民所得及經濟成長統計資料庫 (dgbas.gov.tw)](https://statdb.dgbas.gov.tw/pxweb/Dialog/NI.asp)
