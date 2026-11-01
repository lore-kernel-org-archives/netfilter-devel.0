Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559742;
	b=o/p6SI93dlhGFQe3gXT2+LakfKYzMMq5HDNwkImFYfk+jF2lRGlp1p06I0mdk7UTFSs8
	 l9L0Fa+kxHP2kcY2zf3ALmzvQFnXXSmlvuTP3ym3MtuEmaCZ3S9DvBil4BxuIbJwovALx
	 4vPM9Fhs+tuTfT6495no1gDJ29KGEfloJLbWnxvHvHIEcVt7XByI+chMzh8tVNW+Kj3j0
	 DOhy2XGE587K5LXINkiJrsbfK+lc4czuTIbujR2hiNT6q95e8jiQmw8wDFYrWfjLDSJgc
	 O385QffcF2+juY/PRguY8M4XfQWIQh2t8EiR1dq4uqZ8RH2hJyjoh8KYGlhdlE9Ax9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559742;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
	b=b3F6cwatvs2VrAkczZubvKiq0syFJ5Rp4Fe4x4UV273sPWy0hMElaCgcyZDvVju0DGTg
	 Z8rbaJR/O79nwzI4m7AQhghDdmhiqpjz/0B+lpaxzR2DUEblYR2eHTiQJAaNxSJWMCKlH
	 NNaQGvsbhH7uCL6h15TI4fyPCdDPI6djeI7Fy7PLGLl69/wDxWVUuoZjpjB7GH/44L+G8
	 uEZyaVBvdI24QQ/Gs/VhkeTpUgu803rc9K6dFQ0kVC1KXtxUFtDUsV47NF8jxmBJfV8It
	 DFKJWk6J6i/HymQOAD9kNmtOZDS91yIjErDTUXzRDTzahE/rh7jQQYPm5wVKDKdNPgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=biN1YAb9;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="JPMMT/PD";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B6606A326
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A2B6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=biN1YAb9;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JPMMT/PD
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQpMP4031031
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=; b=biN1YAb9EyBE1Cv0
	iPyf7+JX0Ql5uxcicbd6kqsSgjK+yn2lDQvdEgpTVsRkDRU56bZm2UYqal5+aNoG
	AwWe42Dsd1zFxTqawpAkIurQ91jSPxyqQx0dl0QyMpfnOMWj/NI+phXIty35pBQU
	nUJGfQ2GlVsO8A7Wqca0k79W1JbyTbB126Vxb4psPI+tP4Qxy6P3PIOuCaBz5rKw
	qPwAEYsXsYLH8DXNWpTA33fB9eM71QQqN8nVFa1s762tNMRZ7egrF0X/d37ZRRMZ
	Dt8kYwEYQBu+qw9GIRRNpG04mbpFQdeb3eLJyOBWQqi/3+6jGm4wwrLgUAvWJ01F
	cA2EsQ==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn9gk3syb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:20 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-7b206156cc6so1723007137.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559739; x=1794164539; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=JPMMT/PDG/Qb0ePQ9PRt2YliE3wIZdmbzZUDkeA4/2LgnkkKn7m/dDsZfTcjElVNNP
         nLt1QV9k3lEh4Ild8KGgRjjJS4/wmrF2D6iA9upf2zqs+Ir6YrcklCEl3usfnYiWnI1P
         52uS4WZqazOsPdOYnnNGVoUi0UrNEYmHPjqQtL2N14it05czj8Ux9VCoPCJb43SAj1zJ
         d8mZukNXPyYjFT5NJdZewJQRoLvM1BYHEM/0JAtVgPcJPf8BCxud7rDZSiX3cWqI9je7
         bKSi/1ldpeCGtIh3BGrgnegqgYH1vn9jDxhHiXPYg47uSS55EBdat8Gy08jIIbbqiITC
         497A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559739; x=1794164539;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=o3Gc6Y3I4xLGeXmO95Q0cSglb0vFFdBrrrAq5fHHcswTKh2So2NncSIX07jqNY/rM3
         KYi9wBmPlLu7jm3QxbzvzHCYHlOl1jBBJ6bL+A2hKjLTkQKZ37Og6zEVOK/mOBcUZKIg
         2gr2YMsUlYR4s6EGiFlkz+DqbR3+CJe2ZBKWzTRxiAGxsU3qo+iYHqu+GlCSXWVQ9aHP
         mtnlkAQeX4fv/7QAExaX64o5RVru8UVUVw6/qDwnonSbJHI5YyvD5XoNdFKP8cGgxIz6
         59V6lFpDOEjpkKj7ek7uNx87qxqz9rn49vSHXptH6EASjJzP6xbiW5jGnkaJq7klnTf+
         UDig==
