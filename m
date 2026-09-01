Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D2F48167C
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280368; cv=none; b=KlSF+ITttbGiF/lyrwlq0Uj6CgO9Ep3vfdUncRaX2lNFb0arkVQ8XRSlizL+AMc2GzMNUHAxPxW9UJaAyq3S8C/vZeNPj55D+83cCkm5+RwWimrWB+7XeuwOsbvJpfWUW7kPQKNmMnJmh4rg+G7An8EvYFlx8NFCvtYa3qhTDnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280368; c=relaxed/simple;
	bh=BZgGViVjbPQGYXtFEDayGxPACR4KC/doJcmK7GuYL1M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BHTxAKODdPtXyazyo93IwvyE2s/+ym7SK59FUPx0JhIObH+PVO8GURo7ekUgVi3Zn82KWCiL6m5y9Fh4NKijdOMQvX/ZLyukDjK6794P1FlGsuM/1VFHj9wE5Qej9wWi6O/OUOBvKgP+RE9udxrK9OmjUuY7DslD6yJz4dcE/Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iAKp+XfD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J2JA8nG7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iAKp+XfD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J2JA8nG7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8hpc3002674
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BuKOZcrHKSXcLVc+QoGKSs7QdAttA3Z6UguXUeCz26M=; b=iAKp+XfDGoJdfC/C
	8HZlzOEsfvpvzLCDNrOZWu3ofs20hWvUNMFieb4fr+2L6nFaGP6OnmNwF2kr9c0x
	sJB1LNzOi70zLr4JK+sEbfmeopeUdbPiF/42sY4L/u3zehDwcnko43LxrGx+CV0F
	ZtPQrghGVP5nwredo++NfWP46YzhFie4NVAu5B2rKvRB1mxcosdKkBF3fCFi14NZ
	LjOb/q/VL+xmr1TnTRW/f/icTq3AD13PsfymA1ouNKvRc2GhITrOpdnW0ei3oq6/
	tt7tikcik5+tb+jqGg/6LuS1ebaNyN90lepRxTESApcDTl8NwHaSA1cmSb0GGLOm
	hmy/Qg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdqbh3arn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:45 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9390a2c895bso30243785a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280365; x=1788885165; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BuKOZcrHKSXcLVc+QoGKSs7QdAttA3Z6UguXUeCz26M=;
        b=J2JA8nG7rKegsX6iuPtGDt1NO5e7ZcpiSlwh53NpLfyXuluqgf43+nKgkMV4o8mngR
         yQ7Ltn9Kzhcj9AY2dtusGOlN9U+K9ZBF7kCgWMygVPcOCPhwlvGMKFnsUTaxuL+C0j+B
         QpkVsM0NNHXh/X6dFAmpk2WHVOgptHKRUovhozv7hEDRVtEm0/tZUmn4Zlv6ahXgFt+Y
         1/jEhsqts+T8QCkiCf42UHIcPksmFSv/47IO5+XFswb6Raa0vKZSRUNTyD2Ao0QvRnd8
         UDEnF8OLx3m751wJXkeVdgYYb51saDiM2f9ifFNE8ejaTvPBgr8LWbSOQZbP7GZWrQsv
         XVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280365; x=1788885165;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BuKOZcrHKSXcLVc+QoGKSs7QdAttA3Z6UguXUeCz26M=;
        b=W0u81GOoV5Xgw/+PqOPgdZ2po+FWz8rFh0BW5TohhwFfiE5xUACh24ToF0MXaHtCVy
         vXSbe2Bk+S85niWewkYWQ/BkH6s8JpAcDaAbjjTaDKaYWsKHW+pvBkbtubbGXJmcelry
         tVQL1yMY0PbC8Ga/+1zckCW8+XTiPIpA+8WH6pY1R5XTDxr4keAIHFKuzUoMdk7XwaBJ
         60sh2NycVZqfTea/G7VN9Y/5VHDXBSR46u+Exh1h1Qx9l/AaP3pMI4S4Z2cdG3jEBe79
         8RR0R76vxx3DI6ahW05iPYs/Jo57o0UNfFWGo1AV6W07IC5N3Kp5zmbHuoE/c1CKNsZw
         22yg==
X-Gm-Message-State: AFuF++nt4TZFEHn5RCwcYG4Y5S2OqiUH1JP6elKlHvJ/rH6piX07LnQW
	SiKP5b5RrE834Lv/fooIPvAMj/ottkNVm7cvLTYhUp7OgdkJfbwNV22nRD2O9UTkgL0fQoH74cb
	oNSUhdWzafj3Bl5DzYisrNwqBcXq+5ZOZimWVzpuYcD1cngVII+5ItdKOPwvYBRPpp/WR6Xs=
