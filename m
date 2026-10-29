Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280948;
	b=oob9l8pZEjdkoN8WGxxVIrIi5JxG5Tqga+xT4S99uCgw2ebYIlma1Di3DR8wymXbcgLS
	 sPvETB/ebULCbHjPb30j3iY8jxh7zM7nVb4Lllqfg0NKZ7tNYicd5AAFVK9JmmTM/Kyu1
	 dUTgJyjmf6kzqu75kq3SfMEhiKSjHKpUaCVyDPnT1vT7rdfNJsrrOcP8oUJr0b9vvaSGS
	 rLOF+UJi2jZXKXxpn6eCCAJYQ4ROLM4FGDJ8ZTBtE97FqXVJcpLTdNg9n8iJ6vTEzk9/w
	 tI4GrsA5JM3PCz+T9Wg+df/oV0M4MHahSkEVdWNecFVl47QhpMDCYTnQ7h39XI9koPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280948;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=uJYlsQbb2pW/L7PXjRP1QZZZc3eeLY6/o8bsnwuZ/I8=;
	b=J3QypjHRWNhsJ/PmWkhuqS9AJDRUb+8XO1hgQGdOESYQ4BvBD/eUcw66Rxx2DW9QrLru
	 zUJWeaSFEUR99O7EACnk67hxcsCVIm5SF7S2T5ZafRC6SlhOB+JSBUqh1onT6mCS0tIG9
	 m/CPsuoKjYHmB+9qZUI2BCagcuQVbe9uCxJycPGzG9mq55z5kjuuuWwqsOUL8rSkrYCqR
	 r6RkbkQlSgZ8iRD+lJppiPrqmYoIOSdC1Udl83OSLjP/XGcZ6bCBr/tSyn6XkSRPJTKV/
	 gBYgKTMwg4A7mvWkCDkRio+Eo8lWKrb5b7CaJ0WabU9+8oYnClZyOzOjKC1ycFcWwig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MVst6O98;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FkW9lUTo;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8BF60A2621
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D8BF60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MVst6O98;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FkW9lUTo
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCe2AD3768233
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uJYlsQbb2pW/L7PXjRP1QZZZc3eeLY6/o8bsnwuZ/I8=; b=MVst6O98CPCoZfzl
	aTMCEd9Zo7hQKuYl6dx38nMQDLeOr7WNMQ3rV7VgO7kPihPRxVjfNYTEFB2rGoR5
	l3hcuW4RjNRM7aPd6udNq1U1dmxVr07Rjpn/8LdNirkCWGljCVBYaktl8lu855qV
	kDZ/rbDc0WA1ki+jcFuzWYfFOshsoimikI1Tu+JI2L3dJBX0oO0cB7UxL8ho+7aM
	9dvrdMJUsvd/rppy8QBSx6F/JQJOAPjKKcH3YEFW8lIhZtf7INdwJOypHqOohOnS
	Pto5vvc2uQm8yDlpNn625V0b4fvydEItnuLO9MhC9fCUEnPU0gon9SYXY60kvR3+
	eKGZJw==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hks3nb6pq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:46 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-99063f4065eso505658241.3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280946; x=1793885746; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uJYlsQbb2pW/L7PXjRP1QZZZc3eeLY6/o8bsnwuZ/I8=;
        b=FkW9lUTordMQLE3Bpod0gPEbIHgCjJ+tVzlBrNH8FyMHq7+YHB5XN11Zyorwqr4Hsl
         9+Oh2Ws4j+7wuZwozwyNSf36xBdviOMSjVUFRRYLLbnAhJGbhJqFe8VuAv6nQxydX12i
         utDWmPRRd7NiF2Y03AFsfXlviwGeG4WyliP9ezzC8T3jJxQ4EBe38vd2goFSBkY/3aJl
         Aa12tUTmAsD0lQiH5PqpR69/NTbjHtuiwDcfMqyn9Xoc+dbGS0+yFJBarGeBa1PnWLmb
         /1AurQAw4KKQnFWcRZKYxY5Oe3psJ2jQUobHVWpXILFnIXjlHP6ZXj+hxGdhZ7aTbvsD
         OPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280946; x=1793885746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJYlsQbb2pW/L7PXjRP1QZZZc3eeLY6/o8bsnwuZ/I8=;
        b=0HZJMWB6/FTbnIpBLhPFiAFgsNKI8Hvcm+bsd+KAkxpGDKHjJVdNkw/SZA9unjjqRp
         Jq7Vsn9OKPf3lsszfi2l4ncz4eCtYqJ1gpGdSbOjx6TEdP6XM/irR/g0fYfwsNdSQk6K
         e8/xBtGdFFJ1CeyELQ/5QKEc9XRMwxxMyRo2ihYZXXinKlt8ztR3pBhiiuPavAYGuxyY
         vEjzSRDekGLEBSIfvg3NDVdnIFuw+K2gPO9xcdGDgEvs7jyXzrYuEqLxHpBYp7d83Mlc
         uiGJ2AmpScU3/wpMqgMru+MvVzUbWXWrquh+dwOV45/tarLwLGJeIZYTgvNaGsqF5Ukl
         XCYw==
