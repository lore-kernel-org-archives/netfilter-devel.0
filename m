Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714473;
	b=1QmfcxYcPN6f0lkwffCK2vx3vfH7CDud84as8Y83UyJVxm1PShzwbvn+O/scNRKKaR07
	 o0ivFLSNtk1hUZgouY+hc1Ye3i0RBlnUWQ3LVNGx6DcEpVb5lDr1m13uzHr/hG+5hgvRi
	 M4b6bOgFZHYD810KyFvnYcL363+X4aiIyI9ZZK4w2a3sa2p5rwNXaiC+mIRqurg86msu1
	 NjkXWbD0ufH670xwstyxL1hGIg6wgpPGGykGYX4zCVzhJnWKm5u7VLteAiogkb956he0+
	 a3a0i76nATqcaEWrxTRKHFqmZvvTgVs+vA1BonSguN6dTM+7HDekmbx+//k2cY/fdpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714473;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
	b=lfBXQW24iOFvDnAd6TIBV8cJWF9zy2xOzfUehALQEemJmvh4PoCHtTR+m1HE3Q0e7PF2
	 D2+TLsvlFvA0OH5Z9e8yFGVf5kopBjjafIoM7Nxu9P8C1pjY+hmOOgWyDFXUpGWLPAet/
	 UesD7iRgybKc/U/69O5gyKhh/4J0oB+KFVpX7mYLKKOw100vCQNgQgFQCoNP/Iy0Zsedq
	 PwRpMP79CTDk1Uf2sAH7jQoVtqRE0PocGKAsCM7QMujiiWfAnifgv4xMtuYNkNiiTMUa7
	 F+l2BJZJE/0JZl+ysJtUfKbwjNvuqBtzAT95ftXwBqkGcxIKwbwXjfpxQURcTGgWVow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AuODcAX+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LzOSg+I7;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4E606A331
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66C4E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AuODcAX+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LzOSg+I7
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZWRo3612759
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=; b=AuODcAX+odnE96rG
	unhsBxUS8tw/cE8LXCIiTpdx5fVoTH8v/HB0Z12EykOwm6/kUjnwZWHRlxxOR5nS
	TiiIjhWzqSXaaO2LWfzLTzSvsWcpsX31guEY68T+8aog21zNLuwHIFyivU6oegb8
	a+MCJV1ZxoZZPxs4KF1S4UZeZVVJ0SjONEfg8C7yujr/nSO7VszYgcbO6c3eM9N1
	jilCdGh5YBx8qfqxgVime+DBVKLjINQvkG+firwAlgfrzgig+rkqkM/tfG5wn5BK
	f/kM7pY5gP5XCfByR1lgZPK4SC33IWqVEEpboPieJo2wsI2oTFQrTfq9MFlR1GwB
	pIVY4A==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq6m9ajrc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:01:12 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5eab2a9a633so3904257e0c.2
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714472; x=1794319272; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=LzOSg+I79ImFhxEPi+kq8WdYO9Rrlm9YjSqmt8iyPt8CxBR1ivyBiy81nKgRc4P3mw
         CW5nnYB0C/DnqwYuvBOGNJBZjr3g59+O2JMsYFLPuRHX/34UFl1oaHTRTPa45OCLxUyQ
         rl2ZR9oR58OZclGOv0H3eNxr4KLHvcjnlIrrcwu+ZJKH1laHe32kYCBuMRRnYwsuQd6q
         MzURhwZsf8fyShheurs4VEo2idwcW0Ge6y9Mqyh0HcHq4a0uGolp6jnwIUYxR6MrfHh2
         UOLBrVCTcByJQVQrm2dRIVAfgXRvfCXfApeUaOfWVcPRH2VLpOc2yt21trfQZeIvIJvU
         8oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714472; x=1794319272;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7QJTXk+yyu2noyd0AhwDq/i52OWJ/qR9UIyjE9rMjs=;
        b=mwENR6OrKtsFRsB2MYKQqrT/I3Q6DMrd/TLp+YAUViE6fN6pnA+aKeF5WhXcJA981U
         zrygHM00lWKPZN0fy9dOTPFsjLvVBogQapzsOAky35gdWSK/+WFtwPuR6EAw3VvbnUvA
         /6wArMQqQxenFT8SAIt3/UoCnurOlxt2XRUdQ2oTWi1z4IXf5vDqMtvS6UJCLkzK7ljt
         Vb6/BrUFcWpD+oIabTzKT2rLTGRT2mfzbTq3EjAgLiL3580tPsFvN4oTX6J9Zy+yKfTy
         QlQ9eVRp92N/cdDL2VaiTpMk8XMhKYbJHzM0nHRVu5TjGD8/9bByXdTVatlSTwcgZ/L4
         0FkQ==
