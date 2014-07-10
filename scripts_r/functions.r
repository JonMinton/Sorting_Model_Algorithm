


###################################################################################################################################
# R Functions
###################################################################################################################################

make_movingcost_matrix <- function(
    proprents,
    medval,
    vendcost=0.03,
    movecost_num=2910, # moving cost numerator
    movecost_denom=24.556, # moving cost denominator
    movecost_outside=528.71 # cost of moving out of country      
){
    
    # Error checking
    if (length(proprents)!=length(medval)) stop("proprents and medval of different lengths")
    N <- length(proprents)
    
    out <- matrix(nrow=N+1, ncol=N+1)
    
    for (i in 1:(N+1)){
        for (j in 1:(N+1)){      
            # If not moving
            if (i==j){
                out[i,j] <- 0
            } 
            # If not moving out of the county
            if ((i != j) & (i != (N+1)) & (j != (N+1))){
                out[i,j] <- movecost_num + vendcost *(
                    (1 - proprents[i]) * medval[i] + (1 - proprents[j]) * medval[j]
                ) / movecost_denom
            }
            # If moving out of the county
            if ((i != j) & ((i==(N+1)) | (j==(N+1)))){
                out[i,j] <- movecost_outside   
            }  
            
        }
    }
    return (out) 
}



make_movingcost_matrix <- cmpfun(make_movingcost_matrix)
