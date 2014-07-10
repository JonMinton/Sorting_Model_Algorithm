
###############
#cccccccccccccccccccccccccccccccc
#c Stay-put % by race:          c
#c    - white_l = 0.4174        c
#c    - black_l = 0.3254        c
#c    - asian_l = 0.2808        c
#c    - hisp_l = 0.2892          c
#c    - other_l = 0.2687        c
#c                              c
#c    - white_m = 0.4082        c
#c    - black_m = 0.3933        c

propstay.white_low <- 0.4174
propstay.black_low <- 0.3254
propstay.asian_low <- 0.2808
propstay.hisp_low <- 0.2892
propstay.other_low <- 0.2687

propstay.white_middle <- 0.4082
propstay.black_middle <- 0.3933

###################################################################################################################################
# Input Data
###################################################################################################################################
Data0 <- read.csv("data/raw/InputsCombined.csv")
Data1 <- read.csv("data/raw/stage2_dec_vc_sheet1.csv")
Data2 <- read.csv("data/raw/stage2_dec_vc_sheet2.csv")


#Data0 <- rename(Data0, c(area="id"))
names(Data0)[1] <- "id"

Data01 <- merge(Data0, Data1, by="id", all.x=T)
Data012 <- data.frame(Data01, Data2)

countsold <- {
    Data012$white.l00 + Data012$white.m00 + Data012$white.h00 +
        Data012$black.l00 + Data012$black.m00 + Data012$black.h00 + 
        Data012$hisp.l00 +  Data012$hisp.m00 + Data012$hisp.h00 + 
        Data012$asian.l00 + Data012$asian.m00 + Data012$asian.h00
}

countsnew <- {
    Data012$white.l09 + Data012$white.m09 + Data012$white.h09 +
        Data012$black.l09 + Data012$black.m09 + Data012$black.h09 + 
        Data012$hisp.l09 +  Data012$hisp.m09 + Data012$hisp.h09 + 
        Data012$asian.l09 + Data012$asian.m09 + Data012$asian.h09
}

countsold.white_low <- Data012$white.l00
countsnew.white_low <- Data012$white.l09


correction  <- 0.0001

countsold <- countsold + correction
countsnew <- countsnew + correction

proprents = Data012$prent
medval = Data012$medval


############################################################################################################################

proprents <- proprents
medval <- medval
countsnew <- countsnew
countsold <- countsold


movingcostmatrix <- MakeMovingCostMatrix(proprents,medval)

###################################################################################################################################
# Input structure for Rcpp
###################################################################################################################################


In <- list(
    data = list(
        stayerprop= 0.4174,
        counts = list(
            oldcounts=countsold,
            newcounts=countsnew      
        )
    ),
    movingcostmatrix = movingcostmatrix,
    utils = list(
        deltas = rep(0, length(countsold) + 1) # Added one for outside region
    ),
    params = list(
        tol_delta = 10^-2,
        tol_mu = 10^-1,
        mu_upper = 0.50,
        mu_lower = 0,
        maxit_outer = 1000,
        maxit_inner = 100000,
        use_logmu = F
    ),
    dbg = list(
        dbgflag= T,
        verboseflag=T
        
    )
)

rm(movingcostmatrix)