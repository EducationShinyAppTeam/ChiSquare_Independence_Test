# Load packages ----
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyjs)
library(shinyDND)
library(plotly)
library(boastUtils)

# Load files ----

# Define UI ----
ui <- list(
  dashboardPage(
    skin = "yellow",
    ## Header ----
    dashboardHeader(
      title = "Test of Independence",
      titleWidth = 250,
      tags$li(class = "dropdown", actionLink("info", icon("info"))),
      tags$li(
        class = "dropdown",
        boastUtils::surveyLink(name = "App_Template")
      ),
      tags$li(
        class = "dropdown",
        tags$a(href = "https://shinyapps.science.psu.edu/", icon("home"))
      )
    ),
    ## Sidebar ----
    dashboardSidebar(
      width = 250,
      sidebarMenu(
        id = "pages", 
        menuItem("Overview", tabName = "overview", icon = icon("tachometer-alt")),
        menuItem("Prerequisites", tabName = "prerequisite", icon = icon("book")),
        menuItem("Explore", tabName = "exp1", icon = icon('wpexplorer')),
        menuItem("Game", tabName = "instr2", icon = icon('gamepad')),
        menuItem("Challenge", tabName = 'instr1', icon = icon('cogs')),
        menuItem("References", tabName = "references", icon = icon("leanpub"))
      ),
      tags$div(
        class = "sidebar-logo", 
        boastUtils::sidebarFooter()
      )
    ),
    ## Body ----
    dashboardBody(
      useShinyjs(),
      tabItems(
        ### Overview ----
        tabItem(
          tabName = "overview",
          withMathJax(),
          h1("The", HTML("&chi;<sup>2</sup>"), "Test of Independence"),
          p('In this app you will explore examples of', HTML('&chi;<sup>2</sup>'),
            'Test of Independence; you will also be able to test your own dataset.
            The Fill in the Blanks exercise would serve to test your
            understandings about this topic.'),
          br(),
          h2("Instructions"),
          tags$ol(
            tags$li('In this application, you will first explore a variety of
                    real life examples using both graphical displays and the',
                    HTML('&chi;<sup>2</sup>'), 'test for independence.'),
            tags$li('By uploading your own datafile, you would be given back a',
                    HTML('&chi;<sup>2</sup>'), 'test for independence result of
                    the variables selected.'),
            tags$li('Read the instructions for Fill in the Blanks first and then
                    click on Go button to get started!')
          ),
          div(
            style = "text-align: center;",
            bsButton(
              inputId = "bsButton1", 
              label = "GO !",
              icon = icon('bolt'),
              size = 'large')
          ),
          br(),
          h2("Acknowledgements"),
          p('This application was coded, developed by Anna (Yinqi) Zhang and
            further updated by Jiayue He in 2021. Special Thanks to Dr. Pearl,
            Alex Chen, James M. Kopf, Angela Ting, Yingjie (Chealsea) Wang,
            and Yubaihe Zhou for being really supportive throughout the
            program.',
            br(),
            br(),
            "Cite this app as:",
            br(),
            boastUtils::citeApp(),
            br(),
            br(),
            div(class = "updated", "Last Update: 7/9/2021 by LSB.")
          )
        ),
        ### Prerequisite ----
        tabItem(
          tabName = 'prerequisite',
          withMathJax(),
          h3(strong('Background: Chi-Square Test of Independence')),
          br(),
          h4('To test for an association between two categorical variables, based on a two-way table 
                that has r rows as categories for variable A and c columns as categories for variable B:'),
          br(),
          h4(tags$li('Set up hypotheses:')),
          h4('\\(H_{0}\\):  Variable A is not associated with variable B.'),
          h4('\\(H_{a}\\):  Variable A is associated with variable B.'),
          h4(tags$li('Compute the expected count under the null for each cell in the table using:')),
          div(style = "font-size: 1.6em", 
              helpText('$${Expected \\ Cell \\ Count} = {Row\\ Total * Column\\ Total\\over Table\\ Total}$$')),
          h4(tags$li('Compute the value for the chi-square statistic using:')),
          div(style = "font-size: 1.6em", 
              helpText('$${X^2} = {\\sum{{(Observed - Expected)^2}\\over {Expected}}}$$')),
          #tags$img(src = 'chi_sqr_stats_2.jpg', width = "384px", height = "100px", style = "text-align: center"),
          h4('Find a p-value using the upper tail of a chi-square distribution with (r-1)(c-1) degrees of freedom or use simulation under the null.'),
          h4('The chi-square distribution is appropriate if the expected count is at least five in each cell.'),
          br(),
          div(
            style = "text-align: center;",
            bsButton(
              inputId = "goover", 
              label = "Explore !", 
              icon = icon("bolt"), 
              style = "color: #ffffff;",
              size = "large"
            )
          )
        ),
        ### Explore page ----
        tabItem(
          tabName = 'exp1', 
          tags$h3('Chi-Square Test for Association Explore Activity'),
          sidebarLayout(
            sidebarPanel(
              selectInput(
                inputId = 'inputs', 
                label = 'Select A Dataset to Explore', 
                selected = 'None',
                choices = c('None', 'Cars2015', 'HeroesInformation', 
                            'CompassionateRats', 'SandwichAnts', 'CocaineTreatment', 
                            'Test Your Own Dataset')
              ),
              br(),
              #### Use your own data ----
              conditionalPanel(
                condition = 'input.inputs == "Test Your Own Dataset"',
                fileInput(
                  inputId = 'file', 
                  label = 'Choose info-file to upload',
                  accept = c(
                    'text/csv',
                    'text/comma-separated-values',
                    'text/tab-separated-values',
                    'text/plain',
                    '.csv',
                    '.tsv'
                  )
                ),
                # ERROR: not showing up in app
                bsPopover(
                  id = "file", 
                  title = "File Upload", 
                  content = "If you have your own dataset you would like to enter, upload it through this"
                ),
                checkboxInput(
                  inputId = 'header', 
                  label = 'Header', 
                  value = TRUE
                ),
                bsPopover(
                  id = "header", 
                  title = "Header", 
                  content = "Please check whether there is a header for your data or not"
                ),
                radioButtons(
                  inputId = 'sep',
                  label = 'Separator',
                  choices = c(
                    Comma = ',',
                    Semicolon = ';',
                    tab = '\t'
                  ),
                  selected = ','
                ),
                bsPopover(
                  id = "sep", 
                  title = "Separator", 
                  content = "Choose which separation your file is using (If you do not know, it is most likely separating with commas"
                ),
                radioButtons(
                  inputId = 'quote',
                  label = 'Quote',
                  choices = c(
                    None = '',
                    'Double Quote' = '"',
                    'Single Quote' = "'"
                  ),
                  selected = '"'
                ),
                bsPopover(
                  id = "quote", 
                  title = "Quotes", 
                  content = "Check what kind of data you have and whether you need to use quotes or not"
                ),
                selectInput(
                  inputId = "columns", 
                  label = "Select Your X-Axis", 
                  choices = NULL
                ),
                selectInput(
                  inputId = "columns2", 
                  label = "Select Your Y-Axis", 
                  choices = NULL
                )
              ),
              # Neil stopped reformatting lines here
                    #Cars2015 input conditional panel
                    conditionalPanel('input.inputs == "Cars2015"', 
                                     tags$ul(
                                       tags$li('In the Cars2015 Dataset, there are three categorical variables:Type, Drive, and Size'),
                                       br(),
                                       tags$li('The Type variables takes on six levels: 7Pass, Hatchback, Sedan, Sporty, SUV, and Wagon'),
                                       br(),
                                       tags$li('The Drive variable takes on three levels: AWD, FWD, and RWD'),
                                       br(),
                                       tags$li('The Size variable takes on three levels: Large, Midsized, and Small')
                                     ),
                                     br(),
                                     selectInput(inputId = 'XCars2015', 
                                                 label = 'Select Your First Variable',
                                                 choices = c('Type', 'Drive', 'Size')),
                                     selectInput(inputId = 'YCars2015',
                                                 label = 'Select Your Second Variable',
                                                 choices = c('Type', 'Drive', 'Size')),
                                     tags$code('Challenge Question No.1'),
                                     tags$em(textOutput('Carsquestion')),
                                     br(),
                                     tags$code('Challenge Question No.2'),
                                     tags$em(textOutput('Carsquestion2')),
                                     br(),
                                     downloadButton('CarsDownload', 'Download')
                    ),
                    
                    #HeroesInformation input conditional panel
                    conditionalPanel('input.inputs == "HeroesInformation"',
                                     tags$ul(
                                       tags$li('In the HeroesInformation Dataset, there are five categorical variables: Gender, EyeColor, Race, HairColor, and Alignment'),
                                       br(),
                                       tags$li('The Gender variables takes on three levels: Male, Female, and Other'),
                                       br(),
                                       tags$li('The EyeColor variable takes on three levels: blue, -, and Other'),
                                       br(),
                                       tags$li('The Race variable takes on three levels: -, Human, and Other'),
                                       br(),
                                       tags$li('The HairColor variable takes on three levels: -, Black, and Other'),
                                       br(),
                                       tags$li('The Alignment variable takes on three levels: Good, Bad, and Other')
                                     ),
                                     br(),
                                     selectInput(inputId = 'XHeroesInfo', 
                                                 label = 'Select Your First Variable',
                                                 choices = c('Gender', 'EyeColor', 'Race', 'HairColor', 'Alignment')),
                                     selectInput(inputId = 'YHeroesInfo', 
                                                 label = 'Select Your Second Variable',
                                                 choices = c('Gender', 'EyeColor', 'Race', 'HairColor', 'Alignment')),
                                     tags$code('Challenge Question'),
                                     tags$em(textOutput('HIquestion')),
                                     br(),
                                     # tags$code('Challenge Question No.2'),
                                     # tags$em(textOutput('HIquestion2')),
                                     br(),
                                     downloadButton('HIDownload', 'Download')
                    ),
                    
                    #CompassionateRats input conditional panel
                    conditionalPanel('input.inputs == "CompassionateRats"',
                                     tags$ul(
                                       tags$li('In the CompassionateRats Dataset, there are only two variables: Sex and Empathy'),
                                       br(),
                                       tags$li('The Sex variable takes on two levels: Male and Female'),
                                       br(),
                                       tags$li('The Empathy variable takes on two levels: yes and no'),
                                       br(),
                                       downloadButton('CRDownload', 'Download')
                                     )
                    ),
                    
                    #SandwichAnts input conditional panel
                    conditionalPanel('input.inputs == "SandwichAnts"',
                                     tags$ul(
                                       tags$li('In the SandwichAnts Dataset, there are only two categorical variables: Filling and Bread'),
                                       br(),
                                       tags$li('The Filling variable takes on three levels: Vegemite, Peanut Butter, and Ham & Pickles'),
                                       br(),
                                       tags$li('The Bread variable takes on four levels: Rye, Wholemeal, Multigrain, and White'),
                                       br(),
                                       downloadButton('SADownload', 'Download')
                                     )
                    ),
                    
                    #CocaineTreatment input conditional panel
                    conditionalPanel('input.inputs == "CocaineTreatment"',
                                     tags$ul(
                                       tags$li('In the CocaineTreatment Dataset, there are only two categorical variables: Drug and Relapse'),
                                       br(),
                                       tags$li('The Drug variable takes on three levels: Desipramine, Lithium, and Placebo'),
                                       br(),
                                       tags$li('The Relapse variable takes on two levels: yes and no'),
                                       br(),
                                       downloadButton('CTDownload', 'Download')
                                     ))
                    
                  ),
                  
                  mainPanel(
                    conditionalPanel('input.inputs == "Test Your Own Dataset"',
                                     tableOutput("fileOutput"),
                                     verbatimTextOutput('fileChiSummary')
                                     
                    ),
                    
                    #Cars2015.csv output conditional panel
                    conditionalPanel('input.inputs == "Cars2015"',
                                     tabsetPanel(type = 'tabs',
                                                 tabPanel('Data Description',
                                                          br(),
                                                          box(style = 'warning', 
                                                              title = 'Dataset Details', 
                                                              width = 12, 
                                                              background = 'yellow', 
                                                              collapsible = TRUE,
                                                              'Data for a set of 110 new car models in 2015 based on information in the Consumer Reports New
                                                          Car Buying Guide.'),
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Data Source', 
                                                              width = 12, 
                                                              background = 'orange', 
                                                              collapsible = TRUE,
                                                              tags$a(href = 'http://www.magastack.com/issue/6053-consumer-reports-new-car-buying-guide-february-2015?page=1', 'Consumer Reports 2015 New Car Buying Guide'))
                                                 ),
                                                 tabPanel('Graph and Summary Output',
                                                          br(),
                                                          tags$li('2D Histogram Output'),
                                                          plotlyOutput('carsplotly'),
                                                          bsPopover(id = 'carsplotly', 
                                                                    title = NULL, 
                                                                    content = 'z corresponds to number of count in each category. For example, there are 20 sedans have AWD.'),
                                                          br(),
                                                          verbatimTextOutput('carssur')
                                                 )
                                     )
                    ),
                    
                    #HeroesInformation output conditional panel
                    conditionalPanel('input.inputs == "HeroesInformation"',
                                     tabsetPanel(type = 'tabs',
                                                 tabPanel('Data Description',
                                                          br(),
                                                          box(style = 'info',
                                                              title = 'Dataset Details', 
                                                              width = 12, 
                                                              background = 'olive', 
                                                              collapsible = TRUE,
                                                              'This data was collected in June/2017 from superherodb and not updated since. Super Heroes have been in popular culture for a long time and now more than ever. 
                                                          Since its creation, super heroes have not been very diverse, but that is changing rapidly. This dataset aims to provide an overview about heroes and their physical as well as power characteristics, 
                                                          helping researchers and curious minds identify trends and patterns.'),
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Data Source', 
                                                              width = 12, 
                                                              background = 'teal', 
                                                              collapsible = TRUE,
                                                              'This data was scraped from SuperHeroDb.')
                                                 ),
                                                 tabPanel('Graph and Summary Output',
                                                          br(),
                                                          tags$li('2D Histogram Output'),
                                                          plotlyOutput('hiplotly1'),
                                                          bsPopover('hiplotly1',
                                                                    title = NULL, 
                                                                    content = 'z corresponds to number of count in each category. For example, there are 165 males have bad alignment.'),
                                                          br(),
                                                          verbatimTextOutput('hisur')
                                                 ))
                    ),
                    
                    #SandwichAnts output conditional panel
                    conditionalPanel('input.inputs == "SandwichAnts"',
                                     tabsetPanel(type = 'tabs',
                                                 tabPanel('Data Description',
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Experiment Details', 
                                                              width = 12, 
                                                              background = 'yellow', 
                                                              collapsible = TRUE,
                                                              'As young students, Dominic Kelly and his friends enjoyed watching ants gather on pieces of sandwiches.
                                                          Later, as a university student, Dominic decided to study this with a more formal experiment.
                                                          He chose three types of sandwich fillings (vegemite, peanut butter, and ham & pickles), four types
                                                          of bread (multigrain, rye, white, and wholemeal), and put butter on some of the sandwiches.
                                                          To conduct the experiment he randomly chose a sandwich, broke off a piece, and left it on the
                                                          ground near an ant hill. After several minutes he placed a jar over the sandwich bit and counted the
                                                          number of ants. He repeated the process, allowing time for ants to return to the hill after each trial,
                                                          until he had two samples for each combination of the three factors.'),
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Data Source', 
                                                              width = 12, 
                                                              background = 'orange', 
                                                              collapsible = TRUE,
                                                              tags$p('Margaret Mackisack, "Favourite Experiments: An Addendum to What is the Use of Experiments
                                                          Conducted by Statistics Students?"', 
                                                          tags$a(href = 'https://ww2.amstat.org/publications/jse/v2n1/mackisack.supp.html', 'Journal of Statistics Education (1994)')))
                                                 ),
                                                 tabPanel('Graph and Summary Output',
                                                          br(),
                                                          tags$li('2D Histogram Output'),
                                                          plotlyOutput('saplotly1'),
                                                          bsPopover(id = 'saplotly1', 
                                                                    title = NULL, 
                                                                    content = 'z corresponds to number of count in each category. For example, there are 2 white bread with peanut butter filling.'),
                                                          br(),
                                                          plotlyOutput('saplotly2'),
                                                          br(),
                                                          verbatimTextOutput('sasur')
                                                 )
                                     )
                    ),
                    
                    #CompassionateRats output conditional panel
                    conditionalPanel('input.inputs == "CompassionateRats"',
                                     tabsetPanel(type = 'tabs',
                                                 tabPanel('Data Description', 
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Experiment Details', 
                                                              width = 12, 
                                                              background = 'light-blue',
                                                              collapsible = TRUE,
                                                              'In a recent study, some rats showed compassion by freeing another trapped rat, even when chocolate
                                                          served as a distraction and even when the rats would then have to share the chocolate with their freed
                                                          companion.',
                                                          br()),
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Data Source', 
                                                              width = 12, 
                                                              background = 'blue', 
                                                              collapsible = TRUE,
                                                              'Bartal I.B., Decety J., and Mason P., "Empathy and Pro-Social Behavior in Rats," Science, 2011;
                                                          224(6061):1427-1430.')
                                                 ),
                                                 tabPanel('Graph and Summary Output',
                                                          br(),
                                                          tags$li('2D Histogram Output'),
                                                          plotlyOutput('crplotly1'),
                                                          bsPopover(id = 'crplotly1', 
                                                                    title = NULL, 
                                                                    content = 'z corresponds to number of count in each category. For example, there are 6 female rats show signs of compassion.'),
                                                          br(),
                                                          plotlyOutput('crplotly2'),
                                                          br(),
                                                          verbatimTextOutput('crsur')
                                                 ))
                    ),
                    
                    #CocaineTreatment output conditional panel
                    conditionalPanel('input.inputs == "CocaineTreatment"',
                                     tabsetPanel(type = 'tabs',
                                                 tabPanel('Data Description',
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Experiment Details',
                                                              width = 12, 
                                                              background = 'light-blue', 
                                                              collapsible = TRUE,
                                                              'Data from an experiment to investigate the effectiveness of the two drugs, desipramine and lithium,
                                                          in the treatment of cocaine addiction. Subjects (cocaine addicts seeking treatment) were randomly
                                                          assigned to take one of the treatment drugs or a placebo. The response variable is whether or not
                                                          the subject relapsed (went back to using cocaine) after the treatment.',
                                                          br(),
                                                          br()),
                                                          br(),
                                                          br(),
                                                          box(style = 'info', 
                                                              title = 'Data Source', 
                                                              width = 12, 
                                                              background = 'blue', 
                                                              collapsible = TRUE,
                                                              'Gawin, F., et.al., "Desipramine Facilitation of Initial Cocaine Abstinence",
                                                          Archives of General Psychiatry, 1989; 46(2): 117 - 121.'
                                                          )
                                                          
                                                 ),
                                                 
                                                 tabPanel('Graph and Summary Output',
                                                          br(),
                                                          tags$li('2D Histogram Output'),
                                                          plotlyOutput('plotly1'),
                                                          bsPopover(id = 'plotly1', 
                                                                    title = NULL, 
                                                                    content = 'z corresponds to number of count in each category. For example, there are 10 patients relapsed after using desipramine as drug treatment.', placement = 'right'),
                                                          br(),
                                                          plotlyOutput('stack1'),
                                                          br(),
                                                          verbatimTextOutput('chiSqrSummary1'))
                                     )
                    )
                    
                    
                  )
                ),
                div(style = "text-align: center", 
                    bsButton(inputId = "bsButton2", 
                             label = "Play !",
                             icon = icon('bolt'), 
                             size = 'large'))
        ),
        
        #Game page
        tabItem(
          tabName = "instr2",
          sidebarLayout(
            sidebarPanel(
              tags$code("Interpreting the Graph"),
              selectInput(inputId = 'graphId', 
                label = 'Select Your Graph',
                choices = c('The First Graph', 'The Second Graph', 'The Third Graph', 'The Fourth Graph'),
                selected = 'The First Graph'),
              conditionalPanel('input.graphId == "The First Graph"',
                selectInput(inputId = 'cq1', 
                  label = 'Your Interpretation',
                  choices = c('',
                    'A. The x-axis represents different sandwich fillings',
                    'B. The y-axis represents different sandwich bread',
                    'C. The color bar represents how many sandwiches are in each Bread & Filling combination',
                    'D. A, B, and C'),
                  selected = ''),
                br(),
                div(style = 'text-align: left', 
                  bsButton(inputId = 'cq1check1', 
                    label = 'Check Answer',  
                    size = "large"), 
                  bsButton(inputId = 'next1', 
                    label = 'Next', 
                    size = "large"))
              ),
              conditionalPanel(
                'input.graphId == "The Second Graph"',
                selectInput('cq2', label = 'Your Interpretation',
                  choices = c('',
                    'A. In this dataset, midsized is the most common size for 7Pass cars',
                    'B. In this dataset, midsized is the most common size for SUV cars',
                    'C. In this dataset, small is the most common size for Sporty cars',
                    'D. None of the above'),
                    selected = ''
                ),
                br(),
                div(style = 'text-align: left', 
                  bsButton(inputId = 'cq1check2', 
                    label = 'Check', 
                    size = "large"), 
                  bsButton(inputId = 'next2', 
                    label = 'Next', 
                    size = "large"))
              ),
                                         
                                         conditionalPanel('input.graphId == "The Third Graph"',
                                                          selectInput('cq3', label = 'Your Interpretation',
                                                                      choices = c('',
                                                                                  'A. The use of desipramine is largely associated with the relapse status',
                                                                                  'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo',
                                                                                  'C. The use of placebo is equally associated with the relapse status and non-relapse status',
                                                                                  'D. The use of lithium is more associated with the non-relapse status than the relapse status'),
                                                                      selected = ''),
                                                          br(),
                                                          div(style = 'text-align: left',
                                                              bsButton(inputId = 'cq1check3', 
                                                                       label = 'Check', 
                                                                       size = "large"),
                                                              bsButton(inputId = 'next3', 
                                                                       label = 'Next',
                                                                       size = "large"))
                                         ),
                                         
                                         conditionalPanel('input.graphId == "The Fourth Graph"',
                                                          selectInput('cq4', label = 'Your Interpretation',
                                                                      choices = c('',
                                                                                  'A. All of the female rates showed empathy',
                                                                                  'B. The color hows the number of rats in each category',
                                                                                  'C. Both A and B'),
                                                                      selected = ''),
                                                          br(),
                                                          div(style = 'text-align: left',
                                                              bsButton(inputId = 'cq1check4', 
                                                                       label = 'Check', 
                                                                       size = "large"), 
                                                              bsButton(inputId = 'next4', 
                                                                       label = 'Next', 
                                                                       size = "large"))
                                         )
                                       ),
                                       
                                       mainPanel(
                                         #conditionalPanel('input.bsButton6 != 0',
                                                          conditionalPanel('input.graphId == "The First Graph"',
                                                                           # br(),
                                                                           # br(),
                                                                           plotlyOutput('cha2plot1'),
                                                                           conditionalPanel('input.cq1check1 != 0',
                                                                                            htmlOutput('cq1ans1'),
                                                                                            uiOutput('cq1feed1')
                                                                           )
                                                          ),
                                                          conditionalPanel('input.graphId == "The Second Graph"',
                                                                           br(),
                                                                           br(),
                                                                           plotlyOutput('cha2plot2'),
                                                                           conditionalPanel('input.cq1check2 != 0',
                                                                                            htmlOutput('cq1ans2'),
                                                                                            uiOutput('cq1feed2')
                                                                           )
                                                          ),
                                                          conditionalPanel('input.graphId == "The Third Graph"',
                                                                           br(),
                                                                           br(),
                                                                           plotlyOutput('cha2plot3'),
                                                                           conditionalPanel('input.cq1check3 != 0',
                                                                                            htmlOutput('cq1ans3'),
                                                                                            uiOutput('cq1feed3')
                                                                           )
                                                          ),
                                                          conditionalPanel('input.graphId == "The Fourth Graph"',
                                                                           br(),
                                                                           br(),
                                                                           plotlyOutput('cha2plot4'),
                                                                           conditionalPanel('input.cq1check4 != 0',
                                                                                            htmlOutput('cq1ans4'),
                                                                                            uiOutput('cq1feed4')
                                                                           )
                                                          )

                                       )
                                     ),
                                     div(style = "text-align: left", 
                                         bsButton(inputId = "bsButton8", 
                                                  label = "Challenge!", 
                                                  icon = icon('bolt'), 
                                                  size = "large"))
          ),
        #Challenge page
        tabItem(
          tabName = "instr1",
          # tabsetPanel(id = "games2",
            # tabPanel(
            #   title = h4("Instructions"), 
            # value = "instruct2",
            # fluidPage(theme = 'Muted', 
            # titlePanel('Instructions to Answering the Practice Questions'),
            #                                    h4(tags$li('Click on the GO! button to start the game.')),
            #                                    h4(tags$li('Select from the dropdown menu the answer you think correct.')),
            #                                    h4(tags$li('Click on "Submit!" to see if your answer is correct or not.')),
            #                                    br(),
            #                                    div(style = "text-align: center", 
            #                                        bsButton(inputId = "bsButton4",
            #                                                 label = "GO!", 
            #                                                 icon = icon('bolt'), 
            #                                                 size = "large"))
            #                          ) 
            #                 ),
            # tabPanel(
            #   title = h4("Multiple Choice"), value = "cha1",
              fluidRow(
                box(width = 12, 
                style = 'color: #FFFFFF; background-color: #ffa500',
                htmlOutput('questionCha'))
                                     ),
                fluidRow(
                                       box(width = 12, 
                                           style = 'color: #000000; background-color: #ffa500',
                                           htmlOutput('choiceCha'))
                                     ),
                                     
                                     conditionalPanel('input.submitX != 0',
                                                      htmlOutput('challengeFeedback'),
                                                      htmlOutput('textFeedback')),
                                     br(),
                                     div(style = "text-align: left", 
                                         actionButton(inputId = 'submitX', 
                                                      label = 'Check Answer',
                                                      size = "small"),
                                         actionButton(inputId = 'nextX', 
                                                      label = 'Next', 
                                                      size = "small")),
                                     div(style = "text-align: center", 
                                         bsButton(inputId = "bsButton7", 
                                                  label = "Continue!",
                                                  icon = icon('bolt'), 
                                                  size = "large"))
                            #)
                            
                # )
        ),
        
        #References page
        tabItem(
          tabName = "references",
          withMathJax(),
          h2("References"),
          p(
            class = "hangingindent",
            "https://educationshinyappteam.github.io/Style_Guide/index.html#organization"
          ),
          
          p(
            class = "hangingindent",
            "Attali, D.(2020). 
            shinyjs: Easily Improve the User Experience of Your Shiny Apps in Seconds. R package version 2.0.0 [R Package]. 
            Available from https://CRAN.R-project.org/package=shinyjs"
          ),
          
          p(
            class = "hangingindent",
            "Bailey, E. (2015). shinyBS: Twitter bootstrap components for shiny. 
            (v0.61). [R package]. Available from https://CRAN.R-project.org/package=shinyBS"
          ),
          p(
            class = "hangingindent",
            "Carey, R. (2019). boastUtils: BOAST Utilities, R Package.
                             Available from https://github.com/EducationShinyAppTeam/boastUtils"
          ),
          
          p(
            class = "hangingindent",
            "Chang, W. and Borges Ribeio, B. (2018). shinydashboard: Create
                             dashboards with 'Shiny', R Package. Available from
                             https://CRAN.R-project.org/package=shinydashboard"
          ),
          
          p(
            class = "hangingindent",
            "Chang, W., Cheng, J., Allaire, J., Xie, Y., and McPherson, J. (2019). 
            shiny: Web application framework for R. (v1.4.0) [R Package]. 
            Available from https://CRAN.R-project.org/package=shiny"
          ),
          
          p(
            class = "hangingindent",
            "Wickham, H. (2011), “The Split-apply-combine strategy for data 
                             analysis.” Journal of Statistical Software, 40, pp. 1-29. 
                             Available at http://www.jstatsoft.org/v40/i01/."
          ),
          boastUtils::copyrightInfo()
          
        ) #end of tabItem
        
      )
      
      
    )
  )
)


#import dataset: Cars2015.csv
cars <- read.csv('Cars2015.csv')
cars <- cars[, c('Drive', 'Type', 'Size')]

#import dataset: 
hi <- read.csv('HeroesInformation.csv')

#import dataset: CocaineTreatment.csv
ct = read.csv('CocaineTreatment.csv')
class(ct) #data.frame
treatment <- c('Desipramine', 'Lithium', 'Placebo')
no <- c(14, 6, 4)
yes <- c(10, 18, 20)
treatmentData <- data.frame(treatment, no, yes)

#import dataset: CompassionateRats.csv
cr = read.csv('CompassionateRats.csv')
sex <- c('F', 'M')
no1 <- c(0, 7)
yes1 <- c(6, 17)
crData <- data.frame(sex, no1, yes1)

#import dataset: SandwichAnts.csv
sa <- read.csv('SandwichAnts.csv')
bread <- c('Multigrain', 'Rye', 'White', 'Wholemeal')
hpickles <- c(2, 2, 2, 2)
pbutter <- c(2, 2, 2, 2)
vegemite <- c(2, 2, 2, 2)
saData <- data.frame(bread, hpickles, pbutter, vegemite)


#Server ----
server <- function(input, output, session) {
  
  # Learning Locker Statement Generation
  .generateStatement <- function(session, verb = NA, object = NA, description = NA, value = NA) {
    if (is.na(object)) {
      object <- paste0("#shiny-tab-", session$input$pages)
    } else {
      object <- paste0("#", object)
    }
    
    stmt <- list(
      verb = verb,
      object = list(
        id = paste0(boastUtils::getCurrentAddress(session), object),
        name = paste0(APP_TITLE),
        description = description
      )
    )
    
    if (!is.na(value)) {
      stmt$result <- list(
        response = paste(value)
      )
    }
    
    statement <- rlocker::createStatement(stmt)
    response <- rlocker::store(session, statement)
    
    return(response)
  }
  
  .generateAnsweredStatement <- 
    function(session, 
             verb = NA, 
             object = NA, 
             description = NA, 
             interactionType = NA, 
             response = NA, 
             success = NA, 
             completion = FALSE) {
      statement <- rlocker::createStatement(list(
        verb = verb,
        object = list(
          id = paste0(getCurrentAddress(session), "#", object),
          name = paste0(APP_TITLE),
          description = paste0("Identify the distribution of given text: ", description),
          interactionType = interactionType
        ),
        result = list(
          success = success,
          response = response,
          completion = completion
        )
      ))
      
      return(rlocker::store(session, statement))
    }
  
  #Go to overview Button
  observeEvent(input$goover, {
    updateTabItems(session, "pages", "exp1")
  })
  #Go to game page Button
  observeEvent(input$bsButton2, {
    updateTabItems(session, "pages", "instr2")
  })

  
  
  ###### Download 5 datasets ######
  output$CarsDownload <- downloadHandler(
    filename = function() {
      paste('Cars2015-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(cars, con)
    }
  )
  
  output$HIDownload <- downloadHandler(
    filename = function() {
      paste('HeroesInformation-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(hi, con)
    }
  )
  
  output$CRDownload <- downloadHandler(
    filename = function() {
      paste('CompassionateRats-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(cr, con)
    }
  )
  
  output$SADownload <- downloadHandler(
    filename = function() {
      paste('SandwichAnts-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(sa, con)
    }
  )
  
  output$CTDownload <- downloadHandler(
    filename = function() {
      paste('CocaineTreatment-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(ct, con)
    }
  )
  
  
  inputDataset <- reactive({
    
    validate(
      need(input$file, 'Please Select Your Datafile')
    )
    
    inFile = input$file
    req(inFile)
    inputDataset <- read.table(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)
    return(inputDataset)
    
  })
  
  output$fileOutput <- renderTable ({
    vars = names(inputDataset())
    updateSelectInput(session, "columns", "Select Your X-Axis", choices = vars)
    updateSelectInput(session, "columns2", "Select Your Y-Axis", choices = vars)
    head(inputDataset(), 5)
  })
  
  output$fileChiSummary <- renderPrint({
    chisq.test(table(inputDataset()[ , c(input$columns, input$columns2)]))
  })
  
  #question bank for exploratory data analysis
  qbank <- read.csv('Workbook1.csv')
  qbank$Question <- as.character(qbank$Question)
  
  #Challenge Question No.1 for HeroesInformation
  output$HIquestion <- renderText({
    paste('Is the variable', input$XHeroesInfo, 'independent from the variable', input$YHeroesInfo, '?')
  })
  
  val <- reactiveValues()
  
  # #Challenge Question No.2 for HeroesInformation
  # output$HIquestion2 <- renderText({
  #   val$num <- sample(4:13, 1, replace = FALSE)
  #   HIq2 <- qbank$Question[val$num]
  #   HIq2
  # })
  
  #2D histogram for HeroesInformation
  output$hiplotly1 <- renderPlotly ({
    x <- list(title = input$XHeroesInfo)
    y <- list(title = input$YHeroesInfo)
    hip <- plot_ly(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo], type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    hip
  })
  
  #X^2 summary for HeroesInformation
  output$hisur <- renderPrint({
    hiSummary <- chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo], simulate.p.value = TRUE)
    hiSummary
  })
  #chisq.test(table(hi[ , c(input$XHeroesInfo, input$YHeroesInfo)]))
  #Warning in chisq.test(table(hi[, c(input$XHeroesInfo, input$YHeroesInfo)])) :
  #Chi-squared approximation may be incorrect
  #chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo],simulate.p.value = TRUE)
  
  #Challenge Question No.1 for Cars2015
  output$Carsquestion <- renderText({
    paste('Is the variable', input$XCars2015, 'independent from the variable', input$YCars2015, '?')
  })
  
  #Challenge Question No.2 for Cars2015
  output$Carsquestion2 <- renderText({
    val$num2 <- sample(1:3, 1, replace = FALSE)
    carsQuestion2 <- qbank$Question[val$num2]
    carsQuestion2
  })
  
  #2D histogram for Cars2015
  output$carsplotly <- renderPlotly({
    x <- list(title = input$XCars2015)
    y <- list(title = input$YCars2015)
    carsp <- plot_ly(x = cars[ , input$XCars2015], 
                     y = cars[ , input$YCars2015], 
                     marker = list(size = seq(0, 50, 5), 
                                   color = seq(0, 50, 5),
                                   colorbar = list(title = 'Count'), 
                                   colorscale = 'Reds', 
                                   reversescale = TRUE),
                     type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    carsp
  })
  
  #X^2 summary for Cars2015
  output$carssur <- renderPrint({
    carsSummary <- chisq.test(x = cars[ , input$XCars2015], 
                              y = cars[ , input$YCars2015],
                              simulate.p.value = TRUE)
    carsSummary
  })
  #chisq.test(table(cars[ , c(input$XCars2015, input$YCars2015)]))
  #chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo],simulate.p.value = TRUE)
  
  #2D histogram for SandwichAnts
  output$saplotly1 <- renderPlotly({
    x <- list(title = 'Filling')
    y <- list(title = 'Bread')
    sap1 <- plot_ly(x = sa$Filling, 
                    y = sa$Bread,
                    type = "histogram2d") %>%
      layout(xaxis = x, 
             yaxis = y, 
             title = '2D Histogram for the Sandwich & Ants Example')
    sap1
  })
  
  #stacked bar chart for SandwichAnts
  output$saplotly2 <- renderPlotly({
    x <- list(title = 'Bread')
    sap2 <- plot_ly(saData, x = ~bread, 
                    y = ~hpickles, 
                    type = 'bar', 
                    name = 'Ham & Pickles',
                    type = "histogram2d") %>%
      add_trace(y = ~pbutter, 
                name = 'Peanut Butter') %>%
      add_trace(y = ~vegemite, 
                name = 'vegemite') %>%
      layout(xaxis = x, 
             yaxis = list(title = 'Count'), 
             barmode = 'stacked')
    sap2
  })
  
  #X^2 summary for SandwichAnts
  output$sasur <- renderPrint({
    sas <- chisq.test(table(sa[ , c(2, 3)]))
    sas
  })
  
  #2D histogram for CompassionateRats
  output$crplotly1 <- renderPlotly({
    x <- list(title = 'Sex')
    y <- list(title = 'Empathy')
    cr1 <- plot_ly(x = cr$Sex,
                   y = cr$Empathy,
                   type = "histogram2d") %>%
      layout(xaxis = x, 
             yaxis = y, 
             title = '2D Histogram for the Compassionate Rats Example')
    cr1
  })
  
  #stacked bar chart for CompassionateRats
  output$crplotly2 <- renderPlotly({
    x <- list(title = 'Sex')
    cr2 <- plot_ly(crData, x = ~sex, y = ~no1, type = 'bar', name = 'No') %>%
      add_trace(y = ~yes1, name = 'yes') %>%
      layout(xaxis = x, yaxis = list(title = 'Count'), barmode = 'stacked')
    cr2
  })
  
  #X^2 summary for CompassionateRats
  output$crsur <- renderPrint({
    crsur1 <- chisq.test(table(as.matrix(cr)))
    crsur1
  })
  
  #2D histogram for CocaineTreatment
  output$plotly1 <- renderPlotly ({
    x <- list(title = 'Drug Treatment')
    y <- list(title = 'Relapse Status')
    ctp1 <- plot_ly(x = ct$Drug, y = ct$Relapse,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    ctp1
  })
  
  #stacked bar chart for CocaineTreatment
  output$stack1 <- renderPlotly({
    x <- list(title = 'Drug Treatment')
    p2 <- plot_ly(treatmentData, x = ~treatment, y = ~no, type = 'bar', name = 'No') %>%
      add_trace(y = ~yes, name = 'Yes') %>%
      layout(xaxis = x, axis = list(title = 'Treatment'), yaxis = list(title = 'Count'), barmode = 'stacked')
    p2
  })
  #X^2 summary for CocaineTreatment
  output$chiSqrSummary1 <- renderPrint({
    chisqSummary1 <- chisq.test(ct$Drug, ct$Relapse)
    chisqSummary1
  })
  
  ############ Update Events ############
  #set all the buttons
  observeEvent(input$next1, {
    updateSelectInput(session, inputId = 'cq1', label = 'The Second Graph',
                      choices = c('',
                                  'A. In this dataset, midsized is the most common size for 7Pass cars',
                                  'B. In this dataset, midsized is the most common size for SUV cars',
                                  'C. In this dataset, small is the most common size for Sporty cars',
                                  'D. None of the above')
    )
  })
  
  observeEvent(input$next2, {
    updateSelectInput(session, inputId = 'cq1', label = 'The Third Graph',
                      choices = c('',
                                  'A. The use of desipramine is largely associated with the relapse status',
                                  'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo',
                                  'C. The use of placebo is equally associated with the relapse status and non-relapse status',
                                  'D. The use of lithium is more associated with the non-relapse status than the relapse status')
    )
  })
  
  observeEvent(input$bsButton1, {
    updateTabItems(session, 'pages', 'prerequisite')
  })
  
  observeEvent(input$bsButton2, {
    updateTabItems(session, 'pages', 'exp3')
  })
  
  # observeEvent(input$bsButton4, {
  #   updateTabItems(session, 'games2', 'cha1')
  # })
  
  # observeEvent(input$bsButton6, {
  #   updateTabItems(session, 'games1', 'cha2')
  # })
  
  observeEvent(input$bsButton7, {
    updateTabItems(session, 'pages', 'references')
  })
  
  observeEvent(input$bsButton8, {
    updateTabItems(session, 'pages', 'instr1')
  })
  
  observeEvent(input$next1, {
    updateTabItems(session, 'pages', 'cha2_2')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Second Graph')
  })
  
  observeEvent(input$next2, {
    updateTabItems(session, 'pages', 'cha2_3')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Third Graph')
  })
  
  observeEvent(input$next3, {
    updateTabItems(session, 'pages', 'cha2_4')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Fourth Graph')
  })
  
  observeEvent(input$next4, {
    updateTabItems(session, 'pages', 'instr1')
  })
  
  ############ What's Going On in This Graph? ############
  ############ ############ ############ ############
  #cha2 plot1
  output$cha2plot1 <- renderPlotly({
    x <- list(title = 'Filling')
    y <- list(title = 'Bread')
    cha2p1 <- plot_ly(x = sa$Filling, y = sa$Bread,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Sandwich & Ants Example')
    cha2p1
  })
  
  observeEvent(input$cq1check1,{
    if(input$cq1 == 'D. A, B, and C') {
      output$cq1ans1 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed1 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans1 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed1 <- renderUI({
        tags$h4(strong('Please play with the interactive plots and think about what the axes represent!'))
      })
    }
  })
  
  
  #cha2 plot2
  output$cha2plot2 <- renderPlotly({
    x <- list(title = 'Type')
    y <- list(title = 'Size')
    cha2p2 <- plot_ly(x = cars$Type, y = cars$Size,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Cars Example')
    cha2p2
  })
  #cha2 answer2 + feed2
  observeEvent(input$cq1check2,{
    if(input$cq2 == 'C. In this dataset, small is the most common size for Sporty cars') {
      output$cq1ans2 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed2 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans2 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed2 <- renderUI({
        tags$h4(strong('Start with each car types and then go through the sizes corresponding to each type!'))
      })
    }
  })
  
  #cha2 plot3
  output$cha2plot3 <- renderPlotly({
    x <- list(title = 'Drug')
    y <- list(title = 'Relapse Status')
    cha2p3 <- plot_ly(x = ct$Drug, y = ct$Relapse,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Drug Treatment and Relapse Status')
    cha2p3
  })
  
  #cha2 answer3 + feed3
  observeEvent(input$cq1check3,{
    if(input$cq3 == 'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo') {
      output$cq1ans3 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed3 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans3 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed3 <- renderUI({
        tags$h4(strong('Compare the relapse and non-relapse status within each drug treatment! Go both vertically and horizontally!'))
      })
    }
  })
  
  #cha2 plot4
  output$cha2plot4 <- renderPlotly({
    x <- list(title = 'Sex')
    y <- list(title = 'Empathy')
    cha2p4 <- plot_ly(x = cr$Sex, y = cr$Empathy,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Compassionate Rats Example')
    cha2p4
  })
  
  #cha2 answer4 + feed4
  observeEvent(input$cq1check4,{
    if(input$cq4 == 'C. Both A and B') {
      output$cq1ans4 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed4 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans4 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed4 <- renderUI({
        tags$h4(strong('Think about what could be done to make the graph more informative!'))
      })
    }
  })
  
  ############ Question Bank ############
  question <- read.delim('Workbook2.csv')
  question$Question <- as.character(question$Question)
  question$A <- as.character(question$A)
  question$B <- as.character(question$B)
  question$Correct <- as.character(question$Correct)
  question$Feedback <- as.character(question$Feedback)
  sapply(question, class)
  
  values <- reactiveValues()
  
  output$questionCha <- renderUI ({
    values$num <- sample(1:8, 1, replace = FALSE)
    challengeQuestion <- question$Question[values$num]
    h4(challengeQuestion)
  })
  
  output$choiceCha <- renderUI({
    selectInput(inputId = 'challengeChoice', label = '', 
                choices = c("Please select your response",question$A[values$num], question$B[values$num]))
  })
  
  observeEvent(input$nextX, {
    output$questionCha <- renderUI ({
      values$num = sample(1:8, 1, replace = FALSE)
      questionUpdate <- question$Question[values$num]
      h4(questionUpdate)
    })
  })
  
  #feedback and mark
  observeEvent(input$submitX, {
    if (input$challengeChoice == question$Correct[values$num]) {
      output$challengeFeedback <- boastUtils::renderIcon (
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$textFeedback <- renderUI ({
        div(h4(style = 'text-align: left', paste('Congratulations!')))
      })
    }
    else {
      output$challengeFeedback <- boastUtils::renderIcon (
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$textFeedback <- renderUI ({
        text <- question$Feedback[values$num]
        div(h4(style = 'text-align: left', text))
      }) 
    }
  })
  
  observeEvent(input$nextX, {
    shinyjs::hideElement("challengeFeedback")
    shinyjs::hideElement('textFeedback')
  })
  
  observeEvent(input$submitX, {
    shinyjs::showElement("challengeFeedback")
    shinyjs::showElement('textFeedback')
  })
  
}

boastUtils::boastApp(ui = ui, server = server)
