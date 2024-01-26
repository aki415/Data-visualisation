Table data;
float maxPopulation = 0;
float maxGDP = 0;
float maxLifeExp = 90;
float offsetX = (1600 - 1100) / 2;
float offsetY = (900 - 750) / 2;
int currentYear = 1952;
IntList uniqueYears = new IntList();

float btnX = 100, btnY=50, btnWidth = 120, btnHeight = 40;
// Start with animation paused
boolean isAnimating = false;  
String btnLabel = "Start";

// Global map color for continents
HashMap<String, Integer> continentColors = new HashMap<>();

int findIndexOfIntList(IntList list, int value) {
  for (int i = 0; i < list.size(); i++) {
    if (list.get(i) == value) {
      return i;
    }
  }
  // return -1 if the value is not found
  return -1;  
}



void setup() {
  size(1600, 900);
  background(220);
  
  // Initialize continent color mapping
  continentColors.put("Africa", color(255, 0, 0)); // Red for Africa
  continentColors.put("Asia", color(0, 255, 0)); // Green for Asia
  continentColors.put("Europe", color(0, 0, 255)); // Blue for Europe
  continentColors.put("Americas", color(255, 255, 0)); // Yellow for Americas
  continentColors.put("Oceania", color(128, 0, 128)); // Purple for Oceania
  
  // Load the dataset
  data = loadTable("gapminder.csv", "header");
  
    // Position for the button
  btnY = height - 200;
  
 // Find the maximum population, GDP, and life expectancy for scaling
 // and populate the unique years
  for (TableRow row : data.rows()) {
    float population = row.getFloat("pop");
    float gdp = row.getFloat("gdpPercap");
    float lifeExp = row.getFloat("lifeExp");
    int year = row.getInt("year");

    if (population > maxPopulation) {
      maxPopulation = population;
    }
    if (gdp > maxGDP) {
      maxGDP = gdp;
    }
    if (lifeExp > maxLifeExp) {
      maxLifeExp = lifeExp;
    }
    if (!uniqueYears.hasValue(year)) {
        uniqueYears.append(year);
    }
  }
}


//draw function
void draw() {
  //white backround
  background(255);
  addGridLines();
  drawLegend();
  
  // Display data for the current year
  for (TableRow row : data.rows()) {
    int year = row.getInt("year");
    if (year == currentYear) {
      float population = row.getFloat("pop");
      float gdp = row.getFloat("gdpPercap");
      float lifeExp = row.getFloat("lifeExp");
      String continent = row.getString("continent");
      float x = map(gdp, 0, maxGDP, 50 + offsetX, width-50- offsetX);
      float y = map(lifeExp, 20, maxLifeExp, height-50- offsetY, 50 + offsetY);
      float r = map(population, 0, maxPopulation, 5, 60);
      
   if (continentColors.containsKey(continent)) {
    fill(continentColors.get(continent));
    } else {
    fill(color(255));
  }
      stroke(0);
      
      ellipse(x, y, r, r);
    }
  }

  // Draw Start/Stop Toggle Button
  fill(0, 200, 255);  //blue color button
  rect(btnX, btnY, btnWidth, btnHeight);
  fill(0);
  text(btnLabel, btnX + 35, btnY + 25);
  // function to add X and Y Axis Labels and Numbers
  addAxisLabels();

  // Show current year
  fill(0);
  textSize(24);
  text("Year: " + currentYear, width - 290, 200);

// Control for animation
  if (isAnimating && frameCount % 60 == 0) {
    int index = findIndexOfIntList(uniqueYears, currentYear);
     if (index < uniqueYears.size() - 1) {
      currentYear = uniqueYears.get(index + 1);
    } else {
      currentYear = uniqueYears.get(0);
      // Stop the animation
      isAnimating = false;       
      btnLabel = "Start";      
    }
  }
}
//function to press button
void mousePressed() {
  // Check if mouse is inside the Start/Stop button
  if (mouseX > btnX && mouseX < btnX + btnWidth && mouseY > btnY && mouseY < btnY + btnHeight) {
    isAnimating = !isAnimating;  // Toggle the animation status
    //update button label
    btnLabel = isAnimating ? "Stop" : "Start"; 
  }
}
 
 // function to label the x and y axis
  void addAxisLabels() {
   textSize(20);
  fill(0);
  text("Life Expectancy and GDP per Capita by Continent(1952-2007)",600,110);
  
  textSize(14);
  fill(0);
  text("GDP per Capita", width / 2, height - offsetY + 30);
  // Rotate "Life Expectancy" label by 90 degrees
  pushMatrix();
  translate(offsetX - 25, height / 2);   
  rotate(-HALF_PI);                      
  text("Life Expectancy", 0, 0);        
  popMatrix();
  
  // Numerical indicators for X-axis (GDP per Capita)
  for (float i = 0; i <= maxGDP; i += 10000) {
    float x = map(i, 0, maxGDP, 50+ offsetX, width-50- offsetX);
    text(nf(i, 0, 0), x, height - offsetY + 10);
  }

  // Numerical indicators for Y-axis (Life Expectancy)
  for (float i = 20; i <= maxLifeExp; i += 10) {
    float y = map(i,20, maxLifeExp, height-50- offsetY, 50+ offsetY);
    text(int(i), 250, y);
  }
}

void addGridLines() {
  // Light gray for grid lines
  stroke(220); 
  
  // Vertical grid lines for GDP per Capita
  for (float i = 0; i <= maxGDP; i += 10000) {
    float x = map(i, 0, maxGDP, 50 + offsetX, width - 50 - offsetX);
    line(x, 50 + offsetY, x, height - 50 - offsetY);
  }

  // Horizontal grid lines for Life Expectancy
  for (float i = 20; i <= maxLifeExp; i += 10) {
    float y = map(i, 20, maxLifeExp, height - 50 - offsetY, 50 + offsetY);
    line(25 + offsetX, y, width - 50 - offsetX, y);
 }
}


//function to create legend
void drawLegend() {
  // Define margins for positioning
  float marginX = width - 270;  // Position it 200 pixels from the right edge
  float centerY = height / 2;   // Center of the canvas
  

  // Display the legend title "Continents"
  textSize(16); 
  fill(0);
  text("Continents", marginX, centerY - 120); 
  textSize(13);
  
  int i = 0;
  for (String continent : continentColors.keySet()) {
    fill(continentColors.get(continent));
    noStroke();
    rect(marginX, centerY - 110 + i*20, 15, 15);
    fill(0); 
    text(continent, marginX + 20, centerY - 98 + i*20);
    i++;
  }

  // Population legend
  textSize(16); 
  fill(0);
  text("Population", marginX, centerY - 60 + i * 20);
  textSize(13);
  
  float[] legendPopulations = {
    200000000,
    100000000,
    50000000,
    10000000,
    1000000
  };

//text for pop legend
  String[] legendLabels = {
    "200 million",
    "100 million",
    "50 million",
    "10 million",
    "1 million"
  };

  for (int j = 0; j < legendPopulations.length; j++) {
    //adjusting circle sizes 
    float r = map(legendPopulations[j], 0, maxPopulation, 10, 60);
    float yPosition = centerY + 60 + j * 20; 

    // Circle
    stroke(0);
    fill(255);
    ellipse(marginX, yPosition, r, r);

    // Text
    fill(0); 
    text(legendLabels[j], marginX + r / 2 + 10, yPosition + 5);
  }
}
