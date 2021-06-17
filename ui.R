library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyjs)
library(shinyDND)
library(plotly)

#Header setting
ui <- list(
  dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Chi-Square Test of Independence",
                  titleWidth = 250,
                  tags$li(class="dropdown",
                          actionLink("info", icon("info"), class="myClass")),
                  tags$li(class = "dropdown",
                          boastUtils::surveyLink(name = "App_Template")),
                  tags$li(class="dropdown",
                          tags$a(href="https://shinyapps.science.psu.edu/",
                                 icon("home", lib="font-awesome")))
                  ),

#Sidebar menu
  dashboardSidebar(
    width = 250,
  sidebarMenu(id = 'pages', #use pages to name the menu
              menuItem(text = "Overview", 
                       tabName = "overview", 
                       icon = icon("dashboard")),
              menuItem(text = 'Prerequisites', 
                       tabName = 'prerequisite', 
                       icon = icon('book')),
              menuItem(text = 'Explore', 
                       tabName = "exp1", 
                       icon = icon('wpexplorer')),
              #menuItem(text = 'Test Your Own Dataset', tabName = 'exp2', icon = icon('wpexplorer')),
              menuItem(text = 'Game', 
                       tabName = "exp3", 
                       icon = icon('gamepad'),
                       menuSubItem(text = 'Interpreting the Graph', 
                                   tabName = 'instr2', 
                                   icon = icon('gamepad')),
                       #menuSubItem('What is Going on Graph?', tabName = 'cha2'),
                       menuSubItem(text = 'Fill in the Blank', 
                                   tabName = 'instr1', 
                                   icon = icon('gamepad'))
                       #menuSubItem('Fill in the Blank', tabName = 'cha1')
              ),
              menuItem(text = "References", 
                       tabName = "references", 
                       icon = icon("leanpub"))
  ),
  #Add psu logo
  tags$div(
    style = "position: absolute; bottom: 0;",
    class = "sidebar-logo",
    boastUtils::sidebarFooter()
  )
),

