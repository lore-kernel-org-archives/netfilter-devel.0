Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714477;
	b=QeUS3NP9nKeogSBpCnn57Ayww8NJaoiEuy/y5SxipNlEEGmqNuxZsDF07Of4vgUnpQ/9
	 ilUSiMpcxksEpklRQo7dGkxD92UMZAjIypkqRCu9M4bIvts4pXK6asTyVwUxuS9brpOl1
	 bSDaGXdz5zQvXbb8hX+wimj+iwklgdWy/EdkJsdq7dNo5s5pMKOvmScWWsmoYhykVVS/F
	 PrzbZmWhGhFwhPey1eIjpbyuv6zHTVD8pSazsxNTBBDPXK1t14i7kabmGD5j/gNVEdYv7
	 lkyLYn44+uNqpencqPT4S7ckHrlus9A23nHWqV0DE1g6FckyZY6PAHtjqfvWSqgDvzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714477;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
	b=Dgci4a9B96YAyYeX+gydNaOVVCRqJ+8gpM+HTX/4kSUvqYJMksDnYiIFeRcIbr2LI3St
	 c10vh0+1qJW/eSQdaKY/1SFJHoMnow4R8+9tQX/hahNGla7H9l4UdknlKTEA6d5Y4Jvvv
	 whHKCDZZfkHObwqLekGPKJ4vDp4w245KqqTYcQQbpXqgM8BCI6plQv8QvEdKOHOde0eg+
	 i9qeemcuxpA5vkoA/t0MG5ofBZR2Gz8hxeZwLborZNb5SJvuawq7LzixqA3/OYxpzm/j4
	 x+pf9kMMTZZN0uvZ5SYLLfCgqLZgHnmNB4UasYm/Vm4+MOkzqfM+6JNzp1fE9Tk8xoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fgydXZc8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Xvb7IxWl;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231A606D81F
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4231A606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fgydXZc8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Xvb7IxWl
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZ5O93003231
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=; b=fgydXZc89i1UE5RC
	v0/bO965dxZFBU4iR2kIjF4zsGtdTHfJkzGVeGxsqJ+jBjX0abV6VdDVkWTzX1Of
	N4FUWIXSGM2LEpVY89nhs5ZOwjCvJ0F+N5G+lHlG5clMRWmMmfJa6M2cktUY+n37
	/LlWjHr38c+fiy/Ixu8G0/4lMn8ESgu1ks2hk8SrxPwpZffjG1FvkKrVZlNZ1gKA
	t9BKFBfL2H9YtfdYTwbb6w5DiV/EkSFnwZT68WxyZPGAypEM8jbnIA9bcpWsq05j
	Y9Q1wFOwCVTWjr8pp18fEkmL8ZNY93aMKSPD8bAu6+c0nLSiSCOijGNwxY4y5m/4
	1zZGkQ==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq2ackfcm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:01:15 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5c96bf59c31so686225e0c.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714474; x=1794319274; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=Xvb7IxWlmn98CAClQ8xwkfMgrP/pcDESy2XAvTMsYC2IZIYjxGhtaZJmHjx4D2cGVn
         WI7qgiFm5Z4bhORi5w1ocvi5wPdpj+lgV/TAUR+DHAVwDxLHU+7FEI+CAs6rBsnryJdY
         d40zCPLhHZtV1HJOqwwTwnnqBjegxDeuFeRfUcRp7aV6l8EE+qeinyc47b4QQOGYOCFK
         uX/MOACys9xWnBHgkhkms5UxUxUhoBnQ3zeefQ9aXGyulshTjkQVqvyVrmgG2AkEBEGf
         sG0OFnccTY/WEhaMHnjDQiUc3QDQeBwzwyEnEE8tM9EwagQLSJmdQuYNsw9yE7bn6TQV
         6Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714474; x=1794319274;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=kFTUwaJVv752TQSymO52Dnj95Ltq5LbtWf5vrhZitxgYPvEGkOgVcrgr91CmrV5U8e
         y6UZ+TXiJaoOTdQwXHhxYBX1EAfZMUp7tFbpLh3iDcBFihyvX0bFKPAjGzYwoJgXodSR
         87P8Z/30vAaKbLX2TAsX30uGplIFQJ+M4Q1ZH29t3uHJwX1kj7+EZ2wumntrxLfsCgdX
         VZDSUHk2C2OY6sucikzZOshY4WlfWeLspBQDa922aXnA5ADLULbjYqe2DvxGmBUroFhc
         3GPuuhMhCgL0vKnQSttj+HyZb+Bi1aF0WDQeLMrsZJHTXxgnh5ZuzCH8vsxmv8xhE+6w
         ZKMQ==
X-Gm-Message-State: APuU4Z/qH6N7aFMftz3k+QI9u0Ko3KS2d8hPVJu97eRLV6tUgRHaYx66
	V2dTC9HZnKKwhAfeMvwQpvteWgUCXyAP51unFGX5axU/STZnhlP7vbvDHe1XOCoIjgzqAR1q7Ro
	o0p4agXl2EJeQw/zu+4XFc0/+tyUmHQ8yfb5qTMjdUVnxiFQOAKvF2pAL4GYPkU/flbbEAGo=
