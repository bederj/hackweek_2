//when you create a note you give it a position
//then when you want to show that note you call the drawNote function


Note[] notes; // a list of Note objects

// make the keys
void createNotes(){
  println("creating notes");
  notes = new Note[85];
  
  
  // if we want a lot we need a loop to make all 85
  int l=0;
  for (int k = 60; k < 85; k++){
    notes[k] = new Note(k+l,width/2);
    l+=40;
    println(k+l);
  }
  
  
}



// the note class that does all the stuff like showing the actual note

class Note {
  float x;
  float y;
  float angle=0;

  Note(float _x, float _y) {
    x=_x;
    y=_y;
  }
   
  void drawNote(){
    
   fill(255-bg);
  // pushMatrix();
   //translate(x,y);
  // rotate(radians(angle));
   //rect(x,y,10,500);
   //popMatrix();
   
   //rotateNote();
  }
  
  void removeNote(){
 
  }
  
  void rotateNote(){
   angle+=25; 
  }
  
}