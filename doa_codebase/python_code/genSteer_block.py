import math
import numpy as np
from gnuradio import gr



class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block example - a simple multiply const"""

    def __init__(self, azi_angle_deg=90, elem_num=2, elem_dist=.1, speed_const=299792458):  # only default arguments here
        """arguments to this function show up as parameters in GRC"""
        gr.sync_block.__init__(
            self,
            name='genSteer',   # will show up in GRC
            freqVec=[np.float32],
            aziSteerVec=[np.complex64]
        )
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).
        self.azi_angle = math.radians(azi_angle_deg)
		self.ele_angle = math.radians(ele_angle_deg)
		self.elem_num  = elem_num
		self.elem_dist = elem_dist
		self.spd_const = speed_const

    def work(self, input_items, output_items):
        """example: multiply with constant"""
    
        freqVec = input_items[0]
		
		
		nn = numpy.arrange(self.elem_num)
   		output_items[0] = math.exp(1j*2*math.pi* numpy.multiply(freqVec,nn) *(1/self.spd_const) * self.elem_dist) 
    
   		 

        return len(output_items[0])



