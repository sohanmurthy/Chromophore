//Connects to local Fadecandy server and maps P3LX points to physical pixels
FadecandyOutput buildOutput() {
  FadecandyOutput output = null;
  int[] pointIndices = buildPoints();
  output = new FadecandyOutput(lx, "172.25.26.193", 7890, pointIndices);
  lx.addOutput(output);
  return output;
}

//Function that maps point indices to pixels on led strips
int[] buildPoints() {
  int pointIndices[] = new int[model.size];
  int i = 0;
  for (int pixels = 0; pixels < model.size; pixels = pixels + 1) {
          pointIndices[i] = pixels;
      i++;
  }
  return pointIndices; 
}
