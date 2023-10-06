select DISTINCT nrbts.PLMN_id as RC_5G, nrbts.MRBTS_id as MRBTSID_5G, 
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
nrbts.moVersion,
	--MPLANENW.mPlaneIpAddressDN, 
	(case when like("%IPIF-1%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF1 when like("%IPIF-2%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF2 when like("%IPIF-3%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF3 when like("%IPIF-4%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF4 when like("%IPIF-5%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF5 when like("%IPIF-6%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF6 when like("%IPIF-7%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF7 when like("%IPIF-8%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then IPIF8 end)as mPlaneIP,
	(case when like("%IPIF-1%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK1 when like("%IPIF-2%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK2 when like("%IPIF-3%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK3 when like("%IPIF-4%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK4 when like("%IPIF-5%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK5 when like("%IPIF-6%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK6 when like("%IPIF-7%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK7 when like("%IPIF-8%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then MASK8 end)as mPlaneMask,
	(case when like("%IPIF-1%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN1 when like("%IPIF-2%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN2 when like("%IPIF-3%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN3 when like("%IPIF-4%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN4 when like("%IPIF-5%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN5 when like("%IPIF-6%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN6 when like("%IPIF-7%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN7 when like("%IPIF-8%",case when MPLANENW.mPlaneIpAddressDN is not null then MPLANENW.mPlaneIpAddressDN else MPLANENW.mPlaneIpv4AddressDN end) then VLAN8 end)as mPlaneVLAN,

    --NRBTS_X2CPLANE as LTECP,
	(case when like("%IPIF-1%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF1 when like("%IPIF-2%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF2 when like("%IPIF-3%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF3 when like("%IPIF-4%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF4 when like("%IPIF-5%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF5 when like("%IPIF-6%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF6 when like("%IPIF-7%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF7 when like("%IPIF-8%",NRBTS_X2CPLANE.ipV4AddressDN1) then IPIF8 end)as cPlaneIP,
	(case when like("%IPIF-1%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK1 when like("%IPIF-2%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK2 when like("%IPIF-3%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK3 when like("%IPIF-4%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK4 when like("%IPIF-5%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK5 when like("%IPIF-6%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK6 when like("%IPIF-7%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK7 when like("%IPIF-8%",NRBTS_X2CPLANE.ipV4AddressDN1) then MASK8 end)as cPlaneMask,
	(case when like("%IPIF-1%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN1 when like("%IPIF-2%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN2 when like("%IPIF-3%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN3 when like("%IPIF-4%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN4 when like("%IPIF-5%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN5 when like("%IPIF-6%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN6 when like("%IPIF-7%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN7 when like("%IPIF-8%",NRBTS_X2CPLANE.ipV4AddressDN1) then VLAN8 end)as cPlaneVLAN,
	--NRBTS_X2UPLANE as LTEUP, 
	(case when like("%IPIF-1%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF1 when like("%IPIF-2%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF2 when like("%IPIF-3%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF3 when like("%IPIF-4%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF4 when like("%IPIF-5%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF5 when like("%IPIF-6%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF6 when like("%IPIF-7%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF7 when like("%IPIF-8%",NRBTS_X2UPLANE.ipV4AddressDN1) then IPIF8 end)as uPlaneIP,
	(case when like("%IPIF-1%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK1 when like("%IPIF-2%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK2 when like("%IPIF-3%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK3 when like("%IPIF-4%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK4 when like("%IPIF-5%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK5 when like("%IPIF-6%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK6 when like("%IPIF-7%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK7 when like("%IPIF-8%",NRBTS_X2UPLANE.ipV4AddressDN1) then MASK8 end)as uPlaneMask,
	(case when like("%IPIF-1%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN1 when like("%IPIF-2%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN2 when like("%IPIF-3%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN3 when like("%IPIF-4%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN4 when like("%IPIF-5%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN5 when like("%IPIF-6%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN6 when like("%IPIF-7%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN7 when like("%IPIF-8%",NRBTS_X2UPLANE.ipV4AddressDN1) then VLAN8 end)as uPlaneVLAN
	 from NRBTS
	LEFT join MPLANENW USING (plmn_id, mrbts_id) --on MPLANENW.PLMN_id=NRBTS.PLMN_id and MPLANENW.MRBTS_id=NRBTS.MRBTS_id
	left join mrbts USING (plmn_id, mrbts_id)
	left join NRBTS_X2UPLANE USING (plmn_id, mrbts_id) --on NRBTS_X2UPLANE.PLMN_id=NRBTS.PLMN_id and NRBTS_X2UPLANE.MRBTS_id=NRBTS.MRBTS_id
	left join NRBTS_X2CPLANE USING (plmn_id, mrbts_id) --on NRBTS_X2CPLANE.PLMN_id=NRBTS.PLMN_id and NRBTS_X2CPLANE.MRBTS_id=NRBTS.MRBTS_id
	left join (
				select 	PLMN_id, MRBTS_id,
				group_concat(case when cast(IPIF_id as numeric)=1 then localIpAddr end) as IPIF1,
				group_concat(case when cast(IPIF_id as numeric)=2 then localIpAddr end) as IPIF2,
				group_concat(case when cast(IPIF_id as numeric)=3 then localIpAddr end) as IPIF3,
				group_concat(case when cast(IPIF_id as numeric)=4 then localIpAddr end) as IPIF4,
				group_concat(case when cast(IPIF_id as numeric)=5 then localIpAddr end) as IPIF5,
				group_concat(case when cast(IPIF_id as numeric)=6 then localIpAddr end) as IPIF6,
				group_concat(case when cast(IPIF_id as numeric)=7 then localIpAddr end) as IPIF7,
				group_concat(case when cast(IPIF_id as numeric)=8 then localIpAddr end) as IPIF8,
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
					SELECT IPIF.PLMN_id, IPIF.MRBTS_id, IPIF.IPIF_id, VLANIF.VLANIF_id, VLANIF.vlanId, IPADDRESSV4.localIpAddr, IPADDRESSV4.localIpPrefixLength from IPIF
					left join VLANIF on VLANIF.PLMN_id=IPIF.PLMN_id and VLANIF.MRBTS_id=IPIF.MRBTS_id and substr(IPIF.interfaceDN,instr(IPIF.interfaceDN, "VLANIF-")+7)=VLANIF.VLANIF_id
					join IPADDRESSV4 on IPADDRESSV4.PLMN_id=IPIF.PLMN_id and IPADDRESSV4.MRBTS_id=IPIF.MRBTS_id and IPADDRESSV4.IPIF_id=IPIF.IPIF_id where  VLANIF.vlanId > 1 
					)
					group by PLMN_id, MRBTS_id
				) as IPIFVLAN USING (plmn_id, mrbts_id) --on IPIFVLAN.PLMN_id=NRBTS.PLMN_id and IPIFVLAN.MRBTS_id=NRBTS.MRBTS_id
	 
where  NRBTS.actEcpriPhase2=1 and NRBTS.actEcpriPhase3=1
group by nrbts.PLMN_id, nrbts.MRBTS_id
order by Name_5G ASC