// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: Copyright 2024 Sam Blenny

module press_fit_post(diameter, height, chamfer, label=false, $fn=30) {
    r = diameter / 2;
    h = height;
    c = chamfer;
    difference() {
        // Rotate this 2D polygon around the Z axis to make a post
        // with inward chamfer at top and outward chamfer around base
        // ---,
        //    |
        //    |
        // ____\
        rotate_extrude(convexity=10)
            polygon([
                [0,0], [r+c, 0], [r, c],
                [r, h-c], [r-c, h], [0, h],
            ]);
        // Optionally inset text with diameter label on the top face
        if (label) {
            translate([0,0,h-0.1])
                linear_extrude(0.2)
                    text(
                        text=str(diameter),
                        size=2.2,
                        font="Liberation Sans:style=Bold",
                        halign="center",
                        valign="center",
                        spacing=0.9
                    );
        }
    }
}

// Example post
press_fit_post(diameter=7.81, height=9, chamfer=1, label=true);

