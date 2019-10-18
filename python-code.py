import struct 
import numpy as np
from pathlib import Path
from scipy import constants
from numpy import matlib as M
import matplotlib.pyplot as plt

def hermitian(A, **kwargs):
    return np.transpose(A,**kwargs).conj()

T = np.transpose
H = hermitian
pi = constants.pi
CLKGEN = 80e6
f_A1 = open(Path('./testData/rawIQData'),'rb') # Antenna 1 file
# f_A2 = open('.\packetTracker\testData\rawIQData','rb') # Antenna 2 file

def toIQ(f):
    return np.fromfile(f,dtype=np.complex64,count=1000000)

IQ1 = toIQ(f_A1)

c = constants.speed_of_light 

n_Receivers = 2
nVec = M.mat(np.arange(n_Receivers))
tarFreq = 915e6
d = .163

thLook = np.arange(-90,90,1)

lambdaa = c/tarFreq

uVec = (d*np.sin(thLook))/lambdaa
uVec = T(M.mat(uVec))
steerVec = np.exp(-1j*2*pi*uVec*nVec)

# t = np.linspace(0, 0.5, 500)
# s = np.sin(40 * 2 * np.pi * t) + 0.5 * np.sin(90 * 2 * np.pi * t)
# fft = np.fft.fft(s)

# T = t[1] - t[0]  # sampling interval 
# N = s.size

# # 1/T = frequency
# f = np.linspace(0, 1 / T, N)



ftIQ = np.fft.fft(IQ1)
freq = np.fft.fftfreq(IQ1.size,d=1/CLKGEN)
print(freq)
# plt.plot(freq, ftIQ.real, freq, ftIQ.imag)
# plt.show()
