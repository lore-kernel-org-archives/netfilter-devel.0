Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0142E416
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633784; cv=none; b=jb3LeX991bYBchz9l34jJIra+VyaWltacLvWSnLnwq41NMYj/x35dy0lqyxygIeV2ofxSACs58V05GR/cVb+hfOWCkhOP5zamogp+UGoS2/pnqGB6/P8EeJxC+lya9nQbFCvL3yUorgcX99wNqmk1WFWlVlIPVajg8YgVCwtsJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633784; c=relaxed/simple;
	bh=lHVF8s0Wcz9LBxO8G6crtjxSLQILW6JFK03HQ68HxHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JqLqRl2vMf2nVpZCRgBq3XKCSkBgarPfgtPETSG3fLALcevljxECGbu5WmmPVOtH+gYI3J2ot4lu50Hxqa1PegXbkMCRNQq5kWUn0o1quFNykjZZozNv55vW6YNBM/jTD1rQbfs29Q/a/dM2svDlCSjW92utDHCLbXiKzDNGNQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SKRikF3R; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MSw7po0Z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SKRikF3R";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MSw7po0Z"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H60UF71211727
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bPPpF5ergNhRT/pW00RFS37TyyLLqr/jihR+fYpv5CY=; b=SKRikF3RtqYA1Kpg
	fcEmjIOh1ebiWa+/VmuK9tREQROdOWelHHILKSd2enSBEZF4ePmpaZ0CADVk3df7
	t8OHaV4rC5nbjswXUTJixOZOHlji03TNX/sx4yYKYHY5KDtqufVRYcmNM9ORrOM9
	DXoibWKG0Ubxl/2n2ItzC742AeF4guLqvZTF4DOmGjOOPR+3oW+g6Es9luEEXIn6
	Rzuh+RxAMCsF7IIA7mpT+7xID6Xcdy6repJ0e2B/UtkESfdy92z8rDhxZw9Y13YV
	+5dL+y6PJeXc8+hxbKWlUAweojL1QK8Gi2Wv99Um6znZB3faJ1SsPYYAK8lCaMh3
	Nfjs8Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqxaybj7v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:38 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93ae8e7e546so108058785a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633777; x=1790238577; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bPPpF5ergNhRT/pW00RFS37TyyLLqr/jihR+fYpv5CY=;
        b=MSw7po0Z2kM0ci2GWv9AsOU5v7l0y4sdtn3j1ijyTcGnfii/FRvYqZS7Ln/h/IevkB
         5NeCfLRk1K3gp/mNvvWpD/IH9K7o/4opID3M553FcG32/7S6Dw4Lxvza4P8uTYhz1DuJ
         hwlxJqS95c/C+d1HdVsy8l2081H8+CHqpZktL3br61sBy/yjqKMFbrlOdOMyz/tee6Yt
         vP4G4jzMe2pjCYWjadrqGwr9zMceSs5yhpmOun++qQRJeyjjepRuYXxR8U3xiUXNiEA0
         FPh65vnr7V1n4DeKT1oQkupccPxAcSkR50xMCg5HewHmxYRS3T1pFzv61wI2YRtqo35Y
         rmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633777; x=1790238577;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bPPpF5ergNhRT/pW00RFS37TyyLLqr/jihR+fYpv5CY=;
        b=k9Hi14wQMzvylYHCEw/zCxMkhWzMGtdkL4yfM55AFY9zMSH6f8YGgVIuhh6WoC9TrN
         wMs3vBWgReTNzmz/gzXotxMAs4inFk0rrwAPsK679e6Iz/9ileth/hIxFAWanUBGlUeG
         XfD5csnPspJxRJHXHBN3z+MrUJXhdFbHBtbJi/e9eg8beOcKlG5Crs+i3sanpq2UV79L
         BjiKZUHJohtgW1IhZgYh5VsYIVTXhLyNI3xldm8UEJ0C1p9RP8FQzuWA+Oy/O/GFAm1M
         wAS5hC/fpnpjYM1bUK7i17BbQ5B/laKx6tuhZ36yrTkn9ZmBEyjHbHKSjWbkV5A2WxgL
         DElw==
X-Gm-Message-State: AFuF++l4g2vX1jhiHcBk3WdUC3R/vkm0Kdk6/fZIgVVmxKvslGh47XPh
	eN7w9JCmB+lHGnMi9oDXrrg6y1iaOFuHIUshHWpo2ZteMW+Prg2V5nPvefzJzbb5UVXkgkwKXeh
	CcU5/oEvkSYV32+1O7MRKqY06id99nNQ7m8ehKuk6iceafpy2BLFn1g/Qz+fOwYLbVzYg5TU=
