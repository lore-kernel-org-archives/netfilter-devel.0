Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1134973B7
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403662; cv=none; b=Y6tFPmyHXdtcUOkT/du8SARWqCXDD4V60f6yw8j82gECGVnnAumaWQbT4U3BVKgibz4VmMYFyhEBp+HzSJbvgw1e5X9dFIBrQcEz/XcIpSUiz9rudnjqxpMhMN26iehH1HRJEUfw4RJiVa588zr1d+RYRG/WRPIg/E9MbwWQuY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403662; c=relaxed/simple;
	bh=BL3oGn/LL/2F5RMkxXlmkBRxIQjgu4TbcW4XHa/vdLs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=aWG5aZKHruQrXjgY1EFpsl5GO/BnUv/M7ZHo0TdfCUHZOdcJyTCNC/2AeblF4+MRlTsfpCzXGi4WKHRAB4D8/zexwAnQXBkTcZQTiwPS5h10Lfs424HBnaT077mbJfkpTv6Us8vusgQQKFdjTajCOT2mM3x2LHGpq7CHX8YatwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WaQ9frD5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JfyPnU9d; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WaQ9frD5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JfyPnU9d"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8Orrm1665504
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 09:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Jnh2LHDqAZyw+kfjNWRxm+
	Y9eId9oJCvEqNJ5fnGlNs=; b=WaQ9frD58EO9OF7z8CquO7HejM+9SAUv5PTCFl
	xI3rUKzhPOPK7U23Vb/JNolOt4AQ07NfN6BqoioeC87+n768g3dUo9ECSwosGx7+
	hGIEN/WZqxHrV3+m2Xgq+dwaTRPbkTkNAylZZHLdwHrVc7iS4NUotxbuAQSWOilg
	DI5/oHC2NXsxgqzCrPEuCikUFbv2okryWwQ8MxMFif4BE2moowjrhZ9I4hIsjXdX
	llvXyqm8F9zhL6eYTNN1GZcwOLCUaPpW3QYjWZncK/9wSgyirdKifaFVf7qG4AVz
	I3gVeAcH/yIcMkxNgUjfjDDmROn2NShKyUAmlEKAZ+Kw4oYw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf3n0fn6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 09:54:20 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f1e62510cso469547285a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 02:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792403660; x=1793008460; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Jnh2LHDqAZyw+kfjNWRxm+Y9eId9oJCvEqNJ5fnGlNs=;
        b=JfyPnU9d8iEZr5v5Ld/XlABebje3NgBWtDgtqfsDWL108EHfwOz82pjhHWCPWg10sP
         2An+NYn8VfAPHmcz3rQiKbMNjM7o84Cvb+UhrdFHJcaL44HDg7Cd9dC+cC/dZ5Gz7kwI
         Fg7gyQJ2mVUZIbzLZ5MVNLZiZSCvPlFWB6N5HC2TEl8FHWNA+CX5zdgqKirkAAtJe0nO
         RuMCUk3iMLnwA3KPlA3UIdTvqGAFvnNL5ovISoeveikxjUf1y81EW1ImWOfFSXmsh3WS
         Khg2WqaROSw/tOlSJlbzwex8zGVnDAV8PHu+hoCYPnMKpPFQWrda6QA6mTwNZVlNPv5m
         nBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792403660; x=1793008460;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Jnh2LHDqAZyw+kfjNWRxm+Y9eId9oJCvEqNJ5fnGlNs=;
        b=XvNOtj+Aj9kkCidyMNAOy24vtZegba98w/XZ4WfsJlU4MSDHodXYDxi+YfGIDEjsvM
         abCH3smF8g/ksYq3ff3fW0UTiArjP5sswxAQwfxA4bY6wtfYz3STtbii1gtIxiweTGSj
         DLPN5wvtmK+iTSRXRRms3wLQYUXdCXlMI6emtbRIRaVRYb1yVjD5PtFZgnWhbLUid6Iv
         W2vdNa5gpfOK1q4WepglHBSSYhDa9fXuiuEC1aFg1vO0Se6peX99ZxzIU1Tic28a/fS7
         P/tEdefvGqqFUqT8NzQtj9AzrKX23S5nx8p2jn6QjJMoRI3FPZuwG5FscgrJM07z5itw
         pICA==
X-Gm-Message-State: AFq9FYLCBSuj2sGNiE4T7h1N8sv5OqNLGjpuBM9J2NDUqo3aWNSY9Qt7
	PP/52hwq14ExZ9UQyerZIC5kqWN+vNAn4A6/uI0xBvnvMBKDDT803BUwLcrocS+JVfHa81f9nAZ
	n+CTLjPlTLMQcmOEYAG14eEKrle4UKYmE6sff67ck5cokfH174BEIbv5rfoxGXEBb28Gqjgc=