X-Gm-Gg: AYBFou15Cv7d88FVX2fESMRdw5ad20bXeIqyWj+LFYmmp++zEfNnv7yLcXmiOLVKwnM
	9ymqofB+cNm0ezOMTpnvwVZ80mYaZU8Lj/jjxFx75w+gsZIapdP1eGXMJ2UY/MFRw8BVA7auUWY
	A2hl2jPL2V7CHtrjgtV91puQD5ObAQkmMiFTNq+hYTeGw3pLSFByYGvAwAMZ8Ekd60OZtTZF3nf
	urDABfMkeFmr/5YIeSOiU9ConQZiHdxdx5z1WsdGI9OGlxoMKuybuzahSrCI533xhn+lTQalE6r
	/BOqSc/OKk9SeeeSMneqppxqbCmkzN0hLb+J0FWaOWNCvHm0KxerW7+sSL7i/1X7/8xPDx1QnPL
	oQ/k7KsSyfk0jMXQ2lJj9DG+KtZGA7EMoW0h3LKsGeI9MkPSYtXjNoi1qriMaLMo=
X-Received: by 2002:a05:6122:e22b:b0:5ea:dbae:3cb1 with SMTP id 71dfb90a1353d-5ec68971944mr5004838e0c.19.1793714474117;
        Tue, 03 Nov 2026 06:01:14 -0800 (PST)
X-Received: by 2002:a05:6122:e22b:b0:5ea:dbae:3cb1 with SMTP id 71dfb90a1353d-5ec68971944mr5004701e0c.19.1793714473121;
        Tue, 03 Nov 2026 06:01:13 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80eb1sm26793697f8f.34.2026.11.03.06.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:11 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:43 +0100
Subject: [PATCH nf-next v3 2/8] net: netfilter: nf_flow_table: refactor MTU
 check for tunnel offload
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
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-2-60b5f063f1df@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=T4gZ3PKQ c=1 sm=1 tr=0 ts=6ae9e92b cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX3ahN+emliCZ0
 Sjy4bMjp5yi7Iq+Z/my8kl7L6jsFXtfxR5bcOWNAJOembXI5pf92BsRFq7yuY1HkPNSP5gmcN9v
 cFOxODoM6fOl2RlrDWzEbK3n3URMHq3A6pAuX/WhJIVDEG3OBoGclHH6Xvrx1Nz5jj6ag9mDANt
 BpHetPr0ZI09NO+ufFuj1j+p6zG2PglyRlSNWwZLbXZRUGwnQfBBs5FvvIZFsyXKhXZ7kp+s3wE
 KXpRpIhCgxvQtMjGyErbjvTnp7gmHDrLQLCYVX0NZodLT96AX60kqTEehU+y14cllot4HGVpXGk
 aPjL1r5cePaTKk6rpajBC4/qPdA8bymCkRd+I9ud+nXypeyEDaBaDw57hGpMeB5E+r/T8M5MXK/
 NPc6T/IgPXPr/NRyzZj6miICDF0saOFr7vLi0QE+KbRp9bYjRjA4NsSY5k7aWzwXWyfXCmeSUjZ
 MiOcxNrivJcxcA8KReA==
X-Proofpoint-GUID: giQRvl0Io4LArX2pjlrK2sGBJVStVHfg
X-Proofpoint-ORIG-GUID: giQRvl0Io4LArX2pjlrK2sGBJVStVHfg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX2sGL8skJveYJ
 nHRWGfbIdAJ+qRjKVhCX2lSB//NwwyWonqycqqYQDRu52GMsAHXPH/SMzpRgiEsZ8Lho/VKwdBE
 aGVJGLEIn1agjuDqh7mJoQrnb8J+zZ8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1015 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

Introduce nf_flow_offload_check_mtu() helper and use the encapsulated
protocol (tun.encap_proto) to compute the tunnel overhead instead of
relying on tun_num, so the correct inner header size (IPv4 vs IPv6) is
accounted for. Use it in both the IPv4 and IPv6 forward paths.
This is a preliminary patch to support IPv4 over IPv6 and SIT flowtable
tunnel offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 41 ++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e07fa9327eb7..902b9b595677 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -472,6 +472,31 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+static int nf_flow_offload_check_mtu(struct nf_flowtable_ctx *ctx,
+				     struct flow_offload *flow,
+				     enum flow_offload_tuple_dir dir,
+				     struct sk_buff *skb)
+{
+	unsigned int mtu;
+
+	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
+	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
+	case AF_INET:
+		mtu -= sizeof(struct iphdr);
+		break;
+	case AF_INET6:
+		mtu -= sizeof(struct ipv6hdr);
+		break;
+	default:
+		break;
+	}
+
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct nf_flowtable *flow_table,
 				   struct flow_offload_tuple_rhash *tuplehash,
@@ -479,17 +504,13 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
-	unsigned int thoff, mtu;
+	unsigned int thoff;
 	struct iphdr *iph;
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
-	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num)
-		mtu -= sizeof(*iph);
-
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (nf_flow_offload_check_mtu(ctx, flow, dir, skb))
 		return 0;
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
@@ -1108,17 +1129,13 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
-	unsigned int thoff, mtu;
 	struct ipv6hdr *ip6h;
+	unsigned int thoff;
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
-	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num)
-		mtu -= sizeof(*ip6h);
-
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (nf_flow_offload_check_mtu(ctx, flow, dir, skb))
 		return 0;
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);

-- 
2.56.0

