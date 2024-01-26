import processing.data.*;

Table dataTable;
PImage mapImage;
// Define margins for canvas layout
float xLeftMargin;
float xRightMargin;
float yTopMargin;
float yBottomMargin;


float tempGraphTopMargin;
float tempGraphBottomMargin;
float tempGraphLeftMargin= xLeftMargin -5900;  

  // Colors for advancing divisions
color advancingDiv1Color = color(255, 0, 0); // Red for Advancing Division 1
color advancingDiv2Color = color(173, 216, 193); // Green for Advancing Division 2
color advancingDiv3Color = color(135, 206, 235); // Blue for Advancing Division 3

//Colors for retreating divisions
color retreatingDiv1Color = color(255, 255, 0); // Yellow for Retreating Division 1
color retreatingDiv2Color = color(255, 165, 0); // Orange for Retreating Division 2
color retreatingDiv3Color = color(219, 112, 147); // Purple for Retreating Division 3

 
void setup() {
  size(1800, 1000);  // Set the canvas size
  background(255);  // Set background to white
  textSize(8);  // Set the text size
  fill(0); 

    // Load the CSV data
  dataTable = loadTable("minard-data.csv", "header");
  tint(255, 127);
  mapImage = loadImage("mapsec.png");
  image(mapImage, 0, 0, width, height);
  noTint();  
  
  displayTitle();
  drawLegend();
  drawColorLegend();
 displayTemperatureTitle();
  // Find the range of LONC and LATC to scale the plot
  float minLon = 24;  // Based on data
  float maxLon = 37.6;  // Based on data
  float originalMinLat = 53.9;  
  float originalMaxLat = 55.8;

//compression adjustment
  float adjustment = 0.0000001;  
  float minLat = originalMinLat + adjustment; 
  float maxLat = originalMaxLat - adjustment;
  
  // Define margins for canvas layout
  xLeftMargin = (width * 0.10);  // 10% margin on the left
  xRightMargin = (width * 0.20);  // 20% margin on the right
  yTopMargin = height *0.02 ;  // 2% margin at the top
  yBottomMargin = height * 0.30;  // 30% margin at the bottom
  

  
   // Define margins for the temperature graph on the right
  tempGraphTopMargin = height * 0.60; // Start temperature graph 60% into the canvas
  tempGraphBottomMargin = height * 0.95; // End temperature graph 95% into the canvas
   // Define labels for the x and y axes
  String xLabel = "Dates";
  String yLabel = "Temperature in °C";
  
// Draw the paths
// First, draw Division 2 retreating line
for (int i = 1; i < dataTable.getRowCount(); i++) {
    TableRow currentRow = dataTable.getRow(i);
    TableRow previousRow = dataTable.getRow(i - 1);
    
    float x1 = map(previousRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y1 = map(previousRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);
    float x2 = map(currentRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y2 = map(currentRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);

    String prevDirection = previousRow.getString("DIR");
    int division = currentRow.getInt("DIV");

    if (prevDirection.equals("R") && division == 2) {
        stroke(retreatingDiv2Color);
        strokeWeight(map(currentRow.getInt("SURV"), 4000, 340000, 1, 100));
        line(x1, y1, x2, y2);
    }
}

// Draw the rest of the diviion lines
for (int i = 1; i < dataTable.getRowCount(); i++) {
    TableRow currentRow = dataTable.getRow(i);
    TableRow previousRow = dataTable.getRow(i - 1);
    
    float x1 = map(previousRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y1 = map(previousRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);
    float x2 = map(currentRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y2 = map(currentRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);

    String prevDirection = previousRow.getString("DIR");
    int division = currentRow.getInt("DIV");

    // Skip the Division 2 retreating lines 
    if (prevDirection.equals("R") && division == 2) {
        continue; 
    }

    if (prevDirection.equals("A") && division == 1) {
        stroke(advancingDiv1Color);
    } else if (prevDirection.equals("A") && division == 2) {
        stroke(advancingDiv2Color);
    } else if (prevDirection.equals("A") && division == 3) {
        stroke(advancingDiv3Color);
    } else if (prevDirection.equals("R") && division == 1) {
        stroke(retreatingDiv1Color);
    } else if (prevDirection.equals("R") && division == 3) {
        stroke(retreatingDiv3Color);
    }
    
    strokeWeight(map(currentRow.getInt("SURV"), 4000, 340000, 1, 100));  
    line(x1, y1, x2, y2);
}
  
  
 //   Loop to draw the text above 
for (int i = 1; i < dataTable.getRowCount(); i++) {
    TableRow currentRow = dataTable.getRow(i);
    TableRow previousRow = dataTable.getRow(i - 1);

    float x1 = map(previousRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y1 = map(previousRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);
    float x2 = map(currentRow.getFloat("LONP"), minLon, maxLon, xLeftMargin, width - xRightMargin);
    float y2 = map(currentRow.getFloat("LATP"), maxLat, minLat, yTopMargin, height - yBottomMargin);

    if (i % 2 == 0) {
       // Black color for text
      fill(0);  
      // Set text size to 12 pixels
      textSize(12);  
      
      float offset = map(currentRow.getInt("SURV"), 4000, 340000, 1, 100) + 10; // Add a base offset of 10 pixels

      text(currentRow.getInt("SURV"), (x1 + x2) / 2, (y1 + y2) / 2 - offset); 
    }
} 

  //CITY 
    for (int i = 0; i < dataTable.getRowCount(); i++) {
    float lon = dataTable.getFloat(i, "LONC");
    float lat = dataTable.getFloat(i, "LATC");
    String cityName = dataTable.getString(i, "CITY");
    
    float x = map(lon, 24, 37.6, xLeftMargin, width - xRightMargin);
    float y = map(lat, maxLat, minLat, yTopMargin, height - yBottomMargin);

    fill(0, 0, 0);  // Set the color to black
    ellipse(x, y, 10, 10);
    
    textSize(20);  // Set the font size to 20
     text(cityName, x + 10, y);  // Add city names next to the circles
   
  }

  
  
  
  
 // Set up the styling for the temperature graph
  stroke(0); // Black color for the line
  strokeWeight(1);
  fill(0); // Black color for the points

  drawTemperatureGraph();

  // Draw x and y labels
  fill(0); // Black color for labels
  textSize(14); 
  textAlign(CENTER, CENTER);

  // X-axis label
  text(xLabel, width / 2, height - 10); 
  // Y-axis label
  pushMatrix();
  translate(width - 300, height - 250);
  rotate(HALF_PI);
  //position
  text(yLabel, 0, 0); 
  popMatrix();
  
 // size of the markers note
textAlign(RIGHT, CENTER);
textSize(16);
text("*The size of the markers", width * 0.92, height - 90); 
text("denote the number of days", width * 0.935, height - 75); 
text("the army survived in certain temperatures", width * 0.99, height - 60); 

}

// Function that draws the temperature vs. date graph
void drawTemperatureGraph() {
    // Prepare the y-axis for the temperature graph
  drawTemperatureYAxis();
  
  float previousX = 0, previousY = 0;

  for (int i = 0; i < dataTable.getRowCount(); i++) {
    TableRow row = dataTable.getRow(i);

    float temperature = row.getFloat("TEMP");
    String date = row.getString("DAY") + " " + row.getString("MON");
    int daysSurvived = row.getInt("DAYS");

    // Map the temperature and date to graph's dimensions
    float mappedY = map(temperature, -30, 0, tempGraphBottomMargin, tempGraphTopMargin); //data range
    float mappedX = map(dataTable.getRowCount() - 1 - i, 0, dataTable.getRowCount() - 1, tempGraphLeftMargin, width - xRightMargin);
    // Calculate marker size based on days survived
    float markerSize = map(daysSurvived, 1, 16, 5, 50); 

    fill(0); // Black color for the date
    text(date, mappedX-19, height * 0.98); 

    // Draw the marker as an ellipse
    ellipse(mappedX, mappedY, markerSize, markerSize);
    // Display temperature
    fill(0); // Black color for the temperature text
    textSize(12);
    //Offset
    text((int)temperature, mappedX, mappedY - markerSize - 5); 
 
    if (i > 0) {
      // Draw lines connecting the data points
      line(previousX, previousY, mappedX, mappedY);
    }

    previousX = mappedX;
    previousY = mappedY;
  }
 
}

// Function draws the y-axis labels for the temperature graph
void drawTemperatureYAxis() {
  // Temperatures for y-axis ticks
  int[] ticks = {-30, -25, -20, -15, -10, -5, 0};
  
  for (int i = 0; i < ticks.length; i++) {
    float mappedY = map(ticks[i], -30, 0, tempGraphBottomMargin, tempGraphTopMargin);
    // Draw the tick
    line(width - xRightMargin +5, mappedY, width - xRightMargin + 10, mappedY);
    // Draw the label
    text(ticks[i], width - xRightMargin +15, mappedY);
  }
}

void drawLegend() {
  // Define starting position for the legend
  float legendX = width * 0.87; // 80% from the left
  float legendY = height * 0.33; // 5% from the top
  
   // Label "Size of the Army" at the top of the legend
  // Black color for the text
  fill(0); 
  textSize(18);
  text("Size of the Army", legendX, legendY - 15); // Position 15 units above the first line
  
  // Define army sizes to represent legend
  int[] armySizes = {6000, 50000, 200000, 340000};
  
  // Define offset between each line in the legend
  float yOffset = 30;
  
  for (int i = 0; i < armySizes.length; i++) {
    // Calculate stroke weight for each army size
    float lineWeight = map(armySizes[i], 4000, 340000, 1, 25);
    strokeWeight(lineWeight);
    // Black color for the line
    stroke(0); 
    
    // Draw the line
    line(legendX, legendY + (i * yOffset), legendX + 50, legendY + (i * yOffset));
    
    // Draw the label next to the line
    fill(0); 
    textSize(16);
    //Positioning
    text(armySizes[i], legendX + 65, legendY + (i * yOffset) + (lineWeight / 2)); 
  }
}

void drawColorLegend() {
  int legendX = width - 260; // Starting X position for the color legend
  int legendY = 70;          // Starting Y position for the color legend
  int boxSize = 20;          // Size of the color box
  int yOffset = 30;          // Offset between color boxes

  // Black color for the text
  fill(0); 
  textSize(18);
  text("Direction", legendX+40, legendY-20); 
  
  // Arrays for colors and their labels
  color[] colors = {advancingDiv1Color, advancingDiv2Color, advancingDiv3Color, retreatingDiv1Color, retreatingDiv2Color, retreatingDiv3Color};
  String[] labels = {"Advancing Division 1", "Advancing Division 2", "Advancing Division 3", "Retreating Division 1", "Retreating Division 2", "Retreating Division 3"};

  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    noStroke();
    rect(legendX, legendY + (i * yOffset), boxSize, boxSize); // Draw the color box

    // Label for the color box
    fill(0); 
    textSize(18);
    // 10 units space from box
    text(labels[i], legendX + boxSize + 10, legendY + (i * yOffset) + 15); 
  }
}

//function for title
void displayTitle() {
  float titleX = width * 0.35; 
  float titleY = height * 0.065; 
  // Black color for the text
  fill(0);
  // Size of the title text
  textSize(24); 
  
  text("Minard Visualization of Napoleon's Russia Campaign", titleX, titleY);
}

void displayTemperatureTitle() {
  //Positioning
  float titleX = width * 0.50;  
  float titleY = height *0.60;  
  //Black color for text
  fill(0); 
  // Size of the title text for the temperature graph
  textSize(20);
 
  text("Temperature during retreat", titleX, titleY);
  
}
