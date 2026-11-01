Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559747;
	b=fV+voACcTMEHdqT6XtGpdXm+k26b/oTfl8mmsdVw/4YXOM0p/GR9ZOvz3jwtCD2EXwW9
	 lQK6t61cOGGna71EwXOMoPbmnRrpc/U6ZlGh3z3DLLQwaZ7w+VdYXTiHf/ir9Z1psgjgX
	 3wP0Y6GZTZrPB+8utN6VnOk06C6MG5m9c3YPZhCtl1RV81mKJ0tK9UEB0K4bHUvXAqxA8
	 cza3HbXsIlqNmBAJIZev+rnxPFi6AoSJJS4ndHkE/og+GY6QWZX2KqC1MoHZkqJoHaA60
	 RURhm1ZWo+FvHaBFqKDKbQ4YMXEq83NKhDtusOGsoAI4t7g1sVtioRoTkt2um+tYwDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559747;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
	b=D/7iYQxaMgpXZG3xJjLNp/hCuSrizRoIpgbKykrKlMqXFkLAVvT0c1K50GlHNFAwNuJz
	 yuz1T5Ymv07jTQlGO9EzW/1kHI2wpeFcBhP5PcNFTNpGABHVDN9FuBDIhQHjsGHKhv5y0
	 8snv4fwFw7zwUi00oZ0FxZOU51otYxB6c9LpUURSo8o45Md1868bpH/aOPKKzV84ma8u+
	 fEmI94dRHTttonFPR5PzpLIlGuzXvmsEJugzwt9VcPnJzIcz6uZywWb4YgizfQytCVERK
	 KUmZiwnlTqdBK80e3C7ubuTavNWC3mXixHw8qdGATgEwXiGObMEJvidCqI9ywVove8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pJey2lHc;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=I0CN53Ty;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEE8606A338
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CEE8606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pJey2lHc;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=I0CN53Ty
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQDXV2465610
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=; b=pJey2lHcVRcI9iVk
	NYQFM1rFMEeEClin46LZD/r6dH63WKCzOf5WpbJuwFtCjyAOYDhiXm7uBB4/MjLZ
	O49SF4RLMZZzMoTwDPIMZBsGfPxhnIaeyoZmUbNdr6waTEV1nGHRqt7FElJaKwmp
	/tvRDIBGilbEo6Vp1aLKDKRyJAP9zy10W0v9h/1+cPrygV0mS0Mz93bZiI/aPITZ
	8sQzWWlpY4HyeOa9QBgA6PMWK8V539KL2A+sdrUsGfEDgcFnQMFozEszkIPGYRwi
	O/CegiOfR6BpB6fZ/IufDhXztynY+YRb6Py9vOzdna1M5nv5wJcOVhqBSc+41J9a
	sZ1fOg==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn79rv4un-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:26 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-7cc10da5ad4so523848137.2
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559746; x=1794164546; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=I0CN53TyqnCnn1VqlH8ReodKV089VXO4i2eV8WlBEejQK446O2YDuxJNT4kaLskvxe
         zpT2azgIfm4dBfizqKWfHk/us6gTpbB3lPE+UMJFJAElNzMwF9BE7e/7M54SgIRMnv9x
         XIEw9Hd2fSweogPbriRlzb2ZykWuGTjiDnFEpWmA7mQRH8gvTEnSXYHFdtJcqaAoneG7
         BuY//BRkBv1Y3Iblx0WAaf7rZ1gRWRmfAcH49LTUDxFHLCKQkqIwrAzQ0lVROLtBWcu/
         szGSnKHPWI0U2LwPDCxHTUhdjT3lOEAkb5YzHhBZNoXzRuz8mas0egKR0B1HwfQcWuHU
         d7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559746; x=1794164546;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=Lp1FvJFQGGGxpfHCFwTyEbjQbsvWnYx6+45uZwbpt2avaFlDOGlW83axeQ/oIhRfgA
         M/ztnE7L3GgMHHxKLUGM13ZimYYcCUkduK1fXI/JUzVPn9Eb7oNxxhZcg11GC7t2kE/K
         TrPEcyrGiC0FMtItkobg+aFiAPAqCgZUCHWDhpjnetVgaHCieTCqsjO/gEQGbH4AC0WW
         DetocblVVohMhvzcqZfe7NDgJscapr31l4v6+1H86hkthX/QEub5DkUA06xgUTjoM+HU
         tBg6WRCp+XE/4EdI6VbHzfYP+X7WWYLb9D7BGoZTjSAg3qVzMJ+6Jxg3Xgv9ybb0TCer
         xxmQ==
