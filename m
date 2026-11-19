Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079266;
	b=IbtW6T0KiegBJucl7hbm07507QEny83HDxIXac/KrWxtBWx32HJXCrvqRKNd6/eWxfmC
	 dxuqqcz9WzvsD7x/PE8iIQtR8FuGOFH4sSohiQsiS5el9+JCw/pu6lpvQRlX/8BTGWWza
	 unXMe0SXNwhnwBXqTqbq75ifTnTiYXozgpLe79oIrFSpM4oC4XO36dU7asNI3mCZqS753
	 Zwm4iLNw9XKnmdc7Wbsgwasb3Ed0RddWKSJzQTDMxbWvVIOuUsofusXJs4UohoGYd3RZ6
	 s5GEEKGuohNrV9Tn2a0ixlywZuOLeipC8qew6PROYLLCi1KrokM/C30EqL1+IzNaN2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079266;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=AA9WnoNznkdE5rLkhYphgL9iLAOpFik684NXP39Zx+4=;
	b=cFl39YfgWZXdYtnD34tSyrzK6FKrMtK7h9ROtUHvthsbr7aQjxwu0ToafMRqHp86Wm8K
	 aeKSBPxaY6kalaz37bmXBzxRURj6WX+2I5i33fGFf7gy8qMMQQYvZBSbvoLtKuBeW9L8b
	 EEPlHXhBUZMHFcbC4FqNVfN1nQ8LSD6RoV09OXwYCwGl0UeuCtIZvLV6vZt1IITQHcrTN
	 DDheZ1nIt39Xib0JIUH3/rUXYzyys7VQldslL38o+aqVmKwQ8c3XZynddH/crO5sQftdh
	 t2LOsHBS8UFzNYnj0B/XlVYX3W18RrGOuc9h04rp5QTCbac9/UNWaxZwVupzNzZBeyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=djM7m+uI;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA7606A32A
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 09:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFDA7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=djM7m+uI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795079264;
	bh=AA9WnoNznkdE5rLkhYphgL9iLAOpFik684NXP39Zx+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=djM7m+uIfZ0le+mbQ7DWRWbCXkXpuoun27E0C+Lnhqv/Pq+okiFryAWpmd/BWuNyt
	 b6lwQk2R4YgkDWKoiqaOPk7SGqBE++SdppdWWgkmkzXEembpVVrZiJqXI8zEOkM3Mr
	 mov6Mdt+D8UCSDmDNRELlSIeCiqWhJCDpD/1mo/ufx5HXc6yZAfafP6assAk9UO1eG
	 OcsxnLmwWP73OlLEgGZcdcPdr8qQOVvWWVYF+Yepu58oXZLiEEXzwrJytudpN1Zoau
	 cFF4qy4nv6t/+q+XGBse3NHD7Bd4EzoOHfAS6RPW5GtnVF4UnEF/93Afn84BCxyQWe
	 c1a9T2h23VfqA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 108C06005F
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 10:07:44 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Thu, 19 Nov 2026 10:07:36 +0100
Message-ID: <20261119090736.3342541-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119090736.3342541-1-pablo@netfilter.org>
References: <20261119090736.3342541-1-pablo@netfilter.org>
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
v4: no changes

 net/netfilter/nf_flow_table_ip.c | 60 ++++++++------------------------
 1 file changed, 14 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5971d2584c5c..83c24d7a3925 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -854,31 +854,15 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
-		xmit.dest = tuplehash->tuple.out.h_dest;
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
+	xmit.dest = tuplehash->tuple.out.h_dest;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
@@ -1175,31 +1159,15 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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
-		xmit.dest = tuplehash->tuple.out.h_dest;
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
+	xmit.dest = tuplehash->tuple.out.h_dest;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
-- 
2.47.3

