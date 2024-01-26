Table data;
float maxPopulation = 0;
float maxGDP = 0;
float maxLifeExp = 90;
float offsetX = (1600 - 1100) / 2;
float offsetY = (900 - 750) / 2;  


void setup() {
  size(1600, 900);
  background(220);
  
  // load the dataset
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
  // Display data
  for (TableRow row : data.rows()) {
    float population = row.getFloat("pop");
    float gdp = row.getFloat("gdpPercap");
    float lifeExp = row.getFloat("lifeExp");
    
    float x = map(gdp, 0, maxGDP, 50 + offsetX, width-50- offsetX);
    float y = map(lifeExp, 20, maxLifeExp, height-50- offsetY, 50 + offsetY);
 
   // Set color based on population range
    if (population >= 500000000) {
      fill(0, 0, 255);  // Blue for 500 million+
    } else if (population >= 200000000) {
      fill(255, 0, 0);  // Red for 200 million - 500 million
    } else if (population >= 100000000) {
      fill(0, 255, 0);  // Green for 100 million - 200 million
    } else if (population >= 50000000) {
      fill(255, 0, 255);  // Magenta for 50 million - 100 million
    } else if (population >= 10000000) {
      fill(0, 255, 255);  // Cyan for 10 million - 50 million
    } else if (population >= 1000000) {
      fill(128, 0, 128);  // Purple for 1 million - 10 million
    } else {
      fill(255, 165, 0);  // Orange for less than 1 million
    }
    // Set circle outline to black 
    stroke(0); 
    
    ellipse(x, y, 8, 8);
  }
  
  // Function to add x and y axis  labels and numbers 
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
  // Define margins for positioning
  // Position it 250 pixels from the right edge
  float marginX = width - 250;  
  float centerY = (height / 2)-75;  

//Colors for legend
  color[] legendColors = {
    color(0, 0, 255),
    color(255, 0, 0),
    color(0, 255, 0),
    color(255, 0, 255),
    color(0, 255, 255),
    color(128, 0, 128),
    color(255, 165, 0)
  };
//Text that will be visible in legend
  String[] legendLabels = {
    "500 million+",
    "200 million+",
    "100 million+",
    "50 million+",
    "10 million+",
    "1 million+",
    "< 1 million"
  };

  // Text settings
  textSize(12);
  fill(0);

  // Calculate total height of the legend
  float totalLegendHeight = legendLabels.length * (30 + 10); 

  // Starting Y position legend is vertically centered
  float startingY = centerY - totalLegendHeight / 2;

  // Draw title "Population"
  textSize(16);  // Increase the font size for the title
  text("Population", marginX, startingY - 40);  // Position the title 20 pixels above the first circle
  textSize(12);  // Reset the font size back to 12 for the rest of the legend

  // draw each rectangle with color and the corresponding population range
  for (int i = 0; i < legendLabels.length; i++) {
    float yPosition = startingY + i * (30 + 10); // vertical positioning

    // rectangle with color
    fill(legendColors[i]);
    rect(marginX, yPosition, 30, 30);

    // Text
    fill(0); // Set text color to black
    text(legendLabels[i], marginX + 30 + 10, yPosition + 20); // Display readable population range
  }
}
