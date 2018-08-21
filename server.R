
library(shiny)
library(car)
library(rgl)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    # generate bins based on input$bins from ui.R
    model1 <- lm(log(Volume) ~ log(Height), data = trees)
    model2 <- lm(log(Volume) ~ log(Height) + log(Girth) , data = trees)
    
    model1pred <- reactive({
      treesInput <- input$Height
      predict(model1, newdata = data.frame(Height = treesInput))
    })
    
    model2pred <- reactive({
      treesInput <- input$Height
      treesInput2 <- input$Girth
      predict(model2, newdata = data.frame(Height = treesInput, Girth=treesInput2))
    })
    
  output$plot1 <- renderPlot({
    treesInput <- input$Height
    g <- ggplot(data = trees, aes(x = Height, y=Volume))
    g <- g + geom_point() + geom_smooth(method=lm, se=FALSE) + ylab("Volume of trees(cubic ft)")
    g <- g + geom_point(aes(x = treesInput, y = model1pred()), color="red", size = 3) + theme_classic()
    g
  })
  
  output$plot2 <- renderRglwidget({
    treesInput <- input$Height
    treesInput2 <- input$Girth
    test <- data.frame(Volume = model2pred(), Girth =  treesInput2, Height = treesInput, group = 2)
    trees$group <- 1
    trees <- rbind(trees, test)
    
    rgl.open(useNULL=T)
    
    scatter3d( x = trees$Volume ,
            y = trees$Girth ,z = trees$Height,
            zlab = "Height of trees",
            ylab = "Girth of trees",
            xlab = "Volume of trees(cubic ft)",
            surface=F, ellipsoid = FALSE, fit=c("lin"), 
            groups =  as.factor(trees$group))

    rglwidget()
    
  })
  
  
  
  output$pred1 <- renderText({
    round(model1pred(),2)
  })
  
  output$pred2 <- renderText({
    round(model2pred(),2)
  })
  
  output$r1 <- renderText({
    round(summary(model1)$r.squared,3)
  })
  output$r2 <- renderText({
    round(summary(model2)$r.squared,3)
  })
  
})
