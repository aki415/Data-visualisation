Table data;

//float points
float maxPopulation = 0;
float maxGDP = 0;
float maxLifeExp =90;
float offsetX = (1600 - 1100) / 2;
float offsetY = (900 - 750) / 2;  

//set up function
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
  // Display data
  for (TableRow row : data.rows()) {
    float population = row.getFloat("pop");
    float gdp = row.getFloat("gdpPercap");
    float lifeExp = row.getFloat("lifeExp");
    
    //Size of population corresponds to size of circle
    float x = map(gdp, 0, maxGDP, 50 + offsetX, width-50- offsetX);
    float y = map(lifeExp, 20, maxLifeExp, height-50- offsetY, 50 + offsetY);
    float r = map(population, 0, maxPopulation, 5, 60);

    // Set circle outline to black and inside to white
    stroke(0); // Black outline
    fill(255); // White fill
    ellipse(x, y, r, r);
  }
  
  // Add X and Y Axis Labels and Numbers
  addAxisLabels();
 
}

void addAxisLabels() {
  // Set up title for the graph
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

//Create grid lines
void addGridLines() {
  // Light gray for grid lines
  stroke(220); 
  
  // vertical grid lines for GDP per Capita
  for (float i = 0; i <= maxGDP; i += 10000) {
    float x = map(i, 0, maxGDP, 50 + offsetX, width - 50 - offsetX);
    line(x, 50 + offsetY, x, height - 50 - offsetY); 
  }

  // horizontal grid lines for Life Expectancy
  for (int i = 20; i <= maxLifeExp; i += 10) {
    float y = map(i, 20, maxLifeExp, height - 50 - offsetY, 50 + offsetY);
    line(25 + offsetX, y, width - 50 - offsetX, y);
  }
}

//legend function
void drawLegend() {
    // Define some margins for positioning
    float marginX = width - 250;  // Position it 200 pixels from the right edge
    float centerY = (height / 2)-100;   // Center of the canvas

    // Use the specified representative population values for the legend
    float[] legendPopulations = {
        200000000,
        100000000,
        50000000,
        10000000,
        1000000
    };

    String[] legendLabels = {
        "200 million",
        "100 million",
        "50 million",
        "10 million",
        "1 million"
    };

    // Text settings
    textSize(14);
    fill(0);

    // Calculate total height of the legend
    float totalLegendHeight = 0;
    for (float population : legendPopulations) {
        float r = map(population, 0, maxPopulation, 5, 60);
        totalLegendHeight += r + 10;  // radius + some margin for each circle
    }

    // Determine starting Y position such that the legend is vertically centered
    float startingY = centerY - totalLegendHeight / 2;

    // Draw the title "Population"
    textSize(16);  // Increase the font size for the title
    text("Population", marginX, startingY - 40);  // Position the title 20 pixels above the first circle
    textSize(12);  // Reset the font size back to 12 for the rest of the legend

    // Draw each circle with its size and the corresponding population value
    for (int i = 0; i < legendPopulations.length; i++) {
        float r = map(legendPopulations[i], 0, maxPopulation, 5, 60)*2; // Calculate circle radius
        float yPosition = startingY + i * (60 + 10); // Vertical positioning

        // Circle
        stroke(0);
        fill(255);
        ellipse(marginX, yPosition, r, r);

        // Text
        fill(0); // Set text color to black
        text(legendLabels[i], marginX + r / 2 + 10, yPosition + 5); // Display the readable population value
    }
}