X-Gm-Gg: AYBFou1c0HM77Bu1IVbvypAEcOmCWEH91ZllnDyNq5kpwIMmfHPW6jgL3q++gw6w5Vq
	sqekJa5AVNbMZnr7S1LybgmFMmyD9nKmccxC4DMwSPdm0AXuMii5lILgKlzMzjjy0m8wsrAVxuM
	9k1r7Com0WeJBZZPqwt0eGgM3Gp2ek0RMgMfz2R9oyTsXfqcom/v5EmfY5KIeEWnbpXsPVijn8R
	QyW6O3eB92P/me4HaEgaMFnJWvGtI1pn1yUQBvdv41qLUZ/D4vAA9RMPWRoytidq8h5z9Ibw2dI
	ICMnCKZ/kwHmSBaf1pyJ+9XpJ+9+5Hz0cN7TLREAdNG1iGjxVChTMf757LT3TkhVBLvWaT8pea3
	rnisTnQm0noi+Wg==
X-Received: by 2002:a05:620a:170b:b0:93f:2779:58c with SMTP id af79cd13be357-93f29d682camr1188163985a.49.1792403659718;
        Mon, 19 Oct 2026 02:54:19 -0700 (PDT)
X-Received: by 2002:a05:620a:170b:b0:93f:2779:58c with SMTP id af79cd13be357-93f29d682camr1188160685a.49.1792403659164;
        Mon, 19 Oct 2026 02:54:19 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd510d60sm21418026f8f.58.2026.10.19.02.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:54:18 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 11:54:03 +0200
Subject: [PATCH nf] netfilter: flowtable: reset transport header after
 nf_flow_encap_pop()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-nf_flow_encap_pop-th-fix-v1-1-4b8afcefdff7@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2M0QqDMAwAf0XyvEDTieB+ZUgpNZmBkZZWtoH47
 ys+3sHdAY2rcoPHcEDljzbN1oFuA6Qt2otR187gnZ/I0YwmQd75G9hSLKHkgvuGoj9065Qiebq
 Ps0DPS+Wur/UTTGA5zz9Dl7eMbgAAAA==
X-Change-ID: 20261019-nf_flow_encap_pop-th-fix-0d6ca121349f
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Nono dorimu <sudononosleep@gmail.com>,
        Dong Chenchen <dongchenchen2@huawei.com>
Cc: netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDAzOSBTYWx0ZWRfX3CkdY/RVvLoq
 FZGGTuQO4a0vcnzGt+ek3JdC8CT6gy3KaGaJm7S6ggk7/YkzDnG8SbSClxJiiGGb2M8/MAQE2Ec
 abq8PzUq3HYsYpD/iG23KJQ+DN8Nizw=
X-Proofpoint-ORIG-GUID: 8VytptbmeQogfE3SCMxLltoEj5B1SzAv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDAzOSBTYWx0ZWRfX2/VVzoy1i3y2
 Yz06PGN0DsC7uyixLmfA6Ar8oyCEfdRFq30PLdhDgoo4y0byT9JUVXGn5mVxD1vW498ibmBbyGM
 YTCwYGVoX1uVWI4EnGH1oVs6XOPMn3aqLkjGqiz/h1tzHpptQbnMdp0COk9j3YnsguWsxLl8kf8
 pkj1Dhbn5WDBw6zEE3zuphd2w/8a07c03w/gWh2mS2dQ+DUajsepRHOxncPcmRyh6Us0kqETHJu
 0IpK63MFpUkzjRPbSzmVc9c+VAgVz+nHCep4oTQLLdWlORCxiO98aX8gXjMCb2U8q9XsFXDDOGJ
 Jq4Bin56rSBIcil6hzzrLtoyXviePQEuorj1KGPeA4Qrz/qfZOBi+/6A49ZhDVsL80cII9AZKB0
 vQ2z8E+wRRaj6bJEU78HYoqdFP8U9DPU9LmNJi4p/h3eKVHKA3lP9kxA0w6X7LtlMprtqgDIQB6
 R3yCLoZXMLgxQFrKINQ==
X-Proofpoint-GUID: 8VytptbmeQogfE3SCMxLltoEj5B1SzAv
X-Authority-Analysis: v=2.4 cv=Zf2IpcVA c=1 sm=1 tr=0 ts=6ad5e8cc cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=1xW1JWfKw9oSDmfl3j8A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190039

nf_flow_encap_pop() pulls vlan/pppoe or ip tunnel headers and resets the
network header, but leaves the transport header pointing into the removed
outer header. Reset the transport header to the inner L4 header, otherwise
later consumers (e.g. GSO segmentation) parse a bogus header.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..e0978f8733f4 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -502,6 +502,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
 	thoff -= ctx->offset;
+	skb_set_transport_header(skb, thoff);
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -1097,6 +1098,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
+	skb_set_transport_header(skb, sizeof(*ip6h));
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);

---
base-commit: ab699d296e066eb64f51d2a8a1d42237a3b186c8
change-id: 20261019-nf_flow_encap_pop-th-fix-0d6ca121349f

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

