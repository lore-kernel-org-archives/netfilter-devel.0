Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559743;
	b=A1xjOrtWRZruxru6kacuYjyKb9h4j/RL8F/Futd3EPbJVCEJFenEksqMVITn3tIkcUaK
	 YVlagqy0eLuywTsdStSSatgPNBuIhaNidMSvRHSnjo0N1Ef+SfsA77w1n6Oq15Ln4sspX
	 4fzD7CSril1PkX8oIUHXXIJIpdg+wyLnwpKRETw3b1vXDcby4sH8LpCUOIRrtapYeeiod
	 54FZ2MZ8YhGWPB4+uyihbzNxig/mI4I9ufDdj6AWCkJ3E9R5BiwTDQhmjUOHp16MZ/kkb
	 fROcIH1algUteuzNABVb4sx0h/HfBIBQmVXv5QoYa8OWxJmkBybAlkr39Vs9EuSSXsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559743;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
	b=uXLZjYuqeO4WbWfcgUlVmOYMsJlf8Ap8aW3gIwwexUsolgd42ey8ihzKegYMdra6mMXz
	 HYoCt3BawCO42S/oRV6Vfm8BgUNVuXoc9D4bfXiYv90EdmB+8VNAE50vlsIB/XXs1pDBS
	 A8Ask2o4y3hLCSGKzEqNmqxJ91K+ur7sTSifRqAXyx1cvWOAGQ/KTdeUNAYkCusJBBwhA
	 GAR5MnpCcNSNhTtfHZoGQVm+NmKETKfeIkpQEu1mphJcyT/FU1gsfI005D/xZd7vKaEZR
	 rE3QPtvsVQtL1J9zhGO/ydCRQfzzc6DIluRvQy1+TsupnDus3aygabzkwkVwlJTL46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="A5/BXzV0";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ejosh6dk;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34897606A326
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34897606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=A5/BXzV0;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ejosh6dk
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HPrDn2419811
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=; b=A5/BXzV0mGaroje9
	CnHteb7bEaQL2yBH9r8wbmoMgoZYzdJrgh5e6XZaJ12tykRgTol3IcCjFwh71H61
	I8ZPFhRCqerNfgM4i+DASl/tOkCY4dCZO/BvpgeJtLemJLfKMmld+NC2rILvtd4x
	c/uzCB6051ObBKiMbRMwyturhO2J+CTiTpyUhgPpMiKLnOA9Is25Ay5H/aK3Im5x
	/W3MJASTsxw61+mEx68Kp9WLo0iWDjIkVFSzfBCM6w/1V6IYz2QLuvvf6yanztOA
	Fr6DWGEClL0sRQ0tC3lWyJH7mqb3H0Mi53oWthW9lIIzzUQKQzYilWTImHuEByhh
	bLGc7A==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn61fvahr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:22 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f322ef7d3so441257585a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559741; x=1794164541; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=Ejosh6dkzD1KmRgRwcFx9GduiNwBXi5JkWt+dK+1gdQbFGjU2NV6Ep4se9+1jFkqqb
         W2MGd4e/X9zZKyX2QLHaVP98MiQPhTNwO2sDNUUnNht2ohfABK4pzDVVPh9+8n+BLbu2
         JAZj8Yg088R+eGJDHuzfJaQBO91X47OtMaeAYXvmglASzLxiS1U3aCz+sSl6oCjpdNUu
         rIl3lsl2JL+EUTEBoBci1DKIeTkjRXqQpEm/nkuXDXWfGP4jOzy+Q8lWRqFUT+dw33cO
         Oc6NWplhbdww1SktD3GENZqKZHFUwJWI1+PSBnSHfjLE/YB3fXFarXMGMM2NAsh/ev0w
         AaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559741; x=1794164541;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G0+MB/jUqRMYUuh/ZFNJ9BJObePXpvta6v/irZNtSoo=;
        b=zrsS+8BqccQxXC4pHn+Tc5oy7RiLOZZKn2D+g4TmqvaX6OUhd0zTvITmg/bf2iXxlO
         89MESzVS3Bk2i1H0zoqJ7hclSjR2WBNd+JYNpXYlHbT5+9P8ySQTXkzcuuRLkU7lGmNg
         G5w/nLdb9yijedsmXFccCoMA19M7y5YKcFTqEWnypdiilxJ7UfdsNHiQB4ZFIk4VWpxl
         mGWMKey8brR0GtxT2QvlPcPH8ZxUIZfopaIyTxkxW08qjmkuDNGnqdulZV7kKTgA1O20
         fPmr36485rfTdx1hqwpiNana9uXWSTRTJZM7g6j/1ww+mYS89MwiV8354O8oOb4lSjJ2
         /7yg==
