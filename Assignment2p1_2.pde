Table gapminder;
// Gray for all data points
color dataColor = color(100,100,100); 


void setup() {
  size(1600, 900);
  background(255);
  
//Load the gapminder.csv file
 gapminder = loadTable("gapminder.csv", "header");
//adjusted canvas values
float offsetX = (1600 - 1100) / 2; 
float offsetY = (900 - 750) / 2;  
  
  // Set up title for the graph
  textSize(20);
  fill(0);
  text("Life Expectancy Evolution by Continent (1952-2007)",600,110);
  
  // Set up axis labels
  fill(0);
  textSize(14);
  text("Year", width/2, height - offsetY + 30); 
  pushMatrix();  
  translate(offsetX - 30, height / 2);  
  rotate(-HALF_PI); 
  text("Life Expectancy", 0, 0);  
  popMatrix();  
   
// Display years on x-axis
  for (int year = 1952; year <= 2007; year+=5) {
    float x = map(year, 1952, 2007, 50 + offsetX, width - 50 - offsetX);
  // Vertical grid lines for years
  // Light gray for grid
    stroke(220); 
    line(x, 50 + offsetY, x, height - 50 - offsetY);
    text(year, x, height - offsetY ); 
}

//extended x-coordinate
float extendedX = map(2010, 1952, 2007, 50 + offsetX, width - 50 - offsetX); 

// Extend the life expectancy range grid lines to this extended x-coordinate
for (int i = 20; i <= 90; i += 10) {
    float y = map(i, 20, 90, height - 50 - offsetY, 50 + offsetY);
    // Light gray for grid
    stroke(220); 
    // for life expectancy range on y-axis
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
    float y = map(lifeExp, 20, 90, height - 50 - offsetY, 50 + offsetY); 
  fill(dataColor);
    stroke(dataColor);
    // Choose shape based on continent
    if (continent.equals("Asia")) {
      rect(x-3, y-3, 6, 6);
    } else if (continent.equals("Europe")) {
      ellipse(x, y, 6, 6);
    } else if (continent.equals("Africa")) {
      triangle(x, y-3, x-3, y+3, x+3, y+3);
    } else if (continent.equals("Americas")) {
      line(x-3, y-3, x+3, y+3);
      line(x+3, y-3, x-3, y+3);
    } else { // Assume Oceania for others
      ellipse(x, y, 8, 4);
    }
  }
    // Drawing the Legend
  float legendX = 1385;
  float legendY = 400;
  float gap = 25;
  fill(dataColor);
  stroke(dataColor);
  textSize(14);
  
  rect(legendX-6, legendY-6, 12, 12); // Asia
  text("Asia", legendX + 20, legendY + 4);
  legendY += gap;

  ellipse(legendX, legendY, 12, 12); // Europe
  text("Europe", legendX + 20, legendY + 4);
  legendY += gap;

  triangle(legendX, legendY-6, legendX-6, legendY+6, legendX+6, legendY+6); // Africa
  text("Africa", legendX + 20, legendY + 4);
  legendY += gap;
  
  line(legendX-6, legendY-6, legendX+6, legendY+6); // Americas
  line(legendX+6, legendY-6, legendX-6, legendY+6);
  text("Americas", legendX + 20, legendY + 4);
  legendY += gap;

  ellipse(legendX, legendY, 16, 8); // Oceania
  text("Oceania", legendX + 20, legendY + 4);

}
 
void draw() {
  
  noLoop();
}
