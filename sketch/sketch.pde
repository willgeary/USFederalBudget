// Will Geary (@wgeary) 2018

// Inputs
Boolean recording = true;
String discretionary_file = "../data/discretionary_outlays.csv";
String mandatory_file = "../data/mandatory_outlays.csv";
float frames_per_year = 60.0;
float totalFrames = frames_per_year * (2023-1962);
float global_time = 0;
float area_multiplier = 6.4;

/*
float min_annual_total = 190.0;
float max_annual_total = 2500.0;
float min_diameter = 180;
float max_diameter = 600;
*/

//// Global variables
ArrayList<DiscretionaryPieChart> discretionaryPieCharts = new ArrayList<DiscretionaryPieChart>();
ArrayList<MandatoryPieChart> mandatoryPieCharts = new ArrayList<MandatoryPieChart>();
int totalSeconds;
float year;
Table discretionaryTable;
Table mandatoryTable;
PFont raleway;
PFont ralewayBold;

void setup(){
 // size(1400, 1400);
  size(1300, 1000);
  smooth();
  
  // Fonts and icons
  raleway  = createFont("Raleway-Heavy", 32);
  ralewayBold  = createFont("Raleway-Bold", 28);
  
  // Load data
  loadDiscretionaryData();
  loadMandatoryData();
}

void draw() {
  
  // Black background
  fill(0);
  rect(0,0,width,height);
  
  // Draw the discretionary pie chart
  pushStyle();
  pushMatrix();
  translate(-280,height-960);
  for (int i=0; i < discretionaryPieCharts.size(); i++) {
      DiscretionaryPieChart pieChart = discretionaryPieCharts.get(i);
      pieChart.pieChartTransition();
    }
  popMatrix();
  popStyle();
  
  
  // Draw the mandatory pie chart
  pushStyle();
  pushMatrix();
  translate(320,height-960);
  for (int i=0; i < mandatoryPieCharts.size(); i++) {
      MandatoryPieChart pieChart = mandatoryPieCharts.get(i);
      pieChart.pieChartTransition();
    }
  popMatrix();
  popStyle();
  
  
  
  year = global_time / frames_per_year + 1962;
  
  pushMatrix();
  pushStyle();
    translate(0,0);
    textSize(140);
    textAlign(LEFT);
    fill(255);
    text(int(year),40, 130);
    textSize(48);
    text("U.S. Federal Government Outlays", 420, 64);
    textSize(18);
    /* Discretionary budget authority is established annually by Congress, 
    as opposed to mandatory spending that is required by laws that span multiple years, 
    such as Social Security or Medicare. */
    text("Discretionary budget authority is established annually by Congress.", 420, 90);
    text("Mandatory spending is required by laws that span multiple years.", 420, 112);
    text("Amounts in constant 2009 U.S. Dollars.", 420, 134);
    textSize(20);
    translate(-200,0);
    text("Data from the Office of Management and Budget", 250, height-45);
    text("Visualization by Will Geary (@wgeary)", 250, height-20);
    text("Area directly proportional to spending amount", width-317, height-45);
    text("Percentage labels relative to spending type", width-280, height-20);
  popStyle();
  popMatrix();
  
  pushMatrix();
  pushStyle();
  if (year >= 2018) {
    textMode(LEFT);
    textSize(24);
    fill(255,255);
    text("Congress Budget Forecasts",53,170);
  }
  popStyle();
  popMatrix();
  
  global_time += 1;
  
  if (recording == true) {
    if (global_time < 5000) {
      saveFrame("frames/p1/#####.tiff");
    }
    else {
      saveFrame("frames/p2/#####.tiff");
    }
  }
  
  if (global_time >= totalFrames) {
    global_time = totalFrames;
  } 
  
}

