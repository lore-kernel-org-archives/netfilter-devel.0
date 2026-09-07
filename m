Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D03C41A928
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766459; cv=none; b=n49v3OW8oF5X/oiXHFlA2uvzmSBXVbGqle7aNAG7NOVy9lbhZ/OQSOMakQsseRUWTXZhFlCJig28xmAM9RpMMYaNXAC0EDxIUWuXaOwU/avLVwfEAzdqx6SSoeWl7yhZPl1yt28vJpj7O+DN/J5QNxXG4hmFrCBXpTwIsdESZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766459; c=relaxed/simple;
	bh=ObImdCRctrqV/c4iowlCxHzbW8PQspAWlX7/vA5RNkQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kDhruxxMWO27/4XWU62QPucZF+Mu33rbMUo8Gavp1i1CMyPe3cRDLzQ0kdIm9mgCH2GeiD0YlzGFrPe8W1YmrSOvKFsex6SZimrC9akbo+plYdE7EBVfJs+6EUex0BVbKpyH/sPDAVYQpBF5OsRE/hiCQP9sjWK4Vakxyvbx32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=amT6/JyX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S761pqKD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="amT6/JyX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S761pqKD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777Dcx2838540
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rh33Ui9H5SWpvWB3yrjhBwzPLRQ1S9PELIWm3yJzGZ0=; b=amT6/JyX0bFoBv7E
	i9Ub2IUA6c4v0WDawYcNQ9YRePsgzPaNARirD1EEzaYMUNvGHGMh9SCGKwLjD55S
	f8NNrUdSgzizcwE+E5FxMS57y4jak3L+hLR1G12qHhixqHKpW2nKtoAndrPKphNz
	cbrSRRuaPPDmDTxUQvQwpt598l0IwiM+ZWhTzHCIO8Qm5F2fbFtMjcO+TEan6919
	K5DopRZNMXsl+OU8YKsAIPFpmxjX8XQflsa/XGzcKu1A5EUVMW0bFfhHSppqzYXn
	7LqnxZ5YFESU9H2uuZDIwcIxVqYijh8/wP42HMM2jySEoZTY1WbTRA2VJgOfbLjn
	PxOIAw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ggbuenqpe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:34:17 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9382f9430deso557215285a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766456; x=1789371256; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rh33Ui9H5SWpvWB3yrjhBwzPLRQ1S9PELIWm3yJzGZ0=;
        b=S761pqKD2DFxICqr77NIIXqYGrM5LZ1hQds/z+/gHVDa0ojRR2UhyXfnGkxb0Leu5P
         MJX4tCIGFOQeOgyWB6v5SXApHo+Su7rzMqHeZIQxK+IapkZJECrGWyQmlpuPUwKhKFji
         Hgz0uYKHlSJVONAUw3G6WFoR5c01pBh3UaOkHljrvtuh62kRgzJVdQdAn5Bhkc5WGauO
         B26swHuk65L5y1mtSlMf+xc8kdlEfPH9IdD6JsaMxZBmrWIhuIN/t/Bahgadq6mWBTx7
         37hQA2AB0Cax5KQ1mg441/m8z8fSAsYEVOsLPn+jeMMm2fOSjXH5jrxBAYLKXf4oibWW
         0hwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766456; x=1789371256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rh33Ui9H5SWpvWB3yrjhBwzPLRQ1S9PELIWm3yJzGZ0=;
        b=UadbiiKkfGi8xpGXClFipClNcwE5OtSDYA3jGZcJDdiHkGE/60LvA645IdJ9Ss4lau
         l1nTWxLrIAsvZjCEXIq4sKwgUdsJ8s2gs5qM+HhoNJBzlZIcHjKkJuGyUNSX661aWmSp
         W5USAr6Zir3N2k1ln0/FxCFF7liBdzpug1RCdrWxEPFgptuW24Et8RnNfDTlehUuhtwJ
         gyHUOGIc/mwo+2oVDSqJ+QjMEMmsoc5SCDhr4fL8iIXoWProOpHL4iAnG40tvgOdB5Ko
         /3PL9bjvqbGx0xp+r7UVwnqdmhd0PaqiloomGKztuBJZEyLQAy13Gy8/docMTxxDTXAk
         E/8g==
