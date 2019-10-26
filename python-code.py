import struct 
import numpy as np
from pathlib import Path
from scipy import constants
from numpy import matlib as M
import matplotlib.pyplot as plt
# 16384 Samples
def hermitian(A, **kwargs):
    return np.transpose(A,**kwargs).conj()

T = np.transpose
H = hermitian
pi = constants.pi
CLKGEN = 25e6
f_A1 = open(Path('./packetTracker-codebase/testData/rawIQData'),'rb') # Antenna 1 file
# f_A2 = open('.\packetTracker\testData\rawIQData','rb') # Antenna 2 file
f_A2 = open(Path('./packetTracker-codebase/testData/usaBitch.txt'),'r')

def from_binary(f):
    return np.fromfile(f,dtype=np.complex64,count=1000000)
def from_csv(f):
    raw_output = np.genfromtxt(f,skip_header=1)
    IQ_output = []
    for row in raw_output:
        IQ_output.append(complex(row[0],row[1]))

    return IQ_output

data = from_csv(f_A2)

c = constants.speed_of_light 

# n_Receivers = 2
# nVec = M.mat(np.arange(n_Receivers))
# tarFreq = 800e6
# d = .163

# thLook = np.arange(-90,90,1)

# lambdaa = c/tarFreq

# uVec = (d*np.sin(thLook))/lambdaa
# uVec = T(M.mat(uVec))
# steerVec = np.exp(-1j*2*pi*uVec*nVec)

# t = np.linspace(0, 0.5, 500)
# s = np.sin(40 * 2 * np.pi * t) + 0.5 * np.sin(90 * 2 * np.pi * t)
# fft = np.fft.fft(s)

# T = t[1] - t[0]  # sampling interval 
# N = s.size

# # 1/T = frequency
# f = np.linspace(0, 1 / T, N)


ftIQ = np.fft.fft(data)
freq = np.fft.fftfreq(len(data),d=1/CLKGEN)

print(freq)
plt.plot(freq, ftIQ.real )
plt.show()
