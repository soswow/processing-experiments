class EdgeConfiguration{
  float tabSize;
  float tabDepth;
  String firstCornerType;
  String secondCornerType;
  float edgeSize;
  
  // Calculated
  public boolean startHigh;
  public boolean endHigh;
  public float startSkipSize;
  public float endSkipSize;
  public float cornerSize;
  public int fullTabsNumber;
  
  private HashMap<String, Boolean> edgeCornerStartHigh = new HashMap(){{
    put("a1", true);
    put("b1", false);
    put("b2", true);
    put("c1", false);
    put("c2", false);
  }};
  
  
  EdgeConfiguration(float tabSize, float tabDepth, 
    String firstCornerType, String secondCornerType, float edgeSize) {
    this.tabSize = tabSize;
    this.tabDepth = tabDepth;
    this.firstCornerType = firstCornerType;
    this.secondCornerType = secondCornerType;
    this.edgeSize = edgeSize;
    this.calculate();
  }
  
  private float getSkipByCornerType(String cornerType) {
    if(cornerType == "c1" || cornerType == "c2" || cornerType == "b2" ) {
      return this.tabDepth;
    } else {
      return 0;
    }
  }
    
  private void calculate(){
    this.startHigh = this.edgeCornerStartHigh.get(this.firstCornerType);
    this.endHigh = this.edgeCornerStartHigh.get(this.secondCornerType);
    
    this.startSkipSize = getSkipByCornerType(this.firstCornerType);
    this.endSkipSize = getSkipByCornerType(this.secondCornerType);
    
    float spaceBetweenCorners = this.edgeSize - this.tabSize * 2;
    println("spaceBetweenCorners", spaceBetweenCorners);
    int fullTabsNumber = floor(spaceBetweenCorners / tabSize);
    
    
    if (this.startHigh == this.endHigh) {
      // Odd number ot tabs required
      if (fullTabsNumber % 2 == 0) {
        // Goes to closest odd number
        fullTabsNumber -= 1;
      }
    } else {
      // Even number ot tabs required
      if (fullTabsNumber % 2 == 1) {
        // Goes to closest even number
        fullTabsNumber -= 1;
      }
    }
    println("fullTabsNumber", fullTabsNumber);
    this.fullTabsNumber = fullTabsNumber;
    spaceBetweenCorners = this.fullTabsNumber * this.tabSize;
    
    this.cornerSize = (this.edgeSize - spaceBetweenCorners) / 2;
  }
  
  public String toString() {
    return "startHigh: " + this.startHigh +
    ", endHigh: " + this.endHigh +
    ", startSkipSize: " + this.startSkipSize +
    ", endSkipSize: " + this.endSkipSize +
    ", cornerSize: " + this.cornerSize +
    ", fullTabsNumber: " + this.fullTabsNumber +
    ", tabSize: " + this.tabSize +
    ", tabDepth: " + this.tabDepth;
  }
}
