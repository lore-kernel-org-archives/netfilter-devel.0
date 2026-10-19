Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462444C225E
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 10:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405011; cv=none; b=l4i9ls3wGbjbeVvS6Ie1m3lXTpKEgL4AnqCuM2hwg3dT7rZMKpArgZSWLFSyG9LNo+4cdjIWyudUsbrM3dm2DSJmMW7T4DcHdOo1X6Sqw0+eFNVmV9reBPdrjZBhyUWtl/rnXqyl/pX0SgT546rIcCyzN00xFHosrLmcU37EqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405011; c=relaxed/simple;
	bh=1H0FNz+n80FCown/LZvUyZBH0Hf8RqvHhNNGv70eFqo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=WfrtFGJTgfku7UVb6TV/vPY9m+Na+exkGeeY1iooe8jLgBq102SOqOT3xKFnLraELCO5fyq0K1mYebXB6OhymOX9eVan8/mrN8I3OHfV0JaWHyvBjOmbkWpPT2vlMcpE89OIsKtpCbxUm+cyCmgruGrPltfCZJjtY8iDQ/1xvUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GGdbfS93; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VAA1gI2M; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GGdbfS93";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VAA1gI2M"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8PExo2193438
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 10:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=/TzuN/kAKQJmAhx9QGfrfV
	bOHmKxUQ0A1jrrL3yIsPQ=; b=GGdbfS93mde0fPqQ15LM9FbrpP2MkPyexVDmK6
	u6iXZiOCyRKGbWTPzIKlRFQHnn2t39HbcEjDrZAPumHTWnsljasAbRB4GPqY9Vus
	4KDa4rWfzBwFQD6phj3ShxQvA0AQOYDAu5Jrzq5K07CJm4GqxBNHByInichzOeK5
	yKLeui6XyQLnEc8MfzEileDtvW3W4nuu99+X11lgKa7T5h/pFW/uUwp1D11cEiY8
	+wT9Iwxz9kPswRbLi4DZUqClhSjww8Aym6c+uiCYlJNF85ztG2ByZ+evc82rFvZO
	D2usT1G7DbaP7ReZsKCiuXLhkZzMvdPtmTba3Qq+Afz/DGUg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hd5w1a80r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 10:16:48 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f13c143c8so371485185a.3
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 03:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792405008; x=1793009808; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/TzuN/kAKQJmAhx9QGfrfVbOHmKxUQ0A1jrrL3yIsPQ=;
        b=VAA1gI2MEexu/k0Xd6GcWWaRejeS7xAzXvgK7+zCMJ0qXvdAmOgo3fcaw3bC0yYq4y
         oJQyJ/Qyua1BEI0OMJVRHIjntjqjYHd3ZpF9TPg2o8CG7G3rAk9bEPJKvd1z6HIQeE55
         yXniYoDlM/WBdrFmB/MmzWafOUsmiYrWoiUPwFKnNbHw4W3VyHtaYPXQ2jPJxrigNttS
         STf3u2lZ31qawFOq1dXyLVV4De58OvkStQvyl7ySg164JS11L061qMxuYSKEkqMLMtPL
         t0hRornl0OYQou+jUjS0bTXoy+ds1q0CsB1NpaQqjaYk7GnE552k13N46iSuacSnDcty
         Vljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792405008; x=1793009808;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/TzuN/kAKQJmAhx9QGfrfVbOHmKxUQ0A1jrrL3yIsPQ=;
        b=VJLUv8DS+UBtYZcIoU1azxFvZCZGT6NtyUO53E4udtsXvsgjYojN5KgFP49Vj0HEmR
         9FTtqYslOJjnthZxu5ivb17O8xjiQ28wW3zi/Oil8m9xBOQUgHcVCgEl+H0mvnQTlfUC
         ZKi+8k0QHcSavs04xBF5/8fluQGAqHrUkrvFQu7KncMXY0eNu8Qgt49mekqA3mp1RKll
         rbmhMjYdJecj65TRkna4F2ggFPeXAygVR4EziRoFPD2oILrQBKyDmQl2jaJF/rFwv2u5
         iM4RJq7qQDDtxqaDsjVmE5bZ62Ca6Lj77wdmkud10R+yiUZjMHYrKzPc1nrlH8mag+2P
         7pDA==
X-Gm-Message-State: AFq9FYL1cx777/vsApbE8Jti+28f8C+mu0UrMUJemZpRwwhuC6ZFBdWC
	AyAJTgNZ9euXELKcI2Jmnv11dwf5ov+5Lsalozla8Xt8ZCcpju9W0QfVayxZZ87s7WqvbhNqubx
	7OyzcMY0KT45LjlIilR3YH7K39h4jZpjsZDi8+4YL1oXKZR1afqPrhL4XVY587CXnq1yDqu/5ST
	jxWvE=
