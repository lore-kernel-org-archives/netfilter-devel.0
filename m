Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559750;
	b=UZAQJahjE1tkwFDWBZSm8esLz8p3rfsEFmCRDa33/7ymgiKdLQz4Oat7Q/TNukbcR7u8
	 9oo1KNrHM2rbj7XWSRx2ipAC43u2aTB5Vo5GN1rbzp4Li1ZB2OuF2NhTjUqjBJHaMWBjF
	 XpdAP6ykd4ZzAnu9j8LFdjbigfjNhfHYckM2bsbazLe+VWX477pvOklTHdQi3j2Ui0/qW
	 bGFRA0rG4TkUSWW/z79EbF28Pt/jCIQ46CeeekjY3L/si1mBr2AYuXIseR2spf8jD92MV
	 uFV84d7PXFlqQxpVNI1WoOOBVm36DJ5voDrkeDplg02wbHmAp1yO4+2ztlY96H2ZoOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559750;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=DzRHvF1o9IKB57O9mz1DN5HJc48wgTP5DHvcTPcKook=;
	b=Rzk8gOlFjzkh4qOkoTGEGJax8d3Hd/8TEBArcZkHvrS44+U19tNFJvmN9aPg7VBeVsTu
	 DIa0DrbjjqtZZ/3gIvRBBhNVl2Y8kiW4cdZFbi3KkXs5B9fp4lzw4oPCvC+XedVZxpDGJ
	 04XSwi8tq77kf/QUepCtX3pHGxRwEBxb2OIYw1uZ+vM3o4vchM4NEF1EyAb2bNY4fz7RG
	 Ll13v9VXkB/y/ZIfZm0jWorZc0VHsV+rUzUfaTmEVrmO/3OR1pffx+8kpuUk9vK/nVanJ
	 srHYSlGc6d+vbOb6nOrRVUrP9jXVXAixZm58dy0QSFEOGSuV6ImVFdvjkdmfiwS/JZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=j13F44FW;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TKJ8cEqJ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE40606A331
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DE40606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=j13F44FW;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TKJ8cEqJ
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQDXW2465610
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DzRHvF1o9IKB57O9mz1DN5HJc48wgTP5DHvcTPcKook=; b=j13F44FWa3psSY/7
	lNkojb7xoskbkA73eq3t4IDLBEOO8P5A/NQW0ZzeMfyKCTC++ZzuaEcKe4aRKVhD
	6Y+8e1AlImR57CkXzDE2DKhmgtUCTxH4xe/EWo9kW2EgEH4Z17+zNrrlRMHmoUNE
	fLSs36MeyWcjXVLbR/S0hOuedcpH6BSGYw2DoO//B2AmaAXTO5FglM0HIfSqSQpD
	nVZBl6nlVkbsd/Q5RjaKd5AlNU4qF9RjfcQeSRwUXeVOomP6WZOCB//SdXTAFvlp
	xYbhlCZXrjrqgxWNsbHmAnPKUICGl9Tdzh02ZMzzzus1URnwd/K6Y9ODOPoHqGrx
	egcm/A==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn79rv4uq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:29 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-934963b2bc0so470730285a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559748; x=1794164548; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DzRHvF1o9IKB57O9mz1DN5HJc48wgTP5DHvcTPcKook=;
        b=TKJ8cEqJiEs400VXKpLaoH5A2PQRZdf0wNugLBBOWTo+xzm05VaXfnfDV2JXI0a/aw
         fkla/RzLqcjUR6HBuHt/8vuIMLyG8X+Q0xVRp/VwV8e0Lz789kDkjaSIyPTt3PB5V6xy
         Di0mKREmCyB9I6lyq3kngk2ksySaFGaTLS5+bl7EJLq3W1+aJzlFQ8CK/i2ZEN4WchTi
         +Okb25Y/CwR13JNthrpTBywt/GitDXWuMKGpO5m387eYZHFVRtdbLx0k+sYJGuX0Am0v
         jYvS+q6w0PkQHv/qhyoK+OidZ3Z51g3wKbZoqKgjqMfisZfRyDsiAvJeJJwRK3aw2V1j
         56YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559748; x=1794164548;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DzRHvF1o9IKB57O9mz1DN5HJc48wgTP5DHvcTPcKook=;
        b=z2a3sSLp9DBacCmugiGUwBtRgyVm6Bfu+QUjhNtCKfraE+Mg00hQ0AkGnNc17mE+MA
         yjlNpYU5l6Z0oi5QZ3KnWuuR/MgU92RWZ+C1qZIAcTkH1c5GX4oETCAh8cflEJpXBRa1
         ofemyqHiEoQ2q8fuPPUEdZVWlfTEgrsLI6HtY+FNKQq43Us2W7VW9fZixxbzkZbsuny+
         fFK/TJgK2y+s+8Vgw7Epq67YuoHDxwuAHtT523fGF7Pk8epedvupqVPaLTlPKaLHgGTF
         ubN10wAXMWYRYX+q4ups/Z0OVLekIah5asJtIT0JxyKQd1Ewmgx3TvbicJ+DRI0+5Igt
         VFoQ==