X-Gm-Message-State: AFq9FYIQxmj/R1K+zq9zB9JeeX4TDJGAzBIYlay4mzNcDvJFNye3hp6G
	5EhWA/5Rha/ZFp4VQB/MPAlr5tUNKbwpXEQeZYb+suhSZCbq5CsL1Y35Hh5xvQqrrtQPyWJc0EV
	UhKElbRlYKVyeHskwG13N9oVtEva5FwT6wZwkUJV57umsqEgCydV1rGgGYq85eJypi81UrkU=
X-Gm-Gg: AYBFou1nvTg3UYugqEYPIHbA9xKiLN37GG34Tv8l+pr2XEQ52JiP2USZS0twRAuBMBy
	eMaFIlSi4t68di7FwaTosXfzTtP/1RFkNS79CLD8hR0unYJXrQ/krR68dqXh7HioEcD9YPWsiu7
	35xVfa58PnipZKef1EElGoqwXwAVJOfo3PNA98GzDw+Dzp59U0YeO3bO92/F34C0ELTMeXIKHT5
	Ma+q51MERQN173CKFCymm73LtxKDMLKkqR6PpiCCRhFikpNCwEeBEU7oCLZHf0p5+VqrR9J34JO
	Vpkw3aja5/AdwRAt3a/ORc8dxR2KqRm/VEY4YhR/xRZW+6LVLn/CJ3NSCrYfrf5/Ljrva/JtHG4
	TYE1nIXDaIEfjiunKcnp/hgn8ua8hToPQNjfMjFWkTCKNZjTBDnEQqErMVrunAo0=
X-Received: by 2002:a05:620a:468e:b0:942:e4f7:6104 with SMTP id af79cd13be357-944217a23cdmr1327687885a.55.1793559741199;
        Sun, 01 Nov 2026 11:02:21 -0800 (PST)
X-Received: by 2002:a05:620a:468e:b0:942:e4f7:6104 with SMTP id af79cd13be357-944217a23cdmr1327683585a.55.1793559740689;
        Sun, 01 Nov 2026 11:02:20 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab61d8b9f4sm259126635e9.12.2026.11.01.11.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:19 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:01:56 +0100
Subject: [PATCH nf-next v2 2/8] net: netfilter: nf_flow_table: refactor MTU
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-2-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXysbKw/KouNk4
 sgFOiu+cUyY5AqA7otdUPEmXEzpkS+uZp/gL65tE8KlRHXSDeD8gHf5x3eVbWJzIiv3b9ysKymP
 McPXwJwxCvlEIxfQVtQSRinsVQXbF/Q=
X-Authority-Analysis: v=2.4 cv=V/LoQuni c=1 sm=1 tr=0 ts=6ae78cbe cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: KOYquC7pEYnRXu8YKic8JXAQgx2P9u_6
X-Proofpoint-ORIG-GUID: KOYquC7pEYnRXu8YKic8JXAQgx2P9u_6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXzYxb3yr+qs0T
 gpQ/6IWvwFtHBjcnhdbLyDKZ7R/PE8yxPvWak0e0wOmY7NN3n3BNnsVgz0tzRSxdOcQ1ZhLBavC
 CWQi/iK8LRYTocJiJA4tEWt/yJ65FirNFuJZe6qb/Ju1nP225XIjB6FuKiAd8ZwVlKCtgwdENWi
 rbctImhXm9JG7n5WiqsfJ//Py30b0qTvbQKNz8OVgYCIjX2uYk2L/BsuE/JrqRd7my0Dp+f7RdL
 bc9mNvmzpjPliAnHzK+y4qGVYahvKMFLTcDABbcMpg1rrTPuVTSsR/+B9ZZ+VP8NKr9iLzrMHwJ
 Lf+jUdVcft2nr44LWhwh6WFx+0Yznko+yt35QI4oIXB+p4SX0dmmDpN5Vb2kzvq3fGqZrEgUaNs
 8UZD9g3aasCx1sNSCMRLgFnYyT/T5rPC5AbhvoprN5M+8vkOwznb690WqvlNIOZR4Jfom1msJru
 Q2wa2YNpmCBbgaYLNXw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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