X-Gm-Gg: AYBFou3LOFF0DLQuuE2jB7fehbb01aOXsocsn2pKDMM/kBFE1IdlPpwVEpy7YmBrOZw
	ez3DPlvUWh3PUyo+5iT/eQRJFD6qvHU0FUh6Gi8qgh5I6gpJfU4HBW5BPYKLv/Q4zLdY1QK2G9T
	Eym4fI6qHyZpsGLEo9fbXr7H5fblbYsCZ8TPsS0c/7oqURwNNOWalsu63fO0kuqmKiZr9Q7ijG5
	RU/kZn97SsnVVBafrVDrcrcSw3NV5SFqhdxFIUJwesPe/lL302n9JSc4vJG/O139dOjLaju1Tbk
	Z0y5X8J5WgOZ+vFlABH9slGAkS74JGdHxycSpC4oITU+TTDiQLSi7Z+vUN84uCXg1fre/j9zf2s
	O6L6eRWXcyxYCwQ==
X-Received: by 2002:a05:620a:4503:b0:93e:7939:43f0 with SMTP id af79cd13be357-93f29cfbe5dmr1161424685a.32.1792405008347;
        Mon, 19 Oct 2026 03:16:48 -0700 (PDT)
X-Received: by 2002:a05:620a:4503:b0:93e:7939:43f0 with SMTP id af79cd13be357-93f29cfbe5dmr1161421385a.32.1792405007837;
        Mon, 19 Oct 2026 03:16:47 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d756ce69sm185607365e9.4.2026.10.19.03.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 03:16:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 12:16:24 +0200
Subject: [PATCH nf] netfilter: flowtable: fix pmtu discovery in
 nf_flow_tunnel_ip6ip6_push()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-nf_flow_tunnel_ip6ip6_push-fix-pmtu-v1-1-324979b15484@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2N0QqDMAxFf0XyvIDtWJn7lTGKuGQGNJbW6kD89
 4XBeTkcuPeAQlmowKM5INMmRRY1cZcGhrHXD6G8zcG3PrjWdagceVr2uFZVmqKkYMRUy4gsX0z
 zWpH57sIt0NXzALaUMln7vzxBGV7n+QNyr8qeeQAAAA==
X-Change-ID: 20261019-nf_flow_tunnel_ip6ip6_push-fix-pmtu-ff81656e32fc
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA0MCBTYWx0ZWRfX9AEV0we1p/32
 w90IaE3tJ9nN3oOPBzf8VW7K2RCBxYnDrxGApz/3Agm8oQX6vh6o539174LVneK/abtw2dnOTBN
 Rufp11U0/te9Bs+a78P5f0RBB+1QGus=
X-Authority-Analysis: v=2.4 cv=KuPYSmWN c=1 sm=1 tr=0 ts=6ad5ee11 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=3HDBlxybAAAA:8 a=EUspDBNiAAAA:8 a=jdz-NEu0cmAWA5xRHoAA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA0MCBTYWx0ZWRfX6j+H/lydbg31
 MIxMP8zLAUlmGVh+yGjDwRD/9QoXl+WouYl9TJQqL5MuXa8uUbN2ibqGnM2hCIEJB6O+UEETgcp
 PoQQ1xqEE6P4xi+fLftPeH1Y/X5xKEH0VegAoggWGeVwwammsG1LseLUr4kFS0RlOtPbnUQR5L2
 yuC/k06pXfx/56xo/Zzk4YJnNFFZEBOH2AZ/wvRGgrUv8TdYlpVe1Hebn5SzURWwrVcLB0qXTbe
 /ASF6ZEck/vx8rqqTooFI346Y40p3wCQ/N4lcBgnvhcUc1wujMCiLBMomgmPFWDbLER9KyGQIAm
 KP8ZEvN5mETkXxEPIjHxpyz2UnnKMC0zDciNXZKpdbpvH9pbthki8kxQ1V4LL3exlxX6A2OG1lE
 VaPGLCw8ECgBFDNNIL1v21nk6axhuEiF3D83/9Q/LzJqEjh983M9l6NIpo5897p958DSnl/83rp
 WkrL8CbL6zmtVZVtX8g==
X-Proofpoint-ORIG-GUID: o3aB6bVVihk9zXoYrJxVH6iZGQU_MZBZ
X-Proofpoint-GUID: o3aB6bVVihk9zXoYrJxVH6iZGQU_MZBZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190040

nf_flow_tunnel_ip6ip6_push() invokes skb_scrub_packet() before updating
the PMTU. skb_scrub_packet() drops the skb dst, so
skb_dst_update_pmtu_no_confirm() finds no dst and the PMTU update is
silently lost.

Move the PMTU update before skb_scrub_packet() so the inner route is
updated with the MTU advertised by the tunnel dst, as done in
ip6_tnl_xmit().

Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..12faf85ee374 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -664,10 +664,10 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
 	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
+	skb_scrub_packet(skb, true);
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);

---
base-commit: ee2d4c2d7cc18a2cd504044a75ea614e720248eb
change-id: 20261019-nf_flow_tunnel_ip6ip6_push-fix-pmtu-ff81656e32fc

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