X-Gm-Message-State: APuU4Z/ZhpL8DcKTlkzvhbXbBdid3ogEhcopGgjbKiV7QrInb3vSVYzO
	j0FjEjcToJhAM4sfcN78nG6Q8Rh10YsjoCNitvwU1gO14FZJn3PAA6gWFoVhen3QqZbx0NTXXSe
	QlUoXkydwW6csDUCMt2JcKzEDxa780Vyl/IfzYpAaNeQi8LvJeKZjZnMs2IZN9GAnob4Wf4wd99
	pQ+qE=
X-Gm-Gg: AYBFou0Rfl/bPb854Rt+QEiYRChpUXIWQZxRqtwNF7Lz/Xz+rrdLuCmVcG7MSr3+67m
	MHCemBFVbMsMJFWoJf1ziTmSz2p88L7j0aG73S3mppRjvzAEMxY0uWmmaXIGMBL36G/4cXn58Kh
	lsoSOYmu3bugArqWY1U7I1TcdlHUb7inZNcYMpcBhI2g9Tv0uvOQG4QutoIJ3yKdw3tE8tZUXfj
	oO/lyfJdE/+XCUN2qqRI63F3D4iiT8rlpmMozylAKvgfp8u+XrQOeBgxFco9w4E7SMNNZ6WtIIt
	8Gx2YKGo5MAsVQrYTCc8zsmvVRQQQFK7kxgg/EDV05S0mgiwBrf5TNViURgH/ZKdgmQoiSni8SG
	l97804faStJiROYaDou9kHLVZWn7QtYLqqxYYEQNt5hT9tdBRGV75A/t6ueftyeI=
X-Received: by 2002:a05:6102:1499:b0:7c1:9f20:36ad with SMTP id ada2fe7eead31-7d0728aff1fmr3992470137.2.1793559739275;
        Sun, 01 Nov 2026 11:02:19 -0800 (PST)
X-Received: by 2002:a05:6102:1499:b0:7c1:9f20:36ad with SMTP id ada2fe7eead31-7d0728aff1fmr3992464137.2.1793559738768;
        Sun, 01 Nov 2026 11:02:18 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a84esm17150159f8f.39.2026.11.01.11.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:16 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:01:55 +0100
Subject: [PATCH nf-next v2 1/8] net: netfilter: nf_flow_table: recognize
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-1-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-GUID: -PMyOwNwRXQiP7mybRWxW3pt2m_4_64V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXycn6MmhF9PDz
 Q3XGoOts5tJQh2shERDbh2miFtpkSbuJVCeHFRoKp20TkHpfQ4QZsvPSedbdQ+JBCiDiRsOqqjg
 w2IbT5LWiB0XkD8jmHZKcWH3vBRrLjPDjG8uxg/TWeTsxtTh7VbqlUz6WxgQU0HJ0tUsEL7WtRa
 AaJuhX516cElFKYX+4jSvTfnxf/0/ylKzvqJIsiphZMrFHIXl2Y4P+asAF+B7ifxfo4oKCkkGq3
 QoDKCWzjhOu/QaebHfwLgL4BIhy903/6MPeI9uLqnG+pXlFEtVcjy6X097WWDgMCBB4WmllESjM
 kG+OCeAy+nzy/e8oqXHEs+bxMjYNb6tmFqyYYm4DNzqj3aXqKG3zuohocUYaZNDmDJOgkyi1DKd
 QZEaJyy8UarHsSBCZmXQskemM+2tUSx4yy/emxjw/f+/r+D7AaZxgcCB88GP6eRLJ4YcJQuSLe3
 KEx19/EdpMBD5+zvLBA==
X-Authority-Analysis: v=2.4 cv=HNBWhYtv c=1 sm=1 tr=0 ts=6ae78cbc cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=m99eJ5p7w77CmUfuVTAA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX7wuFPbum4fzd
 Vu9DLVBGhBY40LBRuFMRb+3zQs/indTvl2UmVco6P1qyaPbQX3cdupNQnMeynqW1bT5AmHsWXsV
 hf7eyP1rcuKwd818EJsMsQ9Lxv/3+v4=
X-Proofpoint-ORIG-GUID: -PMyOwNwRXQiP7mybRWxW3pt2m_4_64V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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

