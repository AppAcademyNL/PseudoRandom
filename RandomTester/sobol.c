//
//  sobol.c
//  RandomTester
//
//  Created by Axel Roest on 10/03/16.
//  Copyright © 2016 The App Academy. All rights reserved.
//

// This code is from Numerical Recipes in C, copied from the book

#include "sobol.h"
#define MAXBIT 30

#define MAXDIM 6

#define SIGN(a,b) ((b) >= 0.0 ? fabs(a) : -fabs(a))
#define DSQR(a) ((a)*(a))
#define DMAX(a,b) ((a) > (b) ? (a) : (b))
#define IMIN(a,b) ((a) > (b) ? (b) : (a))

//When n is negative, internally initializes a set of MAXBIT direction numbers for each of MAXDIM different Sobol’ sequences. When n is positive (but ≤MAXDIM), returns as the vector x[1..n] the next values from n of these sequences. (n must not be changed between initializations.)

void sobseq(int *n, float x[])
{
    int j,k,l;
    unsigned long i,im,ipp;
    static float fac;
    static unsigned long in,ix[MAXDIM+1],*iu[MAXBIT+1];
    static unsigned long mdeg[MAXDIM+1]={0,1,2,3,3,4,4};
    static unsigned long ip[MAXDIM+1]={0,0,1,1,2,1,4};
    static unsigned long iv[MAXDIM*MAXBIT+1]={0,1,1,1,1,1,1,3,1,3,3,1,1,5,7,7,3,3,5,15,11,5,15,13,9};

    if (*n < 0) { // Initialize, don’t return a vector.
        for (k=1;k<=MAXDIM;k++) {
            ix[k]=0;
        }
        in=0;
        if (iv[1] != 1) {
            return;
        }
        fac=1.0/(1L << MAXBIT);
        for (j=1,k=0 ; j<=MAXBIT ; j++,k+=MAXDIM) {
            iu[j] = &iv[k]; // To allow both 1D and 2D addressing.
        }
        for (k=1;k<=MAXDIM;k++) {
            for (j=1;j<=mdeg[k];j++) {
                iu[j][k] <<= (MAXBIT-j);            //  Stored values only require normalization.
            }
            for (j=mdeg[k]+1; j<=MAXBIT; j++) {       //  Use the recurrence to get other values.
                ipp=ip[k];
                i=iu[j-mdeg[k]][k];
                i ^= (i >> mdeg[k]);
                for (l=mdeg[k]-1;l>=1;l--) {
                    if (ipp & 1) {
                        i ^= iu[j-l][k];
                    }
                    ipp >>= 1;
                }
                iu[j][k]=i;
            }
        }
        // test output of sobol formula
//        for (i = 0 ; i < MAXDIM*MAXBIT; i++) {
//            j = (i / MAXDIM) + 1;
//            k = (i % MAXDIM) + 1;
//            printf("[%d , %d] = %ld\n",j, k, iu[j][k]);
//        }
        printf("index\tim\tx[0]\tx[1]\tx[2]\n");
    } else {
        //        Calculate the next vector in the se- quence.
        im=in++;
        for (j=1;j<=MAXBIT;j++) {        //        Find the rightmost zero bit.
            if (!(im & 1)) {
                break;
            }
            im >>= 1;
        }
        if (j > MAXBIT) {
            x = 1/0    ; ("MAXBIT too small in sobseq");
        }
        im=(j-1)*MAXDIM;
        //         XOR the appropriate direction number into each component of the vector and convert to a floating number.

        for (k=1;k<=IMIN(*n,MAXDIM);k++) {
            ix[k] ^= iv[im+k];
            x[k]=ix[k]*fac;
        }
        printf("%ld\t%ld\t%f\t%f\t%f\n",in, im, x[0], x[1], x[2]);
    }
}

void sobseqBreakPoints(int *n, float x[], void (*callback)(unsigned long *arr, const int width, const int height))
{
    int j,k,l;
    unsigned long i,im,ipp;
    static float fac;
    static unsigned long in,ix[MAXDIM+1],*iu[MAXBIT+1];
    static unsigned long mdeg[MAXDIM+1]={0,1,2,3,3,4,4};
    static unsigned long ip[MAXDIM+1]={0,0,1,1,2,1,4};
    static unsigned long iv[MAXDIM*MAXBIT+1]={0,1,1,1,1,1,1,3,1,3,3,1,1,5,7,7,3,3,5,15,11,5,15,13,9};
    
    if (*n < 0) { // Initialize, don’t return a vector.
        for (k=1;k<=MAXDIM;k++) {
            ix[k]=0;
        }
        in=0;
        if (iv[1] != 1) {
            return;
        }
        fac=1.0/(1L << MAXBIT);
        for (j=1,k=0 ; j<=MAXBIT ; j++,k+=MAXDIM) {
            iu[j] = &iv[k]; // To allow both 1D and 2D addressing.
        }
        callback(iv, MAXDIM, MAXBIT);
        for (k=1;k<=MAXDIM;k++) {
            for (j=1;j<=mdeg[k];j++) {
                iu[j][k] <<= (MAXBIT-j);            //  Stored values only require normalization.
            }
            callback(iv, MAXDIM, MAXBIT);
            for (j=mdeg[k]+1; j<=MAXBIT; j++) {       //  Use the recurrence to get other values.
                ipp=ip[k];
                i=iu[j-mdeg[k]][k];
                i ^= (i >> mdeg[k]);
                for (l=mdeg[k]-1;l>=1;l--) {
                    if (ipp & 1) {
                        i ^= iu[j-l][k];
                    }
                    ipp >>= 1;
                }
                iu[j][k]=i;
                callback(iv, MAXDIM, MAXBIT);
           }
        }
    } else {
        //        Calculate the next vector in the se- quence.
        im=in++;
        for (j=1;j<=MAXBIT;j++) {        //        Find the rightmost zero bit.
            if (!(im & 1)) {
                break;
            }
            im >>= 1;
        }
        if (j > MAXBIT) {
            x = 1/0    ; ("MAXBIT too small in sobseq");
        }
        im=(j-1)*MAXDIM;
        //         XOR the appropriate direction number into each component of the vector and convert to a floating number.
        
        for (k=1;k<=IMIN(*n,MAXDIM);k++) {
            ix[k] ^= iv[im+k];
            x[k]=ix[k]*fac;
        }
    }
}