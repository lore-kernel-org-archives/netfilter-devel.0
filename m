Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795302404;
	b=4PjjxS6i2uZKWWS4VtjW6Zj8N2K2Wv2YEqbXQLVcIEKQ3NB74PYDeB7qPUtdmQ2zO3ah
	 zg7ErSH0PV8tjHVMYXJhy+xQsKwFLmGQOBo6UnUqJfigQXXFEX68zdlRTwK7XcZPi11Nu
	 MgkM+b9S/qFALiKIKBbwi/heL/+kSCujy7FD+cCvTA9989/Lj70ePhjbiaiAu0VljhFS4
	 LAjB2zPOEWmAePyTtvNYPlf3wuC0dnWAdPSUYIEoP5BBU3z06RR6kw2bGjJxxtRWWmeBe
	 WZEiya1lcjM/pbuDDe5G98PjvqS1IvhxDEZ9TQQusiN3O1U60YvFjWyEQZd+9zPpUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795302404;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Ifz5ujdQDRbM864KEhzlk3SR6Spbp6CMzKRGYXrFizA=;
	b=mk8Zl9cZxualWiptLtTn6XRBmGm4lIKGNxOlLtcOC0BlxRI99rh/0ihGVGTbVkZ9/tsv
	 kMayJR5/spWNMI7pD6eJ//Hq+RQX1/b9Omo/lb0JHuLECnJ+08cSP2cEAhiW1QQYmebX/
	 pOzPsSmbcMEWfg6k/dwuMR2zdOwFrL6Wp8tDNZlmCbI4/85e90uflkgYCbOCMnPAQO3bJ
	 qrUssTIBMzvddr3/t9zJv5/nGZtD03n/YsYRWMmjyJOThiVfrDtFx7943LBu8Yx9LXnC9
	 MGABZeVE4TKrbK6n22tLFJkD324kRST302eGrVZX+LXtdNRJ+t3c8ZJevDBW9+pvziA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CWQBANZ5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67122606A336
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 23:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67122606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CWQBANZ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795302397;
	bh=Ifz5ujdQDRbM864KEhzlk3SR6Spbp6CMzKRGYXrFizA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CWQBANZ5ZpeYpc/XEs9nRDCOHqWogD4jz09PBjH1fFLaVdEdchiKADKvhdv7Ks6mz
	 Ql1FNb3JVpVG9mPIKUwG3X47/S0Se+rYX302E9vDVLSNU0//QQ9IZ0pR7kud0V4yZb
	 lA288enOOAhLKrH+Oc/izNRhO6SxWuJhSszmhDNSuX5LEaWgusNO2CTpcn3VO7RYXh
	 1LzgTd9zO3i1aO9PCLilO6YyCOAs2MZIFeM6gVqGDsSEu1kaej84QsJpEM2XFHYz0+
	 brdI9MEJdoAMDeBys2jfTrm605FdAH+g4N+j/6/JGa9rBsDJZkUGZ8B5jqDQaqXWsC
	 cP97y81yTnHlA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27AA760078
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:06:37 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Sun, 22 Nov 2026 00:06:29 +0100
Message-ID: <20261121230629.3744139-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121230629.3744139-1-pablo@netfilter.org>
References: <20261121230629.3744139-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit ("netfilter: flowtable: cache destination hw address for
XMIT_NEIGH type"), it is possible to possible to consolidate xmit path
further since the caching of the neighbour entry. To make it happen, do
not attach the cached dst to the skbuff, let's just transmit it via
dev_queue_xmit() without it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: - keep skb_drop_dst() in place.

 net/netfilter/nf_flow_table_ip.c | 72 ++++++++++----------------------
 1 file changed, 22 insertions(+), 50 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index da15783a36a4..1948fcd30201 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -854,33 +854,19 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache) < 0)
 		return NF_DROP;
 
-	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		if (!is_zero_ether_addr(tuplehash->tuple.out.h_dest))
-			xmit.dest = tuplehash->tuple.out.h_dest;
-
-		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
-		break;
-	case FLOW_OFFLOAD_XMIT_DIRECT:
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		xmit.source = tuplehash->tuple.out.h_source;
-		break;
-	default:
-		WARN_ON_ONCE(1);
+	xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+	if (!xmit.outdev) {
+		flow_offload_teardown(flow);
 		return NF_DROP;
 	}
+	if (!is_zero_ether_addr(tuplehash->tuple.out.h_dest))
+		xmit.dest = tuplehash->tuple.out.h_dest;
+
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
+	skb_dst_drop(skb);
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
@@ -1177,33 +1163,19 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache) < 0)
 		return NF_DROP;
 
-	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		if (!is_zero_ether_addr(tuplehash->tuple.out.h_dest))
-			xmit.dest = tuplehash->tuple.out.h_dest;
-
-		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
-		break;
-	case FLOW_OFFLOAD_XMIT_DIRECT:
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		xmit.source = tuplehash->tuple.out.h_source;
-		break;
-	default:
-		WARN_ON_ONCE(1);
+	xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+	if (!xmit.outdev) {
+		flow_offload_teardown(flow);
 		return NF_DROP;
 	}
+	if (!is_zero_ether_addr(tuplehash->tuple.out.h_dest))
+		xmit.dest = tuplehash->tuple.out.h_dest;
+
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
+	skb_dst_drop(skb);
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
-- 
2.47.3

