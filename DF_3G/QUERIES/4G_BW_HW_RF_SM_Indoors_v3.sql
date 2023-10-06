-- Importar tabla -> blLTE.csv

with baseLTE as (select * from blLTE)

-- Código --
select  DISTINCT lnbts.plmn_id, lnbts.mrbts_id, lnbts.lnBTS_id, case when lnbts.name is null then lnbts.enbName else lnbts.name end as eNB_Name, 
case when lncel.name is null then lncel.cellName else lncel.name end as LNCELL_Name, 
 LNCEL_FDD.LNCEL_id, LNCEL_FDD.dlChBw/10 as dlChBw, LNCEL_FDD.ulChBw/10 as ulChBw, LNCEL_FDD.earfcnDl, LNCEL.tac, 
 LNCEL_FDD.rootSeqIndex, LNCEL.phyCellId, lncel.pMax, 
 
baseLTE.Azimuth, baseLTE.Latitud, baseLTE.Longitud, -- Datos de RF -- 

a.redirFreqUtra,  -- Channel BW --

case when lnbts.actInterEnbDLCAggr=0 then "false" when lnbts.actInterEnbDLCAggr=1 then "true" else "" end as actInterEnbDLCAggr, -- Carrier Aggregation

case when SM_SRAN.smcode is not null and BB_SRAN.bbcode is not null then SM_SRAN.smcode || " + " || BB_SRAN.bbcode
	 when SM_SRAN.smcode is null then BB_SRAN.bbcode
	 when BB_SRAN.bbcode is null then SM_SRAN.smcode end as HW_BB,

case when airScaleRF.HW_RF_AirScale is not null  then airScaleRF.HW_RF_AirScale else nonAirScaleRF.HW_RF_WBTS end as HW_RF, 

-- case when LNCEL_FDD.dlMimoMode = 0 then "Single_TX"
	--  when LNCEL_FDD.dlMimoMode = 10 then "TXDiv"
	--  when LNCEL_FDD.dlMimoMode = 11 then "4-way TXDiv"
	--  when LNCEL_FDD.dlMimoMode = 30 then "Dynamic Open Loop MIMO"
	--  when LNCEL_FDD.dlMimoMode = 40 then "Closed Loop Mimo"
	--  when LNCEL_FDD.dlMimoMode = 41 then "Closed Loop Mimo (4x2)"
	-- when LNCEL_FDD.dlMimoMode = 42 then "Closed Loop Mimo (8x2)"
	--  when LNCEL_FDD.dlMimoMode = 43 then "Closed Loop Mimo (4x4)"
	--  when LNCEL_FDD.dlMimoMode = 44 then "Closed Loop Mimo (8x4)" else "" end as DL_MIMO_Mode,

	  CHANNEL.CHANNEL_id, case when CHANNEL.direction = 1 then "TX" when  CHANNEL.direction = 2 then "RX" else "" end as Channel_Direction, 
m.MTRACEID, m.lcrId, m.tceIpAddress,
	  
lnbts.moVersion as SW_Version,

case when LNCEL.administrativeState = 1 then "unlocked"
when LNCEL.administrativeState=2 then "shutting_down "
when LNCEL.administrativeState=3 then "locked"
 end as Estado_Sector

from LNCEL 
LEFT JOIN baseLTE ON baseLTE.LNB=lncel.name
left join CHANNEL using (plmn_id, mrbts_id)
left join LNBTS using (mrbts_id, plmn_id, lnbts_id) 
left join LNCEL_FDD using (mrbts_id, plmn_id, lnbts_id, LNCEL_id)
left join (select plmn_id, mrbts_id, lnbts_id, lncel_id, group_concat(redirFreqUtra, " - ") as redirFreqUtra 
		   from REDRT
		   group by plmn_id, mrbts_id, lnbts_id, lncel_id
		   ) as a using (mrbts_id, plmn_id, lnbts_id, LNCEL_id) 

LEFT join (--System Module SRAN
			select plmn_id, mrbts_id, 
			group_concat(case when productName like "%ASIA%" then "ASIA" 
							  when productName like "%FSMF%" THEN "FSMF"
							  when productName like "%ASIB%" THEN "ASIB"
							  when productName like "%ASIK%" THEN "ASIK"
							  else productName end, " + ") as smCode
			from (select * from SMOD_R order by productName asc) 
	 	    group by plmn_id, mrbts_id
			) as SM_SRAN using (plmn_id, mrbts_id)
	 
LEFT join (--Base Band SRAN	 
			select plmn_id, mrbts_id, 
			group_concat(case when productName like "%ABIA%" then "ABIA" 
							  when productName like "%ABIL%" THEN "ABIL"
							  when productName like "%ABIO%" THEN "ABIO"
							  when productName like "%FBBA%" THEN "FBBA"
							  when productName like "%FBBC%" THEN "FBBC"
							  else productName end, " + ") as bbCode
			from (select * from bbmod_r order by productName asc) 
			group by plmn_id, mrbts_id
			) as BB_SRAN using (plmn_id, mrbts_id)

