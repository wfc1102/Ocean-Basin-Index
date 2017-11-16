load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;---------------------------------------  Variables Define -----------------------------------------

 DIRs_in = (/ "./", "/nexsan/people/fwang/CMIP5/CanESM2/run1/data/" /)
 DIRs_out= (/ "/nexsan/people/fwang/CMIP5/CanESM2/" /)
 ncs     = (/ "BASIN_LICOM.nc", "vo_Omon_CanESM2_historical_r1i1p1_185001-186012.nc" /)
 vars    = (/ "ind", "vo" /)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      SOSE         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   nc0  = DIRs_in(0) + ncs(0)
   print("Now,the nc is: "+nc0)
   fin0 = addfile(nc0,"r")

   lat0 = fin0->lat
   lon0 = fin0->lon

   nc1  = DIRs_in(1) + ncs(1)
   print("Now,the nc is: "+nc1)
   fin1 = addfile(nc1,"r")
   num_tim = dimsizes(fin1->time)
   num_tim=min((/num_tim,12/))

;-------------- lev ---------------
   var  = fin1->$vars(1)$(0,:,0,0)
   lev  = var!0
   lev1 = fin1->$lev$
   num_lev = dimsizes(lev1)
   delete(var)

;-------------- var ---------------
   var0 = fin0->$vars(0)$
   tmp  = fin1->$vars(1)$(0:num_tim-1,0:num_lev-2,:,:)
   tmp@_FillValue=-9999
   tmp  = abs(tmp)*100.
   var1 = tmp(0,0,:,:)
   var1 = dim_sum_n_Wrap(dim_sum_n_Wrap(tmp,0),0)

;-------------- lat ---------------
   lat1 = fin1->lat
;-------------- lon ---------------
   lon1 = fin1->lon

;   vit = var1
   vit = tointeger(var1)
   copy_VarMeta(var1,vit)
   vit@_FillValue = -9999
;   printVarSummary(vit)

   num0 = 0
   
   numx = dimsizes(var1(0,:))
   numy = dimsizes(var1(:,0))

   nlat = dimsizes(dimsizes(lat1))

   do i=0,numx-1
   do j=0,numy-1

     if(ismissing(var1(j,i)).or.vit(j,i).eq.0)then
       vit(j,i)=vit@_FillValue
       continue
     end if
     ;;; Below Coarse Grid is Sea
     ;;; num0 counts if High-Resoluton is Land
     ;;; vit: -9999 where Coarse is land, 0 if High-Resoluton is Land; num0 is the number of 0s in vit
     ;;; step3 inspect where vit is 0 and try to eliminate it, by which makes num0 to 0

;---------------- for MIROC4h -----------------
     if(tmp(0,0,j,i).eq.5)then
       vit(j,i)=vit@_FillValue
       continue
     end if
;---------------------------------------------

     if(nlat.eq.2)then
       rlat1=lat1(j,i)
       rlon1=lon1(j,i)
     else
       rlat1=lat1(j)
       rlon1=lon1(i)
     end if
       
     if(rlon1.lt.0)then
       rlon1 = rlon1+360.
     end if

     j_rlat = ind_nearest_coord (rlat1, lat0, 0)
     i_rlon = ind_nearest_coord (rlon1, lon0, 0)
 
   if(j.eq.154 .and. i.eq.141)then
     print(j_rlat+" "+i_rlon+" "+lat0(j_rlat)+" "+lon0(i_rlon)+" "+var0(j_rlat,i_rlon))
   end if

     if(var0(j_rlat,i_rlon).eq.0)then
       num0 = num0 + 1
       vit(j,i)=0
     else
       vit(j,i)=(/var0(j_rlat,i_rlon)/)
     end if
     
   end do 
   end do 

   vit@long_name  = "Index on T grids"
   vit@units  = "0Land,1Arc,2Atl,3Ind,4Pac,5-7Atl_Ind_Pac in SO"

;   printVarSummary(vit)
   print("-------------------------------" + num0 + "-------------------------------------------")
       system("rm "+DIRs_out(0)+"BASIN_CanESM2_vo_step1.nc")
  fout    = addfile(DIRs_out(0)+"BASIN_CanESM2_vo_step1.nc","c")
  fout->ind = vit
  fout->lat = lat1
  fout->lon = lon1

  asciiwrite ("BASIN_CanESM2_vo_step.txt", 1)

end
