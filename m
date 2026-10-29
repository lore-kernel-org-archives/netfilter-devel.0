Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280944;
	b=0RaD8iyNaGGk0qkuoaF5nqaHVO5XIOKcy5ystMpKwi2pJNOw3uqezVpb3fWRAqAfP5O8
	 oxA5WvuDPAJC3jU6KkCULHwbZb31oAiRZEJ98Z0DmXIoeHXRbAVaUak7PYnnKJ8sDn8vD
	 ULUqlR45L/T53EUIpZTjmWQHKCKLWjL4au4Rq69DYkeanrw23EGyS3diReMcU0MFwNgQi
	 z39IJ8M5rHRvKR6vfZ9PTIhkX5FJOX/9oq6oir4ySsmaMSdiu/bQ2jhvpkC6i5uIV5EYH
	 2mfex19VVlxzaZVBwlEIPIYUGKNGyvsxpMt3M29rZEp/rKgnkrX1FSM1r0iE6tP3gPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280944;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/28GQRdfBjNpaKqoNfgQNMIhyHphRu4eJhHEmguSmaM=;
	b=vVVC9a65TnZDf5s4BL+dkVqIM154P0llUaQ0XgJr0Ls2MS0CMAdwQtYUp4biXRc1g+15
	 zp4n1cxrLa9xlrrPt3cTVy8Sr9GsLr/gEKNfsTRYxa96yjLs41TELASe9lgVjV+qYTwrv
	 eoncxfCB0oNwwObOgHa16dABnCKgDL1R5UHwZMlBng5BKxmpDeB2c69lhRE7f+Ib769kE
	 C9D5Oth9nZ6IeGRkJmHYSebnuoRxOUVXwRk1UscGL+ZBo6g9x8nL+c4ajZ/ICJ3GWSkls
	 y0HcQyczDl39RHlSdDG/28M7cYwYATER0hJAng5mzXeGa/k+WS0tKI8BG81Lp7wK1ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=U+hV56lE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N99pk5SG;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CB760A2607
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6CB760A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=U+hV56lE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N99pk5SG
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeCBH610322
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/28GQRdfBjNpaKqoNfgQNMIhyHphRu4eJhHEmguSmaM=; b=U+hV56lEhV87Txso
	hODZ4Tr9YC/5TkCyrk+ByAID7mE+2r5YtkPcx/NR7XWq0jTAZPROCUB161LureqN
	ZjVQl/lomhnWcDgQ61Ty3ppo6gwRExs1vVsCP8SpeZLKNrZE6Zm5hRDA33PfQOtj
	brIBEIrEOyBZqOzgNv5Lo2YCm00TPvsGR9Kdp8scg0d6mlF+vBI7KfYivROFlgZt
	qJOiDux0zijRCy03pjD2kYyW/lW3xo/v3lbTsIJPSxR+BV9TVod+nZhDFQpt9UGN
	UyoJcYJUoZBnyc2eMiRtF+NHmXG8Diwp2WnAXezICCgD2TJiU0TopJGfkQfRnGfL
	GEdiLQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hktmpau92-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:42 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f1f2fafeaso264756385a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280942; x=1793885742; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/28GQRdfBjNpaKqoNfgQNMIhyHphRu4eJhHEmguSmaM=;
        b=N99pk5SGLMZ3awEIZWchYcuiyaRBimT3d0SVYd8Qisr2QB82xM/d2cUGE8VJEZ8HLv
         P1AZ06ex8JCZlw2BTOL7Ycb8xZQwbV7mBY46+grMgxo4S4mRg22Kh39Fi4yIxGDjeuOx
         VtiJBWdplX43R/6fh3lP1kSraoKKi8KdGBJTtLd7BRN7fYIbiUTPaNfCdsxu18fFf1If
         yj48TOYGaVeFc+ParUGThVTwgG322xrKRu9a8TvgIrGGVF5uZPFJfsrPLmBGsrxXUBDw
         ZcEIvlQx+WAIRRtQvNYCjRgJafDVk/HGrQED6P3vVevidez2j+BepkcXlt3N57dyi6A/
         0SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280942; x=1793885742;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/28GQRdfBjNpaKqoNfgQNMIhyHphRu4eJhHEmguSmaM=;
        b=x4dLgfGw7Kel3IGp1hBVxeZuJSWfJTcRoVGjb1EoLR2tt3+tWUvH7ll9DZSIZtF2sR
         XvUehZtgvyQXI1y8tCCXL1LNH/2/ZI1CQA3zLc3uFPyf+WCBlUHvJwztQRQrU1WiGOd8
         q7K3mSP+uwv1FPzGpgjKxeMDpR6hrlI0AYCy1WFhMDj9oBeVOP51L3TN0AwiJ/fuWjQx
         Pfs7XItZZIiwk6lUUFnb3tS1/Z4iWMZYIzLIlKu2eExxV2F9NHaLQQdKVx+bspgd23f/
         QFVH4VBs55nqncJWlyf5MQSYnKkGI5uiyB9a00YICG10tyNi02vgoMXXuLysHjptwrMV
         OJZQ==
