#
library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)

# test1

# gs <- lapply(1:9, function(ii) 
#   grobTree(rectGrob(gp=gpar(fill=ii, alpha=0.5)), textGrob(ii)))
# grid.arrange(grobs=gs, ncol=4, 
#              top="top label", bottom="bottom\nlabel", 
#              left="left label", right="right label")
# grid.rect(gp=gpar(fill=NA))
# 
# # test 2
# 
# lay <- rbind(c(1,1,1,2,3),
#              c(1,1,1,4,5),
#              c(6,7,8,9,9))
# grid.arrange(grobs = gs, layout_matrix = lay)
# 
# # test 3
# 
# hlay <- rbind(c(1,1,NA,2,3),
#               c(1,1,NA,4,NA),
#               c(NA,7,8,9,NA))
# select_grobs <- function(lay) {
#   id <- unique(c(t(lay))) 
#   id[!is.na(id)]
# } 
# grid.arrange(grobs=gs[select_grobs(hlay)], layout_matrix=hlay)

# place in a list the two grobs

lay <- rbind(c(1,1,1,2),
             c(1,1,1,2),
             c(1,1,1,2))
grid.arrange(grobs = list(grob1,grob2), layout_matrix = lay)
