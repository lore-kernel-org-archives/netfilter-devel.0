Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280942;
	b=uALB6hlpPJtz34lWRwlV8H+4HBkJuOqHdMOz0bjUHwCWd9f7gAcvVjV2P0CgIGOI99Wb
	 fe0vWLVRLOve3WdX8b5fco/aOwQVzTE1sXIDw0qW+Ye3EjheSYL5eaMnSDs/adECHQClA
	 v+i44itnCrEau4LotlqegtMjN4O/PBN3PRCzamnAz+S9S7VB9g03sSd+Y/ROAvAVwNke+
	 PRgIO+75SNOT/euwf1TtXmNw18joOhem/T18g5/Foy2oFvzubLfsYdRVbjuFTk3yX3q+6
	 3HzCvSquAaXgP4rvkOWq8LhBmm/+3ot8whhO0vHEKPpdk4J/stTyoedsnehhTqOasyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280942;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
	b=z9uX1m/FJ4jXTkQlaArzh69an9L0KXlYKzU5SxtAtKsOXe5yxMu16RjCWC93ZYuZrhta
	 c8TkzakEGWY3LAw4LUaqh8F0eNDpRTCqgD9b9EIUGhCK1423IUAjYu14Ryqssc3aXtyny
	 r76qMaNhnrjsJ7xc3G84243DkW0Ol8BtxBKipLskVqdBvZBgmHqD0c+HXyqXAC2yepctR
	 jE6yq0lQUXwRN0i0FwJv4OXGQ/HiEa7A6wugf0bl5r8UAHzBuBz0egwb5/2/eHZFANqFs
	 WfV/ygMA6LT8BbnkIhzs1EZ0g2zHXumbKFZ8a0iNX1P2kJyg2aM37m0ODMf4OIGIATg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="N8CxV/LC";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ku1umrGj;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADE3606A329
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EADE3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=N8CxV/LC;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ku1umrGj
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeP2T669603
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=; b=N8CxV/LC7UmMRXYk
	OUejEdvshGFScV/qh/FLsW+MQFM6y10ZuDNUjSDopbIVRCNbAfFWM0i+gEmWUejX
	2g8zcVIojxVsDt0Hwmx3Bvg1T3dgWzq+30/R3kz6Xgv1Rr3+oUuiHYmmXzz0tXt3
	6pKvBcIKSeKyFgq7gKKLGjOl4IxWo128zC75n7D4phYBv66OTRO3rIuhwbDwceyH
	TsKd4H0BS794VSuH0VPzx/ajgpLQkRpD/vZH/JseY9SBv34Q5dvz6w6BbGUHprmZ
	DvnYQlkyFgF+Io3DJIM4bwSRMFpFcfeMKUiSczmlmKtcXVkha4qBf0tr6zARz547
	DHR1PQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkpmc3rd3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:40 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91b8c60c550so65556266d6.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280940; x=1793885740; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=ku1umrGj9fT11qf4/4KMYlMxOuG5MmddyEt0ZpE6WAXc6PSRvCDoOE7wDNg8oE3YGh
         Ts8sgaCQESAESVCPF2d0L2apJGhBzGqJyt0IGjgh/nozMNHwzgjGeS3t3iFVM354uTfN
         tzDCzodJFOaZBaZMijyCmC3qNkil76od8dC5FMCoDaXNxF93q4e6CpbncSWLaAlGCNma
         jjUBb8FLxHiMeZuvopcMxsZ/eSXLAKeVk8QS/fxHYAUAgxYcK6aoobyXnELXl9Gpgkn7
         NfQ2Ix1pqlsNNSAhMay0znaJ0ExJ3SUrYyDZ+ut1c7QF5GjjPSeVpNmvTQ/uXL9Zs4Xo
         woow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280940; x=1793885740;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=oMfF3ykrbbZuE/PNzoQVhueYqlrslsGOSMHwzt5n9a/gjLV6qQvuixdAfKZ6UMPdPI
         ZMei+3J2MIAJmKwPB9xc/K/V8yiDTVbLK5yOrgbHGe5XuR2oZPgjbTF0zWpshQrYceYb
         9xhHb3IVw2kXF2i4TMAJ9aQpsZfbUeOOUgiQyyZUpHsQgXqAD7kbnmdJ0i9Xr4Dn5sVL
         SNCZusOSSTWO6UYKUrpSIYcMrKid9HGgsSWo8zReCPvnyVEnGmnoSwSYEFpHSfBuRYhy
         IPx290a2y+wJoMY3QNrvzUQK34ILmKWhr3766Z28wdTU4VXzTqgPQs5+lZ+mHaUjHkZu
         yVhw==
