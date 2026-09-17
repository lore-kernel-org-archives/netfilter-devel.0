Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA21E42E416
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633801; cv=none; b=Mm+DQwUq1oJYig4cxnln4iifCVf46oIEUyT+/XCNZ1Kh00VUHGKhdt0dzWrcvUaPFuvqexAHZnJtm3JhyzdmkCvUyV5m+kCcMF+rgGO4Np9i7VH4ekdvthOmmewnp/cwtXwUlDvj7vrVf1ntqK1bY5lv55l7ah5Kni4FXtDhFN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633801; c=relaxed/simple;
	bh=rNxxPYZvvS0xziEix65HCNH7tYsfMS2iHJ3mRY5rHkU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ood0AVsJ+cgCDx1/DilAZnJKYmCKcGGYjeNJO7sFj9S87DKriuVK0tFhzP0eW7KFMuEAqDNb6RjidXD65AG/MiZx1a0nmY9dVSzLmWI6i0DEUHiCHf8DzLmU+uYikn6KWrbRcIi/zrl9BfBqUqryo5W/0uoaWH0q0Yuh2zAXTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pvEhesEH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=doeRefQX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pvEhesEH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="doeRefQX"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H60u4M1375673
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xCN7YOfm7t7aL8aoNmpZZk363y9KqRhIlG7E2MGmIUk=; b=pvEhesEH16daytUF
	hgc/XtxMR6ux0LJ1wqd1P51KlXzWGVVWu9JXv4ngu2hDIdiMmHuhjlCbeCSDK1DO
	2L0L6ZYfwydOK2/YPnKVeJMyxffyVU+wC+6sjUH8zAVKXIcw9V/tI3jRvLd/4Hj2
	UoApT70qZA/RVZfsyZyZFn+oRzedx7qygUtPi+t/1tgTdhUfbx6gh8BhHRyFrCpF
	s433e/k/nh0u2bIXoZJPrCdJOISUqlKxTcgAMZjed0vS0AGrZxOPS/Ee/NaXtZmo
	meOWN+yy9hZie7fGd5M+papQcye1PUjPb/ZCzecTH/INABNc88lFvO3Z+E17X8Ve
	tiI/qw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqy6au7x1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:42 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-939d6c515deso113419985a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633782; x=1790238582; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xCN7YOfm7t7aL8aoNmpZZk363y9KqRhIlG7E2MGmIUk=;
        b=doeRefQX3x8nif67EB2o0618VeAOE6GNmxTkQITpPlQJNlRiW0gx5OgjdP+dCgHv8c
         8oXZ1gTkZq1Tl9Gzef2oDMNFno19Dxnfl88dZ1oeKD50VZmURPLgR8Kpfc4NqhWXML2R
         SJsoYgREYrc5WCuAqnymzqocg3bf2FnXrPYx1S4goRui8WoIEOIXQWNszFJEPe6mrit0
         ReIEVGyn7Ifv33aNbiEnD9yVfTcP2WEA3odc0K2EFVRuQZGXqjOig+0NhJHsHNXWEBeY
         k65DnwQA8Ka0+ARfvw4Z+9Fs5NQTPTR3GCyaKXKqCGaPhcl0Q1RLKXGOr+IVkkTHzNNR
         dedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633782; x=1790238582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xCN7YOfm7t7aL8aoNmpZZk363y9KqRhIlG7E2MGmIUk=;
        b=yWeUD0Zr3b3tmh2gOwTX01smzvclNpkkWb2AJUsiZbEThdUYK4ODQp73OgjUMNl02q
         Q8BhpMy+JVK1A50Zhh4kZdRX2rvYAU3q6GdhjxOwN6wR3hazPTCVIIfWNiAE72Cga8mm
         UPvgZrC5IZfsJFcQWWPdsj06tNit1R9zfSxGc/sgHbUEppCe9SGsQ+0MRaRJrPCE062W
         xWF+kARRV1/XkUu3FhvKnvjKDrpFUMzRUlnFKfNtHsykrm0pXEYfP8I3quDEba9Zkege
         oM2mpSi/uua6d6xwnoy3H2OOcXE1bLPPAaLRz+w6oK0TeT2qBUVyeEqc2DAEIaQzyntX
         NfHA==