X-Gm-Message-State: APuU4Z8a77y4uLZeJLHee7sHlQ0KTaybSzZn3es/a2TQuWfIqbHr7aXU
	jkQQGssWqIf4oqtCVLhthMbF+NfugkdnkvW2nwhW8dDGtRU5k9ErnpLBQfWDVmG6cI6nrxT4PQF
	F22lUImp2lK42TEEOor/Pee/4u4E3SXGfdHIymzJvLrvazf4EE2XS6LuroJZI0paX8bQa4J0=
X-Gm-Gg: AYBFou03FB81OK3Y6YXJsDbpaBBWO6JMIE9Bjz1K3cvKLEX7fRM3K9/bNjOx7tBpIIT
	7yux1dvBbjqpp/Yo4nAhAyB5P7chH0m5y4deA0fgdEA9QaMmRh5mnm9hiIpl6pyXI5izpMUoVLa
	qFgpUsxVqgvpJsL2vdBZUw3YzL/xv6hxi0Rja/ibDoPh/JBoqGuF+30ZKEj9GduKkilu+avzx5A
	ehBgHSdgAUcFWGhU5s2Kd0PF05Wm//Vg/nBeSePxHP3Pf7R8kOkT9tueVCN9Q0wXEGVSIgKzHBl
	BeZrH0sDo9fpYbQjgatUfnV2dtph3V7Ts6OhzgzropRoKNYyBtC2iAn5m7KJgFAvVRFO3hoWcw7
	BoCQCeu6iq7ooPc92F8cOtghNOYBu9xMJw7ZgJVKDls1AvqMw0xCGALM2/XkDm0s=
X-Received: by 2002:a05:6122:4d86:b0:5ea:aedd:6087 with SMTP id 71dfb90a1353d-5ec6871d3d2mr5829678e0c.4.1793714471417;
        Tue, 03 Nov 2026 06:01:11 -0800 (PST)
X-Received: by 2002:a05:6122:4d86:b0:5ea:aedd:6087 with SMTP id 71dfb90a1353d-5ec6871d3d2mr5829582e0c.4.1793714470476;
        Tue, 03 Nov 2026 06:01:10 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2afee292bsm65369595e9.4.2026.11.03.06.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:08 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:42 +0100
Subject: [PATCH nf-next v3 1/8] net: netfilter: nf_flow_table: recognize
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
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-1-60b5f063f1df@oss.qualcomm.com>
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
X-Proofpoint-GUID: 67cYyqa1kBOe2TwWtrI4k0viMNme-X-g
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX2kIKNGzs38fF
 0fTBF+w8B+MVPVbMbITJTXp6pcf2V8Yv0ycECq7+OJD7AKDx0d+1UIowgIOv9wtsje2uRo66SbZ
 iu68FvIrPxOhAoFHsdjUX3Na7LFwnBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfXwUKfYVw5WBmb
 vQShxFhWi13UVpEjyIJT94scHPzIcQwUb5ndPF9jAx4hJXrqbTRwtsVy9OdZG8RtjliKh4LaF5P
 BC89w5WLEfQTWK0T72/sqou86fQpubtKTP6Yq/v6N2rnnVvUF8Sz7GzZRcVo/kEUoiPSPM4L6kT
 SsjddXIZz21vfbEL+aofDKTEQj0lhZ5WQvrsrhmpvJzR2RMT7VYYZ5FUgrN5MAa1qWw+HvWRAr5
 pDWq8oh6wuNSjc/YR0FMzBT1FcT0k2EniZqRmGdYe21BlCF/a/vjo5Xm9Pwur+s3T3kOhxSGZ2S
 0Q8uA3LctVmRQ/su2IZMSkS7oryBBdlMx/6hc4H/haBsHS/fshKVgRT4YRn9A0bTagAM26L7y6w
 aYE8Rld9DInGbVaRZOlqSQaCZR1APmq/Az1MtVcum9jI+JPrNmPvpM1X9Fk2LYvhfnwu/vPWVC6
 pTqFKSTdlGrvow+9fWg==
X-Authority-Analysis: v=2.4 cv=C7B8WgP+ c=1 sm=1 tr=0 ts=6ae9e928 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=m99eJ5p7w77CmUfuVTAA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-ORIG-GUID: 67cYyqa1kBOe2TwWtrI4k0viMNme-X-g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

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