X-Gm-Message-State: APuU4Z9RvF78jReVuMo1WdYoy603uVenm/dV6OA2fCwynwd4IzhXRAcT
	8DDhVq4dblTv1EgVpksBQXknIK3LganR1lDtJPLsFkOlo6hVOwbtR7GIKpPa11xftYzRO0OefQz
	WRInvaZP3RpRR8JIQYCaixAsHYuF296LNcFdZBTzMVnlvxWvphdKMdbubp9WJPtWEzGk5JNI=
X-Gm-Gg: AYBFou0qhzcrT9s+30qGUTd3sV2Smgt4rwaLO30BFy4Lojr/TvUTi5k5Jjyffb0ORMK
	6BRNs1+mnyqnWYDLm3BQYgojq2KNwUVUTafq/s7hKeoffyMBKeyeBb1vAFeHfaFwBD9cypVVTvT
	rWvLrllIT175zRR/lmQMiF5lbF+d3kkC184K2KKs0yDScG5Kp3woStIbJur2x3a+NPsh8JZPFYm
	/IjhMAXSxZkjfZV+/80Rj79lV/RrkvkQgK9kc85gX2BrUz6gpJbOB8ITIvOyI6i6A9Xl+6a+XY0
	a9hsr4c0jAaJBnRg3gEErhLOKVpBIcMlbZJ64SZtqVgrJy+f7OXn6rEl2yWDpf/+C3DH0e8YhVb
	kmbwsqaaXTxJkVkkPGbEa8UGqDEQvnMDwYpqeIUL+C/mgAuIPfO2ZzXXJpq5dIV4=
X-Received: by 2002:a05:6102:3eca:b0:7cc:2cd0:e73c with SMTP id ada2fe7eead31-7d072cb04f3mr2805911137.25.1793559745579;
        Sun, 01 Nov 2026 11:02:25 -0800 (PST)
X-Received: by 2002:a05:6102:3eca:b0:7cc:2cd0:e73c with SMTP id ada2fe7eead31-7d072cb04f3mr2805902137.25.1793559744950;
        Sun, 01 Nov 2026 11:02:24 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e7a1d9d71sm9894212f8f.48.2026.11.01.11.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:23 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:01:58 +0100
Subject: [PATCH nf-next v2 4/8] net: netfilter: nf_flow_table: use tunnel
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-4-c6c282cab5cb@oss.qualcomm.com>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
In-Reply-To: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: wo21FVEX39pkfFX6O9vPgg3biOLEypPu
X-Authority-Analysis: v=2.4 cv=Wtq+otfv c=1 sm=1 tr=0 ts=6ae78cc2 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=BwFUO5JFP4DfzLIXruUA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX6L2R/G5rydbP
 NPtU7uVUkG4F7SxedlQm8zI9NNITxheqYsdqZFW9iNIATrhporUG7L1VsRL1HHkh3WRyjq5JpGZ
 TJz3NDHa4+0QT7FyFdg7THkVgHUiEbw=
X-Proofpoint-GUID: wo21FVEX39pkfFX6O9vPgg3biOLEypPu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX/olzaJjzkZNs
 skUJN20045Fl3SL6i37oNHfn4BmRMXnAF0pPkOin40Rj/A/erohveSUZjr4U360h9mXsrkaW9CH
 4wbqoYaVHmb4wBTxfV63ebmQ68i01OPvvyyS4VOt/FWNLI/gAyYLbuYFAUmRohWYoG0IT4rldRG
 ugcURjZX2qDWFXmQCR8gATSMuu5Yptzn72JVXlbT21kheoIEE2mpAuM3zYri7E7gDIASp8fLhrW
 94uwOu7LrRgelLq+8KDM32YtMZMMBc4rVBPLMSNqXOAJIIy7rpU7Sdcw2YfCUvqW8kYb7aba5+O
 iQU9OE1/RhcHxSycbBhTk8jKtI0f71ROMxYRPPBt/qla72A4wz8gppy+2LqJu2DyVCWSWKNYBSO
 k8DrOuuWMVhqFxANEPCPw78FINwjdKNw6+C+2L3plWcw/367vkjeYE5x50kFWbfUbHxXKC1EZzl
 ZIQi1+yGAjvbiMFHOhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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