left join ( --HW RF modules no SRAN
	select PLMN_id, mrbts_id, 
	group_concat(NoRFModulesPerType," + ") as HW_RF_WBTS,
	sum (case when substr(NoRFModulesPerType,2,4) = "AHPCA" then NoRFModules else 0 end) as AHPCA,
	sum (case when substr(NoRFModulesPerType,2,4) = "FRHA" then NoRFModules else 0 end) as FRHA,
	sum (case when substr(NoRFModulesPerType,2,4) = "FRHC" then NoRFModules else 0 end) as FRHC,
	sum (case when substr(NoRFModulesPerType,2,4) = "FRHD" then NoRFModules else 0 end) as FRHD,
	sum (case when substr(NoRFModulesPerType,2,4) = "FRHE" then NoRFModules else 0 end) as FRHE,
	sum (case when substr(NoRFModulesPerType,2,4) = "FRHG" then NoRFModules else 0 end) as FRHG,
	sum (case when substr(NoRFModulesPerType,2,4) = "FXFA" then NoRFModules else 0 end) as FXFA,
	sum (case when substr(NoRFModulesPerType,2,4) = "FXFC" then NoRFModules else 0 end) as FXFC,
	sum (NoRFModules) as totalRFModules
	from (
		select PLMN_id, mrbts_id, rmCode as productName,
		count(*) || case rmCode
			when "475075A" then "AHPCA"
			when "474252A" then "AHHB"
			when "474649A" then "AHPC"
			when "473042A" then "FHFB"
			when "471894A" then	"FRHA"
			when "472142A" then	"FXCA"
			when "472166A" then	"FXFA"
			when "472656A" then	"FRHC"
			when "472656A" then	"FRHC"
			when "472678A" then	"FXCB"
			when "472679A" then	"FXFC"
			when "472746A" then	"FRHD"
			when "472830A" then	"FRHE"
			when "473225A" then	"FRHG"
			when "473225A" then	"FRHG"
			when "471266A" then "FRCA"
			when "471268A" then "FRCB"
			when "471017A" then "FRFA"
			when "471273A" then "FRFB"
			else rmCode
			end as NoRFModulesPerType,
			count(*) as NoRFModules
		from (
			select PLMN_id, mrbts_id, case when RMOD.prodCode is not null then substr(RMOD.prodCode,1,7) else ""	end as rmCode
			from RMOD
			  )
		where mrbts_id is not null
		group by PLMN_id, mrbts_id, rmCode
	) 	group by PLMN_id, mrbts_id
) as nonAirScaleRF using (plmn_id, mrbts_id) 

left join ( --HW RF modules SRAN
			select PLMN_id, MRBTS_id,
			group_concat(NoRFModulesPerType," + ") as HW_RF_AirScale,
			sum (case when productName = "AHPCA" then NoRFModules else 0 end) as AHPCA,
			sum (case when productName = "FRHA" then NoRFModules else 0 end) as FRHA,
			sum (case when productName = "FRHC" then NoRFModules else 0 end) as FRHC,
			sum (case when productName = "FRHD" then NoRFModules else 0 end) as FRHD,
			sum (case when productName = "FRHE" then NoRFModules else 0 end) as FRHE,
			sum (case when productName = "FRHG" then NoRFModules else 0 end) as FRHG,
			sum (case when productName = "FXFA" then NoRFModules else 0 end) as FXFA,
			sum (case when productName = "FXFC" then NoRFModules else 0 end) as FXFC,
			sum (NoRFModules) as totalRFModules
			from (	
				select RMOD_R.PLMN_id, RMOD_R.MRBTS_id, RMOD_R.productName,
				count(*) || RMOD_R.productName as NoRFModulesPerType,
				count(*) as NoRFModules
				from RMOD_R
				group by RMOD_R.PLMN_id, RMOD_R.MRBTS_id, RMOD_R.productName
				)
			group by PLMN_id, MRBTS_id
			) as airScaleRF using (plmn_id, mrbts_id)
			
left join (-- Objeto MTRACE
			SELECT plmn_id, mrbts_id, group_concat(MTRACE_id, " + ") as MTRACEID, lcrId, tceIpAddress FROM MTRACE 
			group by lcrId,plmn_id, mrbts_id ) as m using (MRBTS_ID, PLMN_ID, lcrId)


--where lncel.mrbts_id=7744 --eNB_Name like "ANT.Yondo"
where eNB_Name like "%Plaza Claro%"--is not null and eNB_Name not like "%Test%" and eNB_Name not like "%Prueba%"
order by eNB_Name, lnbts.mrbts_id, lncel.name ASC