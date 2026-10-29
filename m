Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280938;
	b=mO0Ll/Ti3F9wx8t8Fs7ntHm071XPxXrOFQTupw3g1fIu9j1xJ2y5uHdnGNBhekgSQZUT
	 QoUU+jFJtwmxVYWPp5CsG8KLkhPNvz2N8gBOcOEhJultghl9B9VKWh3gJvX/Flx5se/PA
	 lDIArVA8NlSl+TYdLJdmdqveNuRg0dqV+QZMvGqqDiCkuw5Rc1nEIICZUWR71dl0vXqo5
	 EnY6r1EAOJjKQOeQGRlnyVz+cZaxn8FTB18kU/OJOpSnA1qToyZTaeBD8YEsrA+46t9qz
	 o4YNDby3k0fPLoRKR+t/BW4eNHUteodftd+Q69rAM0MGbXUfqxbHTCGsGP/OktJrsEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280938;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
	b=w95JSeF3uoiHtDlMRmMKy/z42QuZY1DmABLEq/RdB2isUKOWjVKNJg3NAmmgZeSxFyn4
	 07jnQgISmZYGnTlJ+YhFV2LUmU3wHNa9b4PVD7HeJXrQ7a+hoKYOWDyJW0RCt9qR8+j2j
	 7etDwJmeAnkKHbCR07Izv8CB6bhzZkuF7bENPtVteGcIla67PkBY2DWBqDgmpHM+7DY2r
	 sIAnIjVMsK32sbxqk8FjhyfkpLJWJLis/qE/UW91CiSeCeVbbKKyW/m9uIw0dHLmuHcJJ
	 wzCJmPFLB3AMK+LJ+1HvJp1aod9HkSDqfvaxv4leyLW6eLMxN3Krvn1eF6XBzk2sTxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="H6Q/oBOp";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QyNN+Opt;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E60606A332
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88E60606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=H6Q/oBOp;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QyNN+Opt
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCdx4X3399571
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=; b=H6Q/oBOp4C932Isz
	95Ph55eoKHZKtyWrS9f1sFFb7ZyN1znXBqF9ZURV9k7H4M7D+wAMl5jgRrZs5WJh
	ztgPaMKCGzH5V2/JL8eJR4TnuSPfJzvfmdTO2PRnCY70G5XworKevioSN6PRzPSN
	8F0MxYlJtsvI1UYsCNq62bLh5ZaRP78t2FkV5dK4Er975Ah082f5gIAoXdG0ONph
	hnWD9FDMLIp6o9nbf5zn/PB1wmC50ULhf+zQZzGhrAHKZj8vCFmAjCzqwONIYYSP
	Yrmqj3a+auuOHFg0hoMgLu6hCywgBLKlIYuIFW/OEIM+cSViBLivifVVFMrSR1CM
	B4EHlw==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hknb2c558-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:37 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-988bbb0ed9aso1780550241.3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280937; x=1793885737; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=QyNN+OptFdlFF0K7m/VFTglUKgXllGt0KkClDb+0MaVnmzNfWr7Xs4rOEiqeHyuSBI
         F32On/ltUjvOuHSJaSoTcz1CUm7MRF0nEKivPdbgeHlWMzqdy2eTsycxyfWbSgaqipYp
         oUvyugLGKMlK30fylRIJ40xnyQWmouXNMamPWVPgC03PcYXMcQRVMb7SITP03HKM4jxW
         bPnCLaTbmZqkomGpSCwiC1jAVibMGccjE7Scd3qNIu9zQrRZ2ujOG0AZtW3bpWnk1p1e
         KzHHLM316f+6ENSUEMY73ITAijHxorQ79psHYW9v3iFixIZ/cBtIL+pRUMbA9JY3BiTw
         MJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280937; x=1793885737;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=X8XlDXbFbWX17dlYCo8SOYaZqg8zJ037BmEcp7lK8QoAwE0iopQHLv7rMvQydaUN6c
         ytNNmPYywsQWT6+3cSeCC0kRIBO16vGH77h7nlPKMdTg4FK6GGENP/SQfQfyAnzlwWd2
         WhSn5ZjjS6P9X4A9wYuhfJLFme/D0GaNEbx3i2ZwkP6ISa/qd7+pBflsjfLjt4zvB/6J
         y9m6Eu4s1YlWftfoEjk7ZUcKfzvG4oPn89a5GjF1HPX6VEoYNhNCwvB24RtfoufnsWBJ
         OMM7Yjtpzzj6jbepg/r4XGlKnAdSA2F4V/gcnk2z0V/mWA2NIkr8YNIAH4fuY3/Tq/zZ
         O/PQ==
