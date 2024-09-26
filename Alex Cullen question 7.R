#necessary packages
library(dplyr)
library(ggplot2)
library(ggpubr)

#reading in data
data <- read.csv("C:/Users/alexi/OneDrive/Documents/Tigers Questionaire/tigers.csv")
View(data)

#splitting into two games
game1 <- data|>
  filter(GamePk == 1)

game2 <- data|>
  filter(GamePk == 2)

#making a list of unique pitchers to perform analysis on each one
#list of unique games for individual game performances
pitchers <- unique(data$PitcherId)
games <- unique(data$GamePk)

#loops through the games 
for(game in games){
  #looping through the unique pitchers and creating graphics for each
  for (pitcher in pitchers){
    data1 <- data|>
      filter(GamePk == game & PitcherId == pitcher)
    
    #making a new dataset with average velo
    velos_by_inning <- data1|>
      group_by(Inning, PitchType) |>
      summarize(avg = mean(ReleaseSpeed, na.rm = TRUE))
    
  #chart for extension down the mound
   ext <- ggplot(data1, aes(x = ReleaseExtension, y= ReleasePositionZ))+
      geom_point(aes(color = PitchType))+
      xlim(-1, 20)+
      ylim(0, 8)+
      geom_segment(aes(x = 0, y = 0.833, xend = 18, yend = 0), size = 1, color = "brown")+
      labs(y = "Release Height", x = "Extension", color = "Pitch Type")+
      ggtitle(paste0("Extension plot for Pitcher ", pitcher))+
      theme_bw()
   
   #simple movement plot
   bplot <- ggplot(data1, aes(x = TrajectoryHorizontalBreak, y = TrajectoryVerticalBreakInduced))+
     geom_point(aes(color = PitchType))+
     ylim(-2, 3)+
     xlim(-2, 2)+
     labs(y = "Induced Vertical Movement", x = "Horizontal Movement", color = "Pitch Type")+
     ggtitle(paste0("Movement plot for Pitcher ", pitcher))+
     theme_bw()
   
   #velo per inning
  velo <- ggplot(velos_by_inning, aes(x= Inning, y= avg, color = PitchType))+
     geom_line(size = 1.5)+
     geom_point(size = 3, show.legend = FALSE)+
     theme(strip.text = element_blank())+
     theme_bw()+
     labs(y= "Average Velocity")+
     ggtitle(paste0("Average Pitch Velocity for Pitcher ", pitcher))
   
   
   #combining them
   combo <- ggarrange(ext, bplot, velo, nrow = 2, ncol = 2, common.legend = TRUE, legend = 'right')
   
   #saving as an image
   ggsave(paste0("Pitcher", pitcher," Game ", game, ".png"), plot = combo, width = 14, height = 10, units = "in")
   
  }
}


#custom score variable, very simple and rudementary
#pitcher is punished for giving up hits and rewarded for getting outs

data$score = ifelse(data$PitchCall == "walk", -1,
             ifelse(data$PitchCall == "single", -1, 
             ifelse(data$PitchCall == "double", -2, 
             ifelse(data$PitchCall == "triple", -3,
             ifelse(data$PitchCall =="home_run", -4,
             ifelse(data$PitchCall == "field_out", 1,
             ifelse(data$PitchCall == "force_out", 1,
             ifelse(data$PitchCall == "sac_bunt", 1,
             ifelse(data$PitchCall == "strikeout", 2,
             ifelse(data$PitchCall == "grounded_into_double_play", 2, 0))))))))))

# List of PitchCalls that count as strikes
strike_calls <- c("called_strike", "field_out", "swinging_strike", "single", "foul", "strikeout", 
                  "double", "foul_bunt", "foul_tip", "grounded_into_double_play", "home_run", 
                  "force_out", "field_error", "sac_bunt", "swinging_strike_blocked")

#simple 1 for strike or ball, 0 for the other
data$isStrike <- ifelse(data$PitchCall %in% strike_calls, 1, 0)
data$isBall <- ifelse(data$PitchCall == "ball", 1, 0)

#pitcher score table
pitcher_score <- data|>
  group_by(PitcherId,GamePk)|>
  summarize(
    "Balls" = sum(isBall),
    "Strikes" = sum(isStrike),
    "Score" = sum(score),
  )
View(pitcher_score)
