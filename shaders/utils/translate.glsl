uniform vec4 POS;

vec4 translate_to_centerCam(vec4 p){
    vec4 cam_POS = POS;
    float movement_threshold = 100.0;
   
    int i_x = int(cam_POS.x / movement_threshold);
    int i_z = int(cam_POS.z / movement_threshold);


    return p + vec4(i_x * movement_threshold, 0.0, i_z * movement_threshold,0.0);
}