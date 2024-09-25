library(dplyr)
library(ggplot2)
library(kableExtra)
game <- read.csv("C:/Users/alexi/OneDrive/Documents/Tri-State 2024/all_appy_games.csv")
game2 <- read.csv("C:/Users/alexi/OneDrive/Documents/Tri-State 2024/all_appy_games.csv")
game <- game|>
  mutate(Count = paste(Balls, Strikes, sep = "-"))
View(game)

game <- game|>
  filter(PitcherTeam  == "TS")|>
  filter(PitchofPA == 1 & (PitchCall == "StrikeCalled" | 
                          PitchCall == "StrikeSwinging" | 
                          PitchCall == "FoulBall"))
game2 <- game2|>
  filter(Pitcher == "Rabatin, Ben")

results <- list()

for (i in 1:nrow(game)) {
  # Extract the values of PAofInning and Date for the current observation
  PAofInning_value <- game$PAofInning[i]
  Date_value <- game$Date[i]
  
  # Store the values in the results list
  results[[i]] <- list(PAofInning = PAofInning_value, Date = Date_value)
}
game2$Date <- as.Date(game2$Date)
results_df <- do.call(rbind, lapply(results, as.data.frame))

# Ensure the Date column in results_df is of Date type
results_df$Date <- as.Date(results_df$Date)

# Filter the data frame based on the results_df values
game <- game2 %>%
  semi_join(results_df, by = c("PAofInning", "Date"))



game$Single = ifelse(game$PlayResult == "Single",1,0)
game$Double = ifelse(game$PlayResult == "Double",1,0)
game$Triple = ifelse(game$PlayResult == "Triple",1,0)
game$HomeRun = ifelse(game$PlayResult == "HomeRun",1,0)
game$Out = ifelse(game$PlayResult == "Out" | game$PlayResult == "FieldersChoice",1,0)
game$RBOE = ifelse(game$PlayResult == "Error",1,0)
game$BB = ifelse(game$KorBB == "Walk",1,0)
game$HBP = ifelse(game$PitchCall == "HitByPitch",1,0)
game$K = ifelse(game$KorBB == "Strikeout",1,0)
game$SAC = ifelse(game$PlayResult == "Sacrifice",1,0)

game$PA = game$Single + game$Double + game$Triple + game$HomeRun + game$Out + game$RBOE +
  game$BB + game$HBP + game$K + game$SAC

game$AB = game$Single + game$Double + game$Triple + game$HomeRun + game$Out + game$K

AVG = round((sum(game$Single)+sum(game$Double)+sum(game$Triple)+sum(game$HomeRun))/sum(game$AB), digits = 3)
AVG

strike_count <- game2 %>%
  filter(PitchCall %in% c("StrikeCalled", "StrikeSwinging", "FoulBall", "InPlay")) %>%
  group_by(PitchCall) %>%
  summarize(count = n())
strike_count

total_count <- sum(game2$PitchCall %in% c("StrikeCalled", "StrikeSwinging", "FoulBall", "InPlay"))
total_count


game <- game|>
  filter(Pitcher == "Stich, David")|>
  mutate(IZ = ifelse(as.numeric(PlateLocSide) >= -0.83 & as.numeric(PlateLocSide) <= 0.83 &
                       as.numeric(PlateLocHeight) >= 1.5 & as.numeric(PlateLocHeight) <=
                       3.5,
                     "Y", "N"))
game <- game|>
  filter(TaggedPitchType == "Slider")|>
  filter(PitchCall == "StrikeSwinging")

