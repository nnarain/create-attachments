include <NopSCADlib/core.scad>
include <BOSL/constants.scad>
use <BOSL/transforms.scad>

include <../parts/block.scad>
include <../parts/pi-mount.scad>

bind = 0.01;

pi_mount_offset = [-10, 10, 0];

module pi_mount_stl() {
    stl("pi_mount");
    union() {
        zrot(90) fastener();
        translate(pi_mount_offset)
            zmove(fastener_thickness() - bind) zrot(45) pi_mount();
    }
}

module pi_mount_assembly() {
assembly("pi_mount_assembly") {
    render()
        pi_mount_stl();
        // zmove(pi_rest_z_offset) pcb(BOARD_TYPE);
}
}
