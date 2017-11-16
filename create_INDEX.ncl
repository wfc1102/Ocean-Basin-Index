load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;=======================================  Variables Define =========================================

 DIRs_in = (/ "/nexsan/people/fwang/CMIP5/CanESM2/run1/data/", "/nexsan/people/fwang/CMIP5/CanESM2/"/)
 ncs     = (/ "vo_Omon_CanESM2_historical_r1i1p1_185001-186012.nc", "BASIN_CanESM2_vo.nc"/)
 vars = (/ "vo", "ind"/)

  nc0  = DIRs_in(0) + ncs(0)
  print("Now,the nc is: "+nc0)
  fin0 = addfile(nc0,"r")
  var = fin0->$vars(0)$(0,:,:,:)
  var2= fin0->$vars(0)$

  nc1  = DIRs_in(1) + ncs(1)
  print("Now,the nc is: "+nc1)
  fin1 = addfile(nc1,"r")
  bas = fin1->$vars(1)$
  lat1 = fin1->lat
  lon1 = fin1->lon

  var@_FillValue=1e20
  num_tim=dimsizes(var2(:,0,0,0))
  sit=new(dimsizes(var),"float",1e20)
  do t=0,num_tim-1
     sit = where(abs(var2(t,:,:,:)).gt.1e-6, 1, sit)
     ;;; if var is 0 at all times, then it's land
  end do

  tmp = conform_dims (dimsizes(sit),bas,(/1,2/)) 
  tmp = where(ismissing(sit),tmp@_FillValue,tmp)
  printVarSummary(tmp)

  vit = tointeger(var)
;  copy_VarMeta(sit,vit)
  copy_VarMeta(var,vit)
  vit@_FillValue=0
  printVarSummary(vit)
 
  vit = (/tointeger(tmp)/)
  num_lev=dimsizes(vit(:,0,0))

  vit@long_name  = "Index on T grids"
  vit@units  = "0Land,1Arc,2Atl,3Ind,4Pac,5-7Atl_Ind_Pac in vO"

  if("CanESM2".eq."MRI-CGCM3" .or. "CanESM2".eq."MIROC5")then
    vit(num_lev-1,:,:)=vit@_FillValue
  end if
 
  system("rm "+DIRs_in(1)+"INDEX_CanESM2_vo.nc")
  fout    = addfile(DIRs_in(1)+"INDEX_CanESM2_vo.nc","c")
  fout->ind = vit
  fout->lat = lat1
  fout->lon = lon1

end