X-Gm-Message-State: AFuF++mdYRxEmO7FLTP28wnHE22lLcah1K/cn8Wlc/Rrzly8E5wB33aj
	YyN0XJCJ8LMjJp0ZR74EdTJlQgdBOUpdNLCaxEEdsllbnn1Il6gyIxdxQcVD0uiQ67z4H0h/rL+
	A+LNJbFVDPK1Pa29tsw7nps4UiCTk4NzLSrbxm0+fjzi7kFH5PGK7FKYbpjRuK3PkIcFQ0c0=
X-Gm-Gg: AYBFou10Evn0G92lNO+OdcAVA8cYFlfkQ3/bT7UU0ZHw+paZZXRLP/bp+WHmLomwdxP
	UYDvwzLB3H8MNfVmYl2F1KCzV36hP97Yik8J2eRmZvXCQhgFx3NtYhptY16H7soP0mCotz4gDrS
	d1GrPJ+JOTkh+2PcX2+QRWENAGcFYgBinxXT3zyAqcd7xyFXASzGG1djmca4uTXmdqIsWfw+jj6
	0bR51VOliy6L0JVPuDMVC+Mg/HlKAlYSxOuAp0GIxoc66lIivbshTcrygGlKJjaw2MzS3FIOsz2
	lN0oC+4TCl3YE4D70lbGJg9yhqUAJ1TXTeP7B+h1lp/6iHNJYeXf8EkLnMUHvAkGA1e0bUw69Ir
	AXBbDiwZv+1mCRg==
X-Received: by 2002:a05:620a:8201:b0:936:499d:9504 with SMTP id af79cd13be357-939803443cbmr1529038885a.14.1788766456487;
        Mon, 07 Sep 2026 00:34:16 -0700 (PDT)
X-Received: by 2002:a05:620a:8201:b0:936:499d:9504 with SMTP id af79cd13be357-939803443cbmr1529035385a.14.1788766455929;
        Mon, 07 Sep 2026 00:34:15 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfd3f8192sm250149415e9.3.2026.09.07.00.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:14 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 09:33:40 +0200
Subject: [PATCH nf-next v2 5/6] net: netfilter: nf_flow_table: refactor MTU
 check for tunnel offload
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-5-7c6ac1750725@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfXyjVkiQQ+cnzn
 2zqO69xSJUe2pRcWK8jT2OuoEdgHEAWEAfNvhMz0MqmDImc2onbX0Jazeci/w9ujCAnz0nmswfe
 STs31neH08GPToPJcf9jmJ6TlE2xgXsJZ8yx1WxjpyPncUlDFshcIBcX3aVGewOWJySxoCIKJtc
 xSL2UFwl/4KhHcyaBHEbUhOtxNSU7pjKRXa4i3LuYanKbiUO0tX9dhz5yk8vKvCmmFb7WV6jMlD
 AodatjwUE56qpzSe28l+THn/oV427R1Tq0eVlDy8pVJC7zjJWJhd86G1NwPUvngWQM3nZWseelO
 CpuSj85HxRAnUNcDM2AsRTozNZMSK0NGdv/z+nFr2NU3jrsMlkiadGU+40SOYO1ES5GLKRnXHit
 V5GCCi1UAyucyRR7viXM+Ld0Yr7RHujAi012YWlVwFfFWNs+s/VAgpGJbOttE29wRvdNR5ODcME
 to9PBQwYC/pEyJbJcFQ==
X-Authority-Analysis: v=2.4 cv=P8AKQCAu c=1 sm=1 tr=0 ts=6a9e68f9 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: KNZxlznKsy-qVBvuVRKIMeSxUDO53sJx
X-Proofpoint-ORIG-GUID: KNZxlznKsy-qVBvuVRKIMeSxUDO53sJx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfX28ITdQM6R2bX
 xnHXjkMgqJfLxNhVG/WGltD9olc1oFyLDnM2QQiFNNm6SgK9CXOAtc3aDeo8DkRG7kdeMC4iMSz
 ero2pDqNXDD10LxLGkcguOYDAEtBsow=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070080

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
index 1b9360d54dfc..96dbdadba4e7 100644
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
@@ -1075,17 +1096,13 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
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
2.55.0

