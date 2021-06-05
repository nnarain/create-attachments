include <NopSCADlib/core.scad>
include <../parts/block.scad>

module fastener_left_stl() {
    stl("fastener_left");
    fastener();
}

module fastener_right_stl() {
    stl("fastener_right");
    mirror([1, 0, 0])
        fastener();
}

module left_block_assembly() {
assembly("left_block") {
    render()
        fastener_left_stl();
}
}

module right_block_assembly() {
assembly("right_block") {
    render()
        fastener_right_stl();
}
}
