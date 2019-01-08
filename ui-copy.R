library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyjs)
library(shinyDND)
library(plotly)

header = dashboardHeader(title = "ANOVA")

sidebar = dashboardSidebar(
  sidebarMenu(id = 'tabs', 
              menuItem('Prerequisite', tabName = 'prerequisite', icon = icon('bar-chart-o')),
              menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
              menuItem('View an Example', tabName = "exp1", icon = icon('refresh')),
              menuItem('Test Your Own Dataset', tabName = 'exp2', icon = icon('table')),
              menuItem('Get Some Practice', tabName = "exp3", icon = icon('th'),
                       menuSubItem('Instructions', tabName = 'instr2', icon = icon('cog')),
                       menuSubItem('What is Going on Graph?', tabName = 'cha2', icon = icon('bullhorn')),
                       # menuSubItem('What is Going on Graph?', tabName = 'cha2_2', icon = icon('bullhorn')),
                       # menuSubItem('What is Going on Graph?', tabName = 'cha2_3', icon = icon('bullhorn')),
                       # menuSubItem('What is Going on Graph?', tabName = 'cha2_4', icon = icon('bullhorn')),
                       menuSubItem('Instructions', tabName = 'instr1', icon = icon('cog')),
                       menuSubItem('Fill in the Blank', tabName = 'cha1', icon = icon('bullhorn'))
              )
  )
)

