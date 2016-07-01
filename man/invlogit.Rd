\name{invlogit}
\alias{invlogit}
\title{Inverse logistic functions}

\description{
  Inverse-logit function, transforms continuous values to the range (0, 1)
}
\usage{
invlogit(x)
}

\arguments{
  \item{x}{A vector of continuous values}
}

\details{
        The Inverse-logit function defined as: 
        \eqn{logit^-1(x) = e^x/(1+e^x)} transforms continuous values to the range (0, 1),
        which is necessary, since probabilities must be between 0 and 1 and maps 
        from the linear predictor to the probabilities 
}
\value{
  A vector of estimated probabilities
}
\references{Moreno et al, (2016).}

\author{Artemis Toumazi \email{artemis.toumazi@inserm.fr}, 
        Moreno Ursino \email{moreno.ursino@inserm.fr}
        }


\examples{
n <- 100
 x1 <- rnorm (n)
 x2 <- rbinom (n, 1, .5)
 b0 <- 1
 b1 <- 1.5
 b2 <- 2
 Inv.logit <- invlogit(b0+b1*x1+b2*x2)
 plot(b0+b1*x1+b2*x2, Inv.logit)
}

\keyword{models}
 