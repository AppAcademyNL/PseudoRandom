# RandomTester
Sometimes the results of the standard random function arc4random is too ’clumpy’, and you notice that the values should be spread apart more. 
In short: you don’t want a uniform random number generator, but a pseudo-random generator. One caveat of these is that there is now a pattern to notice, but in most use-cases like games this is not a problem.

This RandomTester example code has two different pseudo-random generators, the Halton and the Sobol one.

The two pseudo-random generators give back random pairs, but the code can be tweaked to return more dimensions at once.

You can see the differences clearly in the 2D plot with the sliders.

_Uniform distribution_
![uniform](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/uniform.png)

_Halton distribution_
![halton](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/halton.png)

_Sobol distribution_
![sobol](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/sobol.png)

Axel Roest
2016