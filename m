Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E6141C2FF
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766462; cv=none; b=iAnt4NPSypu+CGcvPVCzay3XFLwejimwBk9mzz6XVlJokSgJJ/Qpu7esLI1QnCkCIbrpiu2OmFCErGXb7FbD667NegLStyqgP3vJU54fjJJPORJwFgty1W1GwMcqgf7W7BR1/7yVoWYZ/sNp0j2k8Or8kxb3vMNSipT8c/DB4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766462; c=relaxed/simple;
	bh=J/qZDA+3Sj8IOJgS+POL7nD4CdkycpXlSGgYjfOBgSE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BnGz/3nQmQn//p3J2JofkBCHGoWFWN4tyidSjQYcDDecE7gYWcxZeMYOdS0qnDVI0NW6wLgs3M7Gi4I8eyTSEnFenyS2uihe15zgOgR6BXhZ91iOvD9jrHZbKgfifW0zOBig/Dzkb9PO1X/DSXI1pdO8hf2gH7OrHJjPdWBd43k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OyJJd4ho; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V294mhSD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OyJJd4ho";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V294mhSD"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777LQI3363500
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	giM2soSPIq+JmCyfXubWWdgQ+V4EmIYWdfUvpqFaCQU=; b=OyJJd4hoMe1eDbax
	odpYHCLJI9GjYda6rVtZvEAPnokygJbmGj5OYMSQdv+bAXRIByJvei86kTFVCt2z
	now/uCz5DA+QcH8KbGryhD8tCro86zgJlTq7NKOj0XJ6X/mb7OzvAhghkb0h3Nes
	VGyJn5F1ln51zA14ODYWGHlAWAAq4TuDwL/LiVp0dXNUdPlV1dVlaMAMD8OzxCpG
	jCCzGBZ+e3EAaYE6eNTmbLy0LbJC/cxhpcAL458qkfsj3FbhQEVxRL0EfqZdKU6L
	SSOD98yyZ/oAfubL1cmsueE7+kctufxFdzGXcwS7CK4U4Myhj9uGdurp8VPyYxya
	NvH1jw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghnmj0t36-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:34:20 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93771aa0379so676385285a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766459; x=1789371259; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=giM2soSPIq+JmCyfXubWWdgQ+V4EmIYWdfUvpqFaCQU=;
        b=V294mhSDkWrbtq/TSUxTiMMldZP605SLlXralheHLXkm68qjbfaVlAuiW4vwZjddzK
         X6PZniTgBLTu7C4L7khciF1gyJLIngod02hbcMCFCbU6/5g8rxko5w9ldI3CxnSiPxlU
         hIlNmifYPhFrYrclP4vNPmYJp9+AkReJUS++2L0jto8cPhs5D5QpXllL/a2H5DPOiki8
         xctM4JLf1t1shmE5WNmKdCzIpz7vrPbjox2q+9QZY5J2eR0gR0wb9lnu8TkdS85nT6jW
         ZMfAu+JGHz4gnyY23R8yYxqavrvMyXNDu+jQsTD5Wp9tBlIrlHhmNApkeagXRdYBvgjo
         XUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766459; x=1789371259;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=giM2soSPIq+JmCyfXubWWdgQ+V4EmIYWdfUvpqFaCQU=;
        b=oH8konmzz5YTPYIQIid8/+MM/CirRoHHqVSxH0um6GHxpxCDlxllokYXnlEhE+UFoW
         0ek8827hrLDWPWjRQUrZoL2mDh+PUWJhRGeFjEkGluxz6WPN7yHGVg3lL7lCIp1EHwH7
         yZdqojgYy1/XRwkxuiUQjnKOoN5gtcWhUe8ixo24/0wtRnlwwVxijc4DtTcYLB5TmD7P
         HbrffDVTb/h3HS6DuoPkGziU+mVPsXw6r33B+5JiHyGeTKE3+leHY6uQlYwTsKmzxwwN
         yhY3SW1oQhfmShHpctmEH7hNH1KAwBpkpE+o7A/UKUpoC4/0yDQyGNVIyhMM+vr5zYMT
         XNyw==
X-Gm-Message-State: AFuF++m+xFR+EibZ75/6w+lSIkVmsXYrYiXGenOPVirleOQInPQggrdp
	XUwCVnau3/XPUNLHKFgdl3DdauWM9++jnCmivicH0tnfGVXpAziC40fF/VnVYkCO8Fe2J/5J0Np
	Tp+a+qBu06PdZGaPhQCHVEa6acnF0VCG+cxdEOxyhaLCDH/z6ckfoN+HdxNq8Ot4HtmpY+kA=
