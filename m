Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714874;
	b=H97K8WlJ1dBrQugLRNWPannLxlW7Aldnihtp7Us0xqGqHMwga2dw/nV3PV2ytKQ+CJ26
	 9ZAvi0xSb7TPNSM/ag+8vcr1ALnEnLx+gqPXnc/LqoM1bCToN6G97t+1SkW6hOfmZKG+z
	 YkzpBKpatltIEwTNF/vTCJJliAu86MR+EYzt72a8/I60na7bYCu6HcshJItG/BMxl5Ow9
	 iOkEBeursz8ECJWXSkhTHKS1udt0SHzfrpM+guZj4ir9rynnJqWhSD0RJFuax9Z+kFTAP
	 /7goaCWx++mbZe5fr9LmJr8h55NUnTbaBdBr7aq7cPK6jBClp/DcLq/ljCnJjFkFDHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714874;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
	b=yO7Jkb5fH2IndJIdbkEdaOAKcNOBelr7ikhybvGzdSDIgHdMHO779a2qbjXz9TIF88ME
	 IRrSpqydMlkoLYn+I1gaOiy926Et4fi1asCNaKsk0WbxxpnKxFYQijOYRn2ClQoh+t1W8
	 UOFMTRaMyy7Yt66BIL3aADN49ZimNdMVyUrs7hsBqTlmxLJKYn0DFnSwhrDG8xhgk+CWF
	 eQJbw6wDWGnhwGtoc/0/CgxUeNX9/sOTAFeUIthPiYZn+dp5WlNg3jT91b1dhe7n1eltn
	 NxEpvMycZ9XqVZXeuqQ30R+QplQH5Vgi2EqwBWEjP3C15bJOdOsKjtXTcRPmH0F55QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="XsK9/Zd1";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hY1HUc33;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFD0606D831
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AFD0606D831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XsK9/Zd1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hY1HUc33
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3E4XDb2716181
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=; b=XsK9/Zd1psoocl2V
	TxAJIBou6+7cbmOzzAILQjeFkx6RVVAcVTkoHqcFiN8DpRsAcqUBUXI9c0/Fs3Sx
	L0UM0J7LDmqrmFKUa6solAp/e7rYCp8WVOKsIJBeVGYEVNW6uwEm0AorL6mCpMI/
	YBBiz1ZqPl9tzEADFdpvPnTkq5f0CQfwpTck3LkWitsJXZUbWKcnay2nGQilj1lV
	M+Won/OuXoBHS0Ui2E8l5g7Ank64WMhkf4wc99L6poX4qMpa2tEMtmbL8XmpFh4v
	3XYPdUgdHBuiTKtGMkAZQ7AuI8ORWc/LB4G/sUP+RiqA2uYF2y3fCQWo8j4sdcT0
	H9mrXg==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bg0k1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:07:52 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-82274137201so6248400a34.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714872; x=1794319672; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
        b=hY1HUc33n0+qcv5YefMd6txqEvBc3O+zmZP4oxs2r9C2uXYceg59l51eoFQlx/EHco
         8GLUmbpRIiQgvfvsXTBy1gCNCzbgeOBV1uIFkoEXD9mbUhu6j1K7Cxj12FuxOa9Um4uc
         IHyHI8kXGZ23MlMWIfjN3w5okzpWA5igGwR1/8oFGnE6wGj3ObwhWTps1PfA1Qv/0fSi
         IdTkn2GIyWx0+2zuf7TMwUwV0yixObz7X2+Z2w6LPSpLv0Ac8qCS/gjwgNThN9EoB1oR
         VdHLC9vcrKLa5FgftO2z59a1xVT51E7cXFAOhUdgYwadZHGDQuC8SImeOWldjLcn84Uu
         mudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714872; x=1794319672;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
        b=VnyXb6JLIuMAFUI6Guclidk5Z9ABCvpqZojg1dNZs6nwzmvnjcmSBqcwquxrTdhnpE
         hqksvHvAfKgNPstLk9M+PCjTzP+X/6n0iqFP/cp1WGWO3g71RKGYCkvEucLtcN0Ft3rP
         ZYXTBbdYmo1HHQXdrS5PkVaZURhdcC2DefbrTURJerZWMKXOaNhjgYnP+RLaMiRh6BPI
         mNuopgin5FMl8vWqF216dN+d1oQAevU62wYB5k0cFuRMlf6sSvv29IhSpiyL+M+hgGAU
         OHwQx5XduuRNe++Fqiyc+Ph6BDwiZveH+YVxgv7SIaYWhdFO6Zm6RTMvyTVu3YbhWu2R
         b9UA==
X-Gm-Message-State: APuU4Z96z8xiIje/Uz3wmsDrY8VozI4k/jDr/yF72dTHhAWLFqLCtbYd
	2m3vvsMZIvPtMhn6mmYWvS0jZUwyt+kgWOH+/4xj6ICnOeXF/piDY8kaB17zMUZ8OLF0laOu8Sr
	DS6TPmIWncTFCgqjs/s1oEDLAb+PiFZZ+c+3EVhDFUgyQdNQuBFa3EDEDuBv+ToJ4T5Qr5iuzw9
	i8BeI=
