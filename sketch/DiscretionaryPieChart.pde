class DiscretionaryPieChart {
  
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
  
  DiscretionaryPieChart (float _x, float _y, float _total_start, float _total_end, 
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
      
     
      // Draw arcs
      for (int i = 0; i < angles.size(); i++) {
       
        // Assign colors
        if (i == 0) {c = color(227,26,28);}
        else if (i == 1) {c = color(166,206,227);}
        else if (i == 2) {c = color(178,223,138);}
        else if (i == 3) {c = color(51,160,44);}
        else if (i == 4) {c = color(251,154,153);}
        else if (i == 5) {c = color(31,120,180);}
        else if (i == 6) {c = color(253,191,111);}
        else if (i == 7) {c = color(255,127,0);}
        else if (i == 8) {c = color(202,178,214);}
        else if (i == 9) {c = color(146,101,194);}
        else if (i == 10) {c = color(255,255,153);}
        else if (i == 11) {c = color(177,89,40);}
        
        fill(c);
        stroke(c);
        
        pushMatrix();
        pushStyle();
        stroke(255,200);
        strokeWeight(2);
        
        float xOffset = cos(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/20);
        float yOffset = sin(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/20);
        arc(x+xOffset,
            y+yOffset,
            lerp_diameters.get(i), 
            lerp_diameters.get(i), 
            lastAngle, 
            lastAngle+radians(angles.get(i)));
        popStyle();
        popMatrix();
        
        pushMatrix();
        pushStyle();
        textFont(raleway, 18);
        textAlign( CENTER );        
     
         translate(x,y);
         
         float sliceOffset = -PI/100;

          if (i == 0) {
            pushStyle();
            fill(255,255);
            textFont(raleway, 22);
            pushMatrix();
            
            // YAY THIS WORKS
            translate(cos(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/3.8), 
                    sin(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/3.8));
            text("Military", 5, 0);
            text(String.format("%.0f%%",angles.get(i) / 360 * 100), 2, 25);
            
            
            // Add total
            /*
            translate(-cos(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/3.8),
            -sin(lastAngle+radians(angles.get(i))/2) * (lerp_diameters.get(i)/3.8));
            
            translate(150, 
                    (-lerp_diameters.get(i)/1.8));
            
            */
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
            //text("Discretionary: " + labelString, -60, -lerp_diameters.get(i)/1.6-120);
            text("Discretionary: " + labelString, -60, -310);
            
            popStyle();
            
            
            
          }
          
          
          
          else if (i == 1) {
            pushMatrix();
            pushStyle();
            
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            String label = "Housing: " + String.format("%.0f%%",angles.get(i) / 360 * 100);
            text(label, 0, 0);
            
            
            popStyle();
            popMatrix();
          }
          else if (i == 2) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            String label = "Transportation: " + String.format("%.0f%%",angles.get(i) / 360 * 100);
            text(label, 0, 0);
            popMatrix();
          }
          
          else if (i == 3) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Education: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0, 0);
            popMatrix();
          }
          
          else if (i == 4) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Energy & Environ.: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0, 0);
            popMatrix();
          }
          
          else if (i == 5) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Government: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
          
          else if (i == 6) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
            
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            text("Health & Medicare: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            
            popMatrix();
          }
          
          else if (i == 7) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
                    
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Int'l. Affairs: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
          
          else if (i == 8) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
                    
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Social & Labor: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
          
          else if (i == 9) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
                    
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            text("Veterans: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
          
          else if (i == 10) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
                    
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Science: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
          
          else if (i == 11) {
            pushMatrix();
            translate(cos(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7), 
                    sin(lastAngle+sliceOffset+radians(angles.get(i))/2) * (lerp_diameters.get(i)/1.7));
                    
            textAlign(RIGHT);
            rotate(lastAngle+radians(angles.get(i))/2 + PI);
            
            text("Agriculture: " + String.format("%.0f%%",angles.get(i) / 360 * 100), 0  , 0);
            popMatrix();
          }
  
        popStyle();
        popMatrix();
        
       lastAngle += radians(angles.get(i));
        
      }
    }
  }
}