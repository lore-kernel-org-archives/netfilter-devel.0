Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409542E40D
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633801; cv=none; b=SCRMLBwz9Xe1MQMpftfU82FAajwrc8thWXXc/EC1V3VT64ntZ+PvCMfdx86WBgC3Om6VMyytCFMjw+gsjziKefU8rs1bouXH9+bNpLDuJzB0OLBpGAlYaeQaJvebIXLwj+Od8PONbeP26wrpT6NYpBLFEinj1pecEggsDxohBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633801; c=relaxed/simple;
	bh=AmYTVtq9q2zdn0RuPo3cddtrzQkCt+YTwmkXJN2yUuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XQLFnzewuYXwiaugIaV0L3JikvtIAehCRrc3C6boQqRrfLYX3J4Vf3SiXPI/N3BNi67Z9y+/Wt6fC7QKaOI4/ayivwMh+nly1u2nvazvNwsffCotUFidLAshv8EjCVxkbVPyYqtyFRf8RS0i1YlxZ5upyZ5uRHPaoZbskAiB57E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QOWqs4N7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TVaaN/MO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QOWqs4N7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TVaaN/MO"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H8TX8W597712
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=; b=QOWqs4N7XiO8h7K7
	7GB9L1hFp58lgOLna4yBkix/bs/EuGHcyefwf6QLrNOnf8GbbK6NUSI05kb9lVoA
	DwZLcFxXhTiNXF1KikKzMnIJI346m+j8sYk+gtI0Y9fL4gvex13lZ9mRrnvZqtbt
	/D1FRA7Mo1Zjfwv2diYV5WACllABxrk5Euyd0YD/RiWtP/0gX1zUgay+/h3tFYNv
	oOmcl9fufnpFWTs/1epBoEsCag8HTy08WLuc78a506jCstkEq0uRIuGgwDqR79xp
	d2dEiNBZ6IC9Rf5VFU4Dt3UM9OgciZcnOmedufCvmh9sipisEnRz7h6tcQQHhKQ0
	flouag==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grcra8010-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:41 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9390a2c895bso180873285a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633780; x=1790238580; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=;
        b=TVaaN/MO18XQPjgV7jFQJ4duN6g2vRkNlu+7R/v11UZQv/EIzf0bgb+hfFNunCjoY8
         fdjdRFToOODIftowxsYlp81bjtU1gCI70YDowiHn7yIDgD6qJtiOWYG09+pE/NXczoaq
         DcBv/b6ejDAwqtqB2xIUeZXqrF7hN7qT+TEJ5SXM/kvtlakvUxgqmkMj2/w7iH2SVJ41
         AxVE/wMKdydP6Uqh0WMgo4S1L3lrA3p2t0IxBnsL2lFZpU+ZPOyWEw+4tavE0BbFgOGn
         aeb/p4+yd+21RnhpO0Y3Nn2cKa2/hGvXkAZY3vD4L6IDF9rrr3TLTOL4QC2ezcg/vqUU
         1Nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633780; x=1790238580;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=;
        b=Yki8bKbezcC9kC9U3YQ1A2VpKOF8Kg9u/LsEmYDzb8DeHzqXeVZDxYhrSfSJlQmw/V
         GV0Fj2+dBBB0jN5onHja8gc5UTbgqGPi40r7XKd/mOSGm9ZcYU79agpPfDtFFifzw9HC
         xU5A/WN6FvBibhFQ2/oQs4zgDjOIf2F347n4xlfSKiEDqQLS/Z1xu6j3HQzMNAwo63hO
         ChB9EvzfgSUcmHQtDZ3r3w/1DvneZUptqW1M+rrKQl1kXJJ+usgIMoUbg9A2xAVLs6sw
         4J5LA0EtixFlR8YCYVVaaxmVwUmRzQzUQNwdNL9mPBu6CDdO77Io1HHKJWkyyLo30eh7
         TcGg==
X-Gm-Message-State: AFuF++mtgihB6xCyn3ndPyGu019B+w7zQAPCgyy452+wTFMX7XmUrknt
	+DzYofoToM7yEaNHDbMBRtoxF5fdfa/Rh3FRiwg9a17m0kIC7ARldJ67p3xT++fuk76TXPdiCB/
	27zzrqUeM1Q6tB44W6LN/6vv8aLSaOVXlnQgPUA6+AXyOzlIx3AwbDCid9vsoBeb7UUtcQLs=
