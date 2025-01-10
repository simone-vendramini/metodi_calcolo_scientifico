
The repository presents two scientific computing projects implemented in Julia.

Library for Linear Systems
A library was developed to solve linear systems using iterative methods. The implemented algorithms include:

Jacobi and Gauss-Seidel (stationary iterative methods)
Gradient Descent and Conjugate Gradient (non-stationary iterative methods)
The study evaluates these methods in terms of convergence, precision, iteration count, and computational time, using different matrices and tolerances.

Image Compression with DCT
The second project focuses on image compression using the Discrete Cosine Transform (DCT).

The implementation compresses images by truncating high-frequency components of DCT coefficients.
A comparison was made between a custom DCT implementation and an optimized library, analyzing performance and the visual quality of compressed images.
The effects of compression parameters and artifacts, such as Gibbs phenomenon, were explored to optimize the trade-off between compression level and image quality.
