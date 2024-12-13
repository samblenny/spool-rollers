<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- SPDX-FileCopyrightText: Copyright 2024 Sam Blenny -->
# Spool Rollers

This repo documents my project to make a 3D printable spool rollers to fit in
a plastic cereal box. I wanted to make a filament dry box so I could feed
filament without having to unseal the box.

This didn't work out like I'd hoped because the plastic box was a little bit
too narrow to accomodate the bearings without them rubbing against the box's
side walls. But, it was a good project for learning to use OpenSCAD. Also, I
made some models for calibrating XY hole/contour compensation and bearing
press fit post diameter which may be useful elsewhere.

This is what the finished spool roller looks like:

![fully assembled spool roller with spool](img/assembled-with-spool.jpeg)


## Additional Photos

1. These are my press fit and XY compensation calibration blocks:

    ![XY compensation and bearing press fit calibration blocks](img/xycal-block-6_with_bearing-press-fit.jpeg)

2. These are the two halves of the spool roller frame. The fins and slots are
   designed with 0.1mm clearance, so, with well calibrated extrusion flow and
   XY compensation, they press fit with light pressure. The zip ties hold
   everything in place securely. Printing the frame halves at a 45° angle makes
   the bearing posts strong without requiring supports that might mess up the
   press fit tolerance.

    ![two halves of spool roller with zip ties](img/split-frame-with-loose-zip-ties.jpeg)

3. This is the fully assembled spool roller with 608-2RS press fit bearings.

    ![assembled spool roller with bearings](img/fully-assembled.jpeg)

4. Here, the spool roller is inside the air-tight plastic cereal box with a
   spool of filament. The bearings are jammed against the side of the cereal
   box, so the spool doesn't roll properly.

    ![filament spool roller in a plastic cereal box](img/assembled-in-cereal-box.jpeg)