X-Gm-Gg: AR+sD12m1zLO07hh9hStQ8Aaq2h81gnFXvgxU5EZxCbRVj4iHhVKeFZryUaKgI6nii3
	ryLe2fOZSmhxbY9awqKLgv6shn9c8Zeq2Bo2X770c0GckapPOdcbVtEJBzzLl5WI2yYNeJlUbqH
	OPJyTqrHDEgMNydJLxpoEAT78k4osSUjIodyroM0iwC++1ZB3oyvX3zQXyL0Nss9B+DLAAnZJwr
	WczbwAv5sdD7xQku9aUg0Av5JMga49+l2SXwMr4umLb+MzWCNJoPZ65wExKJZGm+5FIndoEAW3h
	ihjfXYl7wNMBmQ6RGLRvjOf+RddXs55mEu5LbN2qn4jONcelH0+J+S2fsSgKwn5xTrmWJnHsOWL
	6tqeSTXrtWmHFZA==
X-Received: by 2002:a05:620a:880f:b0:92e:bd39:9993 with SMTP id af79cd13be357-93913952c79mr4603718485a.31.1788280365107;
        Tue, 01 Sep 2026 09:32:45 -0700 (PDT)
X-Received: by 2002:a05:620a:880f:b0:92e:bd39:9993 with SMTP id af79cd13be357-93913952c79mr4603706085a.31.1788280364574;
        Tue, 01 Sep 2026 09:32:44 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce3e0desm83257115e9.11.2026.09.01.09.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:43 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 01 Sep 2026 18:32:19 +0200
Subject: [PATCH nf-next 4/6] net: netfilter: nf_flow_table: refactor MTU
 check for tunnel offload
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-4-72e49be8c31f@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfXwVynEgmNBeGx
 gNu8hRwnIAwJvWxRCzqq37E6x+vTjGw9g4uRvcXPrZj7Cl6O1viMUJFpCd4ff+SqHZbnukRSkJe
 19tk+HQL5jGNhSpxIzfVOFto5Uz9IFM=
X-Authority-Analysis: v=2.4 cv=R9wz39RX c=1 sm=1 tr=0 ts=6a96fe2e cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=CJUkwBbGfM167N4AH6QA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: Jujxt2XnhYtEjVNPM6DL7qPJ32vRlIdT
X-Proofpoint-ORIG-GUID: Jujxt2XnhYtEjVNPM6DL7qPJ32vRlIdT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX2VPIVNWg2guL
 FHAO7uKvb1hqQupTMU0ao4eywtBqzdq7zDqUxbJEbKbfei9eBLHisaei/e9H325bp5t/Ev16Ey3
 dirmPNiAybVjZ8H67TZcgb+ZCRmtYAHE0uLUbLp3vSlJj7PPQcMpKIi8MnRuBFjBFDOXvPU+ndK
 eIQFeKeNyn57FDof7TWBdn3urxQrCxpVz/shmrWsIonDJv3JQ9y3lepxz26J3grYturkduflovl
 F/9shzSvayxM01e91rhoTqyxEzXrGxzZfk/GT9iT0np2CGZQ4xdSAZS5dXK2yerRiRvzdq88IQc
 WUU41cFKdSN50J0qLs7ZdLBKqJrjm3sR1aJgLJv87JC7tNW+2ntDfis9vlMTF3OoS8u0r1aEbXz
 HGqZFtg1SM+fGk8ZMWTRiGC6R232WkKlNOVhI30cciEECqoFF6wu1aj1PE4wFC2XuWejjvxBNNN
 09PNHWPR7BEyOSlbNig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010146

Introduce nf_flow_offload_check_mtu() helper and use the encapsulated
protocol (tun.encap_proto) to compute the tunnel overhead instead of
relying on tun_num, so the correct inner header size (IPv4 vs IPv6) is
accounted for. Use it in both the IPv4 and IPv6 forward paths.
This is a preliminary patch to support IPv4 over IPv6 and SIT flowtable
tunnel offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 47 ++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3ecc47b57854..0aaf1e07f320 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -470,6 +470,37 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+static int nf_flow_offload_check_mtu(struct nf_flowtable_ctx *ctx,
+				     struct flow_offload_tuple_rhash *tuplehash,
+				     struct sk_buff *skb)
+{
+	enum flow_offload_tuple_dir dir;
+	struct flow_offload *flow;
+	unsigned int mtu;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
+	if (unlikely(nf_flow_is_tunnel_ip(ctx))) {
+		switch (ctx->ether_type) {
+		case htons(ETH_P_IP):
+			mtu -= sizeof(struct iphdr);
+			break;
+		case htons(ETH_P_IPV6):
+			mtu -= sizeof(struct ipv6hdr);
+			break;
+		default:
+			break;
+		}
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
@@ -477,17 +508,13 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
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
+	if (nf_flow_offload_check_mtu(ctx, tuplehash, skb))
 		return 0;
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
@@ -1073,17 +1100,13 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
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
+	if (nf_flow_offload_check_mtu(ctx, tuplehash, skb))
 		return 0;
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);

-- 
2.55.0

