Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306310;
	b=2t4EVhbOWSORGXUvL60+LoMh/LCFiucbfGStOyPNE9tKOzZG9f8Tr/mlSRDMhYfora2/
	 TkaimpLzK/t7+MISARZsIHqY/k7qG8wJ+oFSvpKUZBuNwoD6OTQTQTEafECqsjvwjcjx9
	 AtjcpovRaHtesbiTn5PFsTH143/p/TWwtxVs4EzaROfh6Ka7vRXSAPEoZ/fo1VWVb92gu
	 O5RJffiMSlZz4q2ujqYTm0WCZ1GC2wdzDbkBngm1gSpEbc6dyAJcIg4mAozEqhOO0dC2L
	 sTVkc0SZ3ZxKyc7uYPBAHXxZsu4zVObMJ3zTdic92AgDPHSMuH9xtEfZs1WwR0jJSDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306310;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=z4HP4t09toWp82DMbGDQwhhmP5dRtq68cZhmD8hgLpM=;
	b=bjgM4JMLR+omYFqiLiqmxyjqEhSODd4PWKibSeuuP2Jm3RL2WlOlzwC+JM3caCNGIePl
	 4WzHUdMoQ5tYbLS8zJat/CR8ku6HY1fL/zQR6xIOADwpQJbhyl4yB//pb27e9KguuBv1z
	 AkTwetj8de6ARXVjrALr8/H3rWDcw3QT/guGRklcdZ+Eb3hRoIGR6r1fYjFP9mhwWgRer
	 0cl56VuMcAkD1NSBn5dH0sibG29FAbPbFIRRphJYDiZcEGblTM4lLw++trvGr1GHRjTi0
	 NI0Q98NpGOILbydummB60V+BY9AwvWiuxJ6NchNIbRWP8W19DtefSBrNL0xq3q0rQUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fASTBcKu;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1068606A330
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1068606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fASTBcKu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795306308;
	bh=z4HP4t09toWp82DMbGDQwhhmP5dRtq68cZhmD8hgLpM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fASTBcKuUHvQOLMwrnNwfUH7ulMIAuLXkSEIIdEu6d0/c1640q8UORPOkZzmAonuJ
	 b5PdGkwKIpqHiOXfFiSzYfg/pIo8U8tqK2VFZsW9qUSq0RM76xV/3r8qnoopLXdYgb
	 EMs0UwrKeL45dk8vyZaKYTTb2UL1/8Z8C2AcYTDNZYeDkf+94QcxzOJSnXgxoF5SCe
	 HJmr3mK9+t/TQ7BeyxkZnzYLbOyiY0uRaxqGl5fP85qKiCwlZfrdGPxMHbjAWFsSWA
	 RQoAJoOsE2d5KYP+lE7BWNL/6SyoJ+xousC0t+ZajZHPnGIRDpy8OW0YyERP3oa+iX
	 sPHfAgydKyi4w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D72EB6005C
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 01:11:47 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v9 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Sun, 22 Nov 2026 01:11:40 +0100
Message-ID: <20261122001140.3768172-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122001140.3768172-1-pablo@netfilter.org>
References: <20261122001140.3768172-1-pablo@netfilter.org>
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
v9: no changes

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

