/*
  Bracket to mount CNI eye tracker camera to an IV pole.
*/

toplength = 235;
sidelength = 100;
thickness = 35;
pole_diameter = 16.5;
mount_screw_diameter = 8.5; // 1/4" screw (clear-through)
mount_nut_size = 15;
mount_nut_height = 10;

// From http://svn.clifford.at/openscad/trunk/libraries/shapes.scad
// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}

module triangle(size=sidelength, height=1) {
  // extrudes a right triangle of given size and thickness
  linear_extrude(height=height, center=true)
  polygon(points = [[0, 0], [size, 0], [0, size]], paths = [[0, 1, 2]]);
}


S = sidelength/2; // precompute this oft-used value
P = 15;            // padding for outer edges

difference() {
  // Outer triangle & top beam
  union(){
    translate([S+P, S+P, 0])
      rotate(180, [0,0,1])
        triangle(sidelength + P*3, thickness);
    translate([-toplength+(S+P), S, -thickness/2])
      cube([toplength,P,thickness]);
  }
  
  // Round the sharp edge
  translate([S-P+1, -S*2+3, -thickness/2-1])
      cube([35,30,thickness+2]);
    
  // Inner triangle
  translate([S, S, 0])
    rotate(180, [0,0,1]) 
      triangle(sidelength, thickness+2);

  // hole for pole
  rotate(-90, [1, 0, 0])
    translate([S-pole_diameter/2,0,-(S+P*2)])
      cylinder(r=pole_diameter/2, h=sidelength+P*4);
    
  // hole for pole mount screw
  offset = S-mount_screw_diameter/2-5;
  rotate(-90, [0, 1, 0]){
    translate([0,offset,-(S+P+1)])
      cylinder(r=mount_screw_diameter/2, h=P+2);
    // Hexnut cut-out for pole mount screw
    translate([0,offset,-(S+mount_nut_height/2)])
      hexagon(mount_nut_size, mount_nut_height+1); // 1/4" hex nut size
  }
  
  // Holes for camera mount bolts-- cut a few to allow optimal positioning.
  for(i = [0:2]){
    d = -toplength+S+P+mount_nut_size + 20 * i;
    rotate(-90, [1, 0, 0]){
      translate([d, 0, S-P])
        %cylinder(r=mount_screw_diameter/2, h=P*3);
      // Hexnut cut-out for pole mount screw
      translate([d, 0, S+mount_nut_height/2])
        // Rotate the nuts for minimal horizontal overhang
        rotate(30, [0,0,1])
          hexagon(mount_nut_size, mount_nut_height+1); // 1/4" hex nut size
    }
  }
}

