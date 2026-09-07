Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDB3417BCA
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766452; cv=none; b=T/WH8mYSnVNyzA/MKW66xpisnyk4BK36zmOxSpztGi+9Ae3lEd1rKOYUMWZGMOYURoF5fhgCsMNhOu8wTIFFAL6qpD7yRhUW1pzr92I6/TvRcQwaQrKN8FQTA9K9OPU3JxxUkJwV5q8GxRNWEqqoQ0zsh8t/nrCz7OXlxNX9S6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766452; c=relaxed/simple;
	bh=CFRrn4x6ponRYhQFZSF7DOt0uGwt2i4dOTnusXvOQb0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SlvXpSW3b2sq8IA2UdBk0AS6U/uKLNX6fhxl8QhDuoyBV+d0OqYllKPOHA0V8LsXTBrloLCb2uUB6OCSM9GFI/Y0lhGfzXHjVve1Nr2QINMAKwcvFL6WNYzjJ2xh5An4P/txTHEf3au808YzIzmk5+s+TztlUPXxTyTJcxEidQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L1yohPxP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WSZ/Yx6e; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L1yohPxP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WSZ/Yx6e"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777ZeT2668316
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:34:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=; b=L1yohPxPT5KqCg1h
	BqOuOyHHVj/9rgW9k9CJFLWeu0GZziZHU3cmnqKtCVs1kubp120COb5oJI9DG3al
	UQs6vAJL505hxg78sCw7Xkq1j16fx0GI2z+E2TBkkX7V6Yj79WUN/I6QLju7va1C
	DRDMcH7a43acqDnvWsTT3qFzWfmmQxSh4HFwm5yOl3oLieQS4I0RHMAHl8qg34Ub
	tRsuVmYXYKQNI2vwUiU3fd+80/Aoa3+LiMcpBZDTHe2lRBX9KMOH6+JwWb9Ji8wW
	arBCRXZDSMyRMlqXGQAEeVPRsddC7pMd0dIaloDcr5TXHI696YCi2Dq4EB5zrGcF
	9XKnOQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ggcca5h8g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:34:10 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93909014c85so536189085a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766449; x=1789371249; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=;
        b=WSZ/Yx6eFSGqVUgmSjY3GEg0z6aGBA19PbrCjQ4cJVCO80rd+YDi6dY/Qb/Y8DlSCm
         dWFw9l3IkBsNFHd9WTQnZs9CJLQ/0EeghBU+M5xu2rgkpMqEK182Gv5Yqmq8OZkWcHfr
         FP6KJKZh442i4s/ovKGu8OZDWSXf0p6FOlTOvByDzS8/CbcxNKCmgnGhD98cIxjmdKxc
         /w5263+upR0aW0sSgdVb+9POjTi3PvjQk34pvUEX+znihIBC0YZah3vB00u4jCYJdAwn
         SF1Y5LxOSGCG/eGjDVt2c3QEv2vV11xiK8Ax4Zca1LLgD5bjh6246fcGEWrDvu10jTkf
         mERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766449; x=1789371249;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=;
        b=OuNsmv09oquo3quEIPQGYqBSDL7v99pdGAK/OUn5gWMXkc4/zNoDvZLmrn+MSlv4hh
         Ov1F9/8KXFPFLBzAUoTzJBR8Qmmjzet9EaULyPNj9GI3PBeVhp5rY8AZJfQk1WwhVGot
         XwhbLkDGthok2ziv9qvsz/8y6VtatLvzFR/99MeuzIjjxBej/bF5glFxW1+EMCLfbdfa
         uyygdRHV0xN/Rz+gwof18EGaw2T5KGDCMIw85vQlwdK37DzbSTDbWe4+0a0TXQvCf4OD
         Aaot7X962XyTasBTxZxSBrW2a6qbXJ9s4ORatpoF+Bq6XwvpA0eoBu/J2owp8Dk8Rk5t
         E4ig==
