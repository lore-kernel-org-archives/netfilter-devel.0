Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714488;
	b=e0ZDeKJYz89VI9xUyGKNcurtqTt1B3dtiAn76nFi5jp64/9mufDpZXOgE3v81d38vX2J
	 VDWlbWsFg7y2T72INAQDX+QyOmM8HqkGGFdiLQvO1a/uh7CFO0P4KEz6udgQCgN7HSJQA
	 P5z2jdBo0aUjCZqUPHCBkLPRQ4r093E2wbgy0CzyIYGWhpwhDURSbXYG+P/k1Ys1ieIMV
	 bzuh6xOI+vcaD8h+IibZ5bEoWQDdKaXPW0HPXBY2ScP5r6G4lGxaBbM0odqHR+1/AMjEq
	 HY87SJzKgGsBCFeq/h8mQYAVHCJWQV1xnokP/c8Wls7BS/upkBpMxaS7YOgDy8XCffA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714488;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=P8+OlAzHpVINqx3IR0YOlEKwLLVVCuMyCCuAZDrv7Z4=;
	b=i2Nzv2C0teomZydewzRasxni0kmtXQdJsMblugeknvw8SwKPhR5ht1xviSEGmw1KaaG3
	 xnxsqLIR1To6a/dwuvmvPVFewewoAlZP3oa6lUt3t4uo7xMgTWgsejodLRdj6lBvdQH9P
	 ZR73KJ1v0KH4lWhSLCXN5NCrzQa8zx09lui+hqDBb60MF1jzdpeIXyaegjJpjoxC5QLj0
	 kSEVcghm2gCNzK++rScTXv99eBYxuQMGGVTOiz33hdcpenUnSIFjKVAOtd7umwJZg8Ksn
	 H6XXSAX/HbmAbwu3JK+ZMP9OasKVYKqYuuEEmrA5T6Vkl0wZL/s2PQBFa49/4WpwIpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XRepnCLA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ibSWkjdP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DA16082BE4
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63DA16082BE4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XRepnCLA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ibSWkjdP
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZ8he3003270
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:01:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P8+OlAzHpVINqx3IR0YOlEKwLLVVCuMyCCuAZDrv7Z4=; b=XRepnCLAElgDIwA4
	F0nnCHQrLDx2V8gXyTP2NIpU1L9fumaq3v07NgpgexeQzcW+kcthvG2bytU15byT
	ChjqVw7wWUNsFwBvI3Bpvgou7FD9gSWG4OMks68uvSWJJjO/EadMBFRSM61DbALd
	KGvwaJf29na9B+ulHffsmAW+JOhpH/gRMvdyaFLfMdkgb6TS57WeEm1ZTcdC9nUq
	A/8GPGWw5nOWLnK1LjuXR9P6i8nLrplakISNlB7RV9TdQNqBr0AfZu527c5s1qRE
	yolFZt8NQU7xy2qQZs696+BXUSY6noaEZgZ9mw1dsmHKVIb3eb7AHCrhNEQgYreW
	vvfVbA==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq2ackfe9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:01:27 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5eaad995a7eso984160e0c.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714487; x=1794319287; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P8+OlAzHpVINqx3IR0YOlEKwLLVVCuMyCCuAZDrv7Z4=;
        b=ibSWkjdPoy4W6FPWiJoy67Gr3orYWt9y7M6KQHoB6UZJWLMBNDWSIRvU4Nu6R2Tatt
         2iK/2kk/3wo0IbLSXyPRk09zV8W9/JAHDYr6IvRWYUi/j4CoYlP/ShqW4iETtKLBOvHu
         MWc+QWUcTXWibvajzBN2gyeY9aci3IXcGqV0aCCG+vAfaHzxFjM1+3BSwn05t0gXG+LD
         YKF33Bo0rra83YnUy/lyaqgAigolOXqnrMDTzzIlzhVXVnwwAY/eTbIS6c9q/R+TbSX4
         dl9BB1hyVE/To+CwINU6mANVUtAKPnjB4ywQC942i07Qk6YEDOl701RudDzVrN7qr2sx
         L9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714487; x=1794319287;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P8+OlAzHpVINqx3IR0YOlEKwLLVVCuMyCCuAZDrv7Z4=;
        b=e7ya04yiwtFtpCYwfaCFzqrjgi6yX5MHvRhSdPjRo9oekj4ktvh/a6jS8n220sqXnB
         vpJBG2XQEeYrw4eKm4KVHKaVkxeASQkB4nIGxvtRKshfsJTTKEjZWQK0R9NQf7wWTOgI
         /1pewrSQ0YZPhsF+nssDwtjmg52L84fTj5a3K+BETn90GcN+UobcRuQXLWZz2eCQ/UOM
         4yd4qLt4wA4ys2BUO16r4l7JEw6Sdi2vulmER9uyvHa4DdfNfcLuFKoG0mo1mteBoLSB
         Dtv4wtzmWBcLrg8kQFQz2QlFCfQgwIs/hcSUKpqJxYg8jG1pzYrYmA7ClKz5DtpW5rM+
         1w3g==