X-Gm-Gg: AYBFou31Apnt+WQvQ7YF7cm6Z1JADBMQFf4C+eK1Wp2qptEXuDHtG8na7acsy1Pqeuu
	+LO8brFJLi47eCykD65tX2bhTXW1FVaLbgmE1xkQHgeZXah9JtFI8svOQITkbI6jyKnPrBSDdGe
	XMXF5beoko0dzX42xlZxBP/4MKiIMA3NvdYwi6owhecLnHPGKU9gbBfQzAj+QpHvc+zX96iSzhG
	0J2OJm9AUJJHl8WR3RAVhpqLrWS+QMEVyC0++EcoTTbYnvGRjx8fWWkzFpGhcSYkW/99lo56RvV
	2+L4k5TyGqo7vg4QgwXeksSbJ+Ofn2Ye6q9jVo3oz5kG8kjDGZoX+PrZHhwfwdOJ3ui9bCQjOR/
	qGkuY+G6EBf9v3g==
X-Received: by 2002:a05:620a:4592:b0:939:31b5:4e08 with SMTP id af79cd13be357-93bb7267e92mr1068898985a.0.1789633777494;
        Thu, 17 Sep 2026 01:29:37 -0700 (PDT)
X-Received: by 2002:a05:620a:4592:b0:939:31b5:4e08 with SMTP id af79cd13be357-93bb7267e92mr1068890585a.0.1789633775780;
        Thu, 17 Sep 2026 01:29:35 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27a41sm12854951f8f.18.2026.09.17.01.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:29:34 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 10:29:07 +0200
Subject: [PATCH nf-next v3 1/6] net: netfilter: nf_flow_table: recognize
 IPv4/IPv6 in tunnel proto matching
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-1-fd2ea96fac7d@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX+7S6PP8wYTay
 MPpRTzlfGkTPvZc6aj7VUxzpf3kDqXRE1gPQ66ILHq1507rlMYv8sZoNfjMRLjUbOpGH5efrjyu
 f5MKJUlJ8JzmT/r4RE244fy9IzjdAQdBSMyymoLxRExO40aPZvEBM+5PvPolAxJBGA5tKDCzxlz
 fqoOm2BTOS4n6PvH5lTGtYQJvHsE9tAamECZItCTWy1vaLlLn4DpQ1oXcISlAGXGil6dXwVGXCO
 bWDh/NkkuRiqGxyes7/tkrQX/Stc0mXSXKbPIHa3b+HJ3IUpSEKg5sZGtXNi6/5pSgdiqDKPc7w
 sZG43cJDDigmCA1LIERKg6aLSPzVMKtzbSvnqAgEW5dr+u+s+iYL9/PBsEHstKTRSuNAmdvuNAT
 NykZoXYUCH/ne0UmSKaUjiv4euF9RlAhxJ9hCspWPCDv1Mlpt+W4du3U+QEw8lQ8Kma1XKIb69U
 8LBEA/nmp5POXd/L7pg==
X-Proofpoint-GUID: BiyvTadqhI-BcDUHZd5URr1FrW_2Q8lb
X-Authority-Analysis: v=2.4 cv=EoJHPicA c=1 sm=1 tr=0 ts=6aaba4f2 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=m99eJ5p7w77CmUfuVTAA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: BiyvTadqhI-BcDUHZd5URr1FrW_2Q8lb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX5vrX1Uzd4iM9
 y6qSq3kWp4+VHrCxNXslSIg2yBQJDPGOCFYAKznNu8tK20CcGpG6kApNFpU19fQ7w10ujiOI2YU
 259noB+u6xKQwjJB6muGxMuaGBGXqzQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170115

Allow the flowtable to parse IPv4-in-IPv6 and IPv6-in-IPv4 tunnels by
accepting both IPPROTO_IPIP and IPPROTO_IPV6 as the inner protocol when
walking the outer header in nf_flow_ip4_tunnel_proto() and
nf_flow_ip6_tunnel_proto(). This is a preliminary patch to support IPv4
over IPv6 and SIT tunnel flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..42e8de696474 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -326,7 +326,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP) {
+	if (iph->protocol == IPPROTO_IPIP || iph->protocol == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
@@ -351,7 +351,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (ipv6_ext_hdr(ip6h->nexthdr))
 		return false;
 
-	if (ip6h->nexthdr == IPPROTO_IPV6) {
+	if (ip6h->nexthdr == IPPROTO_IPIP || ip6h->nexthdr == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;

-- 
2.55.0