void loadMandatoryData() {
  
  // Load pie chart data file
  mandatoryTable = loadTable(mandatory_file, "header");
  
  // Set pie chart params
  float xPos = width/2;
  float yPos = height/2;

  // Initialize pie chart objects
  float total_start;
  float diameter_start;
  float total_end;
  float diameter_end;
  float startFrame;
  float endFrame;
  FloatList data1;
  FloatList data2;
  
  // Budget categories
  float Soc_Security_start;
  float Health_and_Medicare_start;
  float Income_Security_start;
  float Net_Interest_start;
  float Veterans_Benefits_start;
  float Other_start;
  
  float Soc_Security_end;
  float Health_and_Medicare_end;
  float Income_Security_end;
  float Net_Interest_end;
  float Veterans_Benefits_end;
  float Other_end;
  
  for (TableRow row : mandatoryTable.rows()) {
    
    data1 = new FloatList();
    data2 = new FloatList();
    
    startFrame = int(row.getFloat("start_frame"));
    endFrame = int(row.getFloat("stop_frame"));
    
    total_start = row.getFloat("Total_prev");
    if (total_start == 0) {total_start = 191.9;}
    Soc_Security_start = row.getFloat("Soc. Security_prev");
    Health_and_Medicare_start = row.getFloat("Health and Medicare_prev");
    Income_Security_start = row.getFloat("Income Security_prev");
    Net_Interest_start = row.getFloat("Net Interest_prev");
    Veterans_Benefits_start = row.getFloat("Veterans Benefits_prev");
    Other_start = row.getFloat("Other_prev");
    
    total_end = row.getFloat("Total");
    Soc_Security_end = row.getFloat("Soc. Security");
    Health_and_Medicare_end = row.getFloat("Health and Medicare");
    Income_Security_end = row.getFloat("Income Security");
    Net_Interest_end = row.getFloat("Net Interest");
    Veterans_Benefits_end = row.getFloat("Veterans Benefits");
    Other_end = row.getFloat("Other");
    
    data1.append(Soc_Security_start);
    data1.append(Health_and_Medicare_start);
    data1.append(Income_Security_start);
    data1.append(Net_Interest_start);
    data1.append(Veterans_Benefits_start);
    data1.append(Other_start);
    
    data2.append(Soc_Security_end);
    data2.append(Health_and_Medicare_end);
    data2.append(Income_Security_end);
    data2.append(Net_Interest_end);
    data2.append(Veterans_Benefits_end);
    data2.append(Other_end);
    
    /*
    diameter_start = map(total_start, min_annual_total, max_annual_total,
                                      min_diameter, max_diameter);
    diameter_end = map(total_end, min_annual_total, max_annual_total,
                                  min_diameter, max_diameter);
    */
    
    diameter_start = 2 * sqrt(total_start / PI) * area_multiplier;
    diameter_end = 2 * sqrt(total_end / PI) * area_multiplier;
                                  

    mandatoryPieCharts.add(new MandatoryPieChart(xPos, yPos, 
                               total_start, total_end,
                               diameter_start, diameter_end,
                               startFrame, endFrame, data1, data2));
  }
}