X-Gm-Message-State: APuU4Z+4I62nUFoXvUEH+o2vpMb5MUx3qps8gBN2+4ZyJr8yhnrdIHpx
	R1PFFeqTCybfefkgYRmQAcgDUztztQFIZe/FzZaA/NzgavR3q5PgS97sjtpObQ85RvC+lT96jAp
	teEiV2EGwI9BSPHez593lQhAXrV0x3PjfZq4j/12af9FkTtpNbnm0ZjsRLse9yRYpAT7Z1I0=
X-Gm-Gg: AYBFou33hpUUU56BA6i/8+FToqc9cnDzKX97wsPi7dc2DjgbYjwNFF7gCu3Dggku23u
	gBZrWRZLwwpszQvZmrCA6f0QHVzYqdRCfMWn8SUPxd6J4o01ntcvpHZaCqrKCIQwvWPnqernvlr
	85oHVsv5BPlT5liLiEKTnz5c4Sk2yZJCc8vJDifvYy3sxOPmtS0+Vk8OXNF0jnxC2uybhRg6HI9
	119Zuf5g6OVz3P+SEaCrk94l3SP7h1dudZoJ3KsZO2nO7MH/DctDkUXDl+a0asKzdXgPyfhTVxG
	dNdOK1Fthu+oYQKuyFh4MtTU7j0Z2yXIxH37m/Rnw7HUHDQKM40q884eUXQ9/Mm1rhUXNBR1WrH
	FmOw4wcB4UnULe0CtcAiPqWd94C1Cl1cfiK8LB3VOmjS2qdSaak6G/pCIn3PJKmU=
X-Received: by 2002:a05:6122:a5c6:20b0:5d7:2918:c648 with SMTP id 71dfb90a1353d-5ec68718fe7mr3068433e0c.8.1793714485857;
        Tue, 03 Nov 2026 06:01:25 -0800 (PST)
X-Received: by 2002:a05:6122:a5c6:20b0:5d7:2918:c648 with SMTP id 71dfb90a1353d-5ec68718fe7mr3068357e0c.8.1793714485081;
        Tue, 03 Nov 2026 06:01:25 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2aaa4b85fsm55934655e9.10.2026.11.03.06.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:21 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:46 +0100
Subject: [PATCH nf-next v3 5/8] net: netfilter: add IPv4 over IPv6 tunnel
 flowtable acceleration
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-5-60b5f063f1df@oss.qualcomm.com>
References: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
In-Reply-To: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=T4gZ3PKQ c=1 sm=1 tr=0 ts=6ae9e937 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=D7r3e7iHu4DLkCbRepYA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfXzL2JfSI5swqi
 iGmvENn+LwGDKkKy+4qKeQZ10p381RirXRcXYj4ukclaLeOHYo4r5lQ9BrVbZrDDlLizkUShJmT
 ODtnUdZ1sY5//qoWWQwzSmBlkAiBTuyomH9uBDEfvy1CVkGxOuJEFr3Odrbje2sugzMO1HxcfPV
 53WRPQKlVDdUCZ3OfwqrYcKa/5/u4Ac6jvhBRoP0nYPTk7+lkoBMhpsXmWqNyqwpVeWloJdVBCz
 G4VBVTcYuJzDIhdH1LlbzXrWP2rA7TrszC29Pgzbj6JX6Bzi+ZBRO76r5HKnTelCe46UUkHODav
 kYVfLhEakA6nJQEPy9IC5TvGXRIQ3EKEdzeIHaNHzpbd+whEO8i56py9rTh7D0JM7HCl7dNkZsg
 Ltq3YO2sCeAucIM2NjLJu2rbTpvYnsxaEcqqrDh/TBxlmxMwP+MkJMfpo7Yv08rtuVvgZQAeFFY
 4/5BXCX9hAtj+/vVS5g==
X-Proofpoint-GUID: 7tvYcG3GcNQwsTwxvw8luGEA5BUKogdI
X-Proofpoint-ORIG-GUID: 7tvYcG3GcNQwsTwxvw8luGEA5BUKogdI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX+2H5/tGGXydw
 EcOeszNcEtC3WnXQvxhFYaBGRYWRmpW1Dv2+Jeq+psG103AbZwS2tFkHWS58ETgFpJzxI0gX1WI
 EwpqST5ZoKgvRLk0UsPSX8W/objKlZI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1015 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

Introduce sw flowtable acceleration for the TX/RX paths of
IPv4 over IPv6 tunnels, relying on the netfilter flowtable
infrastructure.
The feature can be tested with a forwarding scenario between two
NICs (eth0 and eth1), where an IPv4 over IPv6 tunnel is used to
reach a remote site via eth1 as the underlay device:

    ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (2001:db8:2::2)

[IP configuration]

