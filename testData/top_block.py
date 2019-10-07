#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Sun Oct  6 21:41:03 2019
##################################################


from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser
import limesdr


class top_block(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 32000

        ##################################################
        # Blocks
        ##################################################
        self.limesdr_source_0 = limesdr.source('0009070105C62E09', 2, '/home/aaron/Documents/satcom/limeSuite/testFiles/lms7suite_wfm/loraRadioDualChannel')

        self.blocks_file_sink_0_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/aaron/Documents/satcom/ieeeTracker/packetTracker/testData/rawIQData2', False)
        self.blocks_file_sink_0_0.set_unbuffered(False)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/aaron/Documents/satcom/ieeeTracker/packetTracker/testData/rawIQData', False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.blocks_burst_tagger_0_0 = blocks.burst_tagger(gr.sizeof_gr_complex)
        self.blocks_burst_tagger_0_0.set_true_tag('burst',True)
        self.blocks_burst_tagger_0_0.set_false_tag('burst',False)

        self.blocks_burst_tagger_0 = blocks.burst_tagger(gr.sizeof_gr_complex)
        self.blocks_burst_tagger_0.set_true_tag('burst',True)
        self.blocks_burst_tagger_0.set_false_tag('burst',False)

        self.analog_const_source_x_0 = analog.sig_source_s(0, analog.GR_CONST_WAVE, 0, 0, -1)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.blocks_burst_tagger_0, 1))
        self.connect((self.analog_const_source_x_0, 0), (self.blocks_burst_tagger_0_0, 1))
        self.connect((self.blocks_burst_tagger_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.blocks_burst_tagger_0_0, 0), (self.blocks_file_sink_0_0, 0))
        self.connect((self.limesdr_source_0, 1), (self.blocks_burst_tagger_0, 0))
        self.connect((self.limesdr_source_0, 0), (self.blocks_burst_tagger_0_0, 0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate


def main(top_block_cls=top_block, options=None):

    tb = top_block_cls()
    tb.start()
    try:
        raw_input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
