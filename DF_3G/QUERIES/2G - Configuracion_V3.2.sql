with SRAN_TRS as ( -- TRS 2G SW-SRAN
			select GNBCF.PLMN_id, GNBCF.MRBTS_id, GNBCF.bscId, GNBCF.bcfId
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
			
			from GNBCF
			left join WNBTS_CPLANELIST using (PLMN_id,MRBTS_id)
			left join TOP using (PLMN_id,MRBTS_id)
			left join TRSNW using (PLMN_id,MRBTS_id)
			left join MPLANENW using (PLMN_id,MRBTS_id)
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

--CODIGO --
			
select BCF.plmn_id as RC,  bsc.name as BSC_Name, bcf.name as BCF_Name, b.Band, a.Total_Sectores, A_TRX.Total_TRX, A_TRX.TRX_Sector, A_TRX.Potencia_Sector,

bcf.SBTSId as MRBTS_id, BCF.BCF_id, BCF.bsc_id
, (case when BCF.sbtsid is not null then GNBCF.mPlaneRemoteIpAddressOmuSig else PABTRS.mPlaneRemoteIpAddress end) as IP_BCSU
, (case when BCF.sbtsid is not null then GNBCF.sctpPortOmuSig else SCTP.minSctpPort end) as SCTP_OMU
, (case when BCF.sbtsid is not null then SRAN_TRS.GSM_VLAN else PABTRS.cPlaneVlanId end) as VLAN_GSM
, (case when BCF.sbtsid is not null then SRAN_TRS.GSM_IP else PABTRS.mPlaneLocalIpAddress end) as IP_GSM
, (case when BCF.sbtsid is not null then SRAN_TRS.GSM_MASK else PABTRS.mPlaneSubnetMask end) as MSK_GSM
, (case when BCF.sbtsid is not null then IPRT_2G_SRAN.gateway else PABTRS.cuPlaneGatewayIpAddress end) as Gateway_GSM
 
,b.ET_PCM, --b.Total_E1,
a.locationAreaIdLAC, a.RAC,
(case when bcf.abisInterfaceConnectionType=0 or bcf.abisInterfaceConnectionType is null then "Legacy Abis"
when bcf.abisInterfaceConnectionType=1 then "Packet Abis over TDM"
when bcf.abisInterfaceConnectionType=2 then "Packet Abis over Ethernet"
when bcf.abisInterfaceConnectionType=3 then "Packet Abis over TDM (LS HUB)"
when bcf.abisInterfaceConnectionType=4 then "Packet Abis over TDM (AGG HUB)"
when bcf.abisInterfaceConnectionType=5 then "Packet Abis over Ethernet - TDM"
when bcf.abisInterfaceConnectionType=6 then "Packet Abis over Ethernet - TDM (LS)" end) as ABIS_Type,
BCF.adminState, 

case when bcf.bcfType= 3 then "MetroSite"
 when bcf.bcfType= 4 then "InSite"
 when bcf.bcfType= 5 then "UltraSite"
 when bcf.bcfType= 6 then "Flexi EDGE"
 when bcf.bcfType= 7 then "BTSplus"
 when bcf.bcfType= 8 then "Flexi Multiradio"
 when bcf.bcfType= 9 then "Horizon" end as HW_Type

 ,case when bsc.extraTrxMaxTrxInBcsu = 700	then "Flexi_BSC"
 when bsc.extraTrxMaxTrxInBcsu = 110	then "BSC3i_660"
 when bsc.extraTrxMaxTrxInBcsu = 200	then "BSC3i_1000"
 when bsc.extraTrxMaxTrxInBcsu = 500	then "Flexi_BSC"
 when bsc.extraTrxMaxTrxInBcsu = 550	then "mcBSC" end as BSC_Type
 
--,case when bsc.extraTrxMaxTrxInBcsu=550 then substr(bsc.name,4,3) else substr(bsc.name,6,3) END as CCM

from BCF
left join BSC using (bsc_id, plmn_id)
left join (-- Banda
		   select plmn_id, bsc_id, bcf_id, group_concat(FrequencyBand, "+") as Band 
           from (select * from (
		                       select plmn_id, bsc_id, bcf_id, 
		                       (case when frequencyBandInUse=0 then 900 --Banda 1
									when frequencyBandInUse=1 then 1800
									when frequencyBandInUse=2 then 1900
									when frequencyBandInUse=5 then 800
									end
								) as FrequencyBand
                               from BTS
	                           ) group by plmn_id, bsc_id, bcf_id
				) group by plmn_id, bsc_id, bcf_id
			) as b using (bsc_id, plmn_id, bcf_id)
			 
left join (--Cantidad TRXs 
			select plmn_id, bsc_id, bcf_id,  sum(Cuenta_TRX) as Total_TRX, group_concat(Cuenta_TRX, " + ") as TRX_Sector, group_concat(Potencia, " + ") as Potencia_Sector
			from (select  plmn_id, bsc_id, bcf_id, bts_id, count(trx_id) as Cuenta_TRX , sum(trx.trxrfpower)/1000 as Potencia
				  from trx
				  group by plmn_id, bsc_id, bcf_id, bts_id
				  order by bsc_id, bcf_id, bts_id asc
					) 
			group by plmn_id, bsc_id, bcf_id
			) as A_TRX using (bsc_id, plmn_id, bcf_id)

left join (-- Total Sectores
		   select bts.plmn_id, bts.bsc_id, bts.bcf_id, bts.locationAreaIdLAC, bts.RAC, count(bts.name) as Total_Sectores 
		   from BTS 
		   group by bts.plmn_id, bts.bsc_id, bts.bcf_id, bts.locationAreaIdLAC, bts.RAC
		   ) as a USING (bsc_id, plmn_id, bcf_id)

left join (--ET PCM
			select plmn_id, bsc_id, bcf_id,count(channel0Pcm) as Total_E1, group_concat(channel0Pcm," - ") as ET_PCM
			from(select plmn_id, bsc_id, bcf_id,channel0Pcm 
				from TRX 
				group by plmn_id, bsc_id, bcf_id
				) 
			group by plmn_id, bsc_id, bcf_id
			order by bsc_id
			) as b using (bsc_id, plmn_id, bcf_id)

left join SCTP USING (bsc_id, plmn_id, bcf_id)

left join PABTRS USING (bsc_id, plmn_id, bcf_id)

left join SRAN_TRS ON SRAN_TRS.bscId=BCF.BSC_id and SRAN_TRS.bcfId=BCF.BCF_id and SRAN_TRS.MRBTS_id=BCF.SBTSId

left join GNBCF ON GNBCF.bscId=BCF.BSC_id and GNBCF.bcfId=BCF.BCF_id and GNBCF.MRBTS_id=BCF.SBTSId

left join (-- Rutas estáticas 2G SRAN
			SELECT gnbcf.mrbts_id as SBTSId, gnbcf.bscId as BSC_id, gnbcf.bcfId as BCF_id,
			CAST(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')-1) AS INTEGER) || "." || --as Octeto_1,
			CAST(substr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)) ,1, instr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
			CAST(substr(substr(trim(GSM_IP),length(substr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)) ,1, instr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)),'.')))+length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)) ,1, instr(substr(trim(GSM_IP),length(substr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)) ,1, instr(substr(trim(GSM_IP),length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)),'.')))+length(substr(trim(GSM_IP),1,instr(trim(GSM_IP),'.')))+1,length(GSM_IP)),'.')-1) AS INTEGER) || "." as IP_C,--as Octeto_3

			GSM_IP,gateway,
			CAST(substr(trim(gateway),1,instr(trim(gateway),'.')-1) AS INTEGER) || "." || --as Octeto_1,
			CAST(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." ||--as Octeto_2,
			CAST(substr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)) ,1, instr(substr(trim(gateway),length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')))+length(substr(trim(gateway),1,instr(trim(gateway),'.')))+1,length(gateway)),'.')-1) AS INTEGER) || "." as IP_Gateway
			from GNBCF
			left join SRAN_TRS using (plmn_id, mrbts_id, bscId, bcfId)
			LEFT join IPRT_STATICROUTES using (plmn_id, MRBTS_id)
			where IP_C = IP_Gateway 
			group by gnbcf.mrbts_id, gnbcf.plmn_id, gnbcf.bscId, gnbcf.bcfId
			) IPRT_2G_SRAN using (bsc_id, bcf_id, SBTSId)


--where --BCF.name like "%CAQ.Remolinos%" or BCF.name like "%CAQ.Penas Coloradas%"
where bcf.name is not NULL and  bcf.name not like "%Prueb%" and bcf.name not like "%test%"

group by bcf.plmn_id, bcf.bsc_id, bsc.name, BCF.BCF_id, bcf.name--, a.Total_Sectores , a.locationAreaIdLAC, a.RAC, ABIS_Type
order by bcf.name, BCF.BCF_id ASC