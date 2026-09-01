Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486DD481FC5
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280372; cv=none; b=i/o1sm/V6Hr/pOCq1AUuyJvQ1/2pgyLaBTi9KQa5fAmiLOoKJ1xrEFQE54TmENSzsVmTK9jAlRd1yrXlaY7aIOEtFOKb7LKWtaaHkMueqEKi3ij0/HjcDit61skt4JOFz503eybWiu3C2N7koGG5mE54FbDYTalRclx5Ce0fAtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280372; c=relaxed/simple;
	bh=1Idn6aNfy9pd8Gk3lXsLrzpmsEoe+WcQxBXHj5VOW28=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J4mhzLG0fDroIB22XchU6EswpR0Hc0Bo1poF5EzmtBAlKNsenIFxW4gpy9DINHQkeNa3itOBy2YNX8PuvDM65qz0demtKHIGdOLQVDTPRoHueW+YsS0n0N5EIgxgcEEnfgMESMW5Px51NuOckEcc5mqg5WEgQ6G0078hpD0NtcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gS/O4aWc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fiZIXdLG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gS/O4aWc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fiZIXdLG"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8WRR3256336
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	a4w/pkmZ0ZBipJIlxgM2eGUO8kVkv8mPgNOt+rLDSQ0=; b=gS/O4aWcf+dDfrfL
	TTR96Az6x6oZCHTziI8y6COSPgPj0cXWj6E9s74bYUBSU1KXVRutLaHM3pGoGGh1
	zKJxB7esxz+7q8XWT+Gyrpi8APnwrFTHxid4vvmrRVbTjp7gY+4iPwd1sg0M35P0
	RMey4tvxXW85I344xxhQI7vZ7tbRPaJUaXrOcKfcurP03bCfkbqjui1XCMF8xvyv
	oHvd59763DJDFQb5kgKGzSMsQz5IGYeL/bP4qBAM9IhL6EzWTVJhT8P0sKmto9cd
	fILGPg4nqeCCgFwDDO4fCiJJ1qNaiTjpuhmhnBjTI2n8EJ2cZj/zyPhjmlVuoKaI
	IV+aYA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdynt0y9q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:49 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-933023a5980so20000285a.3
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280369; x=1788885169; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a4w/pkmZ0ZBipJIlxgM2eGUO8kVkv8mPgNOt+rLDSQ0=;
        b=fiZIXdLGRKT2Jg0fagMuts1/1aN5Z8MrPvpY+jjDSd3DFrqH2GebOE6lGQYifur3Cd
         K50cwre2UySO67DgKO4Xk/cGmZa8N8k+GrEd+xmu9QlCoZKajF7ETHD9/p8yzj5WYcis
         J8PudKl+HQIJ2j/CMGMdQ+Mx/6h/idCnIZsc9QermPRzZYYtAGXSKLBtOeKR7Es6F+H6
         Aj7/ipt2T5TtpvHhOdNil1W3Lin4IsBA5/LNPOsd1+fECq8jESBdE2UdKXxHvmaWkJOv
         P2P9euIsex2SQ4q5p/23REtEepxIPSSql+pY3ZkwNA9W1GAkwsed/RLZhT6uJ00xNJQz
         QQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280369; x=1788885169;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a4w/pkmZ0ZBipJIlxgM2eGUO8kVkv8mPgNOt+rLDSQ0=;
        b=kM1Qbatkt5fdwaoeid7m2cfVDqMuiz6O/VfGrGtj341V3v+XNi3fw0MrbVk55n0XY3
         Ul7D0idj6x2mWIUHNK8jl1jQkf78vaGqw+eD17cfP/aSTvt17VMWbWGFDbaZTnFfG7v/
         gLfAEannQ6cVRxVpZYhw6kyX+kqAJDK1R+bbz5veQlWeqSHZPzZamQpHG0cZlQ8y1Mb8
         Ctlv9LXObSAQ+UjWGd708kGXuPx9ovigKLI6Rz+Mptko6x0vgZA5CU4Tv1UaR3f2CDf9
         yxmobt1/fCHFmB/Ymu00CReGaQDCXpESwRTltLsGPl7F6CuXgFpsejGbocA9mCTTeZn5
         IMpw==
X-Gm-Message-State: AFuF++nP4sx2XLS7pVqrLypJ57WzLIbGc6T5rir3MuwShcDVR99fyknY
	4etzRTn1THhsNnbXb5kDtl6en21eVUDsx7sN2gpSAALq7oMzzA2xUdGDkvrKhcKXjz89Ev/c9jz
	AK3NcpI4jMhnatw3ROGuMCD78e3GCsTkPyJtNIyMpb9CtDZmdUYn8M9gc9k7BpaHV66uep24=
