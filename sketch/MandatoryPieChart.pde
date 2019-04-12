class MandatoryPieChart {
  
  float x;
  float y;
  float total_start;
  float total_end;
  float diameter_start;
  float diameter_end;
  float startFrame;
  float endFrame;
  float frames;
  FloatList data1;
  FloatList data2;
  color c;
  String labelString;
  
  MandatoryPieChart (float _x, float _y, float _total_start, float _total_end, 
            float _diameter_start, float _diameter_end,
            float _startFrame, float _endFrame, 
            FloatList _data1, FloatList _data2) {
              
    x = _x;
    y = _y;
    total_start = _total_start;
    total_end = _total_end;
    diameter_start = _diameter_start;
    diameter_end = _diameter_end;
    startFrame = _startFrame;
    endFrame = _endFrame;
    frames = endFrame - startFrame;
    data1 = _data1;
    data2 = _data2;
    
  }
  
  void pieChartTransition() {
    if (global_time >= startFrame && global_time < endFrame){
      
      float lastAngle = -90;
      ArrayList<Float> angles = new ArrayList<Float>();
      ArrayList<Float> pcts = new ArrayList<Float>();
      float total1 = 0;
      float total2 = 0;
      
      // Calc totals
      for (int i = 0; i < data1.size(); i++) {
        float _data = data1.get(i);
        total1 += _data;
      }
      
      for (int i = 0; i < data2.size(); i++) {
        float _data = data2.get(i);
        total2 += _data;
      }
      
      // Keep track of time passing
      float pctComplete = (global_time - startFrame) / frames;
      
      // Initialize some lists to store interpolated data
      ArrayList<Float> lerp_data = new ArrayList<Float>();
      ArrayList<Float> lerp_totals = new ArrayList<Float>();
      ArrayList<Float> lerp_diameters = new ArrayList<Float>();
      
      // Create the interpolated data
      for (int i = 0; i < data1.size(); i++) {
        
        // Add interpolated values
        float lerped = lerp(data1.get(i), data2.get(i), pctComplete);
        lerp_data.add(lerped);
       
        // Add interpolated totals (to calc percentages)
        float lerped_total = lerp(total1, total2, pctComplete);
        lerp_totals.add(lerped_total);
        
        float lerped_diameter = lerp(diameter_start, diameter_end, pctComplete);
        lerp_diameters.add(lerped_diameter);
      }
      
      // Convert data to angles (i.e. 360 degrees)
      for (int i = 0; i < lerp_data.size(); i++) {
        float _data = lerp_data.get(i);
        float _total = lerp_totals.get(i);
        float pct = _data / _total;
        pcts.add(pct);
        float angle = pct * 360.0;
        angles.add(angle);
        lastAngle += radians(angles.get(i)); 
      }
      
      float lineSpace;
     
      // Draw arcs
      for (int i = 0; i < angles.size(); i++) {
       
        // Assign colors
        if (i == 0) {c = color(202,178,214);}
        else if (i == 1) {c = color(253,191,111);}
        else if (i == 2) {c = color(166,206,227);}
        else if (i == 3) {c = color(240,240,240);}
        else if (i == 4) {c = color(146,101,194);}
        else if (i == 5) {c = color(200,200,200);}
        
        fill(c);
        stroke(c);
        
        pushMatrix();
        pushStyle();
        stroke(255,220);
        strokeWeight(2);
        
        float xOffset = 0;//cos(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/50));
        float yOffset = 0;//sin(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/50));
        arc(x+xOffset,
            y+yOffset,
            lerp_diameters.get(i), 
            lerp_diameters.get(i), 
            lastAngle, 
            lastAngle+radians(angles.get(i)));
        //fill(0);
        //noStroke();
        //ellipse(width/2,height/2,20,20);
        popStyle();
        popMatrix();
        
        pushMatrix();
        pushStyle();
        textFont(raleway, 18);
        textAlign( CENTER );        
     
         translate(x,y);
 
         float sliceOffset = 0;
         

          if (i == 0) {
            pushStyle();
            fill(255,255);
            if (year >= 1975) {
              textFont(raleway, 20);
              lineSpace = 20+2;
            }
            else if (year > 1969 && year < 1975) {
            textFont(raleway, 15);
              lineSpace = 15+2;
            }
            else {
              textFont(raleway, 12);
              lineSpace = 12+2;
            }
            pushMatrix();
            
            translate(cos(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/4.0), 
                    sin(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/4.0));
            text("Social", -1, -lineSpace+5);
            text("Security", -1, 5);
            text(String.format("%.0f%%",angles.get(i) / 360 * 100), 2, lineSpace+5);
            
            
            // Add total            
            float _total = lerp_totals.get(i);
            if (_total >= 1000) {
              labelString = "$" + nfc(_total / 1000, 1) + " Trillion";
            }
            else {
              labelString = "$" + nfc(_total, -1) + " Billion";
            }
            popMatrix();
            
            // text("Total: " + labelString, 40, -lerp_diameters.get(i)/1.6);
            textSize(32);
            fill(255);
            textMode(CENTER);
            //text("Mandatory: " + labelString, -10, -lerp_diameters.get(i)/1.6-120);
            text("Mandatory: " + labelString, -10, -310);
            
            popStyle();
            
          }
          
          else if (i == -1) {
            pushMatrix();
            pushStyle();
            
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(LEFT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            rotate(PI);
            String label = "Soc. Security: " + String.format("%.0f%%",angles.get(i) / 360 * 100);
            text(label, 0, 0);
            
            float _total = lerp_totals.get(i);
            if (_total >= 1000) {
              labelString = "$" + nfc(_total / 1000, 1) + " Trillion";
            }
            else {
              labelString = "$" + nfc(_total, -1) + " Billion";
            }
            
            
            popMatrix();
            
            // text("Total: " + labelString, 40, -lerp_diameters.get(i)/1.6);
            textSize(32);
            fill(255);
            textMode(CENTER);
            text("Mandatory: " + labelString, -185, -lerp_diameters.get(i)/1.6-140);
            //text("Mandatory: " + labelString, -200, -340);
            
            popStyle();
          }
          
          
          
          else if (i == 1) {
            pushMatrix();
            pushStyle();
            
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(LEFT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            // Rotate Health and Medicare a bit more because it's upside down
            rotate(PI);
            String label = "Health & Medicare: " + String.format("%.0f%%",angles.get(i) / 360 * 100);
            text(label, 0, 0);
            
            
            popStyle();
            popMatrix();
          }
          else if (i == 2) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            String label = "Income Security: " + String.format("%.0f%%",angles.get(i) / 360 * 100);
            text(label, 0, 0);
            popMatrix();
          }
          
          else if (i == 3) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Net Interest: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0, 0);
            popMatrix();
          }
          
          else if (i == 4) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Veterans: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0, 0);
            popMatrix();
          }
          
          else if (i == 5) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.8));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            if (angles.get(i) / 360 * 100 > 0 && angles.get(i) / 360 * 100 < 1) {
              text("Other: " + String.format("%.1f%%",angles.get(i) / 360 * 100), 0  , 0);
            }
            else if (angles.get(i) / 360 * 100 > 1) {
              text("Other: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            }
            
            popMatrix();
          }         
  
        popStyle();
        popMatrix();
        
       lastAngle += radians(angles.get(i));
        
      }
    }
  }
}