X-Gm-Message-State: AFuF++mPakycOQITATGV0v3iBDaqoFYtieOiz4dftl3exKK3GOsvOZwA
	V/DtvqkEOexuloF5gQV7Qr5wJvCJFHjdjUGodPqAPmowotY/+d1jlTUpVxoHnxfYh+r5tKgnqMM
	lSCyP4muq4fmynpdbcS8vCjSYCUHQrzc4eXd4g7LnfTfGpyJpkoHMIeSQssWBzryNyf3BaPA=
X-Gm-Gg: AYBFou0tT2mtHJjtqGpatrprtZyKn2AVd7c2pCFc+q8Z2MoIiI6FxuSxi7QKpy5qxiV
	rvHk2rFsRUFqZ+wwpOQ3q8eVmVpXPvGSOSJvfs82321vSjygWTRTT9tT5ePRlCmIlHPZx2lYymR
	Pzq69H+k8zGfFOoU+/1TU2jwKeLAxHsKNr5fbUDQMxDWfAU+gNHzxJPEYs9CpaqPJaZw0fdHKpu
	2DRrddZxpRnFil2hf85G+DmPbrvPHuHy90Ju3sFZJ2F7GP9aceaiWZwVW425i5uca29jiD+Ag/g
	NQ1Amf2FN/JLTsn2f7OeWhq+Q8bXqrHpnIrl8CXC/grnvgBOp9iOFFMy65Uxu7PWIkgi1F6Dgz9
	WsZQd5jZUQK29Rw==
X-Received: by 2002:a05:620a:40d1:b0:939:8c80:669 with SMTP id af79cd13be357-9398c801af9mr390051085a.42.1788766449541;
        Mon, 07 Sep 2026 00:34:09 -0700 (PDT)
X-Received: by 2002:a05:620a:40d1:b0:939:8c80:669 with SMTP id af79cd13be357-9398c801af9mr390045985a.42.1788766449011;
        Mon, 07 Sep 2026 00:34:09 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885bfe14sm26955912f8f.35.2026.09.07.00.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:08 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 09:33:37 +0200
Subject: [PATCH nf-next v2 2/6] net: netfilter: nf_flow_table: set inner
 protocol when popping tunnel header
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-2-7c6ac1750725@oss.qualcomm.com>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
In-Reply-To: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: FPitaCyzstlWbox_qjCB6qBcSYft9pe1
X-Authority-Analysis: v=2.4 cv=EJo2FVZC c=1 sm=1 tr=0 ts=6a9e68f2 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=gKarwEfFoU5_EcFYj1IA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: FPitaCyzstlWbox_qjCB6qBcSYft9pe1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfXzSq08owFtaDm
 MXYszPiyJStT5BDI9Y6KcNjvUSVUtFeWmN++c8xHRwLaV2eiV4g+x6mKvGI2NFEAR3ly5F6QxhJ
 jsaX00v6gPLIRxrEf6dgIXu6/bNx7ZMFwq315orTGLR0Bwr/TKyqwVoOLGaJQ75wm9gIWUj0YMi
 jfoX1myfNpSGv3igfzN5RoN3UE0dEvyjlcWV0Vj7FG7Z97Oj1mX46nMRVgbBnEaEBHFexlCEwg6
 yG6xOtM/+xseqO98NvqMOovdeKJHf2FFszm0DSAecO5j6wfm4SxQdZd/2EEkD9bbPdlTHorfvHE
 pBHzPqjt9KhuzMdEH775NS2aBn4HG/zqfItMs+XXq8BnY1TFS3x/pe2Y8SsUWg+hc0JlQ/U8MHe
 wkLHh9m9l9XRl1L1VygJF19yRnjPwdW/tTugbwTcd/CDfM4wiu4cckMAhpSivUSfnA876lNhDyD
 gieCyk7lan7B7e5A+Tw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfX+t2lISF9nVoS
 1UdryeKLAnskmBcm1ZLZKC4ogyvcCCxq3/dD/6twKLldRx1wOa3eG2uchXPdieFdQPbFDKGxSKa
 yCiK3gj3JrC3lxW47sQVyJaszE6cWgo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070080

Pop the outer tunnel header and set skb->protocol to the inner protocol
derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 42e8de696474..cd636b4cf74b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -372,6 +372,11 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+
+	if (ctx->tun.inner_proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,

-- 
2.55.0

