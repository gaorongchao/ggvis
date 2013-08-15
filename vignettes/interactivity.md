<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{Interactivity}
-->



# Interactivity

Gigvis interactivity is built on top of the functional reactivty programming 
model of shiny. You don't need to understand this model to add simple 
interactivity, but if you want to understand how it works, or to add more 
complicated interactions combining multiple controls or multiple plots, you'll 
need to learn the basics of 
[basics of shiny](http://rstudio.github.io/shiny/tutorial/).

This tutorial is divided into two parts:

* Basic interactive controls: these provide a quick and easy way to add basic
  interactivity to a plot. They are not very flexible, but they cover the most
  common interactive needs and you don't need to know anything about shiny to
  use them.

* Embedding gigvis in shiny: alternatively, you can embed a gigvis plot into a
  regular shiny app. This gives you complete freedom to make any component of 
  the plot interactive, to display multiple plots on one page, and to freely
  arrange controls. On the downside, you'll need more code, and you'll need at
  least a basic understand of shiny.

## Basic interactive controls

Gigvis provides a set of basic interactive controls:

* `input_slider()`: a slider, or double-ended range slider
* `input_select()`: create a drop-down text box

which can be used in a limited number of places:

* as arguments to transforms: `transform_smooth(span = input_slider(0, 1))`
* or as properties: `props(size = prop_reactive(input_slider(10, 1000)))`

### Mapping a slider to a property

When you map a slider to a property, you have four basic options:

* constant, unscaled
* constant, scaled
* variable, unscaled
* variable, scaled

### Reusing the same control in multiple places

Note that `input_*` functions yield an object which you can save to a variable. 
If you do that, the same control will be reused in multiple places, so you can
simultaenously control multiple values.

Compare the following two plots. In the first plot, one slider is created and 
used for both layers - it controls the size of both the red and the black 
points. In the second plot, you get two independent sliders which allow you to
control the size of the red and black points independently.


```r
slider <- input_slider(100, 1000)
gigvis(mtcars, props(x ~ wt, y ~ mpg), 
  mark_symbol(props(size = prop_reactive(slider, constant = TRUE, scale = FALSE))),
  mark_symbol(props(fill = "red", opacity = 0.5, size = prop_reactive(slider, constant = TRUE, scale = FALSE))))

gigvis(mtcars, props(x ~ wt, y ~ mpg), 
  mark_symbol(props(size = prop_reactive(input_slider(100, 1000), constant = TRUE, scale = FALSE))),
  mark_symbol(props(fill = "red", size = prop_reactive(input_slider(100, 1000), constant = TRUE, scale = FALSE))))

```


### Compared to shiny

If you're familiar with shiny, you'll notice that these functions have very
similar equivalents: `sliderInput()`, `selectInput()` and so on.  There are two
main differences:

* the argument order has been tweaked so that you can create a basic control 
  with minimal arguments. The `label` is optional because if you're creating a 
  plot for yourself, you usually remember what the controls do; and each control
  is assigned a random `id` so you don't need to think one up.

* gigvis interactive controls are not created in a reactive context, so they
  can not return reactives. Instead, they return delayed reactives, which are
  activated and connected together when the plot is displayed.


## Shiny apps

If you know how to create a shiny app already, adding a gigvis plot is easy. In
`server.r`, create a reactive gigvis object, and call `observeGigvis()`. The 
first argument is the plot object, the second is the plot id (needs to match
with `ui.r`, and the third argument is the session object).


```r
gv <- reactive({
  gigvis(mtcars, props(x ~ disp, y ~ mpg, size = input$size),
    mark_symbol()
  )
})

observeGigvis(gv, "my_plot", session)
```


Create `ui.r` as usual, using `gigvisOutput()` to place the gigvis plot on the 
page.


```r
shinyUI(pageWithSidebar(
  sidebarPanel(
    sliderInput("size", "Area", 10, 1000),
  ),
  mainPanel(
    gigvisOutput("my_plot")
  )
))
```
