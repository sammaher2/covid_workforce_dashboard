

us_co <- us_counties(resolution = "low") %>%
  select(geoid,state_name,name) %>%
  st_transform(5070)

us_st <- us_states(resolution = "low") %>%
  filter(!(stusps %in% c("HI","AK","PR")))  %>%
  st_transform(5070)

co.map <- cps_data %>%
  transmute(county=str_pad(county,5,"left","0")) %>% 
  distinct() %>%
  inner_join(us_co,.,by=c("geoid"="county")) 

ggplot() +
  geom_sf(data=co.map[us_st,],fill="lightgray",color="red") +
  geom_sf(data=us_st,fill=NA,color="black") +
  theme_void()

# %>% 
#   write_csv(.,path = "counties.csv")


mapview::mapview(co.map) %>%
  mapview::mapshot(.,url = "map.html")


#write_csv(met_codes,path = "msa_codes.csv")