X-Gm-Message-State: AFq9FYJDPKJEOiyEXX6rC0ZB3GrMVF130toqhj64A5YAEafZYSlIJaJM
	uhhqyEeI+zWA1k+3CX0Th80ZhMhTnBg/qBzk/8GSmp8QP0iHzWt2SSkYd5wLrWI2Qde7d++cChB
	2Vxs3/V5pnyugKyqza4pps9WQH6ur26dDQwE4N4D2tU1+ShnETEBpW+/F70EzAfFcraIbizI=
X-Gm-Gg: AYBFou3s9ztW+VMSgYkyJjUq++d1+PY6jy9UevKlX4R5DwH+vgSaXAdc3r7+5KKd7Ih
	qQTWzLu2C1N0uhzO+dTWjkzfqmJnka66Zu9rWyIb3VZZOK1tWOgxfalVCmKMl2jJ0YsQtAcnDE9
	zsujKIuDOQ4byp9uHDDLtzW42zSD76tM5OwEmA6n+TFvKUsjQAMSL+oDlveDiyNM5JZvqhqN10G
	Pib1xTsTSSrnA25+zHjgHBjR8/EEqZ7PZszavSJxhJM1oUsp1O/A/4MWZpEhc62xgBb2PF1HtAR
	Mc3sx+BrGsaI2Bx9Wfga53NF1fnJpI5X5wHMN0Qasgqg17s0Tszw3wCrXyNJFMJWeoMjVB+Vhem
	/ZfUysOFkeujbTUL2Zvnx1NreuxMFJu6thNdjyVUsH3ZV10ugAycHGIpGwReeHRAK/uzicRpP3k
	eJbdcAXi72dIaG9/cmyfd7dw==
X-Received: by 2002:a05:620a:1729:b0:93c:2726:77ec with SMTP id af79cd13be357-94408930698mr808310485a.5.1793280939701;
        Thu, 29 Oct 2026 06:35:39 -0700 (PDT)
X-Received: by 2002:a05:620a:1729:b0:93c:2726:77ec with SMTP id af79cd13be357-94408930698mr808304385a.5.1793280939062;
        Thu, 29 Oct 2026 06:35:39 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a969e61f9bsm84350285e9.2.2026.10.29.06.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:13 +0100
Subject: [PATCH nf-next 2/8] net: netfilter: nf_flow_table: refactor MTU
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-2-6a17c54f9fb7@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=X4nHu2Te c=1 sm=1 tr=0 ts=6ae34bac cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-GUID: 0bpgkPFMN1eC8vYvVdt8h-KVkA1F29RI
X-Proofpoint-ORIG-GUID: 0bpgkPFMN1eC8vYvVdt8h-KVkA1F29RI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX+CNKP/ZD6whX
 ICMIsDA+GHAUntcqX9y9APgQuiHUC4O76nu+6tYXEvMx3QFSF7z8WGm95CmLAT8vLfgWEEtEjcm
 L3WF42qGMmXmEq7mp0383dbnIWFWvELyA56a4G4Wxww9JXBRYYmqNzSTwgTMKYrxXGovql17xfW
 R6z09sdb5hHodA3wd7zpdKzrUGcBN3Hcitpzf9ig5wkswrtlZsTHLsqVlReNwU905NYIoNz8fkP
 XUEGTZ6XJePcvb50dw2vAcNWAbXp7Obp+eHDx9diU+UWhWt0A6diyN5GGsm3DTllFuZ9vSa6lvW
 EVwFYjV4P76FIKvwZQv3isO6dWlLnIJLn6xryAVREVxQUhN1HKH6ZLcpDxVszXDa1UujwvesSSq
 wsn87Ay+tHdtUJVFZ7+MusVfZAgxkO7g5XGzSBnKR+ZryQ+rNJDIIEn3zZAZu3jo3NqW1LKPSQZ
 XcyU41X5mAQGkUJrAEw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX2xcYw0J8yMNc
 AUsVW3zMoVSkLjMIlfz/u6/sf7MPYaXQVZOVdpi/tVI77KTiehpSBJz8tCUtl0IwFdSFuP8ZE7p
 Z4t0oOvcbKbqW2QB8LcjcaV/NlihxD8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

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

