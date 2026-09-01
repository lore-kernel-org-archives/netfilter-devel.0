Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6896481652
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280370; cv=none; b=e28n2f/KsEz7a85/Lq80i3NroZNStnqfC8teg1qm6Kg5MuYHZnXW8xAfUKAYvkkF8aUbyvEaPaycAHJoG5Fzopfm+dikz0rUm5evujDjWzKGimHZ7FLVdDT+6RT2C0ff7RR+cTbMyBC3GI+nJLWQWVdn4739KjLoWi/03UWs5bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280370; c=relaxed/simple;
	bh=7CslNYKk1vnhXwILR3c9oztN26/8RPZZqz5rCw2kOOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pohh9CciYLpBQ4zjH5J9/REb48l6rxkaWIrq7G04y/7PTnwPJgkw9hlMGfra+A15w01DRJ7KD1T290k3xGkvDDJ74yY93mKJOUdcFeJ7ti/biT1NRMLN6RvgI1RZLYiWrL1Ku69DedmhAKYk7XbUwyfhPikeWLOhO2uMdDKGRcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oaiHOaN2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iVvwSeBN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oaiHOaN2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iVvwSeBN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8oKr2646926
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j5kepUX1QpXNYsPdAWi1drX7J4nYNsNWxblq3mQxLpA=; b=oaiHOaN2GXLKj+gx
	D1GzVctHO4WOeVZG+26HUMQOcTBML4QPxhhwZ89f/RGWS1uq+Mjes8cqrawksjH+
	PjMpoup7y5AZV3WIeeESMyYq7mKgifRNiX1ePi5+SbpM//1Mz22Uhk88F93Hx5ub
	BoB+C1yU2m4Q/2uxcSO/RbGsf0pdoEGzb310aXPcdTEo/e6glBVjFuCCXhNzhdD1
	aV6ymrDYRKUuF2Ead6j41luEzrwG5JywzRxVfArHUsv1izm8NHHfL6R4MMlbfn4F
	kWIofALN9DeNOwVXUQ8MiTBmnhjXBhB0hcy0hDX9gKH/lJd3yL9bHXu3nWYJmxEt
	ggRggQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdp8fueae-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:47 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9375d92d8cdso20924885a.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280367; x=1788885167; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j5kepUX1QpXNYsPdAWi1drX7J4nYNsNWxblq3mQxLpA=;
        b=iVvwSeBN/joJyTPgazCKXnnbBT//DG7FJeJZ58+8FNmPHfi8NvEHZe+GDM7sy1K9l5
         diwQ2Yr8kLq+j/eMnxqdEbjHLBoaUiT4rGwG/CY8L1C93U4eYI3S2+ABbH5F83OqXK4r
         bkEvRSFrMG4k0WDandp2QNfqbh8bBCy5ZswEt8hAJZSpZXnOgW7J9VL3bWL6d8sZnxnf
         uD0eJ+LxFZ7qJqBTSkzrsELl8Um9BMta76QXMr34ME9I7tgXv8e3YqqSGhynByZcwvcZ
         Jc+lCbNx1tDAIME3Ziv1Axh1LqdxLtrueCmKoKPJ5hYRDcDxSEvAvAchhDlDatR4MCUe
         pxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280367; x=1788885167;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5kepUX1QpXNYsPdAWi1drX7J4nYNsNWxblq3mQxLpA=;
        b=dP9Crpixwv2dsTOmq4hhsr1iU4KsTlj860SP04aAeH/IAyQ0Kxmwrj2TDfUg6Rvhpw
         y6Ukv9D+yVuk0sxh5RKJcYTMvepSCLQOkg7RaGIJjzHG3wO2WWf5/wleGCEweJp/Iazq
         bDzsaERgPQcOo/88odAQvN4hknf+dPuENmTjDenGLwNnPjvTS6DL3k2wQwKTkJ1FjPEv
         7rJcvXAjdPlra7HIWjRjnyNP5DKSSXmk65wXSIyUJ3ERC8UfevEFDvtv6XKfe8wKBAdQ
         OhV3SgxQXf/aivr6Fj1IrtfZYAe0NUFKaLhw0hIjRjCET7VFf0mzWb3pn+ZlovwnhAhe
         jJLw==
X-Gm-Message-State: AFuF++kwDQ42U7oMmGrs922kEaOeyGy6Blsun9KSx29DiMXeegeJgWho
	3dNN+Ob8ACQeFoEJwvUgjeRqO+0bq28HW2+YDETC1+mfeflUgouflitYAPjrBN9sResnQ1zzuGU
	oW7+aZiAGIC8hu7QVKuX8vn8FfpGjUQCXx6BrNscQ2TCnkb5qPHqwW6Y1fnF+l9DYqtrg8WM=
X-Gm-Gg: AR+sD10yhoOAwHigjCce7N1utuIMG/uvKfHfpLPKFzjvcGEgNdhx3iUxQ+TnoeX8JA9
	XNGZUj9wsJUM3rooX/K1YWYAj6tfbJMym0zmfqDcoHvPAaY4cls9xc+lbP+I+AlkTirherNgaHj
	zokTl4LriZOYfQ1SiwXTWXCdA25ZVuIay3vWQULiW3KMFpxrRJHpV87GDx/QA0IhMoTsiB5bBcB
	62VoSL0Cx6uFhskgXapNdDF7vEhI7GkLy/XAewE9KCGJPOVSCWqsQcoUbbxDQoavjI7mLKOH9ap
	kPn64VYo4bcHimUMt19NZZ4/uywF5sk6hkUTXzQ69N772bxORBU9VvNw0tARRl0hu5I1SbHvij7
	q7euTasDNglKlUg==
