Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573F6480DDA
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280366; cv=none; b=I1/A8U7DZlyNFSY2yiydEsGUjBCrCt1vOBDWD75GbgAAXX1Hj2YNnoIEQzExD3lI+UhNmXM2Fv6F3hzwEtKmejDKE/2W5Wu17XhTMrf9prwrGwqWuyxEhWQngFT+YYFmqmdL38o4uNZlpt2mPZk6bkpIdEuwwcLGTe002IWM90Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280366; c=relaxed/simple;
	bh=KPh7/9dZhiB6+r8VfyrhZ4JufaVnx8E+2HlD6sGp4Ds=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cZtBPRF3TkIOUZ/s3rbIINv+dANhdu0lvkk1s3Urnapw+H2j+3QMfWAqkuwMtK6JRKHPuAxDV7voTAovhgsUoR7Tzyqmv2n9LZ6Q2eSMA6ZtW9nkJaFi6GKrKF//klE9jP0l8A9ZUQBXBTt2Ogu6K4thOvX4HFW00cBtLvebl3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AAXymLNV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XPOuYmDO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AAXymLNV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XPOuYmDO"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8WAc2746428
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QLVTYZelpaIzN9Flzm0138Gvf/MSuAjYcqAkmw6vr78=; b=AAXymLNV4ASJE6BW
	9UYfPiaYVpNVRtpMSKtIa4hV49k82AmXPuzrMNcFFM5fNPLAtcE9ynF3uY6+UArQ
	Nf+chkRzfBaXDBUmLT8uU0xzeyxNVv3fDrOBokuOxn1+uUYjvhxj5+RV+ycscNOq
	VpFyXh7JqSH8jmE/q87ncfYhGvDA8063L46n5Hgy6IlKtuazWBYCq10W5AQvyFfA
	k/2Ko33oUW/DUUEe5/8Xlo2iSmbOxUvRFSrey/f6GfN2t8l49PkwyNJ69j4iVwaE
	sIUf5gGM2mNhK9vL22HFd6FpKoLaOh1927K1tzA1AGgT9uaa4fABbUpldan+fhma
	C9ZZUw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdvmm1smn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:44 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93903622880so237556385a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280364; x=1788885164; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QLVTYZelpaIzN9Flzm0138Gvf/MSuAjYcqAkmw6vr78=;
        b=XPOuYmDOioD/6e8NJ5o3vU+B3l9q8QYy+PBfrCPcFFekoog7EDl8y6jrqkx7BvqiWN
         pUbSBAY1mLp0ilR05a3TiuNG11NUqYvs+qFhvdNeW+UXDSy9snTpwTiodwwaNdTRrIBG
         lGsV/GuNCjZgR4waI6++Z7kVsp16pXW4GQ25BBPy2mIw8tnnLmoSejeGQo4IK4vbSf6N
         4qsdcLzGslokHsV0+DXG1yVCkjC62pnVqEGD4Or5Ih2DBsy6qI5E4G6a9BoGobJ9IS0+
         W9TSMoGYLSHk7tlMFN7lSoHBXReEaeDdTTeeSd+K3MLWLgvYmlgyc+2U4+K6PwevEMeo
         ifJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280364; x=1788885164;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLVTYZelpaIzN9Flzm0138Gvf/MSuAjYcqAkmw6vr78=;
        b=E9sFIuG+RjQBRkGZwxjnVy7JSYDDqcbbjKtwFPfr2/LH4FLkLTuhM0jIB5AmSaoD9i
         LRelzLgrGQ8xpmqG+IFa+RYdNKxYTisGGHf2wHRhbIkP4Uqm2h2yoZ9lbr1w7+TvqdAA
         buCzLZgmO15YiNe2KZlHnSTqyrj1cMKVk/X3YhtCvKOGg6o22SMQeRqHsKOEmH0G7mJL
         H9xqtGEtZnjWGXnbMngoo5Rswo2nxVlTBawO0B4pU3BBc5nty4hM+h+XWjvZrQkhZy95
         suJEHUpPBHBw8t5+nDiQya3HjXuCluVS4Tq3YV8GT0BsU5UixlVVaST36ZKOFMRy0ExE
         TLNA==
X-Gm-Message-State: AFuF++l6pg02s9T+nIeVH5LbCy5PdojFA4R19ornRy2hfRPJTfdX7N68
	DmvzaVbEL8kXfzlCyHHVNKnvEsYHugNv1Vg39IkMUya0Cy0qE43WHnbt3QXUMfKMH3trsB68Fwz
	ipCJ6gPF2t8H4+YdXkEZVBvcQqDvFY/koZn6HdZheuIpIPxQcyKbWXG6jbYynIZdAmU/4z7g=
