#Adds residuals from an lm object to a pairs plot to compare added variable plots.
res_pairs <- function(my_lm,...){
  library(dplyr)
  library(stringr)
  df <- str_remove_all(str_extract(str_flatten(deparse(my_lm$call)),"data = .*"),"data = |\\)")

  variables<- deparse(my_lm$call)%>%
    str_flatten()%>%
    str_extract("~.*data =")%>%
    str_remove_all("~|,|data =")%>%
    {if(str_detect(.,"I(.*)")){str_remove_all(.,"I\\(")%>%
        str_remove("\\^\\d?.*\\)")}
      else return(.)}%>%
    str_split("[\\+\\-\\:]")%>%
    unlist%>%
    str_trim()%>%
    unique()

  og_df = get(df)
  filtered = og_df

  for(i in seq_along(1:length(variables))){
    filtered <- filter(filtered,!is.na(get(variables[i])))
  }

  binded = cbind(my_lm$residuals,filtered)
  pairs(right_join(binded,og_df),panel=panel.smooth,...)
}

#lm1 <- lm(mpg~wt,mtcars)

#res_pairs(lm1,col=og_df$cyl)

#pairs(mtcars,col=as.factor("cyl"))
