Table gapminder;
color asiaColor = color(255, 0, 0);      // Red for Asia
color europeColor = color(0, 0, 255);    // Blue for Europe
color africaColor = color(0, 255, 0);    // Green for Africa
color americasColor = color(255, 255, 0);// Yellow for Americas
color oceaniaColor = color(0, 255, 255); // Cyan for Oceania


void setup() {
  size(1600, 900);
  background(255);
  
  //Load gapminder.csv file
 gapminder = loadTable("gapminder.csv", "header");
float offsetX = (1600 - 1100) / 2; // adjust this value
float offsetY = (900 - 750) / 2;  // adjust this valu
  
  //Set up title for the graph
  textSize(20);
  fill(0);
  text("Life Expectancy Evolution by Continent (1952-2007)",600,110);
  
  // Set up axis labels
  fill(0);
  textSize(16);
  text("Year", width/2, height - offsetY + 30); 
  pushMatrix();  
  translate(offsetX - 30, height / 2);  
  rotate(-HALF_PI);  // Rotate by 90 degrees 
  text("Life Expectancy", 0, 0);  // Draw the text
  // Restore transformation settings
  popMatrix(); 
   
// Display years on x-axis
  for (int year = 1952; year <= 2007; year+=5) {
    float x = map(year, 1952, 2007, 50 + offsetX, width - 50 - offsetX);
   
    //vertival grid lines
    stroke(220); // Light gray for grid
    line(x, 50 + offsetY, x, height - 50 - offsetY);
    text(year, x, height - offsetY ); // for years on x-axis
}
// extended x-coordinate
float extendedX = map(2010, 1952, 2007, 50 + offsetX, width - 50 - offsetX); // Mapping 2010 to get extended line

// Extended the life expectancy range grid lines to this extended x-coordinate
for (int i = 20; i <= 90; i += 10) {
    float y = map(i, 20, 90, height - 50 - offsetY, 50 + offsetY);
    stroke(220);
    //horizontal
    line(50 + offsetX, y, extendedX, y); 
    text(i, offsetX - 10, y); 
}
  

  // Loop through each row in the table
  for (TableRow row : gapminder.rows()) {
    float year = row.getFloat("year");
    float lifeExp = row.getFloat("lifeExp");
    String continent = row.getString("continent");
    
    // Determine corresponding continent for spacing
    int spacing;
    if (continent.equals("Asia")) {
      spacing = 1;
    } else if (continent.equals("Europe")) {
      spacing = 2;
    } else if (continent.equals("Africa")) {
      spacing = 3;
    } else if (continent.equals("Americas")) {
      spacing = 4;
    } else { // Assuming Oceania for others
      spacing = 5;
    }
    
    // Map year and life expectancy to canvas positions
    float x = map(year, 1952, 2007, 50 + offsetX, width - 50 - offsetX)+ 11 * spacing;
    //life expectancy range from 20-90
    float y = map(lifeExp, 20, 90, height - 50 - offsetY, 50 + offsetY);
    
    // Choose color based on continent
    switch(spacing) {
      case 1: fill(asiaColor); break;
      case 2: fill(europeColor); break;
      case 3: fill(africaColor); break;
      case 4: fill(americasColor); break;
      case 5: fill(oceaniaColor); break;
    }
    stroke(0);
    // Draw the data point as a circle
    ellipse(x, y, 5, 5);
  }
  
  // Drawing the Legend
  float legendX = 1370;
  float legendY = 400;
   // Vertical gap between entries
  float gap = 25;
  float rectWidth = 12; // width of the colored rectangle
  float rectHeight = 12; // height of the colored rectangle
  
  // text size for the legend
  textSize(14); 
  
  // Asia Legend
  fill(asiaColor); // Set the fill color to Asia's color
  noStroke(); // No border for the rectangles
  rect(legendX, legendY, rectWidth, rectHeight); // Draw a colored rectangle
  fill(0); // Black text
  text("Asia", legendX + rectWidth + 10, legendY + rectHeight); // Draw the text label
  legendY += gap; // Move the Y-coordinate for the next entry

  // Europe Legend
  fill(europeColor); // Set the fill color to Europe's color
  rect(legendX, legendY, rectWidth, rectHeight); // Draw a colored rectangle
  fill(0); // Black text
  text("Europe", legendX + rectWidth + 10, legendY + rectHeight); // Draw the text label
  legendY += gap; // Move the Y-coordinate for the next entry

  // Africa Legend
  fill(africaColor); // Set the fill color to Africa's color
  rect(legendX, legendY, rectWidth, rectHeight); // Draw a colored rectangle
  fill(0); // Black text
  text("Africa", legendX + rectWidth + 10, legendY + rectHeight); // Draw the text label
  legendY += gap; // Move the Y-coordinate for the next entry

  // Americas Legend
  fill(americasColor); // Set the fill color to America's color
  rect(legendX, legendY, rectWidth, rectHeight); // Draw a colored rectangle
  fill(0); // Black text
  text("Americas", legendX + rectWidth + 10, legendY + rectHeight); // Draw the text label
  legendY += gap; // Move the Y-coordinate for the next entry

  // Oceania Legend
  fill(oceaniaColor); // Set the fill color to Oceania's color
  rect(legendX, legendY, rectWidth, rectHeight); // Draw a colored rectangle
  fill(0); // Black text
  text("Oceania", legendX + rectWidth + 10, legendY + rectHeight); // Draw the text label

}

//static data
void draw() {
  
  noLoop();
}