X-Gm-Gg: AR+sD13m19KprJctYkuDLDseVdwCO2GhbPnmi7tSoww9C9g79E1RY27H2M/jB5ePDjH
	Y8e1r+CIApuDr4WF+bh7sZB7XqO2ALJRQS2eDuj1P/eH8xz726AUjR90AUr0x4jG8MQpuitJhri
	MQBsgds5yhZBPUQIPLFziiC1N+/pUdjKFEzAJA3s7Yj77wJ4I8ReZ4aVXUfe86UlBY7/YDKwtVL
	1eAbMFiF5JGkU1QWkyq/Sa+DtpW3Ovn22fwiBAZ8fD5/cLmP9Lg34Vy2Q20cnmUp7Bo3EKA0aRF
	0F8pxaqy/tXDqUuztR/3Csk0fAQmFrU9fYnYClL/Mi/cwGkwzON1qrIRuZqJB7pQwiWdNQaJK5G
	T+/r0welac0TFsA==
X-Received: by 2002:a05:620a:240d:20b0:939:319f:d6e3 with SMTP id af79cd13be357-9394bbd2ab7mr718221585a.5.1788280363594;
        Tue, 01 Sep 2026 09:32:43 -0700 (PDT)
X-Received: by 2002:a05:620a:240d:20b0:939:319f:d6e3 with SMTP id af79cd13be357-9394bbd2ab7mr718213785a.5.1788280363107;
        Tue, 01 Sep 2026 09:32:43 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ee9cf7sm108396f8f.25.2026.09.01.09.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 01 Sep 2026 18:32:18 +0200
Subject: [PATCH nf-next 3/6] net: netfilter: nf_flow_table: populate tunnel
 tuple regardless of inner protocol
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-3-72e49be8c31f@oss.qualcomm.com>
References: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
In-Reply-To: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 5whGp-AOYZhBQSbGZfYhjZR_dog1MJ-G
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX+JA97Mo6Opuk
 OF5NDwVSYE1urPEsr0E1a57S9QAHXXIzdqGVlUgbXR2Hf4RvUw5HEdNP86ukp/eb/cjVy8PZfzR
 MHacsFJfQMm/c/EQG3WVAhyB1Rwac4U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX2me9HPYVNaDO
 t95p3hwVMgquLHEMNHwmynFzYeLynWj3YZTwbmR7KuMAawP22nWzdMD2BJBwnEv7cQ1MCLwfcMp
 loWV+ugy4RKJlvnm6a9i5QeVaUgzsQZEo9PoZTBUrodQlq/ccD1NosDHo/86dROc2Q6bSrTk7qt
 LrTBibr/vsO6PEK2HR8/KTM7sGE5yz3TbwwHddGXa5IXhnARCzjgdPZhk+aRY5ZSx+g22njnGhH
 70DHRC4aao2t/E2iCIlKv0jdNetNhSeborBCUxjUjx5vM7XkeX/ycXONyC9GC75RoTTV65spPBz
 eRJKdQVd6Li89A3MvIoFjHmvfbprP2yEfE+MF4Fxvsbv8zNH5pKyKxolhyN+XaG6sRCGKeuY/B9
 OAqCdb67kAG0oLUCIBR10zo8pv62LT9yoDSPPiRFQvtMvDxqWVYlsqEs5fl5FdFgHNZEk4+RYGb
 awVS5HC4AqRfGng7RMw==
X-Proofpoint-GUID: 5whGp-AOYZhBQSbGZfYhjZR_dog1MJ-G
X-Authority-Analysis: v=2.4 cv=GfwnWwXL c=1 sm=1 tr=0 ts=6a96fe2c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=8uPksCqhpMYrSrxJYREA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010146

Store the outer tunnel addresses and inner protocol in the flow tuple
unconditionally in nf_flow_tuple_encap(), instead of only when the
tunnel is IP-in-IP or IPv6-in-IPv6. Bail out early when the inner
protocol is neither IPPROTO_IPIP nor IPPROTO_IPV6.
This makes the tuple usable for cross-family tunnels such as
IPv4-over-IPv6 and SIT, where the inner protocol differs from the
outer address family.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8af3d98ef4b2..3ecc47b57854 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -195,22 +195,21 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
+	if (likely(!nf_flow_is_tunnel_ip(ctx)))
+		return;
+
 	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
-			tuple->tun.dst_v4.s_addr = iph->daddr;
-			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPIP;
-		}
+		tuple->tun.dst_v4.s_addr = iph->daddr;
+		tuple->tun.src_v4.s_addr = iph->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPV6) {
-			tuple->tun.dst_v6 = ip6h->daddr;
-			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPV6;
-		}
+		tuple->tun.dst_v6 = ip6h->daddr;
+		tuple->tun.src_v6 = ip6h->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	default:
 		break;

-- 
2.55.0