6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 scope global eth0
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:2::1/64 scope global nodad
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr ce9c:2940:7dcc::
    inet 192.168.100.1/24 scope global tun0
       valid_lft forever preferred_lft forever

$ ip route show
default via 192.168.100.2 dev tun0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1

$ ip -6 route show
2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium

$ nft list ruleset
table inet filter {
    flowtable ft {
        hook ingress priority filter
        devices = { eth0, eth1 }
    }

    chain forward {
        type filter hook forward priority filter; policy accept;
        meta l4proto { tcp, udp } flow add @ft
    }
}

When reproducing this scenario using veth interfaces, the following
results were observed:

- TCP stream received from IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~126 Gbps
  - net-next + IP4IP6 flowtable support: ~138 Gbps

- TCP stream transmitted to IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~127 Gbps
  - net-next + IP4IP6 flowtable support: ~140 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 90 +++++++++++++++++++++++++++++++++-------
 1 file changed, 76 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 902b9b595677..ea2cd9df33f8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -856,7 +856,8 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static int nf_flow_queue_xmit4(struct sk_buff *skb,
+static int nf_flow_queue_xmit4(struct nf_flowtable_ctx *ctx,
+			       struct sk_buff *skb,
 			       struct flow_offload_tuple_rhash *tuplehash,
 			       const struct nf_hook_state *state)
 {
@@ -869,6 +870,16 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	struct rtable *rt;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		if (tuplehash->tuple.l3proto == AF_INET6) {
+			struct rt6_info *rt6;
+
+			rt6 = dst_rt6_info(tuplehash->tuple.dst_cache);
+			memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+			IP6CB(skb)->iif = skb->dev->ifindex;
+			IP6CB(skb)->flags = IP6SKB_FORWARDED;
+			return nf_flow_xmit_xfrm(skb, state, &rt6->dst);
+		}
+
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
@@ -886,22 +897,38 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rtable(tuplehash->tuple.dst_cache);
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		struct dst_entry *dst;
+
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
+		if (other_tuple->tun.encap_proto ?
+		    other_tuple->tun.encap_proto == AF_INET6 :
+		    ctx->tun.inner_proto == IPPROTO_IPV6) {
+			struct rt6_info *rt6;
+
+			rt6 = dst_rt6_info(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw6(rt6->dst.dev,
+					     rt6_nexthop(rt6, &ip_addr->in6));
+			dst = &rt6->dst;
+		} else {
+			rt = dst_rtable(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw4(rt->dst.dev,
+					     rt_nexthop(rt, ip_addr->ip));
+			dst = &rt->dst;
+		}
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
 		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set_noref(skb, dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
@@ -948,7 +975,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	else if (ret == 0)
 		return NF_ACCEPT;
 
-	return nf_flow_queue_xmit4(skb, tuplehash, state);
+	return nf_flow_queue_xmit4(&ctx, skb, tuplehash, state);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -1175,13 +1202,18 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
+	if (ctx->tun.inner_proto == IPPROTO_IPIP) {
+		if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
+			return NULL;
+	} else if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0) {
 		return NULL;
+	}
 
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
-static int nf_flow_queue_xmit6(struct sk_buff *skb,
+static int nf_flow_queue_xmit6(struct nf_flowtable_ctx *ctx,
+			       struct sk_buff *skb,
 			       struct flow_offload_tuple_rhash *tuplehash,
 			       const struct nf_hook_state *state)
 {
@@ -1194,6 +1226,16 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct rt6_info *rt;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		if (tuplehash->tuple.l3proto == AF_INET) {
+			struct rtable *rt4;
+
+			rt4 = dst_rtable(tuplehash->tuple.dst_cache);
+			memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+			IPCB(skb)->iif = skb->dev->ifindex;
+			IPCB(skb)->flags = IPSKB_FORWARDED;
+			return nf_flow_xmit_xfrm(skb, state, &rt4->dst);
+		}
+
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
@@ -1211,22 +1253,38 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		struct dst_entry *dst;
+
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &ip_addr->in6));
+		if (other_tuple->tun.encap_proto ?
+		    other_tuple->tun.encap_proto == AF_INET :
+		    ctx->tun.inner_proto == IPPROTO_IPIP) {
+			struct rtable *rt4;
+
+			rt4 = dst_rtable(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw4(rt4->dst.dev,
+					     rt_nexthop(rt4, ip_addr->ip));
+			dst = &rt4->dst;
+		} else {
+			rt = dst_rt6_info(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw6(rt->dst.dev,
+					     rt6_nexthop(rt, &ip_addr->in6));
+			dst = &rt->dst;
+		}
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
 		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set_noref(skb, dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
@@ -1267,12 +1325,16 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (!tuplehash)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
+	if (ctx.tun.inner_proto == IPPROTO_IPIP)
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	else
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
 		return NF_ACCEPT;
 
-	return nf_flow_queue_xmit6(skb, tuplehash, state);
+	return nf_flow_queue_xmit6(&ctx, skb, tuplehash, state);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);

-- 
2.56.0

