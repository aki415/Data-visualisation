Table data;
float maxPopulation = 0;
float maxGDP = 0;
float maxLifeExp = 90;
float offsetX = (1600 - 1100) / 2;
float offsetY = (900 - 750) / 2;  
void setup() {
  size(1600, 900);
  background(220);
  
  // Load the dataset
  data = loadTable("gapminder.csv", "header");
  
  // Find the maximum population, GDP, and life expectancy for scaling
  for (TableRow row : data.rows()) {
    float population = row.getFloat("pop");
    float gdp = row.getFloat("gdpPercap");
    float lifeExp = row.getFloat("lifeExp");
    if (population > maxPopulation) {
      maxPopulation = population;
    }
    if (gdp > maxGDP) {
      maxGDP = gdp;
    }
    if (lifeExp > maxLifeExp) {
      maxLifeExp = lifeExp;
    }
  }
}

void draw() {
  background(255);
   addGridLines();
   drawLegend();
  
  // display data
  for (TableRow row : data.rows()) {
    float population = row.getFloat("pop");
    float gdp = row.getFloat("gdpPercap");
    float lifeExp = row.getFloat("lifeExp");
    
    float x = map(gdp, 0, maxGDP, 50 + offsetX, width-50- offsetX);
    float y = map(lifeExp, 20, maxLifeExp, height-50- offsetY, 50 + offsetY);
 
   // Set color based on population range
    if (population >= 500000000) {
      fill(#000000);  
    } else if (population >= 200000000) {
      fill(#2c2d2d);
    } else if (population >= 100000000) {
      fill(#585a5a);  
    } else if (population >= 50000000) {
      fill(#6f7171);  
    } else if (population >= 10000000) {
      fill(#9b9e9e);  
    } else if (population >= 1000000) {
      fill(#c7cbcb);  
    } else {
      fill(#e4e8e8); 
    }
    // Set circle outline to  be black 
    stroke(0); 
    
    ellipse(x, y, 8, 8);
  }
  
  // function
  addAxisLabels();
 
}

void addAxisLabels() {
  
  //title
  textSize(20);
  fill(0);
  text("Life Expectancy vs. GDP by Country(1952-2007)",600,110);
  
  textSize(16);
  fill(0);
  text("GDP per Capita", width / 2, height - offsetY + 30);
  pushMatrix(); 
  translate(offsetX - 20, height / 2);  
  rotate(-HALF_PI); 
  text("Life Expectancy", 0, 0);  
  popMatrix();  
  
  
  // Numerical indicators for X-axis (GDP per Capita)
  for (float i = 0; i <= maxGDP; i += 10000) {
    float x = map(i, 0, maxGDP, 43+ offsetX, width-50- offsetX);
    text(nf(i, 0, 0), x, height - offsetY-15 );
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

void drawLegend() {
  // margins for positioning
  // Position it 255 pixels from the right edge
  float marginX = width - 255;  
   // Center of the canvas
  float centerY = height / 2;  
  
  String[] samplePopulations = {
    "500 million+",
    "200 million+",
    "100 million+",
    "50 million+",
    "10 million+",
    "1 million+",
    "< 1 million"
  };

  float[] samplePositions = {
    0.06,     // Top for "500 million+"
    0.18, 
    0.3,
    0.45,
    0.6,
    0.75,
    0.9      // Bottom for "< 1 million"
  };

  // text settings
  textSize(12);
  fill(0);
  
  // Defining the gradient's properties
  float gradientHeight = 210; 
  float gradientTop = centerY - gradientHeight/2;

  // Draw the title "Population"
  textSize(16);
  // Position the title 20 pixels above the gradient
  text("Population", marginX, gradientTop - 20); 
  textSize(12);

  // Draw gradient rectangle
  for (int y = 0; y < gradientHeight; y++) {
    float lerpVal = map(y, 0, gradientHeight, 0, 1);
    color gradientColor = lerpColor(color(0, 0, 0), color(255, 255, 255), lerpVal);
    stroke(gradientColor);
    line(marginX, gradientTop + y, marginX + 30, gradientTop + y);
  }

  // population numbers beside the gradient
  noStroke();
  for (int i = 0; i < samplePopulations.length; i++) {
    float yPos = gradientTop + samplePositions[i] * gradientHeight;
    fill(0); 
    text(samplePopulations[i], marginX + 30 + 10, yPos); 
  }
}
