Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793315224;
	b=Gf9DGOEmB7o4PuWcoYHSnCjnDAf8Nc5gu1BEzPh7rxjbR/axk/F5vX/Rhq2IA5YVxQHQ
	 B/yADXLgRoD2BWg8nFd0g4wYKZ2P7SAM8tdNSBB4Kgh6y7qCUKu78jV1Ojft9W/yJROEN
	 ASN1tmkv/Gdx3jQjKn3ipadMRKeV1JZXCZ3JzwWi7N/355nOfKP2ckLtdtzaXz9ofnerW
	 0ADyrWFgIqg65+e+Iv4wr6AwTqkAAirmgr3z6ckXaNNGfjaInCs5Jdksdc3YSxNZIuILp
	 69UNzwjMxfBsSzlCSmlJ1dIJU4lP0Xq3yytizI0TCixsG78cDSfad8NDY1+K6RFQQQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793315224;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=jouYVAIHfLjvnup8PLlQLtruSdsjeiTCBESkmSsM4WM=;
	b=Z4b4AVU8KBzPAwuzA7H+94VjfdlsNeDJ1MSqn2v/PUJLdib6gd4ZfLgfAX5Zbz/bXhRz
	 9GYM5EMJlJNDlN6at8MIXDpq3T6Ap/EE+K+u5LEBZdipmcUquV3J5Lyde7Ya+ewhhgKms
	 mzRwkO3gPUz6sweafl3UiBb0VP5P+Ed4MPynvVZLqjYx6x5iI1ZdTP+yg7Q5xWs7SB/Dq
	 hBW0tE+9kA9IQiQYMce3g4Nq90EyoxoSbYoYjE8krlST+1uEANRdIhifDrl9wnTHUyK4g
	 b40rVX+9Kc+DazMnGVWqPZIu/aeQuozpXVTJOsB7kOsxMETqnJ3h/4FDkkf4D7ce+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dPLBcnFU;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACB0606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 23:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ACB0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dPLBcnFU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793315221;
	bh=jouYVAIHfLjvnup8PLlQLtruSdsjeiTCBESkmSsM4WM=;
	h=From:To:Subject:Date:From;
	b=dPLBcnFU5jX6cEijYBXD5z2kqw4YZmF7eoBih4n2wvAulgagrNGvOo4BU0xORaNJn
	 RnPtAxISfhSPw8kXqC3oFVkGOLqkA3PHvdNu9vdD5eAE8jpi8JD5/C8MRJ9nodzwLx
	 6RKzEh84wgyxHbHbw12m+HFr8q6G5dButJUoQ9tT/xf9aoOd7P7wN3pW8BASy+Hyhe
	 DYxlaBURtOT3KEpUo2kfp90FUbHvg9oTbKLQJiG9KR7fugVheMU5M0t0mt2eBWuLUN
	 mPRctHq3CX5TKvOTL0z2r058QKpwCUPmqDi5/ZOHJ8QLUVFpXlhGUkHmnBVbYnNT5V
	 rqrJ225xzow8g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0DFDF60056
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 00:07:01 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Fri, 30 Oct 2026 00:06:57 +0100
Message-ID: <20261029230657.302417-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Do not use hardware offload workqueue to purge the remaining flow
entries when the flowtable is being destroyed. Instead, iterate over the
flowtable to purge the remaining flow offload entries. Work memory
allocations can fail, leaving us with either waiting indefinitely until
work can be allocated or leaving entries in the hardware.

Given it is possible to encounter either the original or reply direction
when walking down the rhashtable in the destroy path, use the
NF_FLOW_PENDING bit to indicate that the first tuplehash has been
already visited, so this flow can be safely released.

Fixes: c921ffe85333 ("netfilter: flowtable: Fix flushing of offloaded flows on free")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: use NF_FLOW_PENDING bit to release the flow after the first tuplehash
    either original or reply has been seen.

 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 29 +++++++++++++++++++++++----
 net/netfilter/nf_flow_table_offload.c | 23 +++++++++++++--------
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b22d31cb140..9bb46457c192 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -375,7 +375,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
-void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_purge(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow);
 
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a..2bbf12773af3 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -769,6 +769,29 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static void nf_flow_table_do_purge(void *ptr, void *arg)
+{
+	struct flow_offload_tuple_rhash *tuplehash = ptr;
+	struct nf_flowtable *flow_table = arg;
+	struct flow_offload *flow;
+	int dir;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	/* Let the second tuplehash that is seen release the flow. */
+	if (!test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
+	flow_offload_teardown(flow);
+
+	if (nf_flowtable_hw_offload(flow_table) &&
+	    !test_bit(NF_FLOW_HW_DEAD, &flow->flags))
+		nf_flow_table_offload_purge(flow_table, flow);
+
+	flow_offload_free(flow);
+}
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -778,10 +801,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_offload_flush(flow_table);
 	/* ... no more pending work after this stage ... */
-	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_gc_run(flow_table);
-	nf_flow_table_offload_flush_cleanup(flow_table);
-	rhashtable_destroy(&flow_table->rhashtable);
+	rhashtable_free_and_destroy(&flow_table->rhashtable,
+				    nf_flow_table_do_purge, flow_table);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index da2013ceeee2..6d90745c88eb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1175,14 +1175,6 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
-void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
-{
-	if (nf_flowtable_hw_offload(flowtable)) {
-		flush_workqueue(nf_flow_offload_del_wq);
-		nf_flow_table_gc_run(flowtable);
-	}
-}
-
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable)) {
@@ -1192,6 +1184,21 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 	}
 }
 
+void nf_flow_table_offload_purge(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow)
+{
+	struct flow_offload_work offload = {
+		.cmd		= FLOW_CLS_DESTROY,
+		.flowtable	= flowtable,
+		.flow		= flow,
+	};
+
+	if (nf_flow_offload_unsupported(flow))
+		return;
+
+	flow_offload_work_del(&offload);
+}
+
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 				     struct flow_block_offload *bo,
 				     enum flow_block_command cmd)
-- 
2.47.3