X-Received: by 2002:a05:620a:8ec9:b0:939:492:20ce with SMTP id af79cd13be357-939137b3b66mr2516450285a.1.1788280366683;
        Tue, 01 Sep 2026 09:32:46 -0700 (PDT)
X-Received: by 2002:a05:620a:8ec9:b0:939:492:20ce with SMTP id af79cd13be357-939137b3b66mr2516439885a.1.1788280366075;
        Tue, 01 Sep 2026 09:32:46 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce309e30dsm22020345e9.6.2026.09.01.09.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:45 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 01 Sep 2026 18:32:20 +0200
Subject: [PATCH nf-next 5/6] net: netfilter: add encap_proto to
 flow_offload_tunnel
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-5-72e49be8c31f@oss.qualcomm.com>
References: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
In-Reply-To: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: DABNEgymUpCG77oau85l0_fu3PtVTQNe
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX9X5rFEGZ3Z2v
 DcrelQ+rM0aZ8Or07Fvq68ujbdG+Aj10WNDy401UC18FUUbRmUvBRJ0PcxkqERjKUqEtHwSAUA2
 cMp8hSS1hhumapx0+Z6do/MJhaOXjuI=
X-Proofpoint-ORIG-GUID: DABNEgymUpCG77oau85l0_fu3PtVTQNe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX60hwitFtXq5x
 5iF9HBHVOUx86WTI618mQqieqxzbTf/EwQloGMv8Vcl6jXmJqKQE9aSdk3KtAOMrSXVMHBu18Sh
 L6M214kfJWhGGfZbKJiBvEXp26uKUUJxLYaCiombrXV/o5b0HkvXtVXANostTPn1sTi8zBNxxYN
 8irHPVlTXQHFGf/vErYmsjC60Mas53qDf9ZxKoJd0VcRcrv2H9Cm1k61ctCaiVN525GTgu8Fdiy
 emyjIk0yVIFcD6bp5pEFZOzs5eTHqFkUrsp5jkKMRC2x/PRtEDtz0G5/QyfH8orgkCtVITNhsDg
 xqxjrrl1ff9We5qIXfFAYUlDnIZAQ3686YPHsyjckPoMhtG4Tap+fXWsNNXdH416yICRaHjCxMR
 ntFP+OG0fmDX9PjTvrkL/TN0eJ4oqMZKIXyBWncz09PADagx1xMpPGQl6kKDXtb/WhNcud5B514
 IJPsDCsesJn9EHtH9IA==
X-Authority-Analysis: v=2.4 cv=BPWDalQG c=1 sm=1 tr=0 ts=6a96fe2f cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=EiAgCLLKtgnx6EotJx8A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010146

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add encap_proto (AF_INET or AF_INET6) to struct flow_offload_tunnel
to allow its use as part of the hash table key during flowtable entry
lookup.
This is a preliminary change to support IPv4 over IPv6 tunneling via
the flowtable infrastructure for software acceleration.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 1 +
 net/ipv4/ipip.c                       | 1 +
 net/ipv6/ip6_tunnel.c                 | 1 +
 net/netfilter/nf_flow_table_ip.c      | 2 ++
 net/netfilter/nf_flow_table_path.c    | 2 ++
 6 files changed, 8 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87cafc932e9e..22e4ed491eb2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -910,6 +910,7 @@ struct net_device_path {
 			};
 
 			u8	inner_proto;
+			u8	encap_proto;
 		} tun;
 		struct {
 			enum {
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..306e7d9ec3ec 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -118,6 +118,7 @@ struct flow_offload_tunnel {
 	};
 
 	u8	inner_proto;
+	u8	encap_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 1630325c77d3..e27323251a2a 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -379,6 +379,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
 	path->tun.inner_proto = IPPROTO_IPIP;
+	path->tun.encap_proto = AF_INET;
 	path->tun.dst = &rt->dst;
 	path->dev = ctx->dev;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index d5ff50a2ac01..64a184bca467 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1868,6 +1868,7 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
 		path->tun.inner_proto = IPPROTO_IPV6;
+		path->tun.encap_proto = AF_INET6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0aaf1e07f320..5cbc3cf10ec2 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -204,12 +204,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		tuple->tun.dst_v4.s_addr = iph->daddr;
 		tuple->tun.src_v4.s_addr = iph->saddr;
 		tuple->tun.inner_proto = ctx->tun.inner_proto;
+		tuple->tun.encap_proto = AF_INET;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 		tuple->tun.dst_v6 = ip6h->daddr;
 		tuple->tun.src_v6 = ip6h->saddr;
 		tuple->tun.inner_proto = ctx->tun.inner_proto;
+		tuple->tun.encap_proto = AF_INET6;
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..90360406d11e 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -135,6 +135,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.inner_proto = path->tun.inner_proto;
 				info->tun_dst = path->tun.dst;
+				info->tun.encap_proto = path->tun.encap_proto;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
@@ -246,6 +247,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.inner_proto = info.tun.inner_proto;
+		route->tuple[!dir].in.tun.encap_proto = info.tun.encap_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 		dst_release(route->tuple[dir].dst);
 		route->tuple[dir].dst = info.tun_dst;

-- 
2.55.0

