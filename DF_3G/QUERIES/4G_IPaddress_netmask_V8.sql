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
select plmn_id, lnbts_id, group_concat(FrequencyBand, "+") as Bands from (
	select * from (
		select distinct PLMN_id as PLMN_id, LNBTS_id as lnbts_id, 
		(case  
		  when (earfcn>=0 and earfcn<=599) then 2100 --Banda 1
		  when (earfcn>=600 and earfcn<=1199) then 1900 --Banda 2
		  when (earfcn>=1200 and earfcn<=1949) then 1800 --Banda 3
		  when (earfcn>=1950 and earfcn<=2399) then 2100 --Banda 4
		  when (earfcn>=2400 and earfcn<=2649) then 850 --Banda 5
		  when (earfcn>=2650 and earfcn<=2749) then 850 --Banda 6
		  when (earfcn>=2750 and earfcn<=3449) then 2600 --Banda 7
		  when (earfcn>=3450 and earfcn<=3799) then 900 --Banda 8
		  when (earfcn>=3800 and earfcn<=4149) then 1800 --Banda 9
		  when (earfcn>=4150 and earfcn<=4749) then 2100 --Banda 10
		  when (earfcn>=4750 and earfcn<=4949) then 1450 --Banda 11
		  when (earfcn>=5010 and earfcn<=5179) then 700 --Banda 12
		  when (earfcn>=5180 and earfcn<=5279) then 750 --Banda 13
		  when (earfcn>=5280 and earfcn<=5379) then 750 --Banda 14
		  when (earfcn>=5730 and earfcn<=5849) then 700 --Banda 17
		  when (earfcn>=5850 and earfcn<=5999) then 850 --Banda 18
		  when (earfcn>=6000 and earfcn<=6149) then 850 --Banda 19
		  when (earfcn>=6150 and earfcn<=6449) then 800 --Banda 20
		  when (earfcn>=7700 and earfcn<=8039) then 1550 --Banda 24
		  when (earfcn>=8040 and earfcn<=8689) then 1900 --Banda 25
		  when (earfcn>=8690 and earfcn<=9039) then 850 --Banda 26
		  when (earfcn>=9040 and earfcn<=9209) then 850 --Banda 27
		  when (earfcn>=9210 and earfcn<=9659) then 750 --Banda 28
		  when (earfcn>=9660 and earfcn<=9769) then 700 --Banda 29
		  when (earfcn>=9770 and earfcn<=9869) then 2350 --Banda 30
		  when (earfcn>=9870 and earfcn<=9919) then 450 --Banda 31
		  when (earfcn>=9920 and earfcn<=10359) then 1450 --Banda 32
		  when (earfcn>=46790 and earfcn<=47789) then "5G46a"--Banda 46a
		  when (earfcn>=47790 and earfcn<=48789) then "5G46b"--Banda 46b
		  when (earfcn>=49990 and earfcn<=52539) then "5G46c"--Banda 46c
		  when (earfcn>=52640 and earfcn<=53639) then "5G46d"--Banda 46d
		  when (earfcn>=66436 and earfcn<=67335) then 2100 --Banda 66
		  else earfcn
		  end) FrequencyBand
		 from (
			select plmn_id, lncel.mrbts_id, lncel.sbts_id, lnbts_id, lncel_id, 
			case when LNCEL.earfcnDL is null then LNCEL_FDD.earfcnDL else LNCEL.earfcnDL end as earfcn
			from LNCEL
			left join LNCEL_FDD using (plmn_id, lnbts_id, lncel_id)
		 )
	) group by plmn_id, lnbts_id, FrequencyBand
) group by plmn_id, lnbts_id
),

gNB as (
		select distinct nrbts.PLMN_id as RC_5G, nrbts.MRBTS_id as MRBTSID_5G, nrbts.moVersion,
		case when nrbts.name is not null then nrbts.name else mrbts.btsName end as Name_5G, 
		case when nrbts.operationalState = 0 then "initializing"
			 when nrbts.operationalState = 1 then "commissioned"
			 when nrbts.operationalState = 3 then "configured"
			 when nrbts.operationalState = 4 then "integrated to RAN"
			 when nrbts.operationalState = 5 then "onAir"
			 when nrbts.operationalState = 6 then "test"
			 when nrbts.operationalState = 7 then "notCommissioned"
			 when nrbts.operationalState = 10 then "disabled"
			 when nrbts.operationalState = 11 then "enabled" end as Status_gNB,
		nrcell.freqBandIndicatorNr,NRBTS.actEcpriPhase2,NRBTS.actEcpriPhase3,
		a.*

		from NRBTS
		left join mrbts USING (plmn_id, mrbts_id)
		left join NRCELL using (PLMN_ID,NRBTS_ID)
		left join (
					select   LNADJGNB.cPlaneIpAddr as IP_CP_5G, LNADJGNB.x2ToGnbLinkStatus , LNADJGNB.adjGnbId, LNADJGNB.mrbts_id as MRBTS_4G, 
					(case when lnbts.name is null then lnbts.enbName else lnbts.name END) as Name_4G
					from LNADJGNB
					left join lnbts using (plmn_id, mrbts_id)
					) as a on a.adjGnbId=nrbts.mrbts_id
		where nrcell.freqBandIndicatorNr = 78 and (NRBTS.actEcpriPhase2=1 or NRBTS.actEcpriPhase3=1)
		order by Name_5G ASC

),
		
