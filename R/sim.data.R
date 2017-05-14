#' @useDynLib dfpk, .registration = TRUE
#' @export
sim.data <-
function(PKparameters,omegaIIV,omegaAlpha,sigma,doses,limitTox,timeSampling, N){
    
    pk.model <- function(t,dose,ka,CL,V){
        dose*ka/V/(ka-CL/V)* (exp(-CL/V*t)-exp(-ka*t))  
    }
    
    nPK <- length(timeSampling)       		
    # doses <- exp(qnorm(preal)*sqrt(omegaIIV^2+omega_a^2) + log(limit_tox) + log(PKparameters[2]))  
    preal <- pnorm((log(doses)-log(limitTox)-log(PKparameters[2]))/sqrt(omegaIIV^2+omegaAlpha^2))  
    parameter <- NULL               			
    sens_AUC <- NULL                			
    alphatot <- NULL			 			
    tox <- NULL
    
    tab <- c(0,timeSampling,timeSampling)	 
    npar <- length(PKparameters) - 1             
    
    for(i in 1:N){
        ipar <- (PKparameters[2:3])*exp(rnorm(npar, sd=omegaIIV))
        ipar <- c(PKparameters[1],ipar)
        parameter <- rbind(parameter,ipar)
        for(j in doses){
            concen <- pk.model(timeSampling, dose=j, ka = ipar[1], CL = ipar[2], V = ipar[3]) 
            concPred <- concen*(1+rnorm(2*nPK, sd=sigma))   	# real concentrations + predictions of them
            tab <- rbind(tab,c(i, concPred))     		
            alfa <- exp(rnorm(1, sd=omegaAlpha))				
            CL <- ipar[2]		   
            sens <- alfa*j/CL          
            sens_AUC <- c(sens_AUC, sens) 
            alphatot <- c(alphatot, alfa) 
        }
    }
    
    for(i in 1:N){
        row.names(parameter)[i] <- paste("pid", i)
        colnames(parameter) <- c("ka", "CL", "V")
    }
   
    #####################################
    ########## Concentration  ###########
    #####################################
    
    concentration <- NULL
    for(k in 1:length(doses)){
        conc <- pk.model(timeSampling, dose=doses[k], ka = ipar[1], CL = ipar[2], V = ipar[3])
        concentration <- cbind(concentration,conc)
    }

    for(i in 1:length(sens_AUC)){
        if(sens_AUC[i] >= limitTox){
            tox[i] = 1
        }else{
            tox[i] = 0
        }
    }
    tox <- matrix(tox, ncol = length(doses), byrow = T)
    rownames(tox) <- paste("pid", 1:N)
    colnames(tox) <- paste("dose", 1:length(doses))

    data <- list(nPK=nPK, conc=concPred[1:nPK], concPred=concPred, doses=doses, preal = preal, tab=tab, tox=tox, 
                 parameters=parameter, alphaAUC=sens_AUC)

    new("scen", PKparameters=PKparameters, nPK= nPK, time=timeSampling, N=N, doses=doses, preal = preal,
              limitTox=limitTox, omegaIIV=omegaIIV, omegaAlpha=omegaAlpha, conc=concentration, 
              concPred=concPred, tox=tox, tab=tab, parameters=parameter, alphaAUC=sens_AUC
    )
}