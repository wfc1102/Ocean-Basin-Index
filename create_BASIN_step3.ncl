load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;--------------------------------------=  Variables Define ----------------------------------------=

 DIRs_in = (/ "/nexsan/people/fwang/CMIP5/CanESM2/" /)

 count0 = 1
 do while(count0.lt.100)
   count1 = count0 + 1
   ncs     = (/ "BASIN_CanESM2_vo_step"+count0+".nc" /)
   vars = (/ "ind"/)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      SOSE         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   nc0  = DIRs_in(0) + ncs(0)
   print("Now,the nc is: "+nc0)
   fin0 = addfile(nc0,"r")

   var0= fin0->$vars(0)$
   lat0 = fin0->lat
   lon0 = fin0->lon

   numx=dimsizes(var0(0,:))
   numy=dimsizes(var0(:,0))

   vit = var0
;   printVarSummary(vit)

   num0 = 0
   num1 = num(var0.eq.0)
   
   do i=0,numx-1
   do j=0,numy-1

     if(ismissing(var0(j,i)))then
       continue
     end if
     if(var0(j,i).eq.0)then
       num0 = num0 + 1
;       print(var0(j,i-1)+" "+var0(j,i+1)+" "+var0(j-1,i)+" "+var0(j+1,i)+" "+var0(j,i))
       im1=max((/i-1,0/))
       jm1=max((/j-1,0/))
       ip1=min((/i+1,numx-1/))
       jp1=min((/j+1,numy-1/))
       vit(j,i)=max((/var0(j,im1),var0(j,ip1),var0(jm1,i),var0(jp1,i)/))
       continue
     end if
   end do 
   end do 

   print("-------------------------------" + num1 + "  " + num0 + "-------------------------------------------")

   if(num0.eq.0) then
     exit
     ;;; There is no 0s grids any more, Cheers!!!
   end if

   num2 = num(vit.eq.0)
   if(num1.eq.num2) then
     print("------------------------Only inner Lakes left------------------------------------")
     exit
     ;;; Coding cannot eliminate 0s grids any more.
     ;;; probably these 0s are inner lakes, doesn't belong to any sea.
     ;;; Such inner lakes are not our concerns, Anyway, Cheers!!!
     ;;; Thus, land is -9999, inner lakes is 0, other oceans are numbers > 0.
     ;;; User might set inner lakes to -9999, if want.
   end if

        system("rm "+DIRs_in+"BASIN_CanESM2_vo_step"+count1+".nc")
   fout    = addfile(DIRs_in+"BASIN_CanESM2_vo_step"+count1+".nc","c")
   fout->ind = vit
   fout->lat = lat0
   fout->lon = lon0

   count0 = count0 + 1
   asciiwrite ("BASIN_CanESM2_vo_step.txt", count1)
end do
;----------------------------------------------------------------------------------------------------
;  It's not recommanded to reset _FillValue to 0
   printVarSummary(vit)
end