X-Gm-Message-State: AFuF++l5w0Oyj2r4ouo8JbzGy55xIgzpiM9u58/dfBuVFrX+0KkAp6cS
	2tii2iUE+TvUiBBMUPeQ4ehlru+H8ooHeR2S8uV02h8tHFKeXID3dkkgJx6Nk3NpGMZgrW1Xv9Y
	VtWAf0BT6sRX/taZlI8Emc0+8jsU/h27JHCkTQgNNcfsenMFfIwnmxi1wDp1oCpZ462V4tTY=
X-Gm-Gg: AYBFou0LCwz6lIrBKDf5H9lS/Esff6NK4ZeNqjNgmS9FclCNV5i6yUI0iP7XLDWSeAF
	M7ie/xbnM2spw1+oFm+9ssmIyhuB3yQ2pgzT3clSoW1dZ3dopWirdJVfD03YyOkN7Di7DzCOHsp
	vlb54gJsb13z26Gmn98vcCJpfvTPcFKHTBldZufh7aSHxKt21Uu7247ZqUS+wy3RMX3BqtItjYS
	ro0VFNpT4Q7wgEW2r9fK3d23FqwASkDvNO5evjhfAzc8YDDPSBdlndi3OOU5gBvnd4lMIc9Rp1Z
	YGIqcB1uY2QqeNX/4cia5jzVEWqI4DWXiMPwLoUnKieoZ4Rtx9vJSovQOdAoHUF0VEIBxsobSKK
	9l0+utJQZmKKJtw==
X-Received: by 2002:a05:620a:890b:b0:93a:2ea6:4c6e with SMTP id af79cd13be357-93bb794cb7cmr1057577285a.45.1789633781945;
        Thu, 17 Sep 2026 01:29:41 -0700 (PDT)
X-Received: by 2002:a05:620a:890b:b0:93a:2ea6:4c6e with SMTP id af79cd13be357-93bb794cb7cmr1057575085a.45.1789633781560;
        Thu, 17 Sep 2026 01:29:41 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd32c5e1sm82617415e9.5.2026.09.17.01.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:29:40 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 10:29:10 +0200
Subject: [PATCH nf-next v3 4/6] net: netfilter: add encap_proto to
 flow_offload_tunnel
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-4-fd2ea96fac7d@oss.qualcomm.com>
References: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
In-Reply-To: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
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
X-Proofpoint-GUID: DsAhBBCPXqGFBn25mx_NHO-F9tKstvnI
X-Proofpoint-ORIG-GUID: DsAhBBCPXqGFBn25mx_NHO-F9tKstvnI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfXwljcjwyEhtAL
 C6x4FJ9yi6I1GqdOqN6xLRINe9PjexlUt9FufWd0rUZv1oH8MXCI02PkQJh/Sufv7NzoUs8usHq
 Cz8YBZNMGdum4LIfsUR3+Ip0Ts0pkPAppWU4TaNCqzsW31juxhKlZEkvEjVRibXnjcA8Voa4QUg
 ZmOVQ8IuZJIkrji8VPL6L8PzuTPavl5Bgi5/LcPB1i0d9A9fpMHbvKH5Jtr2BfaBvqmvjHjlQsQ
 FYrFIyEd6+5961l4BrJYUrCC6yzgRwEsAjScBQ7818JnlrifxGVTzNQYVu3D7jjQGKZn9AVTavR
 FC3KWlHr2kI+eBQEfSTKg1G/rMYNKo2CHv5DhmLAgasDRMSiH7ZFIT91QAovEfUuVgUWtQQ1oE7
 U6MMBY38S8oNOxNPGYDLn42M0NeGZWV8ck3Dlm4diBFjyTFb8LacHjiJ9JX2DVgNzvQVlPsMrc2
 3ckpu/4Zn4czaHPB/pQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfXxrkQGLRv2ahl
 Ppiykvx6KxuuvV8bZPUfcdeDRpyvLy9Uiu0ew4B2U+LJAcoT4hCCkCHeh482F7tgZ3jXbKSsrWl
 LDOENRtOkdiNYzCvIRkV+8p/Ag3TRc0=
X-Authority-Analysis: v=2.4 cv=VIRIDNPX c=1 sm=1 tr=0 ts=6aaba4f6 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=EiAgCLLKtgnx6EotJx8A:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170115

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
index 1f0710eef185..1feebe423c66 100644
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
index 2ffe64e736e0..15189e1fa068 100644
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
index a53393f8eda0..1b9360d54dfc 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -199,12 +199,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
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

