# RSA_project
RSA is a public-key cryptosystem that is widely used for secure data transmission. A public-key 
cryptosystem means that data is encrypted and decrypted using two different keys: private key and 
public key, respectively. This provides added data security but adds the complexity of the sharing and 
generating the private and public keys between sender and receiver.
The encryption process is given by the following equation:
𝑐 = (𝑚^𝑒) 𝑚𝑜𝑑 𝑛

Similarly, the decryption process is given by the following equation:
𝑚 = (𝑐^𝑑) 𝑚𝑜𝑑 𝑛

As we can see from the previous equations, both operations can be broken down into two steps: 
exponentiation, and modulo (remainder) operation.

The focus of this project is to utilize as few SLICEs/CLBs as possible of the FPGA board. This is done by making good usage of 
other FPGA resources such as DSP slices and BRAM.
****** this version of the design is to work with synchronous reset *********
