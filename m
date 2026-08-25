Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F16231C91
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 23:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787701832; cv=none; b=qOGoMT+lYT/YMdBwGUzhG0TCnI+18N/ZM4kYEqGgISGYGUJQpBLm7ilvFXc7naqmil3ekn0oNEOHoRAjlZY2QKGokzljT5HldeZMMsuZvmQia38a1rbdDL4KW9pTekWZgqsud9Cv1v8SyQAA82V5ietQTmeBS05sdFa/rH/xWqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787701832; c=relaxed/simple;
	bh=WZ6xXXPbrxhjLL+mEc0hT6oCBMPlrA1ddOIod51vmgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LIGMBwH/irv7UOMPe95bCzC7ryB10/uLyV4cxOLuRtbuyJl1LVHHN4uFTm2NoGFFhzah0azoFN8nyyxV1k4R6aiEVoIUe5mcAyVrQkM0ShdVvZa8ug0SAdYYs8YfMHtucz0ueCLK/1n1J663eAUkBH2kSw4xnCZWUKsDghdlDhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b9EPwtSY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b9EPwtSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787701827;
	bh=kXzp55v9RjY9kYDdWQ4kWCZQ0MCBrrQGG8DLIxl6Je8=;
	h=From:To:Cc:Subject:Date:From;
	b=b9EPwtSYu4AHacBtkP8cozdw7pj/KtokkTwsrZNcTHvYXv0dP2SGJnXH5bKFOlwtb
	 54WgDf3WDDhHIxmmfJBJEP1UYKfAoO1BqCaHgZ8jTCGZEBAlYHqmtf5wMCE+iMLAqu
	 xXr7wcg9xK4owHFBdpaHgS1WC1rDaA/rqZ7YG9Zu3/osL3xhDCritMfkoxedJXEA4s
	 ylgN9aPc8F46reMcRUjk0axz7lDRkCIkFRcnOX6Ghm7GJHJbhAU8zQO5W8pOrIknlh
	 sNF3CeXhEHcqWBXNgt/NmHCDC8vftPjlzct8wBUMSELQ+UtYlfbXm38uNxM4/hff/v
	 9wpny0zjb8Dag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3784860085;
	Wed, 26 Aug 2026 01:50:27 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: flowtable: defer ct stats sync via worker
Date: Wed, 26 Aug 2026 01:50:23 +0200
Message-ID: <20260825235023.140011-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the existing gc worker to sync flow stats with ct stats. It is not
safe to access flow->ct from datapath since the GC worker drops the ct
refcount on teardown while datapath could still be accessing the ct
object to update the stats, due to ct typesafe rcu semantics.

Fixes: 53c2b2899af7 ("netfilter: flowtable: add counter support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
There is also flow_offload_fixup_ct(), which is also accessing flow->ct
to adjust state and timeout to hand over the ct back to classic path.

 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_core.c    | 21 ++++++++++++++++++++-
 net/netfilter/nf_flow_table_ip.c      |  6 ++++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..6060202133c7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -171,6 +171,9 @@ struct flow_offload_tuple {
 			u32		iifidx;
 		} tc;
 	};
+
+	atomic64_t			packets;
+	atomic64_t			bytes;
 };
 
 struct flow_offload_tuple_rhash {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..a1f37ca956b8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -565,11 +566,29 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+static void __nf_flow_sync_ct_stats(struct flow_offload *flow, int dir)
+{
+	u64 pkts, bytes;
+
+	pkts = atomic64_xchg(&flow->tuplehash[dir].tuple.packets, 0);
+	bytes = atomic64_xchg(&flow->tuplehash[dir].tuple.bytes, 0);
+	nf_ct_acct_add(flow->ct, dir, pkts, bytes);
+}
+
+static void nf_flow_sync_ct_stats(struct flow_offload *flow)
+{
+	__nf_flow_sync_ct_stats(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	__nf_flow_sync_ct_stats(flow, FLOW_OFFLOAD_DIR_REPLY);
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	nf_flow_sync_ct_stats(flow);
 
+	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..66be815ac2fe 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -509,8 +509,10 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	ip_decrease_ttl(iph);
 	skb_clear_tstamp(skb);
 
-	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
-		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER) {
+		atomic64_add(1, &tuplehash->tuple.packets);
+		atomic64_add(skb->len, &tuplehash->tuple.bytes);
+	}
 
 	return 1;
 }
-- 
2.47.3

