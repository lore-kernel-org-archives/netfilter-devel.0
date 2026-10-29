Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280946;
	b=MiW4R3sOXOLu20423mVpnMHCDasho682dDphS/2/ARfkOxQodpxh2UmY0UEtrCybJ0h9
	 0nj9hSox6BIwI6bq8rEoDfGB8/lu6nHof6wwjE/I/WJmHIahpjPGDg3eKPjwJNtdNVco1
	 ApiPN6oSDu3BzD6cgSc7pFDa3S+yXoa3ypRL7y2s5dt3kerdkdA4QvZvfk7XkPiJmnRa0
	 Piq66vwyqSFZcFoDX0Ei++LCWzRhhAOzG/vxI3mWq2J3ovus4lfXfuyBKoTnF5eGzxp97
	 daiky0umrfO0UjrwMwHOQm1wi197ojRKGAkCZG5Amn1QVeLbzZLiUeymXycyAKqkW4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280946;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
	b=r58C2bYMil8j5jp7B3VmfZEFav+Nifo8hXvzGtMxqoS6JrBK218pijR78uTjtWwvX/Yi
	 1yqBgbx3+P6FUoiTV47HGn5vAPGn17MlmSJXMV+tMvHrcokYiVZCZwOUJlmDfgyPUdPac
	 YpYoa/Rc/kme+hX3t2z1kSouODL0D8bKAr+8kv30rXROzlfH/O990jZ3H10FLxyUWTHT+
	 YDaqyPeyoieKxwjw5AOf+kIYC64geDxMPSgvt61BcRKXatKnEd0bFRFXSvT9l8DheOmVk
	 usaK6zx5H2lxp9UU55TnC/j2TcBn8bdA7gTywyU0K0N6JOgSl0SlK007ujHpvkrn5Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLNZWpNu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="MuUEM/7z";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936CB606A33A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 936CB606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLNZWpNu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MuUEM/7z
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeR8x3768652
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=; b=FLNZWpNuL69Y9q+J
	hA87m+KpiHVjpjWNpAoFy/iUnLvdRh4XlAdZZHOMjD70IKfe31wC8IgwrZ1KO4iX
	ZfJD7guBApgv5G9nz8XoTHikXNh44aDal0v/iJ93dZrMbpX6AM/bQKuXnGv02oDQ
	as7z6YLGwhwcn4wW7gS/ctCA8qGoynes7S1zEmeyWMFjYiRqPAt+hmbiNAnS+5Gs
	FstETjx/WZthnmAGr50Prt+Wrk/QSBFv2RIsE4cMIn7cjVZIRXBAArT2DzIgYRBb
	VTrn7Tty8SepSllJpKCeSZWVBfOyVvNLgDMGVCR/oZLNJS+pIN4qnxi3P1vbe1An
	gY+qgg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hks3nb6pf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:44 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f2c0e6653so191783685a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280944; x=1793885744; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=MuUEM/7zT+dPVXiS/DLA9tzqHBiQtr7MVZw9M9n1knQcPF48QBSMkMXw2gfa/mI6ku
         o+si8iurpWiU9o8ROy5YhhyRrht6Jdh2qve6gIvjzvlhvonqBP54l5q8usYGFmtmTkyL
         p9RQ3TYykzCFCIz0+0MmU7fBa57t2TIXCcIo1djmS6fvGRSHgJL95jZ8PWtBUCM9UWQb
         kYqTkZaU3dwZcMFMFDb+qGiPftS1voaDOO+FWzLvHv6ZnmSNC0dyDKaSy5CrsK301aV+
         c4tLr8QvBG90KWnRadlKrK2E7lzurnz9Yd7lRiFJW0xnRaqj+5VlT220MBhWbQy1HjgA
         /VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280944; x=1793885744;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=O+R4zDpeeh9vQgYtE/o1UiJY3LTR97AxiQMe8hrE+naSIVz6WvivYtdXcRUgGwTqPB
         bIpI/MBwSm/8gXDHGsJQjVlV1Cf0TqbEr4rKh/ZhdaONoXPAhqJ34xQWnOnNCHpoDgDy
         vuWK/+Ln1DfnE7KrNeFCsYrfQHjmcu6gPSheZbTPvgvCiOkt6qbXnHSExhz7SKIO3RVR
         vz0PJ1tsd2HeTVsRzLwRotAA1cJx/ptnMPdxSBQx/wH8v2wDzcTo9Z91Qk/EcqBEqfEj
         l4hoyL6L53bg4dYR3ekeXFKOKOelZ5qwPPlfzJB66B8EbdCg34vcSejfdd/DICNv2WeC
         TGzQ==
X-Gm-Message-State: AFq9FYJp1Nj3OdDZrGLyE6qKzua528Ys+ZIF068KnBEprUc7A8SQsUFS
	tg5FOZu386YMKg2BRRWiw6Edyv5rIPMQfKYueTI4TY2bnbRkbW8l9Gv+qoR+xl0JnE19t2W9Osw
	RCRAiZatRMeLiQ+wBmHwyZm8s9qYN5YZtbnJA3fDt+0rCws0Ovas416B37B6V2xJKlF8nGfw=
