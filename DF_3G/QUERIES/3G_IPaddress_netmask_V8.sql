with ipmask as (
 select 32 as bitLength, "255.255.255.255" as mask
 UNION
 select 31 as bitLength, "255.255.255.254" as mask
 UNION
 select 30 as bitLength, "255.255.255.252" as mask
 UNION
 select 29 as bitLength, "255.255.255.248" as mask
 UNION
 select 28 as bitLength, "255.255.255.240" as mask
 UNION
 select 27 as bitLength, "255.255.255.224" as mask
 UNION
 select 26 as bitLength, "255.255.255.192" as mask
 UNION
 select 25 as bitLength, "255.255.255.128" as mask
 UNION
 select 24 as bitLength, "255.255.255.0" as mask
 UNION
 select 23 as bitLength, "255.255.254.0" as mask
 UNION
 select 22 as bitLength, "255.255.252.0" as mask
 UNION
 select 21 as bitLength, "255.255.248.0" as mask
 UNION
 select 20 as bitLength, "255.255.240.0" as mask
 UNION
 select 19 as bitLength, "255.255.224.0" as mask
 UNION
 select 18 as bitLength, "255.255.192.0" as mask
 UNION
 select 17 as bitLength, "255.255.128.0" as mask
 UNION
 select 16 as bitLength, "255.255.0.0" as mask
),

banda as (
select distinct PLMN_id, RNC_id, WBTS_id, group_concat(FrequencyBand," + ") as FrequencyBand
	from (
		select distinct WCEL.PLMN_id as PLMN_id, WCEL.RNC_id as RNC_id, WCEL.WBTS_id as WBTS_id, --WCEL.UARFCN,
			(case  
			  when (WCEL.UARFCN>10562 and WCEL.UARFCN<10838) then 2100 
			  when ((WCEL.UARFCN>9662 and WCEL.UARFCN<9938) or (WCEL.UARFCN=412 or WCEL.UARFCN=437 or WCEL.UARFCN=462 or WCEL.UARFCN=487 or WCEL.UARFCN=512 or WCEL.UARFCN=537 or WCEL.UARFCN=562 or WCEL.UARFCN=587 or WCEL.UARFCN=612 or WCEL.UARFCN=637 or WCEL.UARFCN=662 or WCEL.UARFCN=687)) then 1900
			  when (WCEL.UARFCN>1162 and WCEL.UARFCN<1513) then 1800
			  when ((WCEL.UARFCN>4357 and WCEL.UARFCN<4458) or  (WCEL.UARFCN=1007 or WCEL.UARFCN=102 or WCEL.UARFCN=1032 or WCEL.UARFCN=1037 or WCEL.UARFCN=1062 or WCEL.UARFCN=1087 ))then 850
			  when (WCEL.UARFCN>4387 and WCEL.UARFCN<4413) then 800
			  else WCEL.UARFCN
			  end) as FrequencyBand
		 from WCEL
		 order by FrequencyBand ASC
	 )
		group by PLMN_id, RNC_id, WBTS_id
),

pabis as ( --Configuracion PABIS
		select BCF.plmn_id as RC, BCF.bsc_id,  lower(bcf.name) as BCF_Name, a.locationAreaIdLAC,
		(case when bcf.abisInterfaceConnectionType=0 or bcf.abisInterfaceConnectionType is null then "Legacy Abis"
		when bcf.abisInterfaceConnectionType=1 then "Packet Abis over TDM"
		when bcf.abisInterfaceConnectionType=2 then "PABIS"
		when bcf.abisInterfaceConnectionType=3 then "Packet Abis over TDM (LS HUB)"
		when bcf.abisInterfaceConnectionType=4 then "Packet Abis over TDM (AGG HUB)"
		when bcf.abisInterfaceConnectionType=5 then "Packet Abis over Ethernet - TDM"
		when bcf.abisInterfaceConnectionType=6 then "Packet Abis over Ethernet - TDM (LS)" end) as ABIS_Type,
		BCF.adminState

		from BCF
		left join (select bts.plmn_id, bts.bsc_id, bts.bcf_id, bts.locationAreaIdLAC, bts.RAC, count(bts.name) as Total_Sectores 
					from BTS 
					group by bts.plmn_id, bts.bsc_id, bts.bcf_id, bts.locationAreaIdLAC, bts.RAC) as a USING (bsc_id, plmn_id, bcf_id)
		   
		where (BCF.name is not null or BCF.name not like "%Prueba%" or BCF.name not like "%Test%") and bcf.abisInterfaceConnectionType=2 and BCF.adminState=1 and a.locationAreaIdLAC is not null
		group by bcf.plmn_id, bcf.bsc_id,   bcf.name
		),
		
