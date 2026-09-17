Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EAB43F4AD
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633624; cv=none; b=h3BKriS22hXKT3RPZ78+C4EL8vB67SEkS138HCFm3GCcmyAGO7hBMMtEawMp1ZsRZjt7Y/ykJ/xHygwkgwKYOezCKbSh5mpGledXtriJns69bumWkFYqK5PKl8qmQ6ufiBDiQ74mjG5XHep6i73UvV0Ua/1N6/4nCMTBxGRdaQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633624; c=relaxed/simple;
	bh=MBRiL0vm/6rpm5swfma4HBP028e3xACJbpCqLV2AG3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIcESNBaNfLcu75se+7CfcAwlDvvcYQhYm/p8UcGYAt+Tz0mEvS6N/xPCB8ezgvbYxzbc1ylfoBy0KmQhIO18eu7NyDOfIfVOgrBqFYkoffeCegIQL5PlPVKlNSrnnz4fOsWY0IxVzp62I7aaefDMq2IH3BnDvcwQ0N6Pc8+mPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BH+8ptR1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QaeBFvoD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BH+8ptR1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QaeBFvoD"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H61Y5l776821
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Xzd0lZhEwTRlepipaGN4+Fgl
	bMFrLPvj5XxbllAhoNs=; b=BH+8ptR1zXiXBGKuXeYehSihZJcvlRvq6eN8QRf7
	+iGPZAhx8HxgGTyoNpwFjJSin6/EhCnjoIkKxUCUYc5NanbRL4159uuvWvt8aIFS
	HmpSxlAj4IQ9cwUqGISUWfwlJ8eWVHH/hOEyWs1Qvpu7UOC8qbaMXQzRDgnmfpFx
	zEcJOHm50/1CYZWkFhgYaAO/7QDvAG3UB8U2UoLxt8o6OfihCuG8ji491E5/MLRy
	oIbxBje8PgfkOOwtmYG/QHxNOQfEgt3jDU3neBcGOed44J4ymoiyy25P9KvzH0+7
	tbxQ1p3xXey0a6BzSCguUHw4t5RfisIlC9KjGwK7qW2+rQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gquw2v9mp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:26:42 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93918756165so101342385a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633602; x=1790238402; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xzd0lZhEwTRlepipaGN4+FglbMFrLPvj5XxbllAhoNs=;
        b=QaeBFvoD7rK4U7Zgqqa2NC2vgf8hhR181zPLdeQLf1MzZgPObCu6u/5lZoYkStvL+D
         N3Ux1DrfYKehP+h68T5Zc0KXU6FBQVSgUUIWgqoLj8vQkYGEn69u9u2CTwYOku0MIAwb
         Oum7SP+qgWMVDMiBEPlYIr7ROxvSYNZ3B8bDVs3Krdwyprb2+JgiYLXcPJy81fMDisZD
         oTo+PQ2WisP+RE1DfR8k1n/VCLKyLBIR3MdK151htvHSmKKN7qo5Uk1xA/abey1RzxGO
         hveGiRpCgXzzOYWrLaCY1FlMXH/K6oJWy/UubT9iOUp6JBLZrPlbJ0igOCNUSJxLbrB2
         boTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633602; x=1790238402;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xzd0lZhEwTRlepipaGN4+FglbMFrLPvj5XxbllAhoNs=;
        b=1kx8ntv+gP8om7H4hRRWDS8fZuhXVuGX61sM/PwVFlTZqE3UiFiUapCeJOZdUBhuWx
         E1laoib3RsDC181Xm1ARQ4t3x30AHgzFlaK7/lIGde4UrevpZkYyJ69AkYjRI2vftOjE
         sAR3KremuBTEZhEfJq69ruEDBJGJpqwuXXAUjQGmlQ6AaTCg0U7swq0oJIP09TpG4+YF
         eTrCom8PFsyoVHGZ33N1HwNgnRWWGL79PdRHc+mRSpdCI6cRSIKxemPF1TIspaPVf+Td
         yZue8rACRpJ5ezHSnPuZWru+/G/BlAhxDB0ijPN7dnoLt7rMMrkT4vn6UvTQPa18pQww
         oS7g==
