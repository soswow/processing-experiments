class Configuration {
  float diskAngle, diskSize, angularSpeed, angularAccelarion, firstLegSize, secondLegSize, diskCenterX;
  PVector diskCenter;
  String side;
  
  Configuration (String side){
    this.side = side;
  }
   
  void setupSliders(PVector position) {
    int yshift = 20;
    int currentShift = 0;
    
    cp5.addSlider(side + "diskAngle")
      .plugTo(this, "diskAngle")
      .setValue(diskAngle)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(0, 360);
       
    cp5.addSlider(side + "diskSize")
      .plugTo(this, "diskSize")
      .setValue(diskSize)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(10, 300);
       
    cp5.addSlider(side + "angularSpeed")
      .plugTo(this, "angularSpeed")
      .setValue(angularSpeed)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(-8, 8);
       
    cp5.addSlider(side + "angularAccelarion")
      .plugTo(this, "angularAccelarion")
      .setValue(angularAccelarion)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(-0.01, 0.01);
       
    cp5.addSlider(side + "firstLegSize")
      .plugTo(this, "firstLegSize")
      .setValue(firstLegSize)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(150, 500);
       
    cp5.addSlider(side + "secondLegSize")
      .plugTo(this, "secondLegSize")
      .setValue(secondLegSize)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(150, 500);
      
    cp5.addSlider(side + "diskCenterX")
      .plugTo(this, "diskCenterX")
      .setValue(diskCenterX)
      .setPosition(position.x, position.y + yshift * currentShift++)
      .setColorCaptionLabel(0)
      .setRange(0, 300);
      
    this.diskCenter = new PVector(diskCenterX, 200);
  }
}
