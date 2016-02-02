base_width = 80;
base_depth = 40;
base_height = 8;

slot_width = 36;
slot_depth = 4;

post_width = 32;
post_depth = 12;
post_height = 50;

flange_depth = 10;
flange_width = 40;
flange_height = 15;

difference(){
  union(){
    // base
    cube([base_width, base_depth, base_height]);
    // post
    translate([(base_width-post_width)/2, base_depth-post_depth-slot_depth, 0])
      cube([post_width, post_depth, post_height]);
    // flange
    translate([(base_width-flange_width)/2, base_depth-flange_depth-slot_depth-(post_depth-flange_depth)/2,0])
      cube([flange_width, flange_depth, flange_height]);
  }
  translate([(base_width-slot_width)/2, base_depth-slot_depth, -1])
    cube([slot_width, slot_depth+1, base_height+2]);
  translate([(base_width-slot_width)/2, base_depth-2*slot_depth-post_depth, -1])
    cube([slot_width, slot_depth, base_height+2]);
}