X-Forwarded-Encrypted: i=1; AKwUvBwQG7hqMeOhzKW6tPZ8Zti56QBYNiPLVNfRtNr8fWMctdQ25EsbORzedg7mw3bySWifwdFmbMhf1NU/7k6aIYk=@vger.kernel.org
X-Gm-Message-State: AFuF++n1OwD7nVulOPcT/NXc3nJ/DuLXTBdb55vEqO56ZZUknrTZsbt1
	yt/q3P1E0t3SAqLMLwYd1RcRxxj1N+sAc2pwJqR+CiwU4/M1v+VJIvm5aCpT5fMGnexF+u5s3bZ
	m5kNyYqGnZP8ewgTjubUoqIlJua9cGJLH2u/ObkM/xGUwOKV2AjlmA6M8qpIrk+zGHM+o3l4=
X-Gm-Gg: AYBFou3pHRTf1RqPGcmbVYK56FhQPTiTkg82RtByUiAg3YIsaP+2dLM+iYXgLsVwM/s
	6V95HT/SghW29LAlduolwKmKdVProhgbvaDZuedKjWBR10fvcwtLTrVB74Fa1SuEE2Ic5OCnPHJ
	xdIY7uQ3JzkY2OHATNgoJ7oqk8olpnI3r1iPHvdCDredKALTvRNqczuUqO3NcnHTLY7iZc2s+iT
	2PprvyvpYGzrSZb67fZHpfpS4yQ3l7wiJ3vj3bqn5DMQBmBCyRsOxUSWfdy7USgVVybZci20NBS
	mYMoCtFiyHXqLdX46yo0MkpCytYj8dxiyuTr3ho+lJNdBP5zPAq8n7SdBl8QHunq8Ic+ubbGXvP
	OOz8bi7HY7MN+o+m+5hDiQ2HNALh5hbJgZCENJQ==
X-Received: by 2002:a05:620a:46a3:b0:93a:11d8:cb56 with SMTP id af79cd13be357-93bb778a676mr1070361085a.23.1789633601554;
        Thu, 17 Sep 2026 01:26:41 -0700 (PDT)
X-Received: by 2002:a05:620a:46a3:b0:93a:11d8:cb56 with SMTP id af79cd13be357-93bb778a676mr1070352985a.23.1789633600053;
        Thu, 17 Sep 2026 01:26:40 -0700 (PDT)