X-Gm-Message-State: AFq9FYK41I+EjJW3ydP6Zm+NqcECDTDJ1rD+wQvxnKBj10nqjeQMaTZD
	kQ9A6H5WCgJ1wSfokZcknxD5Priv7bR6rILuoEO/8MeHAosQuoDmlSFXFjvf1mNd44fIZkTZBFb
	1mycUa9t/qMTjD74p8TSuU5aTDF5C78BEYEoPY7BGVmJCWsEMTjzeIGMDw9GlPYqaKxQXWxU=
X-Gm-Gg: AYBFou08X/f4PdF5dYv+/mxAqmHXvQGN1ZaBbOKkV2B2a/+/MhFvT8E2w3xwJmYNb+k
	YYGnRvhWd4iogqmhO/m0C00yeCWA2fXpV7rOMXm3O6e0VR7F7V9VW1Uxdcsig0CX7HyrX91j0QH
	XkgAipU3GrDXa6SsTVDmeLMWsBXq7aRFwrfkZZiYgd+XLwLfI8L9iaXJSv2HC/6g07mUhnUjwf8
	RCcwqePuzSgAG5uyT0vVVjGpt4TcBUJDOHH0wrnEux1EJuzCx2a3xztnd/UElh5C1PMMya4ie46
	fw9GTGOGDeonnhVxZ61iZgl454d4iT24QfVKYzOQS8mKxUBQtnV2n/hVKUs6nbHKtCmaLI5qtSu
	+4y6kWNVg2B8arNsCIc/wj/o/tZhGfPNtCa3i7njPwORcQT9itDxHbniEHMKfw5Bktgxmshdvz7
	xigiPlKQh9AMOXRjCpetWt+g==
X-Received: by 2002:a05:6102:f9c:b0:7cc:26a8:e716 with SMTP id ada2fe7eead31-7d03a499792mr2652620137.18.1793280936716;
        Thu, 29 Oct 2026 06:35:36 -0700 (PDT)
X-Received: by 2002:a05:6102:f9c:b0:7cc:26a8:e716 with SMTP id ada2fe7eead31-7d03a499792mr2652592137.18.1793280936084;
        Thu, 29 Oct 2026 06:35:36 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e69ffb93asm2380618f8f.8.2026.10.29.06.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:12 +0100
Subject: [PATCH nf-next 1/8] net: netfilter: nf_flow_table: recognize
 IPv4/IPv6 in tunnel proto matching
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-1-6a17c54f9fb7@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=Yu2a1IYX c=1 sm=1 tr=0 ts=6ae34ba9 cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=m99eJ5p7w77CmUfuVTAA:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-ORIG-GUID: 4Rua8BlZUKtLuo8mPcZ7sSm2g9BYjJGo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX26EHQ9YhPZ3S
 3MmU12actF9n7MkVUaGK9HYZcPNQCsRfEV71I2jd8GKqOGjF0T8Pe2mT2juad3WKn8UYf64Ren+
 bZ4LwCtl2QLWDLhwZlKFhrIz3IiX/aE=
X-Proofpoint-GUID: 4Rua8BlZUKtLuo8mPcZ7sSm2g9BYjJGo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX/mNXX6ZS/mfF
 bmvvxOb1+X36HhWDz574JSFbp98luZc1wA8++puCNJXsTTK1rZ0uXaNIBpbY6Cvp6QYDXkpqyn9
 drqaRGXgW/CbqjPn0rOm1FkxpDRcn2FzsDURMJp+BgPdsRXdTn+tfXuZj4mU3JWolfzIbZG8g6A
 JyV0rpIGvM52UuHlB7Z1UWswmR+kAv/yPL/yFCSuUxWQERGRwwHbeajL0v/BLeCjFDoT3tbnwQB
 XPQiBJA9/NcBDbzZrd4Py6IaCOxBVVSGlLj/a4LBqyPHh+29rN1V/fBKasml8vy0Yrgo63S2PtM
 SMtpGx2hKOFNS6WrXzF4yMzxTSRbbs65ih/gem/FufXTIK++XjsPC1NA+I1otLdEuIfnkb12rt3
 IDr7Y9zldnihGSnzWtCVR8PxJUukVCQsR6mytVs0dVdN2eqgg3SWzBkbSaf+2uDjqtPQxZ59aGS
 AOiKIVDrQX3ET+Se66w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290053

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
index 19cafae748ab..e07fa9327eb7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -328,7 +328,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP) {
+	if (iph->protocol == IPPROTO_IPIP || iph->protocol == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
@@ -353,7 +353,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (ipv6_ext_hdr(ip6h->nexthdr))
 		return false;
 
-	if (ip6h->nexthdr == IPPROTO_IPV6) {
+	if (ip6h->nexthdr == IPPROTO_IPIP || ip6h->nexthdr == IPPROTO_IPV6) {
 		ctx->tun.inner_proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;

-- 
2.56.0