SRAN_TRS as ( -- TRS 3G SW-SRAN
			select wnbts.PLMN_id, wnbts.MRBTS_id, wnbts.wbtsId
			,(case when like("%IPIF-1%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF1 when like("%IPIF-2%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF2 when like("%IPIF-3%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF3 when like("%IPIF-4%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF4 when like("%IPIF-5%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF5 when like("%IPIF-6%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF6 when like("%IPIF-7%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF7 when like("%IPIF-8%",WNBTS_CPLANELIST.ipV4AddressDN) then IPIF8 end)as WCDMA_IP_CU
			,(case when like("%IPIF-1%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK1 when like("%IPIF-2%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK2 when like("%IPIF-3%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK3 when like("%IPIF-4%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK4 when like("%IPIF-5%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK5 when like("%IPIF-6%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK6 when like("%IPIF-7%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK7 when like("%IPIF-8%",WNBTS_CPLANELIST.ipV4AddressDN) then MASK8 end)as WCDMA_MASK
			,(case when like("%IPIF-1%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN1 when like("%IPIF-2%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN2 when like("%IPIF-3%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN3 when like("%IPIF-4%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN4 when like("%IPIF-5%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN5 when like("%IPIF-6%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN6 when like("%IPIF-7%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN7 when like("%IPIF-8%",WNBTS_CPLANELIST.ipV4AddressDN) then VLAN8 end)as WCDMA_VLAN
			,(case when like("%IPIF-1%",TOP.sPlaneIpAddressDN) then IPIF1 when like("%IPIF-2%",TOP.sPlaneIpAddressDN) then IPIF2 when like("%IPIF-3%",TOP.sPlaneIpAddressDN) then IPIF3 when like("%IPIF-4%",TOP.sPlaneIpAddressDN) then IPIF4 when like("%IPIF-5%",TOP.sPlaneIpAddressDN) then IPIF5 when like("%IPIF-6%",TOP.sPlaneIpAddressDN) then IPIF6 when like("%IPIF-7%",TOP.sPlaneIpAddressDN) then IPIF7 when like("%IPIF-8%",TOP.sPlaneIpAddressDN) then IPIF8 end)as SRAN_IP_SYNC
			,(case when like("%IPIF-1%",TOP.sPlaneIpAddressDN) then MASK1 when like("%IPIF-2%",TOP.sPlaneIpAddressDN) then MASK2 when like("%IPIF-3%",TOP.sPlaneIpAddressDN) then MASK3 when like("%IPIF-4%",TOP.sPlaneIpAddressDN) then MASK4 when like("%IPIF-5%",TOP.sPlaneIpAddressDN) then MASK5 when like("%IPIF-6%",TOP.sPlaneIpAddressDN) then MASK6 when like("%IPIF-7%",TOP.sPlaneIpAddressDN) then MASK7 when like("%IPIF-8%",TOP.sPlaneIpAddressDN) then MASK8 end) as SRAN_MASK_SYNC
			,(case when like("%IPIF-1%",TOP.sPlaneIpAddressDN) then VLAN1 when like("%IPIF-2%",TOP.sPlaneIpAddressDN) then VLAN2 when like("%IPIF-3%",TOP.sPlaneIpAddressDN) then VLAN3 when like("%IPIF-4%",TOP.sPlaneIpAddressDN) then VLAN4 when like("%IPIF-5%",TOP.sPlaneIpAddressDN) then VLAN5 when like("%IPIF-6%",TOP.sPlaneIpAddressDN) then VLAN6 when like("%IPIF-7%",TOP.sPlaneIpAddressDN) then VLAN7 when like("%IPIF-8%",TOP.sPlaneIpAddressDN) then VLAN8 end)as SRAN_VLAN_SYNC
			,(case when like("%IPIF-1%",TRSNW.cPlaneipV4AddressDN1) then IPIF1 when like("%IPIF-2%",TRSNW.cPlaneipV4AddressDN1) then IPIF2 when like("%IPIF-3%",TRSNW.cPlaneipV4AddressDN1) then IPIF3 when like("%IPIF-4%",TRSNW.cPlaneipV4AddressDN1) then IPIF4 when like("%IPIF-5%",TRSNW.cPlaneipV4AddressDN1) then IPIF5 when like("%IPIF-6%",TRSNW.cPlaneipV4AddressDN1) then IPIF6 when like("%IPIF-7%",TRSNW.cPlaneipV4AddressDN1) then IPIF7 when like("%IPIF-8%",TRSNW.cPlaneipV4AddressDN1) then IPIF8 end)as SRAN_IP_CP
			,(case when like("%IPIF-1%",TRSNW.cPlaneipV4AddressDN1) then MASK1 when like("%IPIF-2%",TRSNW.cPlaneipV4AddressDN1) then MASK2 when like("%IPIF-3%",TRSNW.cPlaneipV4AddressDN1) then MASK3 when like("%IPIF-4%",TRSNW.cPlaneipV4AddressDN1) then MASK4 when like("%IPIF-5%",TRSNW.cPlaneipV4AddressDN1) then MASK5 when like("%IPIF-6%",TRSNW.cPlaneipV4AddressDN1) then MASK6 when like("%IPIF-7%",TRSNW.cPlaneipV4AddressDN1) then MASK7 when like("%IPIF-8%",TRSNW.cPlaneipV4AddressDN1) then MASK8 end)as SRAN_MASK_CP
			,(case when like("%IPIF-1%",TRSNW.cPlaneipV4AddressDN1) then VLAN1 when like("%IPIF-2%",TRSNW.cPlaneipV4AddressDN1) then VLAN2 when like("%IPIF-3%",TRSNW.cPlaneipV4AddressDN1) then VLAN3 when like("%IPIF-4%",TRSNW.cPlaneipV4AddressDN1) then VLAN4 when like("%IPIF-5%",TRSNW.cPlaneipV4AddressDN1) then VLAN5 when like("%IPIF-6%",TRSNW.cPlaneipV4AddressDN1) then VLAN6 when like("%IPIF-7%",TRSNW.cPlaneipV4AddressDN1) then VLAN7 when like("%IPIF-8%",TRSNW.cPlaneipV4AddressDN1) then VLAN8 end)as SRAN_VLAN_CP
			,(case when like("%IPIF-1%",TRSNW.ipV4AddressDN1) then IPIF1 when like("%IPIF-2%",TRSNW.ipV4AddressDN1) then IPIF2 when like("%IPIF-3%",TRSNW.ipV4AddressDN1) then IPIF3 when like("%IPIF-4%",TRSNW.ipV4AddressDN1) then IPIF4 when like("%IPIF-5%",TRSNW.ipV4AddressDN1) then IPIF5 when like("%IPIF-6%",TRSNW.ipV4AddressDN1) then IPIF6 when like("%IPIF-7%",TRSNW.ipV4AddressDN1) then IPIF7 when like("%IPIF-8%",TRSNW.ipV4AddressDN1) then IPIF8 end)as SRAN_IP_UP
			,(case when like("%IPIF-1%",TRSNW.ipV4AddressDN1) then MASK1 when like("%IPIF-2%",TRSNW.ipV4AddressDN1) then MASK2 when like("%IPIF-3%",TRSNW.ipV4AddressDN1) then MASK3 when like("%IPIF-4%",TRSNW.ipV4AddressDN1) then MASK4 when like("%IPIF-5%",TRSNW.ipV4AddressDN1) then MASK5 when like("%IPIF-6%",TRSNW.ipV4AddressDN1) then MASK6 when like("%IPIF-7%",TRSNW.ipV4AddressDN1) then MASK7 when like("%IPIF-8%",TRSNW.ipV4AddressDN1) then MASK8 end)as SRAN_MASK_UP
			,(case when like("%IPIF-1%",TRSNW.ipV4AddressDN1) then VLAN1 when like("%IPIF-2%",TRSNW.ipV4AddressDN1) then VLAN2 when like("%IPIF-3%",TRSNW.ipV4AddressDN1) then VLAN3 when like("%IPIF-4%",TRSNW.ipV4AddressDN1) then VLAN4 when like("%IPIF-5%",TRSNW.ipV4AddressDN1) then VLAN5 when like("%IPIF-6%",TRSNW.ipV4AddressDN1) then VLAN6 when like("%IPIF-7%",TRSNW.ipV4AddressDN1) then VLAN7 when like("%IPIF-8%",TRSNW.ipV4AddressDN1) then VLAN8 end)as SRAN_VLAN_UP
			,(case when like("%IPIF-1%",MPLANENW.mPlaneIpv4AddressDN) then IPIF1 when like("%IPIF-2%",MPLANENW.mPlaneIpv4AddressDN) then IPIF2 when like("%IPIF-3%",MPLANENW.mPlaneIpv4AddressDN) then IPIF3 when like("%IPIF-4%",MPLANENW.mPlaneIpv4AddressDN) then IPIF4 when like("%IPIF-5%",MPLANENW.mPlaneIpv4AddressDN) then IPIF5 when like("%IPIF-6%",MPLANENW.mPlaneIpv4AddressDN) then IPIF6 when like("%IPIF-7%",MPLANENW.mPlaneIpv4AddressDN) then IPIF7 when like("%IPIF-8%",MPLANENW.mPlaneIpv4AddressDN) then IPIF8 end)as SRAN_IP_OAM
			,(case when like("%IPIF-1%",MPLANENW.mPlaneIpv4AddressDN) then MASK1 when like("%IPIF-2%",MPLANENW.mPlaneIpv4AddressDN) then MASK2 when like("%IPIF-3%",MPLANENW.mPlaneIpv4AddressDN) then MASK3 when like("%IPIF-4%",MPLANENW.mPlaneIpv4AddressDN) then MASK4 when like("%IPIF-5%",MPLANENW.mPlaneIpv4AddressDN) then MASK5 when like("%IPIF-6%",MPLANENW.mPlaneIpv4AddressDN) then MASK6 when like("%IPIF-7%",MPLANENW.mPlaneIpv4AddressDN) then MASK7 when like("%IPIF-8%",MPLANENW.mPlaneIpv4AddressDN) then MASK8 end)as SRAN_MASK_OAM
			,(case when like("%IPIF-1%",MPLANENW.mPlaneIpv4AddressDN) then VLAN1 when like("%IPIF-2%",MPLANENW.mPlaneIpv4AddressDN) then VLAN2 when like("%IPIF-3%",MPLANENW.mPlaneIpv4AddressDN) then VLAN3 when like("%IPIF-4%",MPLANENW.mPlaneIpv4AddressDN) then VLAN4 when like("%IPIF-5%",MPLANENW.mPlaneIpv4AddressDN) then VLAN5 when like("%IPIF-6%",MPLANENW.mPlaneIpv4AddressDN) then VLAN6 when like("%IPIF-7%",MPLANENW.mPlaneIpv4AddressDN) then VLAN7 when like("%IPIF-8%",MPLANENW.mPlaneIpv4AddressDN) then VLAN8 end)as SRAN_VLAN_OAM
			,(case when like("%IPIF-1%",GNBCF.mPlaneLocalIpAddressDN) then IPIF1 when like("%IPIF-2%",GNBCF.mPlaneLocalIpAddressDN) then IPIF2 when like("%IPIF-3%",GNBCF.mPlaneLocalIpAddressDN) then IPIF3 when like("%IPIF-4%",GNBCF.mPlaneLocalIpAddressDN) then IPIF4 when like("%IPIF-5%",GNBCF.mPlaneLocalIpAddressDN) then IPIF5 when like("%IPIF-6%",GNBCF.mPlaneLocalIpAddressDN) then IPIF6 when like("%IPIF-7%",GNBCF.mPlaneLocalIpAddressDN) then IPIF7 when like("%IPIF-8%",GNBCF.mPlaneLocalIpAddressDN) then IPIF8 end)as GSM_IP
			,(case when like("%IPIF-1%",GNBCF.mPlaneLocalIpAddressDN) then MASK1 when like("%IPIF-2%",GNBCF.mPlaneLocalIpAddressDN) then MASK2 when like("%IPIF-3%",GNBCF.mPlaneLocalIpAddressDN) then MASK3 when like("%IPIF-4%",GNBCF.mPlaneLocalIpAddressDN) then MASK4 when like("%IPIF-5%",GNBCF.mPlaneLocalIpAddressDN) then MASK5 when like("%IPIF-6%",GNBCF.mPlaneLocalIpAddressDN) then MASK6 when like("%IPIF-7%",GNBCF.mPlaneLocalIpAddressDN) then MASK7 when like("%IPIF-8%",GNBCF.mPlaneLocalIpAddressDN) then MASK8 end)as GSM_MASK
			,(case when like("%IPIF-1%",GNBCF.mPlaneLocalIpAddressDN) then VLAN1 when like("%IPIF-2%",GNBCF.mPlaneLocalIpAddressDN) then VLAN2 when like("%IPIF-3%",GNBCF.mPlaneLocalIpAddressDN) then VLAN3 when like("%IPIF-4%",GNBCF.mPlaneLocalIpAddressDN) then VLAN4 when like("%IPIF-5%",GNBCF.mPlaneLocalIpAddressDN) then VLAN5 when like("%IPIF-6%",GNBCF.mPlaneLocalIpAddressDN) then VLAN6 when like("%IPIF-7%",GNBCF.mPlaneLocalIpAddressDN) then VLAN7 when like("%IPIF-8%",GNBCF.mPlaneLocalIpAddressDN) then VLAN8 end)as GSM_VLAN
			
			from WNBTS
			left join WNBTS_CPLANELIST using (PLMN_id,MRBTS_id)
			left join TOP using (PLMN_id,MRBTS_id)
			left join TRSNW using (PLMN_id,MRBTS_id)
			left join MPLANENW using (PLMN_id,MRBTS_id)
			left join GNBCF using (PLMN_id,MRBTS_id)
			left join (
						select PLMN_id, MRBTS_id,
						group_concat(case when cast(IPIF_id as numeric)=1 then localIpAddrAllocated end) as IPIF1,
						group_concat(case when cast(IPIF_id as numeric)=2 then localIpAddrAllocated end) as IPIF2,
						group_concat(case when cast(IPIF_id as numeric)=3 then localIpAddrAllocated end) as IPIF3,
						group_concat(case when cast(IPIF_id as numeric)=4 then localIpAddrAllocated end) as IPIF4,
						group_concat(case when cast(IPIF_id as numeric)=5 then localIpAddrAllocated end) as IPIF5,
						group_concat(case when cast(IPIF_id as numeric)=6 then localIpAddrAllocated end) as IPIF6,
						group_concat(case when cast(IPIF_id as numeric)=7 then localIpAddrAllocated end) as IPIF7,
						group_concat(case when cast(IPIF_id as numeric)=8 then localIpAddrAllocated end) as IPIF8,
						group_concat(case when cast(IPIF_id as numeric)=1 then localIpPrefixLength end) as MASK1,
						group_concat(case when cast(IPIF_id as numeric)=2 then localIpPrefixLength end) as MASK2,
						group_concat(case when cast(IPIF_id as numeric)=3 then localIpPrefixLength end) as MASK3,
						group_concat(case when cast(IPIF_id as numeric)=4 then localIpPrefixLength end) as MASK4,
						group_concat(case when cast(IPIF_id as numeric)=5 then localIpPrefixLength end) as MASK5,
						group_concat(case when cast(IPIF_id as numeric)=6 then localIpPrefixLength end) as MASK6,
						group_concat(case when cast(IPIF_id as numeric)=7 then localIpPrefixLength end) as MASK7,
						group_concat(case when cast(IPIF_id as numeric)=8 then localIpPrefixLength end) as MASK8,
						group_concat(case when cast(IPIF_id as numeric)=1 then vlanid end) as VLAN1,
						group_concat(case when cast(IPIF_id as numeric)=2 then vlanid end) as VLAN2,
						group_concat(case when cast(IPIF_id as numeric)=3 then vlanid end) as VLAN3,
						group_concat(case when cast(IPIF_id as numeric)=4 then vlanid end) as VLAN4,
						group_concat(case when cast(IPIF_id as numeric)=5 then vlanid end) as VLAN5,
						group_concat(case when cast(IPIF_id as numeric)=6 then vlanid end) as VLAN6,
						group_concat(case when cast(IPIF_id as numeric)=7 then vlanid end) as VLAN7,
						group_concat(case when cast(IPIF_id as numeric)=8 then vlanid end) as VLAN8
						FROM (
								SELECT IPIF.PLMN_id, IPIF.MRBTS_id, IPIF.IPIF_id, VLANIF.VLANIF_id, VLANIF.vlanId, IPADDRESSV4_R.localIpAddrAllocated, IPADDRESSV4.localIpPrefixLength
								from IPIF
								left join VLANIF on VLANIF.PLMN_id=IPIF.PLMN_id and VLANIF.MRBTS_id=IPIF.MRBTS_id and substr(IPIF.interfaceDN,instr(IPIF.interfaceDN, "VLANIF-")+7)=VLANIF.VLANIF_id
								lEFT join IPADDRESSV4_R USING (PLMN_id, MRBTS_id, IPIF_id)
								LEFT join IPADDRESSV4 USING (PLMN_id, MRBTS_id, IPIF_id)
								where IPIF.interfaceDN is not NULL
								group by IPIF.PLMN_id, IPIF.MRBTS_id, IPIF.IPIF_id
								)
						group by PLMN_id, MRBTS_id
						) as IPIFVLAN using (PLMN_id, MRBTS_id)
			) 

--- Código ---
select DISTINCT WBTS.PLMN_id, rnc.name as RNC_Name, WBTS.RNC_id, wbts.SBTSId AS MRBTS_id, WBTS.WBTS_id, 
case when WBTS.name is null then WBTS.WBTSName else WBTS.name end as WBTS_Name, banda.FrequencyBand, wbts.IPBasedRouteIdIub,

(case when wbts.sbtsid is not null then sran_trs.SRAN_IP_OAM else wCDMA_TRS.mPlaneIpAddress end) as OAM_IPAddres,
(case when wbts.sbtsid is not null then sran_trs.WCDMA_VLAN else wCDMA_TRS.CU_Vlan end) as VLAN_ID, 
(case when wbts.sbtsid is not null then sran_trs.WCDMA_IP_CU else (case when wCDMA_TRS.cPlaneIpAddress is null then ipnb.NodeBIPAddress else wCDMA_TRS.cPlaneIpAddress end) end) as CU_IPAddress,

(case when IPRT_3G_WCDMA.gateway is null then IPRT_3G_SRAN.gateway else IPRT_3G_WCDMA.gateway end) as Gateway_3G_StaticRoute, 

a.IPUnidad,

case when wbts.SBTSId is null then c.farEndSctpSubnetIpAddress else RNC_SRAN.sctpFarEndSubnetIpAddress end as RNC_Subnet,
case when rnc.moVersion like "mcRNC%" then 26 when rnc.moVersion like "RNC%" then 24 end as RNC_NetMask_Datafill,

IPNB.MinSCTPPortIub, pabis.ABIS_Type

, case when wbts.sbtsid is null then WCDMA_TRS.sPlaneIpAddress else SRAN_TRS.SRAN_IP_SYNC END as sPlaneIP
, case when wbts.sbtsid is null then WCDMA_TRS.Sync_Mask else SRAN_TRS.SRAN_MASK_SYNC END as sPlane_Prefix
, case when wbts.sbtsid is null then WCDMA_TRS.Sync_Vlan else SRAN_TRS.SRAN_VLAN_SYNC END  as sPlaneVLAN
, case when wbts.sbtsid is null then Sync_Mode_WCDMA.Sync_Mode else Sync_Mode_SRAN.SyncMode END as Sync_Mode
, case when wbts.sbtsid is null then Sync_Mode_WCDMA.Sync_Type else SYNC_SRAN_Type.Sync_Type END as Sync_Type
, case when wbts.sbtsid is null then TOPF_TOPMASTERS.masterIpAddr else IP_GMC_SRAN.masterIpAddr END as IPGM_Clock

, case when wbts.sbtsid is null then HWWCDMA.Module_wcdma else HWSMSRAN.Modulo end as Modulo_BB
, case when wbts.sbtsid is null then nonSRANRF.NoRFModulesPerType else SRANRF.HW_RF_AirScale end as Modulo_RF

,case when WBTSFreqBand.ON_AIR_3G>0 then "On_Air" else "Not_OnAir" end as Sitio_3G_ON_AIR,
WBTSFreqBand.ON_AIR_3G as Sectores_3G_OnAir,
WBTSFreqBand.NOT_ON_AIR_3G as Sectores_3G_NO_OnAir,

WBTSFreqBand.Total_Sectores,
NumeroPortadoras.Portadoras

, case when wbts.SBTSId is not null then (case when SW_SRAN.moVersion is null then wbts.SBTSActSwReleaseVer else SW_SRAN.moVersion end) 
									else (case when WBTS.NESWVersion is null then wbts.SBTSActSwReleaseVer else WBTS.NESWVersion end )end as VersionSW
, rnc.moVersion as RNC_Version

from WBTS
left join IPNB on wbts.IPNBId=ipnb.IPNB_id and wbts.PLMN_id=ipnb.PLMN_id and wbts.RNC_id=ipnb.RNC_id
left join BANDA using (PLMN_id, RNC_id, WBTS_id)
left join RNC using (PLMN_id, RNC_id)
left join pabis on lower(WBTS_Name) = pabis.BCF_Name

left join (-- Tipo de Sincronismo para SRAN
			select  wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id, 
			group_concat(case CLOCK_SYNCINPUTLIST.syncInputType
						when 1 then "1pps/ToD Sync Hub Master"
						when 2 then "1pps/ToD external GNSS receiver"
						when 3 then "internal GNSS receiver"
						when 4 then "2.048MHz input"
						when 5 then "Revisar TRS"
						when 8 then "1pps/ToD from backplane"
						when 10 then "PDH-1"
						when 11 then "PDH-2"
						when 12 then "SYNCE-1"
						when 13 then "SYNCE-2"
						when 14 then "TOPF"
						when 15 then "TOPP"
						else NULL end, " + ") as Sync_Type
			from CLOCK_SYNCINPUTLIST  
			LEFT join WNBTS USING (mrbts_id, plmn_id)
			group by wnbts.MRBTS_id
			) as SYNC_SRAN_Type on SYNC_SRAN_Type.mrbts_id=wbts.SBTSId and SYNC_SRAN_Type.wbtsId=wbts.WBTS_id
			
left join TOPF_TOPMASTERS  using (plmn_id, WBTS_id, RNC_id) ---- IP GMC para WCDMA

left join (-- IP GMC para SRAN
			select wnbts.plmn_id, wnbts.wbtsId, wnbts.MRBTS_id, TOPF_TOPMASTERLIST.masterIpAddr
			from WNBTS
			left join TOPF_TOPMASTERLIST using (plmn_id, mrbts_id)
			) IP_GMC_SRAN on IP_GMC_SRAN.mrbts_id=wbts.SBTSId and IP_GMC_SRAN.wbtsId=wbts.WBTS_id

left join TOPF using (plmn_id, WBTS_id, RNC_id) -- TOPF para 3G Puros

left join (--Modo de sincronismo para 3G en SRAN
			select wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id,
			case btsSyncMode
			when 0 then "FreqSync"
			when 1 then "PhaseSync"
			when 2 then "LoosePhaseAndTimeSync" end as SyncMode
			from WNBTS 
			left join SYNC USING (mrbts_id, plmn_id)
			) AS Sync_Mode_SRAN on Sync_Mode_SRAN.mrbts_id=wbts.SBTSId and Sync_Mode_SRAN.wbtsId=wbts.WBTS_id

left join (--Modo de sincronismo para 3G puro
			select  wbts.plmn_id, wbts.rnc_id, wbts.wbts_id,
			case actTopFreqSynch
			when 0	then "Other"
			when 1	then "FreqSync" end as Sync_Mode
			,case clockProtocol
			when 1	then "clkPDH"
			when 2	then "clkSDH"
			when 3	then "clkSyncE"
			when 4	then "clkToP" end as Sync_Type
			from WBTS
			left join STPG_SYNCHROSOURCELIST using (plmn_id, rnc_id, wbts_id)
			left join TOPF using (plmn_id, rnc_id, wbts_id)
			where SBTSid is NULL
			) as Sync_Mode_WCDMA USING (PLMN_ID, RNC_ID, WBTS_ID)

LEFT join (-- IP Tarjeta RNC
			select DISTINCT IPRO.plmn_id, IPRO.rnc_id, IPRO.ipBasedRouteId,	(case when IPRO.address is null then IPRO.addrValueIPV4 else IPRO.address end) as IPUnidad
			from ipro 
			) as a on wbts.plmn_id=a.plmn_id and wbts.rnc_id=a.rnc_id and wbts.IPBasedRouteIdIub=a.ipBasedRouteId

left join (--Segmento Red RNC para 3G SRAN
			select  wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id, sctpFarEndSubnetIpAddress
			from WNBTS
			left join WNBTS_RNCCONFIGLIST using (mrbts_id, plmn_id)
			) as RNC_SRAN on RNC_SRAN.mrbts_id=wbts.SBTSId and RNC_SRAN.wbtsId=wbts.WBTS_id

left join (-- Segmento red RNC para 3G Puro
			select plmn_id, rnc_id, wbts_id, farEndSctpSubnetIpAddress, farEndSctpSubnetMask, ipmask.bitLength as Net_Mask
			from TMPAR
			LEFT join ipmask on ipmask.mask=TMPAR.farEndSctpSubnetMask
			) as c using (PLMN_id, RNC_id, WBTS_id)
			
left join (-- Rutas estáticas 3G puro
			select ipno.plmn_id, ipno.rnc_id, ipno.wbts_id, ipno.cPlaneIpAddress, gateway, 
			CAST(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')-1) AS INTEGER) || "." || --as Octeto_1,
			CAST(substr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)) ,1, instr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
			CAST(substr(substr(trim(cPlaneIpAddress),length(substr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)) ,1, instr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)),'.')))+length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)) ,1, instr(substr(trim(cPlaneIpAddress),length(substr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)) ,1, instr(substr(trim(cPlaneIpAddress),length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)),'.')))+length(substr(trim(cPlaneIpAddress),1,instr(trim(cPlaneIpAddress),'.')))+1,length(cPlaneIpAddress)),'.')-1) AS INTEGER) || "." as IP_C--as Octeto_3
			from ipno
			LEFT join (
						select plmn_id, rnc_id, wbts_id, gateway, 
						CAST(substr(trim(gateway),1,instr(trim(gateway),'.')-1) AS INTEGER) || "." || --as Octeto_1,
						CAST(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
						CAST(substr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." as IP_Gateway
						from IPRT_STATICROUTES
						) as ipgateway using (plmn_id, rnc_id, wbts_id)
			where IP_C = IP_Gateway and ipno.plmn_id=ipgateway.plmn_id and ipno.rnc_id= ipgateway.rnc_id and ipno.wbts_id=ipgateway.wbts_id 
			) IPRT_3G_WCDMA using (PLMN_id, RNC_id, WBTS_id)

left join (-- Rutas estáticas 3G SRAN
			select wnbts.plmn_id, WNBTS.mrbts_id, wnbts.wbtsId, WCDMA_IP_CU,
			CAST(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')-1) AS INTEGER) || "." || --as Octeto_1,
			CAST(substr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)) ,1, instr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
			CAST(substr(substr(trim(WCDMA_IP_CU),length(substr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)) ,1, instr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)),'.')))+length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)) ,1, instr(substr(trim(WCDMA_IP_CU),length(substr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)) ,1, instr(substr(trim(WCDMA_IP_CU),length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)),'.')))+length(substr(trim(WCDMA_IP_CU),1,instr(trim(WCDMA_IP_CU),'.')))+1,length(WCDMA_IP_CU)),'.')-1) AS INTEGER) || "." as IP_C--as Octeto_3
			--gateway from IPRT_STATICROUTES
			, gateway,
			CAST(substr(trim(gateway),1,instr(trim(gateway),'.')-1) AS INTEGER) || "." || --as Octeto_1,
			CAST(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
			CAST(substr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." as IP_Gateway
			from WNBTS
			left join SRAN_TRS using (plmn_id, mrbts_id)
			LEFT join IPRT_STATICROUTES using (plmn_id, MRBTS_id)
			where IP_C = IP_Gateway 
			) as IPRT_3G_SRAN on IPRT_3G_SRAN.MRBTS_id=wbts.SBTSId and IPRT_3G_SRAN.wbtsId=wbts.WBTS_id
			
left join (-- SW Version SRAN
			select  wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id, MRBTS.moVersion
			from WNBTS
			LEFT join mrbts using (MRBTS_id, plmn_id)
			) as SW_SRAN on SW_SRAN.MRBTS_id=wbts.SBTSId and SW_SRAN.wbtsId=wbts.WBTS_id

left join ( -- HW 3G Puro
			select plmn_id, rnc_id, wbts_id, group_concat(unitName||variant," + ") as Module_wcdma 
			from MRBTS_UNITLIST 
			where unitName like "FSM"
			group by plmn_id, rnc_id, wbts_id
			) as HWWCDMA using (PLMN_id, RNC_id, WBTS_id)
			
left join (--System Module SRAN
			select  wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id, 
			group_concat(case when productName like "%ASIA%" then "ASIA" 
							  when productName like "%FSMF%" THEN "FSMF" 
							  when productName like "%ASIB%" THEN "ASIB" 
							  when productName like "%ASIK%" THEN "ASIK" end, " + ") as Modulo
			from WNBTS  
			LEFT join (select * from SMOD_R order by productName asc) USING (mrbts_id, plmn_id)
			group by wnbts.plmn_id, wnbts.wbtsId, wnbts.mrbts_id
			) as HWSMSRAN on HWSMSRAN.MRBTS_id=wbts.SBTSId and HWSMSRAN.wbtsId=wbts.WBTS_id

left join ( --On Air not ON Air per frequencyBand per WBTS
			select WCEL.PLMN_id, WCEL.RNC_id, WCEl.WBTS_id, FrequencyBand,
			 count(wcel_id) as Total_Sectores, 
			 sum(case when (WCEL.AdminCellState =1 and WCEL.WCELState=0) then 1 else 0 end) as ON_AIR_3G,
			 sum(case when (WCEL.AdminCellState <>1 or WCEL.WCELState<>0) then 1 else 0 end) as NOT_ON_AIR_3G
			from WCEL
			LEFT join banda using (plmn_id, rnc_id, wbts_id)
			group by WCEL.PLMN_id, WCEL.RNC_id, WCEl.WBTS_id
			) as WBTSFreqBand using (PLMN_id, RNC_id, WBTS_id)

left join ( --Numero de Portadoras
			select PLMN_id, RNC_id, WBTS_id, count(*) as Portadoras
			from (select WCEL.PLMN_id, WCEL.RNC_id, WCEL.WBTS_id, WCEL.uarfcn
					from WCEL
					group by WCEL.PLMN_id, WCEL.RNC_id, WCEl.WBTS_id, WCEL.UARFCN
					) as WBTSUARFCN
			group by PLMN_id, RNC_id, WBTS_id
			) as NumeroPortadoras USING (PLMN_id, RNC_id, WBTS_id)

left join ( -- TRS 3G Puro
			select ipno.plmn_id, ipno.rnc_id, ipno.wbts_id, ipno.mPlaneIpAddress, ipno.cPlaneIpAddress, ipno.sPlaneIpAddress 
			, group_concat(case when IVIF_2.localIpAddr=ipno.sPlaneIpAddress then IVIF_2.vlanId end) as Sync_Vlan
			, group_concat(case when IVIF_2.localIpAddr=ipno.sPlaneIpAddress then IVIF_2.bitLength end) as Sync_Mask
			, group_concat(case when IVIF_2.localIpAddr=ipno.cPlaneIpAddress then IVIF_2.vlanId end) as CU_Vlan
			, group_concat(case when IVIF_2.localIpAddr=ipno.cPlaneIpAddress then IVIF_2.bitLength end) as CU_Mask
			from IPNO
			LEFT join (
						select ivif.*, ipmask.bitLength 
						from IVIF 
						left join ipmask on ipmask.mask=IVIF.netmask
						) IVIF_2 using (plmn_id, wbts_id, rnc_id)
			group by ipno.plmn_id, ipno.rnc_id, ipno.wbts_id,ipno.mPlaneIpAddress, ipno.cPlaneIpAddress, ipno.sPlaneIpAddress
			) as WCDMA_TRS using (PLMN_id, RNC_id, WBTS_id)

left join SRAN_TRS on SRAN_TRS.MRBTS_id=wbts.SBTSId and SRAN_TRS.wbtsId=wbts.WBTS_id

LEFT join (-- Modulos RF SW 3G Puro
		select PLMN_id, rnc_id, wbts_id, --rmCode as productName,
		count(*) ||" " || case when substr(RMOD.prodCode,1,7) like "475075A" then "AHPCA"
			when substr(RMOD.prodCode,1,7) like "474252A" then "AHHB"
			when substr(RMOD.prodCode,1,7) like "474649A" then "AHPC"
			when substr(RMOD.prodCode,1,7) like "473042A" then "FHFB"
			when substr(RMOD.prodCode,1,7) like "471894A" then "FRHA"
			when substr(RMOD.prodCode,1,7) like "472142A" then "FXCA"
			when substr(RMOD.prodCode,1,7) like "472166A" then	"FXFA"
			when substr(RMOD.prodCode,1,7) like "472656A" then	"FRHC"
			when substr(RMOD.prodCode,1,7) like "472678A" then	"FXCB"
			when substr(RMOD.prodCode,1,7) like "472679A" then	"FXFC"
			when substr(RMOD.prodCode,1,7) like "472746A" then	"FRHD"
			when substr(RMOD.prodCode,1,7) like "472830A" then	"FRHE"
			when substr(RMOD.prodCode,1,7) like "473225A" then	"FRHG"
			when substr(RMOD.prodCode,1,7) like "471266A" then "FRCA"
			when substr(RMOD.prodCode,1,7) like "471268A" then "FRCB"
			when substr(RMOD.prodCode,1,7) like "471017A" then "FRFA"
			when substr(RMOD.prodCode,1,7) like "471273A" then "FRFB"
			else prodCode end as NoRFModulesPerType,
			count(*) as NoRFModules
						from RMOD
			where wbts_id is not NULL
			group by plmn_id, rnc_id, wbts_id 
			) nonSRANRF using (PLMN_id, RNC_id, WBTS_id)
			
LEFT join (-- Modulos RF SW 3G SRAN
			select PLMN_id, MRBTS_id,
			group_concat(NoRFModulesPerType," + ") as HW_RF_AirScale, sum (NoRFModules) as totalRFModules
			from (	
				select RMOD_R.PLMN_id, RMOD_R.MRBTS_id, RMOD_R.productName,
				count(*) || " " || RMOD_R.productName as NoRFModulesPerType,
				count(*) as NoRFModules
				from RMOD_R
				group by RMOD_R.PLMN_id, RMOD_R.MRBTS_id, RMOD_R.productName
				)
			group by PLMN_id, MRBTS_id
			) SRANRF on SRANRF.mrbts_id = wbts.SBTSId
			
where WBTS_Name is not null and WBTS_Name NOT like "%Test%" and WBTS_Name not like "%Prueba%"
--where WBTS_Name like "BCA.Campestre-2:P2" or WBTS_Name like "BOG.CC Titan-2"--is not null

GROUP BY WBTS.PLMN_id, rnc.name , WBTS.RNC_id, wbts.SBTSId,  WBTS.WBTS_id, WBTS_Name
order by WBTS_Name, banda.FrequencyBand, wbts.wbts_id  asc