X-Gm-Gg: AYBFou1/jUvffec5qdMoLluMXCC1XDQ8AqGbGoBmckGPeyChL4Ybv9cqjjsTXbYh7Pz
	3P4hFZhLzqlyhI1EW51zgXoulpe9jatYkhXVWDoYrabP9UXdr3/atmMelrmznALvqIH/DOxkotw
	pX76vEZcK19CmhccaRoN0dbBrf+WgH3RGY5Wf1t8PBL19uZSccv9UWgxzHd85I4sRLAfMO2C3Nk
	BBN/YBOEBepkZZmYfJq1PNtO8JzVfGxeUr2Ou2tqothlvr6HqAB0walmYx0uRtw8UQ3KXhnXAlk
	GhgRwsnEQTacY2wmCUxtYlu0a9jChMOhMlK3u1o3EuEiceyzk+FGkZQTptKUY6y1QtbfyRInvna
	/a9rzdK/q4SpHNQ==
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr692326585a.49.1789633780483;
        Thu, 17 Sep 2026 01:29:40 -0700 (PDT)
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr692324285a.49.1789633780023;
        Thu, 17 Sep 2026 01:29:40 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fa7dsm13614369f8f.8.2026.09.17.01.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:29:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 10:29:09 +0200
Subject: [PATCH nf-next v3 3/6] net: netfilter: nf_flow_table: populate
 tunnel tuple regardless of inner protocol
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-3-fd2ea96fac7d@oss.qualcomm.com>
References: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
In-Reply-To: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfXzKxYsspWxJnP
 g75Cj/d7tQRxtk3iTUf/UtoGvvHXaGwD3e0MsRo8gvYjQFqe2EhyYYBjirZS54Yul4rMSHfLo6B
 LPfPBjKOjrIVI4hUbkCHzWQubZJgvQ8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX1Wx3naMDLro6
 MGV0S+mLtruBa/25pw28YkWxGuDvXkhoNAK/KabumqQPUodjTvrdYc+un3oJEXP1QRiH586aV51
 Fhe9Vatrt4ZrpvblNqtnA/DvxhNgHyJLnE3eeFK50PDX2yuS2OOhAdhdD+vZ2YAJu87Hsu2AR+r
 e9mcOZsK26Q2a+LYMS7tIc/qm+SVJsnXPZAmj+LDWEv1cydX5aLIaOmeLqjxdrzAAqTpUuGsOLZ
 wSR8/OSlosC38L5HCsarBtQtCtkdTbgdHdIRsgCfdUtggtTWPyOo3SKH522SaDIk023S+wiShRR
 Wl2BMb5xvSM1ktXDlBTnld2rr6T8IZnthC4gBsGIVAfhLB8L16o+qmeczb4Q2PipR/Wst53ctXN
 qKZfe+EvTe7t2S52PuoG3XdWHGLoU73doJ1Z8UQKdbjMQ9lXor9LKgvkAKPZCQU0qA1IrdIb3AO
 CaypymOna5BxC+8YZKQ==
X-Authority-Analysis: v=2.4 cv=WL/qzXsR c=1 sm=1 tr=0 ts=6aaba4f5 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: KHo8Yr5YX60EUUiuyMVvTyGQKZxk1G-2
X-Proofpoint-ORIG-GUID: KHo8Yr5YX60EUUiuyMVvTyGQKZxk1G-2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170115

Store the outer tunnel addresses and inner protocol in the flow tuple
unconditionally in nf_flow_tuple_encap(), instead of only when the
tunnel is IP-in-IP or IPv6-in-IPv6. Bail out early when the inner
protocol is neither IPPROTO_IPIP nor IPPROTO_IPV6.
This makes the tuple usable for cross-family tunnels such as
IPv4-over-IPv6 and SIT, where the inner protocol differs from the
outer address family.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cd636b4cf74b..a53393f8eda0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -189,22 +189,22 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
+	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
+	    ctx->tun.inner_proto != IPPROTO_IPV6)
+		return;
+
 	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
-			tuple->tun.dst_v4.s_addr = iph->daddr;
-			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPIP;
-		}
+		tuple->tun.dst_v4.s_addr = iph->daddr;
+		tuple->tun.src_v4.s_addr = iph->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPV6) {
-			tuple->tun.dst_v6 = ip6h->daddr;
-			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPV6;
-		}
+		tuple->tun.dst_v6 = ip6h->daddr;
+		tuple->tun.src_v6 = ip6h->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	default:
 		break;

-- 
2.55.0