void loadDiscretionaryData() {
  
  // Load pie chart data file
  discretionaryTable = loadTable(discretionary_file, "header");
  
  // Set pie chart params
  float xPos = width/2;
  float yPos = height/2;

  // Initialize pie chart objects
  float total_start;
  float diameter_start;
  float total_end;
  float diameter_end;
  float startFrame;
  float endFrame;
  FloatList data1;
  FloatList data2;
  
  // Budget categories
  float Military_start;
  float Housing_and_Community_start;
  float Transportation_start;
  float Education_start;
  float Energy_and_Environment_start;
  float Government_start;
  float Health_and_Medicare_start;
  float International_Affairs_start;
  float Soc_Security_Unemployment_Labor_start;
  float Veterans_Benefits_start;
  float Science_start;
  float Agriculture_start;
  
  float Military_end;
  float Housing_and_Community_end;
  float Transportation_end;
  float Education_end;
  float Energy_and_Environment_end;
  float Government_end;
  float Health_and_Medicare_end;
  float International_Affairs_end;
  float Soc_Security_Unemployment_Labor_end;
  float Veterans_Benefits_end;
  float Science_end;
  float Agriculture_end;
  
  for (TableRow row : discretionaryTable.rows()) {
    
    data1 = new FloatList();
    data2 = new FloatList();
    
    startFrame = int(row.getFloat("start_frame"));
    endFrame = int(row.getFloat("stop_frame"));
    
    total_start = row.getFloat("Total_prev");
    if (total_start == 0) {total_start = 546.9;}
    Military_start = row.getFloat("Military_prev");
    Housing_and_Community_start = row.getFloat("Housing and Community_prev");
    Transportation_start = row.getFloat("Transportation_prev");
    Education_start = row.getFloat("Education_prev");
    Energy_and_Environment_start = row.getFloat("Energy and Environment_prev");
    Government_start = row.getFloat("Government_prev");
    Health_and_Medicare_start = row.getFloat("Health and Medicare_prev");
    International_Affairs_start = row.getFloat("International Affairs_prev");
    Soc_Security_Unemployment_Labor_start = row.getFloat("Soc. Security, Unemployment & Labor_prev");
    Veterans_Benefits_start = row.getFloat("Veterans Benefits_prev");
    Science_start = row.getFloat("Science_prev");
    Agriculture_start = row.getFloat("Agriculture_prev");
  
    total_end = row.getFloat("Total");
    Military_end = row.getFloat("Military");
    Housing_and_Community_end = row.getFloat("Housing and Community");
    Transportation_end = row.getFloat("Transportation");
    Education_end = row.getFloat("Education");
    Energy_and_Environment_end = row.getFloat("Energy and Environment");
    Government_end = row.getFloat("Government");
    Health_and_Medicare_end = row.getFloat("Health and Medicare");
    International_Affairs_end = row.getFloat("International Affairs");
    Soc_Security_Unemployment_Labor_end = row.getFloat("Soc. Security, Unemployment & Labor");
    Veterans_Benefits_end = row.getFloat("Veterans Benefits");
    Science_end = row.getFloat("Science");
    Agriculture_end = row.getFloat("Agriculture");
    
    data1.append(Military_start);
    data1.append(Housing_and_Community_start);
    data1.append(Transportation_start);
    data1.append(Education_start);
    data1.append(Energy_and_Environment_start);
    data1.append(Government_start);
    data1.append(Health_and_Medicare_start);
    data1.append(International_Affairs_start);
    data1.append(Soc_Security_Unemployment_Labor_start);
    data1.append(Veterans_Benefits_start);
    data1.append(Science_start);
    data1.append(Agriculture_start);
    
    data2.append(Military_end);
    data2.append(Housing_and_Community_end);
    data2.append(Transportation_end);
    data2.append(Education_end);
    data2.append(Energy_and_Environment_end);
    data2.append(Government_end);
    data2.append(Health_and_Medicare_end);
    data2.append(International_Affairs_end);
    data2.append(Soc_Security_Unemployment_Labor_end);
    data2.append(Veterans_Benefits_end);
    data2.append(Science_end);
    data2.append(Agriculture_end);
    
    /*
    diameter_start = map(total_start, min_annual_total, max_annual_total,
                                      min_diameter, max_diameter);
    diameter_end = map(total_end, min_annual_total, max_annual_total,
                                      min_diameter, max_diameter);
    */
    diameter_start = 2 * sqrt(total_start / PI) * area_multiplier;
    diameter_end = 2 * sqrt(total_end / PI) * area_multiplier;

    discretionaryPieCharts.add(new DiscretionaryPieChart(xPos, yPos, 
                               total_start, total_end,
                               diameter_start, diameter_end,
                               startFrame, endFrame, data1, data2));
                               
  }
}