#Set button color
  dashboardBody(
    tags$head(
      tags$style(HTML(".skin-yellow .main-sidebar {background-color:  #ffa500;
                      }
                      .skin-yellow .sidebar-menu>li.active>a, .skin-yellow .sidebar-menu>li:hover>a {
        background-color: #FFD700;")),
      tags$style(HTML('#goover{background-color: #ffa500')),
      tags$style(HTML('#goover{border-color:#ffa500')),
      tags$style(HTML('#bsButton2{background-color: #ffa500')),
      tags$style(HTML('#bsButton2{border-color: #ffa500')),
      tags$style(HTML('#bsButton1{background-color: #ffa500')),
      tags$style(HTML('#bsButton1{border-color: #ffa500')),
      tags$style(HTML('#bsButton7{background-color: #ffa500')),
      tags$style(HTML('#bsButton7{border-color: #ffa500')),
      tags$style(HTML('#bsButton4{background-color: #ffa500')),
      tags$style(HTML('#bsButton4{border-color: #ffa500')),
      tags$style(HTML('#bsButton6{background-color: #ffa500')),
      tags$style(HTML('#bsButton6{border-color: #ffa500')),
      tags$style(HTML('#next1{background-color: #ffa500')),
      tags$style(HTML('#next1{border-color: #ffa500')),
      tags$style(HTML('#next2{background-color: #ffa500')),
      tags$style(HTML('#next2{border-color: #ffa500')),
      tags$style(HTML('#next3{background-color: #ffa500')),
      tags$style(HTML('#next3{border-color: #ffa500')),
      tags$style(HTML('#next4{background-color: #ffa500')),
      tags$style(HTML('#next4{border-color: #ffa500')),
      tags$style(HTML('#submitX{background-color: #ffa500')),
      tags$style(HTML('#submitX{border-color: #ffa500')),
      tags$style(HTML('#nextX{background-color: #ffa500')),
      tags$style(HTML('#nextX{border-color: #ffa500')),
      tags$style(HTML('#cq1check1{background-color: #ffa500')),
      tags$style(HTML('#cq1check1{border-color: #ffa500')),
      tags$style(HTML('#cq1check2{background-color: #ffa500')),
      tags$style(HTML('#cq1check2{border-color: #ffa500')),
      tags$style(HTML('#cq1check3{background-color: #ffa500')),
      tags$style(HTML('#cq1check3{border-color: #ffa500')),
      tags$style(HTML('#cq1check4{background-color: #ffa500')),
      tags$style(HTML('#cq1check4{border-color: #ffa500')),
    ),


  
  useShinyjs(),
  
  #Overview page
  tabItems(
  tabItem(tabName = "overview",
          tags$a(href='http://stat.psu.edu/',tags$img(src='psu_icon.jpg', align = "left", width = 180)),
          br(),br(),br(),
          h3(tags$b("About:")),
          
          withMathJax(),
          h4(p('In this app you will explore examples of', HTML('x<sup>2</sup>') , 'Test of Independence;
                   you will also be able to test your own dataset.
                   The Fill in the Blanks exercise would serve to test your understandings about this topic.')),
          br(),
          h3(tags$b("Instructions:")),
          h4(
            tags$li('In this application, you will first explore a variety of real life examples using both graphical displays and the', HTML('x<sup>2</sup>'), 'test for independence.'),
            tags$li('By uploading your own datafile, you would be given back a', HTML('x<sup>2</sup>'), 'test for independence result of the variables selected.'),
            tags$li('Read the instructions for Fill in the Blanks first and then click on Go button to get started!')
          ),
          div(style = "text-align: center",
              bsButton(inputId = "bsButton1", 
                       label = "GO !",
                       icon = icon('bolt'),
                       style = "color: #ffa500;",
                       size = 'large')),
          br(),
          h3(tags$b("Acknowledgements:")),
          h4('This application was coded and developed by Anna (Yinqi) Zhang.'),
          h4('Special Thanks to Dr. Pearl, Alex Chen, James M. Kopf, Angela Ting, Yingjie (Chealsea) Wang, and Yubaihe Zhou for being really supportive throughout the program.')
  ),
  
  #Prerequisite page
    tabItem(
      tabName = 'prerequisite', withMathJax(),
      h3(strong('Background: Chi-Square Test of Independence')),br(),
      h4('To test for an association between two categorical variables, based on a two-way table 
                that has r rows as categories for variable A and c columns as categories for variable B:'),
        br(),
        
      h4(tags$li('Set up hypotheses:')),
      h4('\\(H_{0}\\):  Variable A is not associated with variable B.'),
      h4('\\(H_{a}\\):  Variable A is associated with variable B.'),
        
      h4(tags$li('Compute the expected count under the null for each cell in the table using:')),
      div(style = "font-size: 1.6em", helpText('$${Expected \\ Cell \\ Count} = {Row\\ Total * Column\\ Total\\over Table\\ Total}$$')),
        
      h4(tags$li('Compute the value for the chi-square statistic using:')),
      div(style = "font-size: 1.6em", helpText('$${X^2} = {\\sum{{(Observed - Expected)^2}\\over {Expected}}}$$')),
        #tags$img(src = 'chi_sqr_stats_2.jpg', width = "384px", height = "100px", style = "text-align: center"),
        
      h4('Find a p-value using the upper tail of a chi-square distribution with (r-1)(c-1) degrees of freedom or use simulation under the null.'),
        
      h4('The chi-square distribution is appropriate if the expected count is at least five in each cell.'),
        br(),
        div(style = "text-align: center",
            bsButton(inputId = "goover", 
                     label = "Explore !", 
                     icon = icon("bolt"), 
                     style = "color: #ffffff;",
                     size = "large"))
        
    ),
    
    ############ Explore Activity No.1 with Different Datasets ############
    ############ ############ ############ ############
    #Explore page
    tabItem(tabName = 'exp1', 
            div(style="display: inline-block;vertical-align:top;",
                tags$a(href='https://shinyapps.science.psu.edu/',tags$img(src='homebut.PNG', width = 15))
            ),
            tags$h3('Chi-Square Test for Association Explore Activity'),
            sidebarLayout(
              sidebarPanel(
                selectInput(inputId = 'inputs', 
                            label = 'Select A Dataset to Explore', 
                            selected = 'None',
                            choices = c('None', 'Cars2015', 'HeroesInformation', 
                                        'CompassionateRats', 'SandwichAnts', 'CocaineTreatment', 
                                        'Test Your Own Dataset')),
                br(),
                
                #test your own dataset
                conditionalPanel('input.inputs == "Test Your Own Dataset"',
                                 fileInput(inputId = 'file', 
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
                                 bsPopover("file", 
                                           "File Upload", 
                                           "If you have your own dataset you would like to enter, upload it through this"),
                                 checkboxInput(inputId = 'header', 
                                               'Header', 
                                               TRUE),
                                 bsPopover("header", 
                                           "Header", 
                                           "Please check whether there is a header for your data or not"),
                                 radioButtons(inputId = 'sep', 'Separator',
                                              c(Comma = ',',
                                                Semicolon = ';',
                                                tab = '\t'),
                                              ','),
                                 bsPopover("sep", 
                                           "Separator", 
                                           "Choose which separation your file is using(If you do not know, 
                                           it is most likely separating with commas"),
                                 radioButtons(inputId = 'quote', 'Quote',
                                              c(None = '',
                                                'Double Quote' = '"',
                                                'Single Quote' = "'"),
                                              '"'),
                                 bsPopover("quote", 
                                           "Quotes", 
                                           "Check what kind of data you have and whether you need to use quotes or not"),
                                 selectInput(inputId = "columns", 
                                             "Select Your X-Axis", 
                                             choices = NULL),
                                 selectInput(inputId = "columns2", 
                                             "Select Your Y-Axis", 
                                             choices = NULL)
                                 ),
                
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
  
  #
    tabItem(tabName = "instr2",
            div(style="display: inline-block;vertical-align:top;",
                tags$a(href='https://shinyapps.science.psu.edu/',tags$img(src='homebut.PNG', width = 15))
            ),
            tabsetPanel(id = "games1",
              tabPanel(title = h4("Instructions"), value = "instruct1",
                       fluidPage(theme = 'Muted',
                                 titlePanel('Instructions to Interpreting the Graph'),
                                 
                                   h4(tags$li('Click on the GO! button to start the game.')),
                                   h4(tags$li('Select from the dropdown menu the most appropriate explanation of the graph present.')),
                                   br(),
                                   div(style = "text-align: center", bsButton(inputId = "bsButton6", label = "GO!", icon = icon('bolt'), size = "large"))
                                 
                       )
              ),
              tabPanel(title = h4("Interpreting the Graph"), value = "cha2",
                       sidebarLayout(
                                          sidebarPanel(
                                            tags$code("Interpreting the Graph"),
                                            
                                            selectInput(inputId = 'graphId', label = 'Select Your Graph',
                                                        choices = c('The First Graph', 'The Second Graph', 'The Third Graph', 'The Fourth Graph'),
                                                        selected = 'The First Graph'),
                                            
                                            conditionalPanel('input.graphId == "The First Graph"',
                                                             selectInput(inputId = 'cq1', label = 'Your Interpretation',
                                                                         choices = c('',
                                                                                     'A. The x-axis represents different sandwich fillings',
                                                                                     'B. The y-axis represents different sandwich bread',
                                                                                     'C. The color bar represents how many sandwiches are in each Bread & Filling combination',
                                                                                     'D. A, B, and C'),
                                                                         selected = ''),
                                                             br(),
                                                             div(style = 'text-align: left', bsButton(inputId = 'cq1check1', label = 'Check Answer',  size = "large"), bsButton(inputId = 'next1', label = 'Next', size = "large"))
                                            ),
                                            
                                            conditionalPanel('input.graphId == "The Second Graph"',
                                                             selectInput('cq2', label = 'Your Interpretation',
                                                                         choices = c('',
                                                                                     'A. In this dataset, midsized is the most common size for 7Pass cars',
                                                                                     'B. In this dataset, midsized is the most common size for SUV cars',
                                                                                     'C. In this dataset, small is the most common size for Sporty cars',
                                                                                     'D. None of the above'),
                                                                         selected = ''
                                                             ),
                                                             br(),
                                                             div(style = 'text-align: left', bsButton(inputId = 'cq1check2', label = 'Check', size = "large"), bsButton(inputId = 'next2', label = 'Next', size = "large"))
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
                                                             div(style = 'text-align: left', bsButton(inputId = 'cq1check3', label = 'Check', size = "large"), bsButton(inputId = 'next3', label = 'Next',size = "large"))
                                            ),
                                            
                                            conditionalPanel('input.graphId == "The Fourth Graph"',
                                                             selectInput('cq4', label = 'Your Interpretation',
                                                                         choices = c('',
                                                                                     'A. All of the female rates showed empathy',
                                                                                     'B. The color hows the number of rats in each category',
                                                                                     'C. Both A and B'),
                                                                         selected = ''),
                                                             br(),
                                                             div(style = 'text-align: left', bsButton(inputId = 'cq1check4', label = 'Check', size = "large"), bsButton(inputId = 'next4', label = 'Next', size = "large"))
                                            )
                                          ),
                         
                         mainPanel(
                           conditionalPanel('input.bsButton6 != 0',
                                            conditionalPanel('input.graphId == "The First Graph"',
                                                             br(),
                                                             br(),
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
                         )
                       )
              )
            )),
    tabItem(tabName = "instr1",
            div(style="display: inline-block;vertical-align:top;",
                tags$a(href='https://shinyapps.science.psu.edu/',tags$img(src='homebut.PNG', width = 15))
            ),
            tabsetPanel(id = "games2",
                        tabPanel(title = h4("Instructions"), value = "instruct2",
                                 fluidPage(theme = 'Muted', 
                                           titlePanel('Instructions to Answering the Practice Questions'),
                                       
                                             h4(tags$li('Click on the GO! button to start the game.')),
                                             h4(tags$li('Select from the dropdown menu the answer you think correct.')),
                                             h4(tags$li('Click on "Submit!" to see if your answer is correct or not.')),
                                             br(),
                                             div(style = "text-align: center", bsButton(inputId = "bsButton4", label = "GO!", icon = icon('bolt'), size = "large"))
                                           ) 
                        ),
                        tabPanel(title = h4("Multiple Choice"), value = "cha1",
                                 fluidRow(
                                   box(width = 12, style = 'color: #FFFFFF; background-color: #ffa500',htmlOutput('questionCha'))
                                 ),
                                 
                                 fluidRow(
                                   box(width = 12, style = 'color: #000000; background-color: #ffa500',htmlOutput('choiceCha'))
                                 ),
                                 
                                 conditionalPanel('input.submitX != 0',
                                                  htmlOutput('challengeFeedback'),
                                                  htmlOutput('textFeedback')),
                                 br(),
                                 div(style = "text-align: left", actionButton(inputId = 'submitX', label = 'Check Answer',size = "small"),
                                     actionButton(inputId = 'nextX', label = 'Next', size = "small")),
                                 div(style = "text-align: center", bsButton(inputId = "bsButton7", label = "Continue!", icon = icon('bolt'), size = "large"))
                   )
              
            )
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
        "https://www.superherodb.com/"
      ),
      
      p(
        class = "hangingindent",
        "https://www7.securybrowseapp.com/view/item_42854.html"
      ),
      
      p(
        class = "hangingindent",
        "https://www.superherodb.com/"
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
      )
      
    ) #end of tabItem
    
    )
    

)
)
)
#shinyUI(dashboardPage( header, sidebar, body))