X-Gm-Gg: AR+sD12/GQj3srku12CmH6XLEyK80bp+XolJQ/7WQlMLndGz/C0pjbnYtAtz6z0VTyE
	w2EUZPaPzk7dg3JReMf5jkZ8OU+JCgapfC1Ns/0MuA6yNcgcUg4RToRea1jkCes6ABJnitCPKgN
	dTHnzZZlZ1m/369g/3MnhAaVSuA6MJXX09SEjrwSI5BJc1lRpx8vllsGRumUfQbnHv7tSU1kT8a
	UguNjX6xPIVTytIj2dvFcRds5utzUD3d4l8BnzjzGPX76wyFG+fBpdJzRdVxYkvU1LHpkO3YF2s
	8ymJmUbCp6FtoN3miLm+Nxe9WLNsVPyVZqr09E4GkuAwy/Ptx65A1amSmuJZDQ8OBLifZd4mUnw
	PUR0DlhAMX0PlHg==
X-Received: by 2002:a05:620a:1b91:b0:936:ef9a:deea with SMTP id af79cd13be357-939138cb02bmr4583621485a.28.1788280368906;
        Tue, 01 Sep 2026 09:32:48 -0700 (PDT)
X-Received: by 2002:a05:620a:1b91:b0:936:ef9a:deea with SMTP id af79cd13be357-939138cb02bmr4583607985a.28.1788280368237;
        Tue, 01 Sep 2026 09:32:48 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9267c369sm251945115e9.3.2026.09.01.09.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 01 Sep 2026 18:32:21 +0200
Subject: [PATCH nf-next 6/6] net: netfilter: nf_flow_table: unify tunnel
 push for IPv4 and IPv6
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-6-72e49be8c31f@oss.qualcomm.com>
References: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
In-Reply-To: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX2+w43b7hbI9d
 LmGjAkvBd0XveQA9NrCL7aU8eYqLwCSRESfkWukOghxVJRoqFsAq6GLHejc8fwwcPoXjUH9mn/n
 SHCe78pH3CLtNLzZYDo4UnipXN53U9wbmutVTIFyvHm4kcRg/bNF5KzknAxy/AWGKg3/pd4q0dk
 sdToWOyxOrvkr0UvJUqyU8GeqB6u3WnhW42ie0SqYSmIYI4hF3kkuHQyPJSRZZOQd3gnG+ffo6d
 8l0sBOuF4T30M3g6ug1FHK+jjRx056FcPPUyWhATVkAX9boaGfnXVFd2Rd/KF2sTq8EXO54uQSD
 Khiyy0O2WlHVuFi8L0WZ2mjsPNkfSz9YgvG+4nfGbhdJk75gBJa2eNhBQlEpqmeD0uvvM9I0Fzm
 34MGoJQMUZVqcZFHyPiKZU7QAVd7M+daCp3ICJLbu5rqyyZ98PoWLz6O1etnVfdb55DU1q9eOju
 UEdDImcOoQ0a2hFDwvA==
X-Proofpoint-ORIG-GUID: Al9Rt8nIu_VdcneZmjc9GB42moV5esd3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX6Wh+LGWc3T7l
 MXWLQ2/ue58yIlev25IDeHhqnc+Xit0OLJfxEeQsaeDTUJ5UgEzIbdDXbTb7BgNukVeYIUypyOX
 x3YhUb+W3E8jsZBXIdJSi/gXpktLBJs=
X-Authority-Analysis: v=2.4 cv=LfkMLDfi c=1 sm=1 tr=0 ts=6a96fe32 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=CQvNws4Pyv-XnHjONYcA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: Al9Rt8nIu_VdcneZmjc9GB42moV5esd3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010146

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

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 121 +++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5cbc3cf10ec2..dc38dcc28773 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -614,23 +614,37 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
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
 
+	if (tuple->tun.inner_proto == IPPROTO_IPV6) {
+		struct ipv6hdr *ip6h;
+
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		tos = ipv6_get_dsfield(ip6h);
+		ttl = ip6h->hop_limit;
+		frag_off = htons(IP_DF);
+	} else {
+		iph = (struct iphdr *)skb_network_header(skb);
+		frag_off = iph->frag_off;
+		tos = iph->tos;
+		ttl = iph->ttl;
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
@@ -641,11 +655,12 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
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
@@ -660,57 +675,57 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
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
 
+	if (tuple->tun.inner_proto == IPPROTO_IPIP) {
+		struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+		dsfield = ipv4_get_dsfield(iph);
+		hop_limit = iph->ttl;
+	} else {
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		dsfield = ipv6_get_dsfield(ip6h);
+		hop_limit = ip6h->hop_limit;
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
@@ -721,15 +736,20 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
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
@@ -836,6 +856,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
@@ -853,9 +874,11 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
@@ -1164,6 +1187,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
+	__be32 ip_daddr;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
@@ -1176,11 +1200,12 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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

