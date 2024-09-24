

df <- df|>
  filter(date == "2024-09-09")

dist <- function(side, height, flag){
  if(flag == 1) {
    dist <- sqrt((side - -0.55333333)^2 + (height - 3.1666667)^2)
  } else if(flag == 2) {
    dist <- sqrt((side - 0)^2 + (height - 3.1666667)^2)
  } else if(flag == 3) {
    dist <- sqrt((side - 0.55333333)^2 + (height - 3.1666667)^2)
  } else if(flag == 4) {
    dist <- sqrt((side - -0.55333333)^2 + (height - 2.5)^2)
  } else if(flag == 5) {
    dist <- sqrt((side - 0)^2 + (height - 2.5)^2)
  } else if(flag == 6) {
    dist <- sqrt((side - 0.55333333)^2 + (height - 2.5)^2)
  } else if(flag == 7) {
    dist <- sqrt((side - -0.55333333)^2 + (height - 1.8333333)^2)
  } else if(flag == 8) {
    dist <- sqrt((side - 0)^2 + (height - 1.8333333)^2)
  } else if(flag == 9) {
    dist <- sqrt((side - 0.55333333)^2 + (height - 1.8333333)^2)
  }  
  return(dist)
}

df2 <- df|>
  filter(relspeed == 83.09685)

dist(df2$platelocside, df2$platelocheight, df2$flag)


library(dplyr)
df <- read.csv("C:/Users/alexi/Downloads/flagged_tm.csv")
View(df)
df$platelocheight <- as.numeric(df$platelocheight)
df$platelocside <- as.numeric(df$platelocside)
df$flag <- as.factor(df$flag)

df1 <- df %>%
  filter(platelocside >= -1.6 & platelocside <= 1.6 & platelocheight >= 0 & platelocheight <= 5)%>%
  mutate(
    locationdistance = case_when(
      flag == 1 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 3.1666667)^2),
      flag == 2 ~ sqrt((platelocside - 0)^2 + (platelocheight - 3.1666667)^2),
      flag == 3 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 3.1666667)^2),
      flag == 4 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 2.5)^2),
      flag == 5 ~ sqrt((platelocside - 0)^2 + (platelocheight - 2.5)^2),
      flag == 6 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 2.5)^2),
      flag == 7 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 1.8333333)^2),
      flag == 8 ~ sqrt((platelocside - 0)^2 + (platelocheight - 1.8333333)^2),
      flag == 9 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 1.8333333)^2)))%>%
  relocate(locationdistance, .after = 11)
  
  df <- df %>%
    mutate(
    locationdistance = case_when(
      flag == 1 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 3.1666667)^2),
      flag == 2 ~ sqrt((platelocside - 0)^2 + (platelocheight - 3.1666667)^2),
      flag == 3 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 3.1666667)^2),
      flag == 4 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 2.5)^2),
      flag == 5 ~ sqrt((platelocside - 0)^2 + (platelocheight - 2.5)^2),
      flag == 6 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 2.5)^2),
      flag == 7 ~ sqrt((platelocside - -0.55333333)^2 + (platelocheight - 1.8333333)^2),
      flag == 8 ~ sqrt((platelocside - 0)^2 + (platelocheight - 1.8333333)^2),
      flag == 9 ~ sqrt((platelocside - 0.55333333)^2 + (platelocheight - 1.8333333)^2)))%>%
    relocate(locationdistance, .after = 11)
  
  command <- df %>%
    group_by(pitcher)%>%
    summarize(
      "Command Score" = mean(locationdistance, na.rm = TRUE)
    )
  
  command_yank <- df1 %>%
    group_by(pitcher)%>%
    summarize(
      "Command Score (-yanks)" = mean(locationdistance, na.rm = TRUE),
      "Dif" = command$`Command Score` - mean(locationdistance, na.rm = TRUE)
    )
  
View(command_yank)
View(command)
compare <- cbind(command,command_yank)
View(compare)

min(command_yank$`Command Score`)
min(command$`Command Score`)

yank_score <- df|>
  group_by(pitcher)|>
  summarize(
    "Yank%" = paste0(((nrow(df)-nrow(df1))/(nrow(df)))*100, "%")
  )

options(digits = 2)
View(yank_score)


boundaries <- tibble(
  flag = 1:9,
  xmin = c(-0.83, 0, 0.83, -0.83, 0, 0.83, -0.83, 0, 0.83),
  xmax = c(-0.27666666, 0.27666666, 0.83, -0.27666666, 0.27666666, 0.83, -0.27666666, 0.27666666, 0.83),
  ymin = c(1.5, 1.5, 1.5, 2.1666667, 2.1666667, 2.1666667, 2.8333333, 2.8333333, 2.8333333),
  ymax = c(2.1666667, 2.1666667, 2.1666667, 2.8333333, 2.8333333, 2.8333333, 3.5, 3.5, 3.5)
)