Received: from localhost (77-32-99-124.dyn.eolo.it. [77.32.99.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd216028sm54680055e9.7.2026.09.17.01.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:26:39 -0700 (PDT)
Date: Thu, 17 Sep 2026 10:26:36 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 6/6] net: netfilter: nf_flow_table: unify
 tunnel push for IPv4 and IPv6
Message-ID: <aqukPF1TmZYXSybm@lore-qca>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
 <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-6-7c6ac1750725@oss.qualcomm.com>
 <aqsUrDjTeQBzW6gy@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UGIDED1mI4WIDnhG"
Content-Disposition: inline
In-Reply-To: <aqsUrDjTeQBzW6gy@chamomile>
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNCBTYWx0ZWRfX2MG0h94fqTbk
 fJeBiGFIWivRC+WFCpWRMel+xk4YFHaJCN5L6WD4yVj1mUsKz9GzeAL9HNMDDCEFRmgkc235GT+
 Skb9xvQ984TWbLX5v6qLal6SXqM29f0=
X-Proofpoint-GUID: 0_KcjQb4VPAFmpU8JpXB7i9KLqpGzL9K
X-Authority-Analysis: v=2.4 cv=N4m8hG9B c=1 sm=1 tr=0 ts=6aaba442 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=oN7owVyBLNHHe3W6XE6vpg==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=CfLf-wjJFVggsOm5SSoA:9 a=CjuIK1q_8ugA:10 a=tAqfI7mpyT1SnJ6y874A:9
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: 0_KcjQb4VPAFmpU8JpXB7i9KLqpGzL9K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNCBTYWx0ZWRfX8d8xdEGNT3DB
 EsohA57RagdMiPi6fzzeIunqvtHJUxUNfhRrjyc8cTcbgDu8nBwPzGQEZm+Xv990TKdSRQlod1z
 ZpSzsIr+eiG0pDmbnw9Z626qrBta75brAZzpFk525qs7n/vQnH7Gw+z+wcj6P+fEt1itd2UnCuB
 Npi07d65v8AASxLZqFxkgmMSVAIaSme5gJH1AA0Td1hnR8p9tgupdKPlNmOxTR3/KN9zW7+KE9u
 f5cnMQBZUpF/wNXvIhJG6XSFvEo6gL7p3HHfJVA995oYZ1ksOb735lzD/Unv8Wl3nOXMOptC/E3
 MdSEdjZ2VF48iyMHQHfzEpeoAcG/EzUA2jqpg/5IN6mfN4IvCwsSkMgouRVQiaGRllwAwCnG6yG
 drenN6KtuZecwQBCvT1n3TF3RMcSiikqO23W44sJQ2Tf9PkxCCYt9xPo7KUebxkZVLodyw/Efu2
 fu0GVgRnol73wMVeq1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170114

--UGIDED1mI4WIDnhG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Sep 07, 2026 at 09:33:41AM +0200, Lorenzo Bianconi wrote:
> > Refactor nf_flow_tunnel_ipip_push() and nf_flow_tunnel_ip6ip6_push()
> > into nf_flow_tunnel_ip_push() and nf_flow_tunnel_ip6_push(), keying the
> > inner header handling off tuple->tun.inner_proto so both IP-in-IP and
> > IPv6-in-IPv6 inner protocols are supported regardless of the outer
> > address family. Replace nf_flow_tunnel_v4_push() and
> > nf_flow_tunnel_v6_push() with a single nf_flow_tunnel_push() that
> > dispatches on tuple->tun.encap_proto, and set skb->protocol explicitly
> > after pushing the outer header.
> > This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
> > flowtable offload.
> > Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
> > enabled yet.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> > ---
> >  net/netfilter/nf_flow_table_ip.c | 129 ++++++++++++++++++++++++-------=
--------
> >  1 file changed, 81 insertions(+), 48 deletions(-)
> >=20
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_t=
able_ip.c
> > index 96dbdadba4e7..25875cc97bda 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -608,23 +608,41 @@ static int nf_flow_pppoe_push(struct sk_buff *skb=
, u16 id,
> >  	return 0;
> >  }
> > =20
> > -static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *s=
kb,
> > -				    struct flow_offload_tuple *tuple,
> > -				    struct dst_entry *dst, __be32 *ip_daddr)
> > +static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
> > +				  struct flow_offload_tuple *tuple,
> > +				  struct dst_entry *dst, __be32 *ip_daddr)
> >  {
> > -	struct iphdr *iph =3D (struct iphdr *)skb_network_header(skb);
> > -	struct rtable *rt =3D dst_rtable(dst);
> > -	u8 tos =3D iph->tos, ttl =3D iph->ttl;
> > -	__be16 frag_off =3D iph->frag_off;
> > -	u32 headroom =3D sizeof(*iph);
> > +	__be16 frag_off =3D 0;
> > +	struct iphdr *iph;
> > +	u8 tos =3D 0, ttl;
> > +	u32 headroom;
> >  	int err;
> > =20
> > +	switch (tuple->tun.inner_proto) {
> > +	case IPPROTO_IPV6: {
> > +		struct ipv6hdr *ip6h;
> > +
> > +		ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> > +		tos =3D ipv6_get_dsfield(ip6h);
> > +		ttl =3D ip6h->hop_limit;
> > +		frag_off =3D htons(IP_DF);
> > +		break;
> > +	}
> > +	default:
>=20
> Please add an explicit case to check for IPv4 here, ie. no default:

ack, I will fix it in v3.

>=20
> > +		iph =3D (struct iphdr *)skb_network_header(skb);
> > +		frag_off =3D iph->frag_off;
> > +		tos =3D iph->tos;
> > +		ttl =3D iph->ttl;
> > +		break;
> > +	}
> > +
> >  	err =3D iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
> >  	if (err)
> >  		return err;
> > =20
> > -	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
> > -	headroom +=3D LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
> > +	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
> > +	headroom =3D sizeof(*iph) + LL_RESERVED_SPACE(dst->dev) +
> > +		   dst->header_len;
> >  	err =3D skb_cow_head(skb, headroom);
> >  	if (err)
> >  		return err;
> > @@ -635,11 +653,12 @@ static int nf_flow_tunnel_ipip_push(struct net *n=
et, struct sk_buff *skb,
> >  	/* Push down and install the IP header. */
> >  	skb_push(skb, sizeof(*iph));
> >  	skb_reset_network_header(skb);
> > +	skb->protocol =3D htons(ETH_P_IP);
> > =20
> >  	iph =3D ip_hdr(skb);
> >  	iph->version	=3D 4;
> >  	iph->ihl	=3D sizeof(*iph) >> 2;
> > -	iph->frag_off	=3D ip_mtu_locked(&rt->dst) ? 0 : frag_off;
> > +	iph->frag_off	=3D ip_mtu_locked(dst) ? 0 : frag_off;
> >  	iph->protocol	=3D tuple->tun.inner_proto;
> >  	iph->tos	=3D tos;
> >  	iph->daddr	=3D tuple->tun.src_v4.s_addr;
> > @@ -654,57 +673,61 @@ static int nf_flow_tunnel_ipip_push(struct net *n=
et, struct sk_buff *skb,
> >  	return 0;
> >  }
> > =20
> > -static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
> > -				  struct flow_offload_tuple *tuple,
> > -				  struct dst_entry *dst,  __be32 *ip_daddr)
> > +static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *sk=
b,
> > +				   struct flow_offload_tuple *tuple,
> > +				   struct dst_entry *dst,
> > +				   struct in6_addr **ip6_daddr)
> >  {
> > -	if (tuple->tun_num)
> > -		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
> > -
> > -	return 0;
> > -}
> > -
> > -static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff =
*skb,
> > -				      struct flow_offload_tuple *tuple,
> > -				      struct dst_entry *dst,
> > -				      struct in6_addr **ip6_daddr)
> > -{
> > -	struct ipv6hdr *ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> > -	__u8 dsfield =3D ipv6_get_dsfield(ip6h);
> > -	struct rtable *rt =3D dst_rtable(dst);
> >  	struct flowi6 fl6 =3D {
> >  		.daddr =3D tuple->tun.src_v6,
> >  		.saddr =3D tuple->tun.dst_v6,
> > -		.flowi6_proto =3D IPPROTO_IPV6,
> > +		.flowi6_proto =3D tuple->tun.inner_proto,
> >  	};
> > -	u8 hop_limit =3D ip6h->hop_limit;
> > +	u8 hop_limit, dsfield;
> > +	struct ipv6hdr *ip6h;
> >  	int err, mtu;
> >  	u32 headroom;
> > =20
> > +	switch (tuple->tun.inner_proto) {
> > +	case IPPROTO_IPIP: {
> > +		struct iphdr *iph =3D (struct iphdr *)skb_network_header(skb);
> > +
> > +		dsfield =3D ipv4_get_dsfield(iph);
> > +		hop_limit =3D iph->ttl;
> > +		break;
> > +	}
> > +	default:
>=20
> Same here.

ack, I will fix it in v3.

>=20
> > +		ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> > +		dsfield =3D ipv6_get_dsfield(ip6h);
> > +		hop_limit =3D ip6h->hop_limit;
> > +		break;
> > +	}
> > +
> >  	err =3D iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
> >  	if (err)
> >  		return err;
> > =20
> > -	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
> > -	headroom =3D sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
> > -		   rt->dst.header_len;
> > +	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
> > +	headroom =3D sizeof(*ip6h) + LL_RESERVED_SPACE(dst->dev) +
> > +		   dst->header_len;
> >  	err =3D skb_cow_head(skb, headroom);
> >  	if (err)
> >  		return err;
> > =20
> >  	skb_scrub_packet(skb, true);
> > -	mtu =3D dst_mtu(&rt->dst) - sizeof(*ip6h);
> > +	mtu =3D dst_mtu(dst) - sizeof(*ip6h);
> >  	mtu =3D max(mtu, IPV6_MIN_MTU);
> >  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> > =20
> >  	skb_push(skb, sizeof(*ip6h));
> >  	skb_reset_network_header(skb);
> > +	skb->protocol =3D htons(ETH_P_IPV6);
> > =20
> >  	ip6h =3D ipv6_hdr(skb);
> >  	ip6_flow_hdr(ip6h, dsfield,
> >  		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
> >  	ip6h->hop_limit =3D hop_limit;
> > -	ip6h->nexthdr =3D IPPROTO_IPV6;
> > +	ip6h->nexthdr =3D tuple->tun.inner_proto;
> >  	ip6h->daddr =3D tuple->tun.src_v6;
> >  	ip6h->saddr =3D tuple->tun.dst_v6;
> >  	ipv6_hdr(skb)->payload_len =3D htons(skb->len - sizeof(*ip6h));
> > @@ -715,15 +738,20 @@ static int nf_flow_tunnel_ip6ip6_push(struct net =
*net, struct sk_buff *skb,
> >  	return 0;
> >  }
> > =20
> > -static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
> > -				  struct flow_offload_tuple *tuple,
> > -				  struct dst_entry *dst,
> > -				  struct in6_addr **ip6_daddr)
> > +static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
> > +			       struct flow_offload_tuple *tuple,
> > +			       struct dst_entry *dst, __be32 *ip_daddr,
> > +			       struct in6_addr **ip6_daddr)
> >  {
> > -	if (tuple->tun_num)
> > -		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
> > -
> > -	return 0;
> > +	switch (tuple->tun.encap_proto) {
> > +	case AF_INET:
> > +		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_daddr);
> > +	case AF_INET6:
> > +		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst,
> > +					       ip6_daddr);
> > +	default:
> > +		return 0;
> > +	}
> >  }
> > =20
> >  static int nf_flow_encap_push(struct sk_buff *skb,
> > @@ -830,6 +858,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
> >  	struct flow_offload_tuple *other_tuple;
> >  	enum flow_offload_tuple_dir dir;
> >  	struct nf_flow_xmit xmit =3D {};
> > +	struct in6_addr *ip6_daddr;
> >  	struct flow_offload *flow;
> >  	struct neighbour *neigh;
> >  	struct rtable *rt;
> > @@ -847,9 +876,11 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
> >  	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> >  	other_tuple =3D &flow->tuplehash[!dir].tuple;
> >  	ip_daddr =3D other_tuple->src_v4.s_addr;
> > +	ip6_daddr =3D &other_tuple->src_v6;
> > =20
> > -	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
> > -				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
> > +	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
> > +				tuplehash->tuple.dst_cache,
> > +				&ip_daddr, &ip6_daddr) < 0)
>=20
> See comment below regarding this.
>=20
> >  		return NF_DROP;
> > =20
> >  	switch (tuplehash->tuple.xmit_type) {
> > @@ -1158,6 +1189,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *sk=
b,
> >  	struct flow_offload *flow;
> >  	struct neighbour *neigh;
> >  	struct rt6_info *rt;
> > +	__be32 ip_daddr;
> > =20
> >  	if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM=
)) {
> >  		rt =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> > @@ -1170,11 +1202,12 @@ static int nf_flow_queue_xmit6(struct sk_buff *=
skb,
> >  	dir =3D tuplehash->tuple.dir;
> >  	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> >  	other_tuple =3D &flow->tuplehash[!dir].tuple;
> > +	ip_daddr =3D other_tuple->src_v4.s_addr;
> >  	ip6_daddr =3D &other_tuple->src_v6;
>=20
> IIRC this is pointing to the same address, it is a double fetch of the
> same pointer? See below:

right.

>=20
> > =20
> > -	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
> > -				   tuplehash->tuple.dst_cache,
> > -				   &ip6_daddr) < 0)
> > +	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
> > +				tuplehash->tuple.dst_cache,
> > +				&ip_daddr, &ip6_daddr) < 0)
>=20
> ... time to use union nf_inet_addr here instead of these two ip_daddr
> and ip6_daddr?

ack, I will fix it in v3.

Regards,
Lorenzo

>=20
> >  		return NF_DROP;
> > =20
> >  	switch (tuplehash->tuple.xmit_type) {
> >=20
> > --=20
> > 2.55.0
> >=20
> >=20

--UGIDED1mI4WIDnhG
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaqukPAAKCRA6cBh0uS2t
rE6aAPkByUjsGgNRLloQINA4vsc4PGd4+lCyt9oztLW75T3l2AD/d/SAc9GUUevf
HLXBamqmeMUdy2RZwrmUfPltFQ8G+wI=
=VFQP
-----END PGP SIGNATURE-----

--UGIDED1mI4WIDnhG--
