// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: Copyright 2024 Sam Blenny
use <press-fit-post.scad>

// This is a 4-bearing spool roller frame that's split into two pieces.
// Printing the two halves at a 45° angle will make the press fit posts
// for the bearings resist shearing under load. This is designed to
// hinge together then fasten securely in place with two zip ties.
//
// Target Dimensions:
// - Absolute max width:        73 mm  (bottom of dry box)
// - Spool outside width:       67 mm
// - Spool inside width:        59 mm
// - Rim to filament clearance: 13 mm
// - 608 bearing thickness:      7 mm
// - 608 bearing diameter (OD): 22 mm
// - Press fit post diameter:    7.97 mm  (see press-fit-tester.scad)
// - zip tie width:              5 mm
// - zip tie thickness:          1 mm

frame_x = 57;
bearing_d = 22;
bearing_r = bearing_d / 2;
axle_d = 7.97;
axle_h = (73 - 57) / 2;
axle_2_axle_y = 114;
axle_z = bearing_r + 5;
frame_z = axle_z + bearing_r + 5;
frame_y = axle_2_axle_y + (2 * (bearing_r + 3));
zip_w = 5;
zip_h = 1;

chamfer = 3;      // normal chamfer
big_chamfer = 10; // chamfer that goes against the build plate

locator_size = 10;
locator_depth = locator_size / 3;
locator_clearance = 0.8;

// Configure OpenSCAD's curve triangulation granularity
if($preview) {$fn=20;} else {$fn=40;}

// Log these values to the console
echo("axle center height", axle_z);
echo("frame height (z)", frame_z);
echo("frame depth (y)", frame_y);
echo("axle length", axle_h);

// Make the basic extruded cross-section shape of half the roller frame
module half_frame_step1() {
    w = frame_x / 2;
    h = frame_z;
    bpc = big_chamfer;  // chamfer that goes on the build plate
    c = chamfer;        // regular chamfer
    rotate([90,0,0])
    linear_extrude(frame_y, center=true, convexity=10)
    polygon([
        [0,bpc],[bpc,0],[w-c,0],[w,c],[w,h-c],[w-c,h],[c,h],[0,h-c]
    ]);
}

// Make a tool shape to cut zip tie holes
module zip_tie_cut() {
    c = 1;  // chamfer
    w = zip_w + 2;
    h = zip_h + 1;
    r = (frame_z / 2) * 1.4;
    translate([-r/2.1,0,r])
    rotate([90,0,0])
    rotate_extrude(convexity=10, $fn=50)
    translate([r,-w/2,0])
    polygon([
        [0,c],[c,0],[0,c],[h-c,0],[h,c],[h,w-c],[h-c,w],[c,w],[0,w-c]
    ]);
}

// Add bearing press fit posts to the half frame
module half_frame_step2() {
    post_x = (frame_x / 2) - 0.05;
    post_y0 = axle_2_axle_y / 2;
    post_y1 = - post_y0;
    union() {
        half_frame_step1();
        translate([post_x,post_y0,axle_z])
            rotate([0,90,0])
                press_fit_post(diameter=axle_d, height=axle_h, $fn=40);
        translate([post_x,post_y1,axle_z])
            rotate([0,90,0])
                press_fit_post(diameter=axle_d, height=axle_h, $fn=40);
    }
}

// This makes a tool shape to cut a horizontal chamfer
module h_chamfer(length, c) {
    translate([- 1.5 * c,0,0])
    rotate([0,90,0])
    linear_extrude(length + 2 * c)
    polygon([[-c,0],[0,c],[c,0],[0,-c]]);
}

// This makes a tool shape to cut a vertical chamfer
module v_chamfer(height, c) {
    translate([0,0,-c])
    linear_extrude(height+2*c)
    polygon([[-c,0],[0,c],[c,0],[0,-c]]);
}

module end_chamfer() {
    w = frame_x / 2;
    end_y = frame_y / 2;
    zip_y = end_y * 0.7;
    bpc = big_chamfer;  // chamfer that goes on the build plate
    c = chamfer;        // regular chamfer
    union() {
        h_chamfer(w, c);
        translate([0,0,bpc]) rotate([0,45,0]) h_chamfer(w, c);
        translate([0,0,frame_z]) h_chamfer(w, c);
        translate([w,0,0]) v_chamfer(frame_z, c);
    }
}

// Locator, male side
module locator_m() {
    cl = locator_clearance;  // clearance between mating parts
    os = locator_size;       // outer size
    d = locator_depth;
    is = os - 2*d*tan(45);  // inner size
    rotate([0,270,0])
    hull() {
        translate([0,0,-cl/2]) cube([os,os,cl], center=true);
        translate([0,0,d-cl/2]) cube([is,is,cl], center=true);
    }
}

// Locator tool shape, female side
module locator_f() {
    cl = locator_clearance;          // clearance between mating parts
    os = locator_size + (2*cl);      // outer size
    d = locator_depth + cl;
    is = os - 2*d*tan(45);  // inner size
    rotate([0,90,0])
    hull() {
        translate([0,0,-cl/2]) cube([os,os,cl], center=true);
        translate([0,0,d-cl/2]) cube([is,is,cl], center=true);
    }
}

// Add end chamfers and zip tie cuts to the half frame
module half_frame_step3() {
    w = frame_x / 2;
    end_y = frame_y / 2;
    zip_y = end_y * 0.7;
    bpc = big_chamfer;  // chamfer that goes on the build plate
    c = chamfer;        // regular chamfer
    locator_z = frame_z - ((frame_z - bpc) / 2) - c/2;
    union() {
        difference() {
            half_frame_step2();
            // Zip tie cuts
            translate([0,zip_y,0]) zip_tie_cut();
            translate([0,-zip_y,0]) zip_tie_cut();
            // Locator cut
            translate([0,-zip_y,locator_z]) locator_f();
            // End chamfers
            translate([0,end_y,0]) end_chamfer();
            translate([0,-end_y,0]) end_chamfer();
        }
        // Add the locator (m)
        translate([0,zip_y,locator_z]) locator_m();
    }
}

// Rotate the half frame to rest on the big chamfered edge
module half_frame_step4() {
    translate([20.56+chamfer*0.9,0,-7])
    rotate([0,-45,0])
    half_frame_step3();
}

union() {
    half_frame_step4();
    rotate([0,0,180]) half_frame_step4();
    // Add hinges
    translate([0,frame_y*0.28,frame_z/2.15])
        linear_extrude(0.5,center=true)
            square([2.1*chamfer,10],center=true);
    translate([0,-frame_y*0.28,frame_z/2.15])
        linear_extrude(0.5,center=true)
            square([2.1*chamfer,10],center=true);
}