X-Gm-Message-State: AFq9FYIK4RHUy3MeiprNXwNvhSZVsLyeG6csewwFZhXyj1WPkxM/2HxB
	22gQ55eGA+SFYG+9bWoAIAArRBqF2jtGDuaw4B5H/GwVRK/ivg683xFSaxNFnQDtBYACcfRVy9x
	fayMVcbkKDllOI4EaxbndNb7+PxfMc8K72sFuf4iHfStg4Jhh3LecM+PygttqscE7V/nfzT4=
X-Gm-Gg: AYBFou2+VVwLdLuCi2PsUzhupnGO2I+4GDZH6z07SqR2fEKfH3Dk97HMqXau8onx6c3
	+iPKOFX5E9pCkq3joma8putfjgALDfJmx1LQWgTxk/jDD7d/dVufswlQwSd3NrBZwfKA9EiAUyN
	iJAHtNBcZLfBNCT/kDtmynkUQvqB7BYGEQ+xeQ0cWBMfWTtIpbvE28Mn0f6aBs60RTXak75Q/nD
	Zo9dkENp4J+tb+PEaneaYz1oNkJUw2sPKjBYP0GrKHYwMb4dqVK5kd0ILZVJiGuPxSXVf2d2V4/
	/in/FsuCz/usiRZfPaRIpzF4iGFYKQb5ERtuRD5VeMNeBgJ1pVPLyD4QquwDy79XsuFiQuQWuRf
	kkypNLxXSXF5U69+4O2gHVGBzihB7gSh0ilJTpcnZ8DTjP0dcChICNDbI6LdYA30ncA9u+NTrhM
	IVxodAANhdTPHMGpN4D/F7fg==
X-Received: by 2002:a05:620a:4489:b0:93f:633b:ee13 with SMTP id af79cd13be357-94408a268efmr789317185a.28.1793280941748;
        Thu, 29 Oct 2026 06:35:41 -0700 (PDT)
X-Received: by 2002:a05:620a:4489:b0:93f:633b:ee13 with SMTP id af79cd13be357-94408a268efmr789313485a.28.1793280941196;
        Thu, 29 Oct 2026 06:35:41 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa813d2950sm65071465e9.8.2026.10.29.06.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:14 +0100
Subject: [PATCH nf-next 3/8] net: ip6_tunnel: add IPv4 over IPv6 flowtable
 tunnel offload
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-3-6a17c54f9fb7@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX5qBeQax7ncWH
 48JaE8FcdIvAOGFCnPhvD7jd5IZHrJTVMNSB/xWtc/qmW//EQQFfdzRbAaAMR+66QGOlv0sXUD2
 Mi9y6Ih3uQGZsGeBeHRv75md/VwEWlppQkDvXIlCDWQGjoX6G27t2IG+Yi2B4gTtKdJhwfGvu3O
 IQv7KfNPH0HLxrlfzQ6neWY4olOM8bDrAU/aH9WH4WRpYid6RiN84+9B5r/QRwbnsmOZ3wQ+yOM
 5s7r1GK0oduI73FHe4L19dMZnecOhgExwX3ImgkoAtrPL32Cpa8c8FU9W1R8EKS9EOYb808sueH
 3dkUtsDRJdH9/pJesmmqRTFTtUs9HEejFkb34iL1ib2pnltsbeqcIGbG5z2O+C1sEf9dvNwnFOj
 tTgj98MO6m0GMe8ZrMhKIoktnUA3oloYiWm7TDZkQ2cE8Fk5JXu7K49GDdrhBIawURgQtsvvFUN
 BhyvavQd0wWwuWRWugw==
X-Authority-Analysis: v=2.4 cv=crYOAF4i c=1 sm=1 tr=0 ts=6ae34bae cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=01qIw42SU59cxVdbmxoA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfXz/e7+XQMrIjz
 RuqNMEwGywvGjPVGu+rpH8O8tfY6hVICaAWx7UbYmRozs7kg1c9sWsBMZPjXcVkNsnxhQ7ec8WU
 2UNshMyXapJ2jkeCKNexpvlXDoT66Nw=
X-Proofpoint-GUID: mjBDfVpNBswCNyInvcSr2lVuCc5msmyC
X-Proofpoint-ORIG-GUID: mjBDfVpNBswCNyInvcSr2lVuCc5msmyC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

Allow ip6_tnl_fill_forward_path() to set the inner protocol for IPv4
packets (IPPROTO_IPIP) in addition to IPv6 (IPPROTO_IPV6), so that the
flowtable can offload IPv4-in-IPv6 tunnels.

Return -EOPNOTSUPP for any other ethertype.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/ipv6/ip6_tunnel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 64a184bca467..9ae14977c900 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1844,8 +1844,16 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct flowi6 fl6;
 	int err;
 
-	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
+	switch (ctx->ether_type) {
+	case cpu_to_be16(ETH_P_IP):
+		path->tun.inner_proto = IPPROTO_IPIP;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		path->tun.inner_proto = IPPROTO_IPV6;
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
 			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
@@ -1867,7 +1875,6 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
-		path->tun.inner_proto = IPPROTO_IPV6;
 		path->tun.encap_proto = AF_INET6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;

-- 
2.56.0

