//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// #include "sobol.h"
void sobseq(int *n, float x[]);
void sobseqBreakPoints(int *n, float x[], void (*callback)(unsigned long *arr, const int width, const int height));
