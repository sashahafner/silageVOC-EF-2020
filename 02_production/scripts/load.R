# Read in data

ff <- '../data/Silage_VOC.xlsx'
concs <- as.data.frame(read_excel(ff, sheet = 1, skip = 0))
react <- as.data.frame(read_excel(ff, sheet = 2, skip = 0))
nms <- as.data.frame(read_excel(ff, sheet = 3, skip = 0))
henry <- as.data.frame(read_excel(ff, sheet = 4, skip = 1))