body = dashboardBody(
  tags$style(type = "text/css", ".content-wrapper,.right-side {background-color: white;}"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  useShinyjs(),
  
  tabItems(
    tabItem(
      tabName = 'prerequisite', withMathJax(),
      tags$h2('Prerequisite'),
      tags$ul(
        tags$li('To test for an association between two categorical variables, based on a two-way table 
                that has r rows as categories for variable A and c columns as categories for variable B:'),
        br(),
        
        tags$li('Set up hypotheses:'),
        tags$i('\\(H_{0}\\):  Variable A is not associated with variable B'),
        tags$i('\\(H_{a}\\):  Variable A is associated with variable B'),
        br(),
        br(),
        
        tags$li('Compute the expected count for each cell in the table using:'),
        tags$img(src = 'chi_sqr_stats_1.jpg', width = "384px", height = "100px"),
        br(),
        
        tags$li('Compute the value for a chi-square statistics using:'),
        tags$img(src = 'chi_sqr_stats_2.jpg', width = "384px", height = "100px", style = "text-align: center"),
        br(),
        br(),
        
        tags$li('Find a p-value using the upper tail of a chi-square distribution with (r-1)(c-1) degrees of freedom.'),
        br(),
        
        tags$li('The chi-square distribution is appropriate if the expected count is at least five in each cell.'),
        br()
        )
    ),
    
    tabItem(tabName = "overview",
            tags$a(href='http://stat.psu.edu/', tags$img(src = 'psu_icon.jpg', align = "left", width = 180)),
            br(),
            br(),
            br(),
            tags$h2("About", align = 'left'),
            tags$li('In this app you will explore an example of X^2 Test of Independence; 
                    you will also be able to test your own dataset. 
                    The Fill in the Blanks exercise would serve to test your understandings about this topic.'),
            br(),
            
            tags$h2("Instructions"),
            tags$ul(
              tags$li('In this application, you will first explore a real life example of cocaine treatment, and 
                      you could opt to view a variety of displays of graphs;'),
              tags$li('By uploading your own datafile, you would be given back a X^2 test for independence result of the variables selected;'),
              tags$li('Read the instructions for Fill in the Blanks first and then click on Go button to get started!'),
              br(),
              div(style = "text-align: center", bsButton(inputId = "bsButton1", label = "GO!", size = "large", style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"))
              ),
            br(),
            
            tags$h2("Acknowledgements"),
            tags$ul(
              tags$li('This application was coded and developed by Anna (Yinqi) Zhang;'),
              tags$li('Special Thanks to Dr. Pearl, Alex Chen, James M. Kopf, Angela Ting, Chealsea (Yingjie) Wang, and Yubaihe Zhou for being really supportive throughout the program;'),
              tags$li('The dataset was pulled from Statistics, Unlocking the Power of Data, by Lock, Lock, Lock, Lock, and Lock and Kaggle'),
              tags$li('The file import code was partially pulled from https://gist.github.com/SachaEpskamp/5796467')
            )),
    
    ############ Explore Activity No.1 with Different Datasets ############
    ############ ############ ############ ############
    tabItem(tabName = 'exp1', 
            tags$h3('Chi-Square Test for Association Explore Activity'),
            sidebarLayout(
              sidebarPanel(
                selectInput(inputId = 'inputs', label = 'Select A Dataset to Explore', selected = 'None',
                            choices = c('None', 'Cars2015', 'HeroesInformation', 'CompassionateRats', 'SandwichAnts', 'CocaineTreatment')),
                br(),
                #Cars2015 input conditional panel
                conditionalPanel('input.inputs == "Cars2015"', 
                                 selectInput(inputId = 'XCars2015', label = 'Select Your First Variable',
                                             choices = c('Type', 'Drive', 'Size')),
                                 selectInput(inputId = 'YCars2015', label = 'Select Your Second Variable',
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
                                 selectInput(inputId = 'XHeroesInfo', label = 'Select Your First Variable',
                                             choices = c('Gender', 'EyeColor', 'Race', 'HairColor', 'Alignment')),
                                 selectInput(inputId = 'YHeroesInfo', label = 'Select Your Second Variable',
                                             choices = c('Gender', 'EyeColor', 'Race', 'HairColor', 'Alignment')),
                                 tags$code('Challenge Question No.1'),
                                 tags$em(textOutput('HIquestion')),
                                 br(),
                                 tags$code('Challenge Question No.2'),
                                 tags$em(textOutput('HIquestion2')),
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
                
                #Cars2015.csv output conditional panel
                conditionalPanel('input.inputs == "Cars2015"',
                                 tabsetPanel(type = 'tabs',
                                             tabPanel('Data Description',
                                                      br(),
                                                      box(style = 'warning', title = 'Dataset Details', width = 12, background = 'yellow', collapsible = TRUE,
                                                          'Data for a set of 110 new car models in 2015 based on information in the Consumer Reports New
                                                          Car Buying Guide.'),
                                                      br(),
                                                      br(),
                                                      box(style = 'info', title = 'Data Source', width = 12, background = 'orange', collapsible = TRUE,
                                                          'Consumer Reports 2015 New Car Buying Guide 
                                                          http://www.magastack.com/issue/6053-consumer-reports-new-car-buying-guide-february-2015?page=1 
                                                          http://www.consumerreports.org/cro/cars/compare.htm?add=true&product=new/chevrolet/impala')
                                                      ),
                                             tabPanel('Graph and Summary Output',
                                                      br(),
                                                      tags$li('2D Histogram Output'),
                                                      plotlyOutput('carsplotly'),
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
                                                      box(style = 'info', title = 'Dataset Details', width = 12, background = 'olive', collapsible = TRUE,
                                                          'This data was collected in June/2017 from superherodb and not updated since. Super Heroes have been in popular culture for a long time and now more than ever. 
                                                          Since its creation, super heroes have not been very diverse, but that is changing rapidly. This dataset aims to provide an overview about heroes and their physical as well as power characteristics, 
                                                          helping researchers and curious minds identify trends and patterns.'),
                                                      br(),
                                                      br(),
                                                      box(style = 'info', title = 'Data Source', width = 12, background = 'teal', collapsible = TRUE,
                                                          'This data was scraped from SuperHeroDb.')
                                                      ),
                                             tabPanel('Graph and Summary Output',
                                                      br(),
                                                      tags$li('2D Histogram Output'),
                                                      plotlyOutput('hiplotly1'),
                                                      br(),
                                                      verbatimTextOutput('hisur')
                                                      ))
                                 ),
                
                #SandwichAnts output conditional panel
                conditionalPanel('input.inputs == "SandwichAnts"',
                                 tabsetPanel(type = 'tabs',
                                             tabPanel('Data Description',
                                                      br(),
                                                      box(style = 'info', title = 'Experiment Details', width = 12, background = 'yellow', collapsible = TRUE,
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
                                                      box(style= 'info', title = 'Data Source', width = 12, background = 'orange', collapsible = TRUE,
                                                          'Margaret Mackisack, “Favourite Experiments: An Addendum to What is the Use of Experiments
                                                          Conducted by Statistics Students?", Journal of Statistics Education (1994)
                                                          http://www.amstat.org/publications/jse/v2n1/mackisack.supp.html')
                                                      ),
                                             tabPanel('Graph and Summary Output',
                                                      br(),
                                                      tags$li('2D Histogram Output'),
                                                      plotlyOutput('saplotly1'),
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
                                                      box(style = 'info', title = 'Experiment Details', width = 12, background = 'light-blue', collapsible = TRUE,
                                                          'In a recent study, some rats showed compassion by freeing another trapped rat, even when chocolate
                                                          served as a distraction and even when the rats would then have to share the chocolate with their freed
                                                          companion.',
                                                          br()),
                                                      br(),
                                                      br(),
                                                      box(style = 'info', title = 'Data Source', width = 12, background = 'blue', collapsible = TRUE,
                                                          'Bartal I.B., Decety J., and Mason P., "Empathy and Pro-Social Behavior in Rats," Science, 2011;
                                                          224(6061):1427-1430.')
                                                      ),
                                             tabPanel('Graph and Summary Output',
                                                      br(),
                                                      tags$li('2D Histogram Output'),
                                                      plotlyOutput('crplotly1'),
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
                                                      box(style = 'info', title = 'Experiment Details', width = 12, background = 'light-blue', collapsible = TRUE,
                                                          'Data from an experiment to investigate the effectiveness of the two drugs, desipramine and lithium,
                                                          in the treatment of cocaine addiction. Subjects (cocaine addicts seeking treatment) were randomly
                                                          assigned to take one of the treatment drugs or a placebo. The response variable is whether or not
                                                          the subject relapsed (went back to using cocaine) after the treatment.',
                                                          br(),
                                                          br()),
                                                      br(),
                                                      br(),
                                                      box(style = 'info', title = 'Data Source', width = 12, background = 'blue', collapsible = TRUE,
                                                          'Gawin, F., et.al., "Desipramine Facilitation of Initial Cocaine Abstinence",
                                                          Archives of General Psychiatry, 1989; 46(2): 117 - 121.'
                                                      )
                                                      
                                             ),
                                             
                                             tabPanel('Graph and Summary Output',
                                                      br(),
                                                      tags$li('2D Histogram Output'),
                                                      plotlyOutput('plotly1'),
                                                      br(),
                                                      plotlyOutput('stack1'),
                                                      br(),
                                                      verbatimTextOutput('chiSqrSummary1'))
                                 )
                                 )
                

              )
            )
    ),
    
    ############ Test Your Own Dataset ############ 
    ############ ############ ############ ############
    tabItem(tabName = 'exp2',
            sidebarLayout(
              sidebarPanel(
                tags$style(type='text/css', ".well { max-width: 20em; }"),
                
                tags$head(
                  tags$style(type="text/css", "select[multiple] { width: 100%; height:10em}"),
                  tags$style(type="text/css", "select { width: 100%}"),
                  tags$style(type="text/css", "input { width: 19em; max-width:100%}")
                ),
                
                tags$img(src = 'select1_button.gif', width = '150px', height = '80px'),
                
                selectInput("readFunction", "Function to read data:", c("read.table", "read.csv", "read.csv2", "read.delim", "read.delim2",
                                                                        "read.spss", "read.arff", "read.dbf", "read.dta", "read.epiiinfo", "read.mtp",
                                                                        "read.octave", "read.ssd", "read.systat", "read.xport", "scan", "readLines"
                )),
                
                htmlOutput("ArgSelect"),
                htmlOutput("ArgText"),
                
                fileInput("file", "Upload data-file:")
              ),
              
              mainPanel(
                verbatimTextOutput('summaryFile'),
                br(),
                dataTableOutput("table")
              )
              
            )
    ),
    
    ############ Matching Pictures ############
    ############ ############ ############ ############
    
    tabItem(tabName = 'instr2',
      fluidPage(theme = 'Muted',
                titlePanel('Instructions to What is Going on Graph?'),
                tags$ul(
                  tags$li('Click on the GO! button to start the game'),
                  tags$li('Select from the dropdown menu the most appropriate explanation of the graph present'),
                  br(),
                  div(style = "text-align: center", actionButton(inputId = "bsButton6", label = "GO!", size = "large", style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"))
                )
                )
    ),
    
    tabItem(tabName = 'cha2',
            titlePanel('What is Going on Graph?'), useShinyjs(),
            sidebarLayout(
              conditionalPanel('input.bsButton6 != 0',
                               sidebarPanel(
                                 selectInput(inputId = 'cq1', label = 'The First Graph',
                                             choices = c('',
                                                         'A. The x-axis represents different sandwich fillings',
                                                         'B. The y-axis represents different sandwich bread',
                                                         'C. The color bar represents how many sandwiches are in each Bread & Filling combination',
                                                         'D. A, B, and C'),
                                             selected = ''),
                                 br(),
                                 bsButton(inputId = 'cq1check1', label = 'Check!', style = 'black', size = 'median'),
                                 br(),
                                 br(),
                                 conditionalPanel('input.cq1 == "D. A, B, and C"',
                                                  bsButton(inputId = 'next1', label = 'Next!', style = 'primary', size = 'median'))
                               )),
              mainPanel(
                conditionalPanel('input.bsButton6 != 0',
                                 plotlyOutput('cha2plot1'),
                                 conditionalPanel('input.cq1check1 != 0',
                                                  htmlOutput('cq1ans1'),
                                                  textOutput('cq1feed1'))
                                 )
              )
            )
            ),
    
    tabItem(tabName = 'cha2_2',
            titlePanel('What is Going on Graph?'), useShinyjs(),
            sidebarLayout(
              conditionalPanel('input.cq1 == "D. A, B, and C"',
                               sidebarPanel(
                                 selectInput('cq2', label = 'The Second Graph',
                                             choices = c('',
                                                         'A. In this dataset, midsized is the most common size for 7Pass cars',
                                                         'B. In this dataset, midsized is the most common size for SUV cars',
                                                         'C. In this dataset, small is the most common size for Sporty cars',
                                                         'D. None of the above')),
                                 br(),
                                 bsButton(inputId = 'cq1check2', label = 'Check!', style = 'black', size = 'median'),
                                 br(),
                                 br(),
                                 conditionalPanel('input.cq2 == "C. In this dataset, small is the most common size for Sporty cars"',
                                                  bsButton(inputId = 'next2', label = 'Next!', style = 'primary', size = 'median')
                                                  )
                               )
                               ),
              mainPanel(
                conditionalPanel('input.cq1 == "D. A, B, and C"',
                                 plotlyOutput('cha2plot2'),
                                 conditionalPanel('input.cq1check2 != 0',
                                                  htmlOutput('cq1ans2'),
                                                  textOutput('cq1feed2')
                                                  )
                                 )
              )
            )
            ),
    
    tabItem(tabName = 'cha2_3',
            titlePanel('What is Going on Graph?'), useShinyjs(),
            sidebarLayout(
              conditionalPanel('input.cq2 == "C. In this dataset, small is the most common size for Sporty cars"',
                               sidebarPanel(
                                 selectInput('cq3', label = 'The Third Graph',
                                             choices = c('',
                                                         'A. The use of desipramine is largely associated with the relapse status',
                                                         'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo',
                                                         'C. The use of placebo is equally associated with the relapse status and non-relapse status',
                                                         'D. The use of lithium is more associated with the non-relapse status than the relapse status'),
                                             selected = ''),
                                 br(),
                                 bsButton(inputId = 'cq1check3', label = 'Check!', style = 'black', size = 'median'),
                                 br(),
                                 br(),
                                 conditionalPanel('input.cq3 == "B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo"',
                                                  bsButton(inputId = 'next3', label = 'Next!', style = 'primary', size = 'median')
                                                  )
                               )),
              
              mainPanel(
                conditionalPanel('input.cq2 == "C. In this dataset, small is the most common size for Sporty cars"',
                                 plotlyOutput('cha2plot3'),
                                 conditionalPanel('input.cq1check3 != 0',
                                                  htmlOutput('cq1ans3'),
                                                  textOutput('cq1feed3')
                                                  )
                )
              )
            )
            ),
    
    tabItem(tabName = 'cha2_4',
            titlePanel('What is Going on Graph?'), useShinyjs(),
            sidebarLayout(
              conditionalPanel('input.cq3 == "B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo"',
                               tags$strong('What is the main problem with this graph?'),
                               br(),
                               br(),
                               selectInput('cq4', label = 'The Fourth Graph',
                                           choices = c('',
                                                       'A. The axes are not labeled properly',
                                                       'B. Each colored area is disproportionate to the number of mice in each category',
                                                       'C. A and B'),
                                           selected = ''),
                               br(),
                               bsButton(inputId = 'cq1check4', label = 'Check!', style = 'black', size = 'median'),
                               br(),
                               br(),
                               conditionalPanel('input.cq4 == "C. A and B"',
                                                bsButton(inputId = 'next4', label = 'Next!', style = 'primary', size = 'median')
                                                )
                
              ),
              mainPanel(
                conditionalPanel('input.cq3 == "B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo"',
                                 plotlyOutput('cha2plot4'),
                                 conditionalPanel('input.cq1check4 != 0',
                                                  htmlOutput('cq1ans4'),
                                                  textOutput('cq1feed4')
                                                  ))
              )
            )
            ),
    
    ############ Question Bank ############ 
    ############ ############ ############ ############  
    tabItem(tabName = 'instr1',
            fluidPage(theme = 'Muted', 
                      titlePanel('Instructions to Answering the Practice Questions'),
                      tags$ul(
                        tags$li('Click on the GO! button to start the game'),
                        tags$li('Select from the dropdown menu the answer you think correct'),
                        tags$li('Click on "Submit!" to see if your answer is correct or not'),
                        br(),
                        div(style = "text-align: center", actionButton(inputId = "bsButton4", label = "GO!", size = "large", style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"))
                      ))
    ),
    
    tabItem(tabName = 'cha1',
            fluidRow(
              box(title = 'Question', width = NULL, style = 'background-color: #99CC33', htmlOutput('questionCha'))
            ),
            
            fluidRow(
              box(width = NULL, style = 'background-color: #99CC99', htmlOutput('choiceCha'))
            ),
            
            conditionalPanel('input.submitX != 0',
                             htmlOutput('challengeFeedback'),
                             htmlOutput('textFeedback')),
            br(),
            div(style = "text-align: center", actionButton(inputId = 'submitX', label = 'Submit!', size = 'median')),
            br(),
            div(style = "text-align: center", actionButton(inputId = 'nextX', label = 'Next!', style = 'color: #fff; background-color: #337ab7; border-color: #2e6da4', size = 'median'))
            ))
    

)

shinyUI(dashboardPage(skin = "black", header, sidebar, body))