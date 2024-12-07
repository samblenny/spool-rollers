// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: Copyright 2024 Sam Blenny
use <press-fit-post.scad>

diameters = [7.84, 7.82, 7.80, 7.78, 7.76, 7.74, 7.72, 7.70];
chamfer = 1;
post_spacing = 18;

module posts(first=0, last=3) {
    translate([0,0,5])
    rotate([45,0,0])
    for(i=[first:last]) {
        d = diameters[i];
        r = d / 2;
        translate([i*post_spacing,0,0])
        press_fit_post(diameter=d, height=6, label=true, $fn=40);
    }
}

// This extrudes a beam having a polygon cross section that's shaped
// like a truncated and chamfered triangle, kinda like this:
//
//             C__D
//           /     \
//         /         \
//       /             \
//    A/       B  E      \F
//    |                   |
//     \_________________/
//
// Inside of all the chamfering, there are two right triangles, ABC and
// DEF, with their long sides at a 45 degree angle. The posts attach to
// the angled sides. Printing posts at an angle makes them much less
// likely to shear or snap under load.
module base_bar() {
    translate([-10,-4.5,0.6])
    rotate([90,0,0])
    rotate([0,90,0])
    linear_extrude(4*post_spacing + 3)
    polygon([
        [0,0], [9,9], [10, 9], [19,0],
        [19,-1], [18,-2], [1,-2], [0,-1],
    ]);
}

union() {
    // Start with the chamfered triangular base bar
    base_bar();
    // Add first four posts on front 45 angled face
    posts(first=0, last=3);
    // Add last four posts rotated onto the back angled face
    rotate([0,0,180])
    translate([-126,-9.9,0])
    posts(first=4, last=7);
}