X-Gm-Gg: AYBFou275JVKLMUTFu5EYs4BuWuk2GCE2WFjTjco4LvYgSQZ5pO2j35h0CnnxvlU+ut
	OwCdbv9LgflbOKWYjHfVdFpV1tdtcehkU5D5rO8cVmY8m9DU7uDCJ9eZOl11QKL3cpLQQSZv+Ro
	WiCocAqnfChPmjeS+EDPMhFteIyBXeAplEex4/1vmvJRPKoO/TNe7sUpZ7URaHm0S4MH8kBFKfL
	PLNxFUKCPWryCyfh1U3bBs96CjBRnZf3reburOkc7XMzNu9aKVNdZ9ivjriYd6TlOcaHUjmtHjw
	bbveeiFfGgRtHcvninmoE4CyE1syTA1b2VNWTCgjF7AZyX4vjmk1ZdZ95Ga1mfPqQvd3WLaIb1p
	KznBImqdypGKk6jaZz0GJh/YT8E8jy6/RJ16Tfd7C/BFGzRcYUOuiHFnrl0Gq3K5b3cY18h3BLT
	p4lOay0hjNc2j0eRuXPYfa1A==
X-Received: by 2002:a05:620a:450a:b0:93f:25a0:6aeb with SMTP id af79cd13be357-94408cf411fmr898994185a.23.1793280943500;
        Thu, 29 Oct 2026 06:35:43 -0700 (PDT)
X-Received: by 2002:a05:620a:450a:b0:93f:25a0:6aeb with SMTP id af79cd13be357-94408cf411fmr898989185a.23.1793280942985;
        Thu, 29 Oct 2026 06:35:42 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7fdb7691sm64955305e9.11.2026.10.29.06.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:15 +0100
Subject: [PATCH nf-next 4/8] net: netfilter: nf_flow_table: use tunnel
 encap proto for route lookup
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-4-6a17c54f9fb7@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: cHD7dF7SlSDw-vIYSaHiIMgCD3KsO9AQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX3tq6h6Y++Wp5
 +iVXVxaqx/iYipl/olu9WB2bxKC/a6ECYUnOB7svipOtFfd/OjvMR9gbU4qRGY6bJsv+c6vwHKR
 fr/XEW8qigz3L5PPf3smqsF+xnC5OK0pbViFBO5uYGpR74XqybDwRh1YHehytXdZm68qQ6vELIp
 EBmVv7jTAHRLeZv4JGJyHFKMsFSvtps2KNAitUyJus2vCQvWwHx4w2oYzcCno5UtRWXTfbhMvPX
 djyx2xtOhlyLKy+5TOdfVraLgNVfi0LA3dROb8X6GMjhiNfHpc00teQ5/PNuLZQ8DWGcGfbdUuk
 TJHGMZh7KS5uQgoSfIVXIfX2p5LuUAHcnoMiPOFaJix3tJmGC0CwCjRE9Z7tD51bhwz58hRlChz
 SSG/cladlT1DvQHIEV9iHPmo3p1YXGwq0inYicKYKFTiwXiXztW/5gOGLgwraPHxiaFXHsrk4UK
 rnRki1S9xSxeoRHs3iA==
X-Proofpoint-GUID: cHD7dF7SlSDw-vIYSaHiIMgCD3KsO9AQ
X-Authority-Analysis: v=2.4 cv=XZEcX455 c=1 sm=1 tr=0 ts=6ae34bb0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=BwFUO5JFP4DfzLIXruUA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfXxJm7GJNTt4rF
 1YVwMhfxA/MASUeRYHlSuDuB2c6JiIi4J0+Wc2mXUzqvKvQlRIGjEDg7oVQWPQRJ5WNWw8M7/iQ
 3m3rBUY4sXGXuE/5rTwrvFYi+AOdDH0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

For IP tunnels, resolve the MTU and the dst cookie against the tunnel's
inner IP protocol (tun.encap_proto) instead of the flow's l3proto, so
the correct header size and route cookie are used when the flow is
carried over a tunnel.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_core.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a..aa8e3f42b23f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -76,9 +76,10 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
+static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple,
+				   u8 l3_proto)
 {
-	if (flow_tuple->l3proto == NFPROTO_IPV6)
+	if (l3_proto == NFPROTO_IPV6)
 		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
 
 	return 0;
@@ -100,9 +101,15 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
+	u8 l3_proto = flow_tuple->l3proto;
 	int i, j = 0;
 
-	switch (flow_tuple->l3proto) {
+	if (route->tuple[!dir].in.tun.encap_proto) {
+		/* For IP tunnels we need to consider tunnel IP protocol. */
+		l3_proto = route->tuple[!dir].in.tun.encap_proto;
+	}
+
+	switch (l3_proto) {
 	case NFPROTO_IPV4:
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
@@ -130,7 +137,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
-				flow_offload_dst_cookie(flow_tuple);
+				flow_offload_dst_cookie(flow_tuple, l3_proto);
 		} else {
 			dst_release(dst);
 		}
@@ -144,7 +151,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
-		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
+		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple,
+								 l3_proto);
 		break;
 	default:
 		WARN_ON_ONCE(1);

-- 
2.56.0

