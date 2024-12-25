# ARC4 Decryption Circuit

This project implements an ARC4 decryption circuit designed to decrypt a given ciphertext using the ARC4 (Alleged RC4) stream cipher. The circuit is implemented in Verilog and can be tested with various inputs to ensure correct decryption functionality.

## Project Overview
The ARC4 Decryption Circuit is based on the ARC4 stream cipher, which is widely used in cryptographic applications. This implementation decrypts a given ciphertext using a secret key and produces the original plaintext. The circuit design allows for efficient decryption and can be used for educational purposes to better understand stream ciphers and cryptographic hardware design.

## Features
- **ARC4 Decryption Implementation**: The Verilog code implements the decryption process of ARC4 using key scheduling and pseudo-random generation.
- **Parallel Decryption Units**: Multiple decryption units are used to speed up the decryption process by handling multiple streams simultaneously.
- **Testbench**: A testbench is provided to simulate and verify the functionality of the decryption circuit.
- **Key Generation**: The circuit allows for key input in the form of a key schedule to initiate decryption.
- **Compatible with FPGA**: Designed for use in FPGA or ASIC systems for high-performance cryptographic hardware.

## Installation
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/hsirrk/ARC4-Decryption-Circuit.git