X-Gm-Gg: AYBFou3ZAc9uIAIi3QQTXByfuiXjt/b01IU6V4U1+XRQGD9WNrycDdc1alRbtBj8j9q
	kRqc60YEZE3KTHkF/K0+wQGPb4T/pdjqs527D7Q+alBqjxeOMSW/ow9sEFIwccwcMkgytnnLLA3
	ne6Y4Gb2OPMA6idrK+OQKIkuffLrZ9hpn9eleaUoe+VwUj0mB7i9GMyv51R67fS1jXbZ4sPTw6F
	cxTXvM3TyskRxFbHc3sdcZ/2zlMpnpE/MpyqOdIqWSNQG6cyEllMXXQCi49QuzqvzfydSwo+I6Z
	QC0xXJ+SVHuvCPYnBjvnQMxO9rB3Xwm1vAIbP/BykqLddmvU6pfh7nLP8O/6sqhzriHl4PFGXgQ
	EmLNC4+PWXOXXC7Tgmk9sku8Sj4pf9TjWMSc3AiKOB5gYGtopJ0ULH/Ah0JEJm+A=
X-Received: by 2002:a05:6830:34a6:b0:81c:292f:97a1 with SMTP id 46e09a7af769-85d36307670mr10972151a34.2.1793714872140;
        Tue, 03 Nov 2026 06:07:52 -0800 (PST)
X-Received: by 2002:a05:6122:1d53:b0:5e9:7a1a:5ad5 with SMTP id 71dfb90a1353d-5ec689672a0mr5271199e0c.20.1793714475995;
        Tue, 03 Nov 2026 06:01:15 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78c10sm24929252f8f.25.2026.11.03.06.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:14 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:44 +0100
Subject: [PATCH nf-next v3 3/8] net: ip6_tunnel: add IPv4 over IPv6
 flowtable tunnel offload
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
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-3-60b5f063f1df@oss.qualcomm.com>
References: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
In-Reply-To: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX3zU+WyTzWGF/
 OYYMo32JX8SogWr1YMndM3MjcSi56kYDVwW4BoY4c85OvLEGTpDSzom5rcYccJyTy0ELUbkV5q6
 sJQCKHVDZnZSZ7bwT4ODs6Q+Vuf5A5A=
X-Authority-Analysis: v=2.4 cv=Xs1vqlF9 c=1 sm=1 tr=0 ts=6ae9eab8 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=j_WIp6COnZI3mYKyEBAA:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-ORIG-GUID: MXdNfttFJAe41_I73vtdxr7nYyTUZXKQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX57dwv2wNX0Nz
 pBphGskpbzyY3oLud7MD6F9vDULQPatQbMuB+q9vva6v1RRii9duMF3wsKL/fNslaG7BBP0GNW/
 dtreTXe20TFvAny1/vWrRRYtbnHaeiwfElkih9IUf1mq4Pb0g+963AeoOfPj4cxEiEG09d9wbt3
 aV/na2ctsWeAodv28LfxyZmeRtJ2sMoNfDmrMt01BeFC4xd8vgCwDBFaeTRxrccPR4GkmBu3D3m
 BpnKOdNwTfztAKIdib0ZHPrZq30n+KnTP8skGgJ8r/4re6d7S41RgYy0WrRo/tjkC30KPQnZ6dm
 rQM5tSfKce9vD6DvtkZ2yOTKx3p6fCLxuzatCILc5KPlWHVL5J7PutSrD8NJr6QPrhRYsFtm6oN
 cVRVZiOoXtWXNrsmj/w8kdqe50T6oa+5a3kwI/e5he5vdnif0J7GB7Mu8FGeg/3Bnks1yfZe61C
 SxaGpsbJRdvyzuujUIA==
X-Proofpoint-GUID: MXdNfttFJAe41_I73vtdxr7nYyTUZXKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

Allow ip6_tnl_fill_forward_path() to set the inner protocol for IPv4
packets (IPPROTO_IPIP) in addition to IPv6 (IPPROTO_IPV6), so that the
flowtable can offload IPv4-in-IPv6 tunnels.

Return -EOPNOTSUPP for any other ethertype, and when the tunnel is
configured for a specific inner protocol (t->parms.proto) that does not
match the inner packet protocol, so the fast path does not bypass the
check enforced by ipxip6_tnl_xmit() and ipxip6_rcv().

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/ipv6/ip6_tunnel.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 64a184bca467..920eb231945a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1840,13 +1840,11 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 				     struct net_device_path *path)
 {
 	struct ip6_tnl *t = netdev_priv(ctx->dev);
+	u8 tproto = READ_ONCE(t->parms.proto);
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 	int err;
 
-	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
-		return -EOPNOTSUPP;
-
 	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
 			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
 			      IP6_TNL_F_USE_ORIG_FWMARK))
@@ -1858,6 +1856,20 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		return -EOPNOTSUPP;
 
+	switch (ctx->ether_type) {
+	case cpu_to_be16(ETH_P_IP):
+		path->tun.inner_proto = IPPROTO_IPIP;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		path->tun.inner_proto = IPPROTO_IPV6;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (tproto && tproto != path->tun.inner_proto)
+		return -EOPNOTSUPP;
+
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
 	fl6.flowi6_mark = t->parms.fwmark;
 	fl6.flowi6_proto = 0;
@@ -1867,7 +1879,6 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
-		path->tun.inner_proto = IPPROTO_IPV6;
 		path->tun.encap_proto = AF_INET6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;

-- 
2.56.0

