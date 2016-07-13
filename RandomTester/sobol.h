//
//  sobol.h
//  RandomTester
//
//  Created by Axel Roest on 10/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

#ifndef sobol_h
#define sobol_h

#include <stdio.h>

void sobseq(int *n, float x[]);
void sobseqBreakPoints(int *n, float x[], void (*callback)(unsigned long *arr, const int width, const int height));

#endif /* sobol_h */