X-Gm-Gg: AYBFou2O5InSimpt2vF/+PWrOIFcjT1GK06Ibqpuei+ut4s5XS8VaKLiu+4xVOZGdJk
	1Nsgpb0TpciCvjRuzBK3SFGQUgR0yH3S/LUHiiHuPApU3ZOFGGC6WCSIdPonL4J2AkWVw9fflQ5
	9FwQNUBpONLNpYNaQWEHa5TYRUE2pnriFEi6EH9VTmhz0l2TreIR8VtAKyoYwUMFv/Pz/OWW4h9
	7PzVQlyZGJDrCgnbXV6DFF8j41T4dBCLSj4jCVm/TmqJtvU0C0D/qGqMMPY162u6wTvx+U+NF0p
	yWlmWl1GBPu2t0BFv7SVPcnzmWGNPtqUx6mXFJCB4HB8HlNipFb247231LodotIE/EfCEaXkfqu
	6VVUOSAB5Bj6UDw==
X-Received: by 2002:a05:620a:3199:b0:92e:bc28:5479 with SMTP id af79cd13be357-939802f299fmr2239790285a.2.1788766459312;
        Mon, 07 Sep 2026 00:34:19 -0700 (PDT)
X-Received: by 2002:a05:620a:3199:b0:92e:bc28:5479 with SMTP id af79cd13be357-939802f299fmr2239784485a.2.1788766458734;
        Mon, 07 Sep 2026 00:34:18 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ac2b4cdsm25435621f8f.16.2026.09.07.00.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:16 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 09:33:41 +0200
Subject: [PATCH nf-next v2 6/6] net: netfilter: nf_flow_table: unify tunnel
 push for IPv4 and IPv6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-6-7c6ac1750725@oss.qualcomm.com>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
In-Reply-To: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfXypcyB4sW9ljI
 WY/nWt7shCPHDJ0YV00rqJLnCqPykhxBaw8V5oG0O2Yr148DqeAsCynR9Rc4XZ3ELpmPrXRemvQ
 dBySObXV3vpp7eyuV76p3ushc4vmdPpeZzT44w1xkgLs3W+y34j6kjXtcfZxkfPQSzo3aOnNuE4
 tRf39PcAyhXCVuIi6OHQbkhPlTCJmoVr3zQ5CqCCIvTkAXC0V11Z/dBijmXR5ZreQU90ufnHVn8
 GHHyYbmYR3O9q1wr6ra8U6MsQg0YKQFkxmUAqyhC31h/x0JA2DZcrl8CmV6Z1LzXZja27ZHG5NL
 1GAoZPL5A4p1zfA2Y7AFf0K/llCrra6UGD3mBhALp4BVPdpX5BS7mY/kvnLcmA6n6gnTvadmHFL
 tOmvZ0nP1H32yu2e+qneMJzlqgIxo/GUmd9iIAGIzIjcNCFBPtW6+IqjOdCNOPHu9enzO4356kg
 CLAJLbteM5+mVbXdECQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfX3mazb9JmAe9p
 0nSWtrS4q4fXoQfjnfhrlsqerP8KYJMn5ZWsA1dHIn7PmJ2A0pER/Qqw0QVF+RVtxuH8DmMj/aa
 TU9YGpdon1KOa95M2kFB+v10n7sN7lQ=
X-Proofpoint-ORIG-GUID: a62LxLfHVua_oKirvRwEhoOHqDh5fz-J
X-Proofpoint-GUID: a62LxLfHVua_oKirvRwEhoOHqDh5fz-J
X-Authority-Analysis: v=2.4 cv=LZYMLDfi c=1 sm=1 tr=0 ts=6a9e68fc cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=t7qd8CqZtBOQhrTyg00A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070080

Refactor nf_flow_tunnel_ipip_push() and nf_flow_tunnel_ip6ip6_push()
into nf_flow_tunnel_ip_push() and nf_flow_tunnel_ip6_push(), keying the
inner header handling off tuple->tun.inner_proto so both IP-in-IP and
IPv6-in-IPv6 inner protocols are supported regardless of the outer
address family. Replace nf_flow_tunnel_v4_push() and
nf_flow_tunnel_v6_push() with a single nf_flow_tunnel_push() that
dispatches on tuple->tun.encap_proto, and set skb->protocol explicitly
after pushing the outer header.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 129 ++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 96dbdadba4e7..25875cc97bda 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -608,23 +608,41 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
 	return 0;
 }
 