SRAN_TRS as ( -- TRS 3G SW-SRAN
			select lnbts.PLMN_id, lnbts.MRBTS_id, wnbts.wbtsId
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
			
			from LNBTS
			left join WNBTS_CPLANELIST using (PLMN_id,MRBTS_id)
			left join WNBTS using (PLMN_id,MRBTS_id)
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

-- CODIGO --

select lnbts.plmn_id, lnbts.mrbts_id, lnbts.lnbts_id, case when gNB.Status_gNB is not null then "5G_" || gNB.Status_gNB else "" end as Status_5G, (case when lnbts.name is null then lnbts.enbName else lnbts.name END) as eNB_Name, Bands, lnbts.moVersion
, case when FLSW.mAddress is null then SRAN_TRS.SRAN_IP_OAM else FLSW.mAddress end as mPlaneIP
, case when FLSW.mPrefix is null then SRAN_TRS.SRAN_MASK_OAM else FLSW.mPrefix end as mPlanePrefix
, case when FLSW.mVlan is null then SRAN_TRS.SRAN_VLAN_OAM else FLSW.mVlan end as mPlaneVLAN
, case when FLSW.cAddress is null then SRAN_TRS.SRAN_IP_CP else FLSW.cAddress end as cPlaneIP
, case when FLSW.cPrefix is null then SRAN_TRS.SRAN_MASK_CP else FLSW.cPrefix end as cPlanePrefix
, case when FLSW.cVlan is null then SRAN_TRS.SRAN_VLAN_CP else FLSW.cVlan end as cPlaneVLAN
, case when FLSW.uAddress is null then SRAN_TRS.SRAN_IP_UP else FLSW.uAddress end as uPlaneIP
, case when FLSW.uPrefix is null then SRAN_TRS.SRAN_MASK_UP else FLSW.uPrefix end as uPlanePrefix
, case when FLSW.uVlan is null then SRAN_TRS.SRAN_VLAN_UP else FLSW.uVlan end as uPlaneVLAN
, case when FLSW.sAddress is null then SRAN_TRS.SRAN_IP_SYNC else FLSW.sAddress end as sPlaneIP
, case when FLSW.sPrexif is null then SRAN_TRS.SRAN_MASK_SYNC else FLSW.sPrexif end as sPlane_Prefix
, case when FLSW.sVlan is null then SRAN_TRS.SRAN_VLAN_SYNC else FLSW.sVlan end as sPlaneVLAN
, case when TOPF_TOPMASTERS.masterIpAddr is null then TOPF_TOPMASTERLIST.masterIpAddr else TOPF_TOPMASTERS.masterIpAddr end as IPGM_Clock
, SYNC_SRAN_Mode.Sync_Mode
, SYNC_SRAN_Type.Type_Sync
, case when lnbts.actInterEnbDLCAggr=0 then "false" when lnbts.actInterEnbDLCAggr=1 then "true" else "" end as actInterEnbDLCAggr	
,SRAN_TRS.WCDMA_IP_CU AS WCDMA_CU_PlaneIP
,SRAN_TRS.WCDMA_MASK AS WCDMA_Prefix
,SRAN_TRS.WCDMA_VLAN AS WCDMA_VLAN
,gNB.Name_5G, gNB.MRBTSID_5G, gNB.moVersion as SWVersion_5G

from LNBTS
left join gNB on lnbts.MRBTS_id=gNB.MRBTS_4G
left join LNADJGNB using (plmn_id, mrbts_id) 
left join SRAN_TRS using (plmn_id, mrbts_id) 
left join TOPF_TOPMASTERS using (plmn_id, mrbts_id) 
left join TOPF_TOPMASTERLIST using (plmn_id, mrbts_id)

left join (-- Tipo de sincronismo SRAN
			select  plmn_id, mrbts_id, 
			group_concat(case syncInputType
						when 1 then "1pps/ToD Sync Hub Master"
						when 2 then "1pps/ToD external GNSS receiver"
						when 3 then "internal GNSS receiver"
						when 4 then "2.048MHz input"
						--when 5 then "Revisar TRS"
						when 8 then "1pps/ToD from backplane"
						when 10 then "PDH-1"
						when 11 then "PDH-2"
						when 12 then "SYNCE-1"
						when 13 then "SYNCE-2"
						when 14 then "TOPF"
						when 15 then "TOPP"
						else "Revisar SCF" end, " + ") as Type_Sync
			from CLOCK_SYNCINPUTLIST 
			group by plmn_id, MRBTS_id
			) as SYNC_SRAN_Type using (plmn_id, mrbts_id)
			
left join ( --SW LTE PURO --FL18 & FL18
			select plmn_id, mrbts_id, lnbts_id, max(mPlaneIpAddress) as mAddress, max(mPlaneVlanId) as mVlan, max(mPlaneVlanMask) as mPrefix, 
			max(cPlaneIpAddress) as cAddress, max(cPlaneVlanId) as cVlan, max(cPlaneVlanMask) as cPrefix, 
			max(uPlaneIpAddress) as uAddress, max(uPlaneVlanId) as uVlan, max(uPlaneVlanMask) as uPrefix, 
			max(sPlaneIpAddress) as sAddress, max(sPlaneVlanId) as sVlan, max(sPlaneVlanMask) as sPrexif
			from (
				select lnbts.plmn_id, lnbts.mrbts_id, lnbts.lnbts_id, 
				case when IVIF.localIpAddr = IPNO.mPlaneIpAddress then mPlaneIpAddress else null end as mPlaneIpAddress,
				case when IVIF.localIpAddr = IPNO.mPlaneIpAddress THEN VLANid ELSE NULL END AS mPlaneVlanId,
				case when IVIF.localIpAddr = IPNO.mPlaneIpAddress THEN bitLength ELSE NULL END AS mPlaneVlanMask,
				case when IVIF.localIpAddr = IPNO.cPlaneIpAddress then cPlaneIpAddress else null end as cPlaneIpAddress, 
				case when IVIF.localIpAddr = IPNO.cPlaneIpAddress THEN VLANid ELSE NULL END AS cPlaneVlanId,
				case when IVIF.localIpAddr = IPNO.cPlaneIpAddress THEN bitLength ELSE NULL END AS cPlaneVlanMask,
				case when IVIF.localIpAddr = IPNO.uPlaneIpAddress THEN uPlaneIpAddress else null end as uPlaneIpAddress, 
				case when IVIF.localIpAddr = IPNO.uPlaneIpAddress THEN VLANid ELSE NULL END AS uPlaneVlanId,
				case when IVIF.localIpAddr = IPNO.uPlaneIpAddress THEN bitLength ELSE NULL END AS uPlaneVlanMask,
				case when IVIF.localIpAddr = IPNO.sPlaneIpAddress THEN sPlaneIpAddress else null end as sPlaneIpAddress, 
				case when IVIF.localIpAddr = IPNO.sPlaneIpAddress THEN VLANid ELSE NULL END AS sPlaneVlanId,
				case when IVIF.localIpAddr = IPNO.sPlaneIpAddress THEN bitLength ELSE NULL END AS sPlaneVlanMask
				from LNBTS
				left join IPNO using (plmn_id, mrbts_id)
				left join IVIF on IVIF.MRBTS_id=LNBTS.MRBTS_id and IVIF.PLMN_id=LNBTS.PLMN_id 
							and (IVIF.localIpAddr = IPNO.sPlaneIpAddress or IVIF.localIpAddr = IPNO.mPlaneIpAddress or IVIF.localIpAddr = IPNO.cPlaneIpAddress or IVIF.localIpAddr = IPNO.uPlaneIpAddress)
				left join ipmask on ipmask.mask = IVIF.netmask
				) group by plmn_id, mrbts_id, lnbts_id
			) as FLSW using (plmn_id, mrbts_id, lnbts_id)

LEFT join banda using (plmn_id, lnbts_id)
LEFT join (-- Modo de Sincronismo
			SELECT plmn_id, mrbts_id, btsSyncMode
			, case btsSyncMode
			when 0 then "FreqSync"
			when 1 then "PhaseSync"
			when 2 then "LoosePhaseAndTimeSync" end as Sync_Mode
			FROM SYNC 
			where btsSyncMode is not null
			) as SYNC_SRAN_Mode using (MRBTS_id, PLMN_id)

where eNB_Name is not NULL and eNB_Name NOT like "%Test%" and eNB_Name not like "%Prueba%"
--where mrbts_id= 12944
-- or mrbts_id=786690
group by lnbts.plmn_id, lnbts.mrbts_id, lnbts.lnbts_id
order by eNB_Name, mPlaneIP asc -- Bands, lnbts.mrbts_id asc