X-Gm-Message-State: AFq9FYLNfn85g1fMQlOCB5/qRZZoqHaQehP8EMe3fFAyfAmmA43RS/5I
	txipWFKMOhXWKVw5Xjoj0zTZPz3kHY3prOTU5ii7PYd8tkWQgQ7uT5DTgzegTa2Fjt7+dvNPSFH
	0S3Yafuzg2HXS6oo5OcOSyEYfOL5fNVb4IgsXqUFKppc9Bxi8w8ZcuQua3K10rrcpuaWFKoM=
X-Gm-Gg: AYBFou2rL/8XQVkVbYjSM9SPoJ9e5ilF9WPwXbnfqT+uxvkU1LEFij4vrxTg1njqwOK
	EsAbzcp4euAf9DlkiViA7UXoxx/ONzd29equpQduM2V0Ll/0RfjCXs6NnWT4HbDP3v1oCYyvYlx
	hzlMsahApgvQzTp62Xaw1Qi3wv6wsZ9mfwIzL8ymRl/9mvVEHB+vrdgreHI65UPW70YZahfiW5q
	Btfv59q9O9Qv7uCTBj/7Svll3m9lvdpD0EkWPlV+YZ8Z0ogQmg3WMT1Q8VvdScCwc+P/7x+Dzoo
	9PUiXX0njIsuIbbeUcwiNsS2x+pW6h39DP4zCDc0WEZ1MrJidtnjkJO6xIkyRmLLdjp+0H76mrX
	AQj8c6LHYn3eaOSvQ9U3PvSuYg1lxRDiPz4nvPSt8NolB9ir4MON3410OvGqjeagGjkX3dkGA9D
	jVd5DD4dLg1pePilZ4DFWb9A==
X-Received: by 2002:a67:e112:0:b0:7ce:78f9:adf2 with SMTP id ada2fe7eead31-7d03a4be14amr2142917137.9.1793280945379;
        Thu, 29 Oct 2026 06:35:45 -0700 (PDT)
X-Received: by 2002:a67:e112:0:b0:7ce:78f9:adf2 with SMTP id ada2fe7eead31-7d03a4be14amr2142902137.9.1793280944749;
        Thu, 29 Oct 2026 06:35:44 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e64ccc693sm5209582f8f.5.2026.10.29.06.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:43 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:16 +0100
Subject: [PATCH nf-next 5/8] net: netfilter: add IPv4 over IPv6 tunnel
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-5-6a17c54f9fb7@oss.qualcomm.com>
References: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
In-Reply-To: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: i78s-FnZQjYWHlyXL3hzb1XxCrYYFCtS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfXyCph5BK78C/c
 mZxS+XMOZhdNtGOWZULdJDknwBeo/d/s+VPuBD6R605AjgZ7dlIcQKMd7F4MVPPcRs3N6SneVWE
 T9QCeP28pdFDo6a5jQVNo5CVkIMChfem10/VTm33txmfZVxyf55FtMH5VnwOUPm/3pgbJ4o4sV4
 bcvytGtxG9/BYAwU728TyI9HfubYSFLr29bfzKAxdvTLTUNt6pQiwIsmwHrlTgFq6xNyG4ncRDs
 Uj2+E6tTiT9FbspJQNUc4ZwN6Q/YMkTM26/gecij2OWcXAbfMjGx5wSng+XCWhN8IQJAiOTRaMa
 yCUBZOQt96AwgHLmGOKzKxWsM0toAiH+MDWNFl7r+5XBds2SElQ21Gy7tFkJ+nHhlaTJfdr4C21
 GUCT/vZmszzeB6WzUzYM4Wla8Q1GHNtWW4WxkHbarHx1d3D5AD6yBM42DirAoM0fAhSsqSC2l7M
 UFvUZIqztnP3V25bi2Q==
X-Proofpoint-GUID: i78s-FnZQjYWHlyXL3hzb1XxCrYYFCtS
X-Authority-Analysis: v=2.4 cv=XZEcX455 c=1 sm=1 tr=0 ts=6ae34bb2 cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=Q9s6MkQQiHVZyQ02r30A:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX2xr6IFfO4hXI
 yFq18aBjdmDg1u9HKTo6hiUnpEwqbYbGIhhu2fkpHYBiNy8gK4YHXvjHQQL8BI77gZkBc9m6jHx
 61wFXwSKgsoOGEL1zd94lo1iaisDdEI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

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
  - net-next + IP6IP flowtable support: ~138 Gbps

- TCP stream transmitted to IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~127 Gbps
  - net-next + IP6IP flowtable support: ~140 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 66 ++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 902b9b595677..0ffa6470c46d 100644
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
@@ -886,14 +887,29 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
@@ -902,6 +918,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
@@ -948,7 +965,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	else if (ret == 0)
 		return NF_ACCEPT;
 
-	return nf_flow_queue_xmit4(skb, tuplehash, state);
+	return nf_flow_queue_xmit4(&ctx, skb, tuplehash, state);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -1175,13 +1192,18 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
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
@@ -1211,14 +1233,29 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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
@@ -1227,6 +1264,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
@@ -1267,12 +1305,16 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
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

