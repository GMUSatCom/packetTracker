import numpy as np
from gnuradio import gr



class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block example - a simple multiply const"""

    def __init__(self, example_param=1.0):  # only default arguments here
        """arguments to this function show up as parameters in GRC"""
        gr.sync_block.__init__(
            self,
            name='basic_doa',   # will show up in GRC
            in_sig1=[np.complex64],
            in_sig2=[np.complex64],
			out_sig=[np.complex64]
        )
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).
        self.example_param = example_param

    def work(self, input_items, output_items):
        """example: multiply with constant"""
        
		chan1Data = input_items[0]
		chan2Data = input_items[1]
		
		chanData = np.concatenate( input_items[0].reshape( (-1,1)), input_items[1].reshape( (-1,1) ))


		covarMat = np.multiply(chan1Data, ))
		
		
		

		output_items[0][:] = input_items[0] * self.example_param
        return len(output_items[0])









