-- Importar tabla -> blUMTS.csv

with a as (select * from blUMTS),

banda as (
		select distinct * 
		from (
			select distinct WCEL.PLMN_id, WCEL.RNC_id, WCEL.WBTS_id, WCEL.UARFCN, wcel.WCEL_id,
			(case  
			  when (WCEL.UARFCN>10562 and WCEL.UARFCN<10838) then 2100 
			  when ((WCEL.UARFCN>9662 and WCEL.UARFCN<9938) or (WCEL.UARFCN=412 or WCEL.UARFCN=437 or WCEL.UARFCN=462 or WCEL.UARFCN=487 or WCEL.UARFCN=512 or WCEL.UARFCN=537 or WCEL.UARFCN=562 or WCEL.UARFCN=587 or WCEL.UARFCN=612 or WCEL.UARFCN=637 or WCEL.UARFCN=662 or WCEL.UARFCN=687)) then 1900
			  when (WCEL.UARFCN>1162 and WCEL.UARFCN<1513) then 1800
			  when ((WCEL.UARFCN>4357 and WCEL.UARFCN<4458) or  (WCEL.UARFCN=1007 or WCEL.UARFCN=102 or WCEL.UARFCN=1032 or WCEL.UARFCN=1037 or WCEL.UARFCN=1062 or WCEL.UARFCN=1087 ))then 850
			  when (WCEL.UARFCN>4387 and WCEL.UARFCN<4413) then 800
			  else WCEL.UARFCN
			  end) FrequencyBand
			from WCEL
	 )
	group by PLMN_id, RNC_id, WBTS_id, WCEL_id, UARFCN, FrequencyBand
),

mssData as (	
	select distinct wcel.plmn_id, wcel.rnc_id, rnc.name as RNCname, rnc_id,--BSC.signallingPointCodeIN0, BSC.signallingPointCodeIN1, BSC.signallingPointCodeNA0, BSC.signallingPointCodeNA1,
	wcel.wbts_id, wbts.name as WBTSname, wcel.wcel_id, wcel.name as WCELname, wcel.LAC, wcel.SAC, wcel.CId, wcel.AdminCellState, 
	--signallingNetworkCode, signallingPointCode, 
	mssCells.nwName as mssNwName, mssCells.SAC as mssSAC, mssCells.locationAreaCode as msslocationAreaCode,
	mssCells.tariffArea as mssTariffArea, mssCells.routingZone as mssRoutingZone

	from WCEL
	join WBTS using (plmn_id, rnc_id, wbts_id)
	join RNC using (plmn_id, rnc_id)
	left join ( --MSS Cell data
			select MSA.plmn_id, MSA.msc_id, msc.name, 
			MSA.RNW_id, msa_id, MSA.adminState as CellAdminState, rncm.RNCM_id, 
			RNCM.rncName as RNCname, RNCM.state as RNCAdminState, msa.mobileCountryCode, msa.mobileNetworkCode, msa.locationAreaCode, 
			MSA.nwName, msa.SAC, --BSCM.signallingNetworkCode, 
			RNCM.signallingPointCode, 
			MSA.tariffArea, MSA.RoutingZone
			from MSA
			join RNCM_LOCATIONAREALIST using(plmn_id, msc_id, locationAreaCode)--ON RNCM_LOCATIONAREALIST .PLMN_id =  MSA.PLMN_id and RNCM_LOCATIONAREALIST.MSC_id = MSA.MSC_id and RNCM_LOCATIONAREALIST.locationAreaCode = MSA.locationAreaCode
			join RNCM using(plmn_id, msc_id, RNCM_id)--on RNCM.PLMN_id = MSA.PLMN_id and RNCM.MSC_id=MSA.MSC_id and RNCM.RNW_id=MSA.RNW_id and RNCM.RNCM_id= MSA.--BTSM.bscIdInMsc 
			join MSC USING (plmn_id, msc_id)
			where msa.adminState = 1
			order by nwName asc--msa.sac asc
					) as mssCells on mssCells.mobileCountryCode = wcel.WCELMCC and mssCells.mobileNetworkCode = wcel.WCELMNC
				and mssCells.sac = wcel.SAC and rncm_id = rnc.RNC_id

	where WCELname not like "__%Prueba%"
) 

select a.Id, --a.Sitio, 
case when wbts.name is null then wbts.WBTSName else wbts.name end as WBTS_Name,
a.Region, a.EquipoRF, replace(a.Latitud,".",",") as Latitud, replace(a.Longitud,".",",") as Longitud, a.Depto, a.Municipio, a.DANE, 
a.Banda, 
banda.FrequencyBand,
--a.BTS_Name,
wcel.name as WCELName,
a.Sector,
a.Estructura, a.Antena, a.AlturaAntena
, a.[#Antenas]
, a.Azimuth, a.TiltElectrico, a.TiltMecanico, a.Twist,
RNC.name as Controller_ID, wcel.cId as LcrId, wcel.PriScrCode,wcel.uarfcn, wcel.lac, wcel.rac,wcel.sac, wcel.MaxDLPowerCapability
,mssRoutingZone --as routingZone
,mssData.mssNwName-- as nwName
,rnc.RNC_id,wcel.wbts_id,wcel.plmn_id as RC,wcel.AdminCellState, wcel.WCELState,wcel.PtxPrimaryCPICH, wbts.SBTSId, WCEL_URAID.value as URAID
--,case when (AdminCellState =1 and WCELState=0) then "WO" else "NO_WO" end as Cell_State

from WCEL
left join WCEL_URAID using (plmn_id, RNC_id, WCEL_id, wbts_id)
left join WBTS using (plmn_id, wbts_id, rnc_id)
left join a on a.BTS_Name=wcel.name
left join banda  on banda.PLMN_id=WCEL.PLMN_id and banda.RNC_id=WCEL.RNC_id and banda.WBTS_id=WCEL.WBTS_id and banda.WCEL_id=WCEL.WCEL_id
left join rnc using (plmn_id, rnc_id)
left join mssData on wcel.wcel_id=mssData.WCEL_id and wcel.WBTS_id=mssData.WBTS_id and wcel.rnc_id=mssData.RNC_id and wcel.PLMN_id=mssData.PLMN_id

where wcel.name not like "%Prueba%" or wcel.name not like "%Test%"
order by wcel.name ASC