strikezone <- ggplot(data = game, aes(x = as.numeric(PlateLocSide), y = as.numeric(PlateLocHeight)))+
  geom_point(data = game, aes(color = TaggedPitchType), size= 2)+
  scale_size(range = c(0.01,3))+
  geom_rect(xmin = -0.83,xmax = 0.83,ymin = 1.5,ymax = 3.5, color = "black", fill = "transparent",size=1.1) +
  geom_rect(xmin = -1.2,xmax = 1.2,ymin = 1.2,ymax = 3.8, color = "black", linetype = "dashed", fill = "transparent") +
  geom_rect(xmin = -.6,xmax = .6,ymin = 1.8,ymax = 3.2, color = "black", linetype = "dashed", fill = "transparent")+
  geom_segment(aes(x = -0.708, y = 0.15, xend = 0.708, yend = 0.15), size = 0.5, color = "black") +
  geom_segment(aes(x = -0.708, y = 0.3, xend = -0.708, yend = 0.15), size = 0.5, color = "black") +
  geom_segment(aes(x = -0.708, y = 0.3, xend = 0, yend = 0.5), size = 0.5, color = "black") +
  geom_segment(aes(x = 0, y = 0.5, xend = 0.708, yend = 0.3), size = 0.5, color = "black") +
  geom_segment(aes(x = 0.708, y = 0.3, xend = 0.708, yend = 0.15), size = 0.5, color = "black") +
  coord_equal() +
  scale_x_continuous(limits = c(-2,2)) +
  scale_y_continuous(limits = c(0,5)) +
  theme_bw() +  
  coord_fixed(ratio = 1) +
  labs(color= "Pitch Type")+
  theme(axis.title = element_blank(), axis.ticks = element_blank(), axis.text = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  ggtitle("K Zone")
strikezone


game <- read.csv("C:/Users/alexi/Dropbox/game32.csv")
game <- game |>
  filter(TaggedPitchType == "Fastball")
#creating pitch by pitch dataframe to print as a table
pbp <- game|>
  mutate(PitchCount = row_number()) |>
  
  #creating in zone variable
  mutate(IZ = ifelse(as.numeric(PlateLocSide) >= -0.83 & as.numeric(PlateLocSide) <= 0.83 &
                       as.numeric(PlateLocHeight) >= 1.5 & as.numeric(PlateLocHeight) <=
                       3.5,
                     "Y", "N"))|>
  
  #choosing which variables to keep
  select(PitchCount, Batter, Inning, TaggedPitchType, RelSpeed,
         SpinRate, Tilt, InducedVertBreak, HorzBreak, RelHeight, RelSide,
         Extension, PitchCall, IZ, 
         ExitSpeed)|>
  
  #rounding to hundreths place
  mutate_if(is.numeric, ~ round(., 1))

#giving names to variables 
names(pbp) <- c("Pitch No.", "Batter", "Inning", "Count", "Pitch Type", "Velo", "Spin",
                "Tilt","IVB", "HB", "Height", "Side", "Extension", "Pitch Call", "IZ",
                "EV")

#displaying pitch by pitch chart
kbl(pbp, format = "latex", digits = 3, booktabs = TRUE, linesep = "") %>%
  column_spec(15, color = ifelse(pbp$IZ == "Y", "green", "red")) %>%
  row_spec(0, background = "#F1B92D", bold = TRUE) %>%
  kable_styling(latex_options = c("striped", "scale_down"),
                full_width = FALSE, font_size = 7, position = "center")


dat <- read.csv("C:/Users/alexi/OneDrive/Documents/Tri-State 2024/all_appy_games.csv")
dat <- dat|>
  filter(PitcherTeam == "TS")|>
  group_by(Pitcher)

dat$BF=ifelse(dat$PlayResult!="Undefined" | dat$KorBB != 'Undefined',1,0)
dat$"PitchCount"=ifelse(dat$Pitcher!="",1,0)
dat$"Pitch Type" = dat$TaggedPitchType
dat$"IZ" = ifelse(dat$PlateLocHeight<=3.5 & dat$PlateLocHeight>=1.5 & dat$PlateLocSide <= 0.83 & dat$PlateLocSide >= -0.83,1,0)
dat$"Swing" = ifelse(dat$PitchCall == 'StrikeSwinging' | dat$PitchCall == 'FoulBall' | dat$"PitchCall" == 'InPlay',1,0)
dat$"Whiff" = ifelse(dat$Swing == 1 & dat$PitchCall == 'StrikeSwinging',1,0)
dat$"firstpitchstrike"=ifelse(((dat$Balls == 0 & dat$Strikes == 0)&(dat$PitchCall=="StrikeCalled" | dat$PitchCall=="StrikeSwinging" |dat$PitchCall=="InPlay" |dat$PitchCall=="FoulBall")),1,0)

View(dat)


#filtering dataframe to be what is displayed on table
pitchbreakdown <- dat|>
  group_by(Pitcher)|>
  summarize(
    "Z%" = paste(round(sum(IZ, na.rm = TRUE)/sum(PitchCount, na.rm = TRUE)*100, 
                       digits = 0), "%",sep = ""),
    "Whiff%" = ifelse(sum(Swing, na.rm = TRUE) > 0,
                      paste(100 * round(sum(Whiff, na.rm = TRUE) / sum(Swing, na.rm = TRUE), digits = 2), 
                            '%', sep = ''),'0%'),
    "FPStrike"=paste(round((sum(firstpitchstrike)/sum(BF))*100, digits = 0),"%",sep="")
    
  )

View(pitchbreakdown)
