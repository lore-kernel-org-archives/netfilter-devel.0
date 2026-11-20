Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795215165;
	b=kUcDj7Xd9iKIouZCDsPhM9AK3qXn/kxjtWdbF9Vc20oHxxERTNoHNgiboX4WYA5SQ+Tx
	 wk924dq7wkRzbxA0tIuEhdROoTqTGVBG767UxC3kISp7PXGYJlOj0WgEmoWd+UKMhCSQ0
	 ulpaBqlL2OM+rV30htXNjkbGyrYo1E74JMR5aqjLqapXwm4Mg4ZDT74CBfQ0Fd9jKTD6d
	 O8yVf2Kk+IdO6sjZF6uR+Zpz8GVtuvM+LEVhKlphDwPsXoqH8ZItBqYmNSyXjnK3t67C1
	 CfVz8P56BfjJb235IqRo9u+3F60egfBpW4mL/JfwwbkCwCAw9uXu80Kn0YLrFO98Slw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795215165;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=qGBnM208F/lKHTZ+/RQlPWsV0qTw/LzcO8PmLxiftDw=;
	b=m6FNzgLTH+VVJWUF4UyboNvNw55Q1F9gHfMz6EGPTSvuMsQifXW4I1f+CA/bPs08ealW
	 fIoaB/cbS+jCFiwSfclCvoPRnSS2ZJjUAhUJiOtDItNtazVSvzlCZ7yaRqIC9/Sv4mg6V
	 fnNKXWnnV3XkXuZwB5IbR/EVsVLyNtR6XZeQHuAOV1RbATlBhVmDqN5S5B/gnPY7I/OQx
	 3Y9loBrXbw2OaMO0I7K8mqVZGHqf4dgBPo+g20M5iR1WtIorc6efV795A7LDHaek932pc
	 4SQNEGD/DgJGKvn9alTLW2jyDJ8Mlef7zlUzTY1V1lD0LNKWckQx08a47cO+26WDA1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iRuHPVfP;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28E5606A6B0
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 22:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B28E5606A6B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iRuHPVfP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795215153;
	bh=qGBnM208F/lKHTZ+/RQlPWsV0qTw/LzcO8PmLxiftDw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iRuHPVfPt/g7wx7H9zUD73PirIJ1JZziKaCS13Xjn7dotvnsBs6dICqnso0+QDtqR
	 ei/tRgprT+t50sfFYhWdeUXymGJ6WS0DMTjjz5uxLci2LjHM7dDNhmlcCJrinIgMMx
	 EA3ZwCPS0HBO0dQRCmpvflamFIiGsn8I2AjPF8TseI0O6UjBXs2oCdjVw7IKkLC6yo
	 mhefdH8XP4BOKoE9RdKupmkDVuRyXhxNYXje/MrClfXazFMSRZnut5H+4fW9LN+Rxh
	 cMw3/LWwTCU9IB+/771uG3cmj7EYeUjfsLdwq2FleXi7CpXVC8HBEWp3gYH1Aen2/L
	 y5up3cP05jjSQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C5C356007D
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 23:52:33 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Fri, 20 Nov 2026 23:52:27 +0100
Message-ID: <20261120225227.3565643-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120225227.3565643-1-pablo@netfilter.org>
References: <20261120225227.3565643-1-pablo@netfilter.org>
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
v3: no changes

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

