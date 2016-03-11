# RandomTester
Sometimes the results of the standard random function arc4random is too ’clumpy’, and you notice that the values should be spread apart more. 
In short: you don’t want a uniform random number generator, but a pseudo-random generator. One caveat of these is that there is now a pattern to notice, but in most use-cases like games this is not a problem.

This RandomTester example code has two different pseudo-random generators, the Halton and the Sobol one.

You can see the differences clearly in the 2D plot with the sliders.

uniform distribution:
![uniform](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/uniform.png)

Halton distribution:
![halton](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/halton.png)

Sobol distribution:
![sobol](https://raw.githubusercontent.com/AppAcademyNL/PseudoRandom/master/samples/sobol.png)

Axel Roest
2016