-static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
-				    struct flow_offload_tuple *tuple,
-				    struct dst_entry *dst, __be32 *ip_daddr)
+static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple,
+				  struct dst_entry *dst, __be32 *ip_daddr)
 {
-	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
-	struct rtable *rt = dst_rtable(dst);
-	u8 tos = iph->tos, ttl = iph->ttl;
-	__be16 frag_off = iph->frag_off;
-	u32 headroom = sizeof(*iph);
+	__be16 frag_off = 0;
+	struct iphdr *iph;
+	u8 tos = 0, ttl;
+	u32 headroom;
 	int err;
 
+	switch (tuple->tun.inner_proto) {
+	case IPPROTO_IPV6: {
+		struct ipv6hdr *ip6h;
+
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		tos = ipv6_get_dsfield(ip6h);
+		ttl = ip6h->hop_limit;
+		frag_off = htons(IP_DF);
+		break;
+	}
+	default:
+		iph = (struct iphdr *)skb_network_header(skb);
+		frag_off = iph->frag_off;
+		tos = iph->tos;
+		ttl = iph->ttl;
+		break;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
-	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
+	headroom = sizeof(*iph) + LL_RESERVED_SPACE(dst->dev) +
+		   dst->header_len;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
@@ -635,11 +653,12 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	/* Push down and install the IP header. */
 	skb_push(skb, sizeof(*iph));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IP);
 
 	iph = ip_hdr(skb);
 	iph->version	= 4;
 	iph->ihl	= sizeof(*iph) >> 2;
-	iph->frag_off	= ip_mtu_locked(&rt->dst) ? 0 : frag_off;
+	iph->frag_off	= ip_mtu_locked(dst) ? 0 : frag_off;
 	iph->protocol	= tuple->tun.inner_proto;
 	iph->tos	= tos;
 	iph->daddr	= tuple->tun.src_v4.s_addr;
@@ -654,57 +673,61 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,  __be32 *ip_daddr)
+static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
+				   struct flow_offload_tuple *tuple,
+				   struct dst_entry *dst,
+				   struct in6_addr **ip6_daddr)
 {
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
-
-	return 0;
-}
-
-static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
-				      struct flow_offload_tuple *tuple,
-				      struct dst_entry *dst,
-				      struct in6_addr **ip6_daddr)
-{
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	__u8 dsfield = ipv6_get_dsfield(ip6h);
-	struct rtable *rt = dst_rtable(dst);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
-		.flowi6_proto = IPPROTO_IPV6,
+		.flowi6_proto = tuple->tun.inner_proto,
 	};
-	u8 hop_limit = ip6h->hop_limit;
+	u8 hop_limit, dsfield;
+	struct ipv6hdr *ip6h;
 	int err, mtu;
 	u32 headroom;
 
+	switch (tuple->tun.inner_proto) {
+	case IPPROTO_IPIP: {
+		struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+		dsfield = ipv4_get_dsfield(iph);
+		hop_limit = iph->ttl;
+		break;
+	}
+	default:
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		dsfield = ipv6_get_dsfield(ip6h);
+		hop_limit = ip6h->hop_limit;
+		break;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
-	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
-		   rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
+	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(dst->dev) +
+		   dst->header_len;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
 
 	skb_scrub_packet(skb, true);
-	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
+	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IPV6);
 
 	ip6h = ipv6_hdr(skb);
 	ip6_flow_hdr(ip6h, dsfield,
 		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
 	ip6h->hop_limit = hop_limit;
-	ip6h->nexthdr = IPPROTO_IPV6;
+	ip6h->nexthdr = tuple->tun.inner_proto;
 	ip6h->daddr = tuple->tun.src_v6;
 	ip6h->saddr = tuple->tun.dst_v6;
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
@@ -715,15 +738,20 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,
-				  struct in6_addr **ip6_daddr)
+static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
+			       struct flow_offload_tuple *tuple,
+			       struct dst_entry *dst, __be32 *ip_daddr,
+			       struct in6_addr **ip6_daddr)
 {
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
-
-	return 0;
+	switch (tuple->tun.encap_proto) {
+	case AF_INET:
+		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_daddr);
+	case AF_INET6:
+		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst,
+					       ip6_daddr);
+	default:
+		return 0;
+	}
 }
 
 static int nf_flow_encap_push(struct sk_buff *skb,
@@ -830,6 +858,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
@@ -847,9 +876,11 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
+	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache,
+				&ip_daddr, &ip6_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -1158,6 +1189,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
+	__be32 ip_daddr;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
@@ -1170,11 +1202,12 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip_daddr = other_tuple->src_v4.s_addr;
 	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache,
-				   &ip6_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache,
+				&ip_daddr, &ip6_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {

-- 
2.55.0