X-Gm-Message-State: AFq9FYLm481Gd3nCRwALNrDumhTqX5n68DOfXaMg00WF8l93L0CL4+Y5
	LLy7zKGda0X6NrGhTn/EPd5YyKNCv+G4Q29lS7Xn9cutTil321pJLHY8uoxnaQ0un8/z8rX64jY
	P8/PhSQ0Acj89BvFQTn4pHuX3I0Ay8VWeviCqUBvWOdkK9xdT3/VAiqzE1RfrdT+LJX/RXi0=
X-Gm-Gg: AYBFou1msldnWOQfPfT0EbNpzaNU6nc7GuVal2CWKsZI2HfOcvInvCwar0KzjPAovRj
	UEgrdBOGd+nprOOHVjKs3K9TshH8XrwxwpQXM9dwKwGDcGmUc0iIxXihpxRwFmiPcy5tNcMUxce
	gpanYVhnNsAHrqY7u7WhQ6eAXI90Uu73fx55bPT6qqlgljkmC125h2FxGyWeQiyH0LM8Wk0sv9Y
	TUymc3OY0IeRlqOwFHCNdnL+upbXhz1LfYS01NZuubwFAVtTcoiSdDCmR4ikNGxRN7b9dJTg9/r
	Kr6tj9znYFVY08ODoBlG9/1TaOeixQNxBmiBew/goV1qV2NYJapWuZiiTrviNwffrij8+QVXYkl
	fgXJy9G3V7w4D+0B78Q8iN6meVJYnoMiYNeg78d/MqvIqTDvr7fu99+WykkZ/XPw=
X-Received: by 2002:a05:620a:2603:b0:939:fde0:a71b with SMTP id af79cd13be357-9442135c728mr1396720885a.0.1793559747509;
        Sun, 01 Nov 2026 11:02:27 -0800 (PST)
X-Received: by 2002:a05:620a:2603:b0:939:fde0:a71b with SMTP id af79cd13be357-9442135c728mr1396713285a.0.1793559746844;
        Sun, 01 Nov 2026 11:02:26 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf751c2d2sm238335775e9.15.2026.11.01.11.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:25 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:01:59 +0100
Subject: [PATCH nf-next v2 5/8] net: netfilter: add IPv4 over IPv6 tunnel
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-5-c6c282cab5cb@oss.qualcomm.com>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
In-Reply-To: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: NQUzyPGHMwg8FtVim1vxmxGlHe1jkivk
X-Authority-Analysis: v=2.4 cv=Wtq+otfv c=1 sm=1 tr=0 ts=6ae78cc5 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=Q9s6MkQQiHVZyQ02r30A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX+IGbk/MLmyjr
 lRKYA5MRXbyUNS51hLNwLZN7qqa210zO60SqqabEAv6GyHmaJ3lja/CB6rDAdBLEfjTLM0ZqtxL
 LtPeBb72a31TVmPAvTeCjRJUZm6UBXE=
X-Proofpoint-GUID: NQUzyPGHMwg8FtVim1vxmxGlHe1jkivk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXwVd/c8XFqFga
 GoJQYNjLlzYM+2jEucjyzugsPKvt2tAKbZgGkM4r5T/PuoHJcV/ZykFIMQhhDi1t6hv+qcwSxtS
 75DCyc+3EhfLbf6WXBH5Dd24H6TPYKGSopl2pXSTfwKjT1DHS56kMQJXx0+lCG4Fczx8f7gwpTo
 SJBK9psxUMPN54Or1gFqnAKw73BrYO3TJa0dAJtfJuON6iShoFCFMOxlHCISp2PljE8gVnL0Oo/
 ofBZSQGZR+2AVXhnAT0XyVvkJQyFmfRM83MJd7DW/6dTkolz6ZFh/unEIRC5kL+s9+uDglF7CBK
 lPVQ9e/QmpXZAQ7fVtGFozcKVcRjTthBk9XNrUn4CuFEkP+TdFa6x30UtFE5QCDyq8H5q6wXy+e
 AaGONWLOvm552RQwhsmKBLF5GHP3ftD/kRIl3H1xwK7/JvJ51GoNK5YvnpmWTQJI/IH4DsBe4Qu
 8HA70dU30ETOXNlHAKA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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
 net/netfilter/nf_flow_table_ip.c | 70 ++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 902b9b595677..2bdebd3ff5f9 100644
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
@@ -886,22 +887,38 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
@@ -1211,22 +1233,38 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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

