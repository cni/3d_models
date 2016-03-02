/*
  Brackets to mount CNI eye tracker camera to an IV pole.
*/

// Top bracket (for the camera)
toplength = 240;
sidelength = 100;
thickness = 35;
pole_radius = 17.0/2;
mount_screw_diameter = 8.75; // 1/4" screw (clear-through)
mount_nut_size = 14.0;
mount_nut_height = 8.0; //8.0;

// bottom bracket (to secure pole to bed)
bed_height = 93;
bed_to_pole = 66;
bed_inset = 15;
bed_fill_side = 21; // Triangle on the upper part of the bed bracket. (hypotenuse ~= 30mm)
bed_recess_height = 4;
bed_recess_radius = 36/2;

pole_support_height = 30;


width = 15;            // thickness of outer edges

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

module hexnut(pad, rot=30){
  translate([0,0,-pad/2-1])
    cylinder(r=mount_screw_diameter/2, h=pad+2);
  // Hexnut cut-out for pole mount screw
  translate([0,0,-(mount_nut_height)])
    rotate(rot, [0,0,1])
      hexagon(mount_nut_size, mount_nut_height*2); // 1/4" hex nut size
}

module top_bracket(P){
  S = sidelength/2; // precompute this oft-used value
  
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
      translate([S-pole_radius,0,-(S+P*2)])
        cylinder(r=pole_radius, h=sidelength+P*4);
      
    // hole for pole mount screw
    offset = S-mount_screw_diameter/2-5;
    rotate(-90, [0, 1, 0]){ // TODO: use hexnut module
      translate([0,offset,-(S+P+1)])
        cylinder(r=mount_screw_diameter/2, h=P+2);
      // Hexnut cut-out for pole mount screw
      translate([0,offset,-(S+mount_nut_height/2)])
        hexagon(mount_nut_size, mount_nut_height+1); // 1/4" hex nut size
    }
    
    // Holes for camera mount bolts-- cut a few to allow optimal positioning.
    for(i = [0:2]){
      d = -toplength+S+P+mount_nut_size + 20 * i;
      rotate(-90, [1, 0, 0]){  // TODO: use hexnut module
        translate([d, 0, S-P])
          cylinder(r=mount_screw_diameter/2, h=P*3);
        // Hexnut cut-out for pole mount screw
        translate([d, 0, S+mount_nut_height/2])
          // Rotate the nuts for minimal horizontal overhang
          rotate(30, [0,0,1])
            hexagon(mount_nut_size, mount_nut_height+1); // 1/4" hex nut size
      }
    }
  }
}

module bottom_bracket(P, thickness){
  difference() {
    union(){
      // part that runs along the side of the bed
      cube([bed_height+2*P, P, thickness], center=true);
      // arm that runs along the top of the bed
      // Includes a triange brace for added strength and 
      // an extension to hold the pole
      translate([(bed_height/2+P/2), -(bed_to_pole/2+P/2+pole_radius/2), 0])
        cube([P, bed_to_pole+2*P+pole_radius, thickness], center=true);
      rotate(180, [0,0,1])
        translate([-bed_height/2,P/2,0])
          triangle(bed_fill_side, thickness);
      translate([bed_height/2+P*2, -(bed_to_pole+P/2), 0])
          cube([pole_support_height, pole_radius*2+P*2, thickness], center=true);
      // Flange to catch the bottom of the bed
      translate([-bed_height/2-P/2, -bed_inset/2, 0])
         cube([P, bed_inset+P, thickness], center=true);

    }

    // hole for pole
    rotate(-90, [0, 1, 0])
      translate([0, -bed_to_pole-P/2, -bed_height/2-P-pole_support_height-1])
        cylinder(r=pole_radius, h=P+2+pole_support_height);
    
    // recess for pole mount flange on bed
    rotate(-90, [0, 1, 0])
      translate([0, -bed_to_pole-P/2, -bed_height/2-bed_recess_height+.1])
        cylinder(r=bed_recess_radius, h=bed_recess_height);
      
    // hole for bed tension screw
    rotate(-90, [1, 0, 0])
      hexnut(P);

    // hole for pole tension screw
    rotate(90, [1, 0, 0])
      translate([bed_height/2+P+pole_support_height/2, 0, bed_to_pole+P+pole_radius])
        hexnut(P);
    rotate(0, [1, 0, 0])
      translate([(bed_height/2+P+pole_support_height/2), -(bed_to_pole+P/2), thickness/2-pole_radius])
        hexnut(thickness/2, rot=0);
  }
}

//top_bracket(width);
translate([-100,-70,0])
  rotate(180, [0, 0, 1])
    bottom_bracket(width*1.0, thickness*1.5);

