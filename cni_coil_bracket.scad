// Simple bracket to secure the Nova 32-channel coil on the scan bed

width = 76;
thick = 4;
height = 50;
hole_rad = 7/2;
hole_xoff = 25.5;
hole_yoff = 9;

$fn = 32;

// size is a vector [w, h, d]
module roundedBox(size, radius) {
  cube(size - [2*radius,0,0], true);
  cube(size - [0,2*radius,0], true);
  for (x = [radius-size[0]/2, -radius+size[0]/2],
       y = [radius-size[1]/2, -radius+size[1]/2]) {
    translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
  }
}

module bracket() {
  difference(){
    roundedBox([width, height, thick], 3);
    for(x=[-hole_xoff,hole_xoff]){
      translate([x,hole_yoff,-thick/2-1])
        cylinder(thick+2, r=hole_rad);  
    } 
  }
}

for(y=[-(height/2+5),height/2+5]){
  translate([0,y,0])
    bracket();
}