Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042202;
	b=cVcyjGnAnQY9ZIXhV4VBSRyK7AJuFDBMMbrUH+uauS6S6afw+Iw/38LPid9ystZL8XHG
	 0+k1hs2YAy98Feggvhj9F72HDV6cPqCcp1YZMmg+Ys0hRlL7izK/VXGBW7OQmEiNnYsvD
	 wviIV2aHJQxWcSZLTSbUWPpd28j1sVQEGlz2laQDiYkVZ/Yhtf5rBPIwZM7D/Xyt1dD9L
	 OlMcYSNAdqKVZ8DjCDYeT/7QG4AFA594UAPoqhTQC0drpGv8R84TpT9zbhg0WGuqJcvkD
	 5m/CNz/l2ma0zLu1aylwccgXJ8y70MGpU5n/iASkYQOd9QXvZbBp81QpwEw1MvtnAOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042202;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=LfzSi9ejNrFLdimHCLjd+h+WewrxMPlinPDegcRJLDY=;
	b=LW6yZCBjA+j2nLwSjEikNYdNJLHVkEt4taRdS2CRxhYIZ2FmZMIY8BkjoLiHb4PRNBLV
	 4kGU/eQ4+/7BQztwxAPMAdzH78HtleGnyV1hUntrJ6KKFQO6k98cnLnFwtoJUH573qWm/
	 LSiUBhcmWh6zZSxme61Ov2Cw8+c7tbKhGORpHzUyUCeYZwyhHhK+yVu5bCX0PKpfwzxPb
	 X/3RNwymJLRfbGUPxrG/XlT6azbhJkbzYdAkQkwf+uNB675svPLNZ7WuIQhEn8xi4SqUD
	 lbpOa7mTYTJcR5TYwQktnzh+YO9M+j58gPAjPod2iwTfj90JWgrCBzpPr6KDoddT4zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LzETX7YU;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC1606A333
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 22:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FDC1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LzETX7YU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795042199;
	bh=LfzSi9ejNrFLdimHCLjd+h+WewrxMPlinPDegcRJLDY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LzETX7YUT3jYADEAzUFIAOjj17/o3NhZ0zOu6/V0Q9w71eoHllyv1Yv3l0C23SjaJ
	 ZIdsidu8NrlguVIvlsJ+s34wl0RV82hXh6y9i8iF1QE46hDdFT2XexYKJ1QogDU/ls
	 ACzVbDVQlYRtwQFb9WMBnjzRFLEqr9k4VnnM9OJT9FJbXugx9C36JzG+xKG6teUIFN
	 zxMKfogcqwlZAdSsU9yRlcs4FA9VJqzqMFxNVWhpvQi4//J6Ku+GvxHL4yYqJBxFUW
	 sVbB+6tWa8cWs+Iv4H7PUXwmz5IHKkevWc8EbSLKBN6zJpT0b0ZgtBCCU1wT52FIdF
	 nvpbqRzB+rNsw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C55A6008C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 23:49:59 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Wed, 18 Nov 2026 23:49:53 +0100
Message-ID: <20261118224953.3279190-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118224953.3279190-1-pablo@netfilter.org>
References: <20261118224953.3279190-1-pablo@netfilter.org>
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
 net/netfilter/nf_flow_table_ip.c | 56 ++++++--------------------------
 1 file changed, 10 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 354188d9dbf3..1db83a938eaf 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -863,31 +863,13 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache, &ip_addr) < 0)
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
+	xmit.source = tuplehash->tuple.out.h_source;
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
@@ -1186,31 +1168,13 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache, &ip_addr) < 0)
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
+	xmit.source = tuplehash->tuple.out.h_source;
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
-- 
2.47.3

