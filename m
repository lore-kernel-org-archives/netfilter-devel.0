Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793315221;
	b=OAhLewPbojcTGcKcX998/I0VW36qIPio7znNqRlaNt8cL4swaj+qbhGMonmk10ii/LJO
	 vIisvrKBJuDmHcvJSBYCRDR0u4Eo/8xAYEBhA8Ps5QOwABUzjkFaLf4inASurtx1gojFn
	 9vXEdhxPflo4Vzo58zDnQp2qOvyJ8qvmrG3Q8fiDA2cnbdHpboBtFK5HNPdVnp/1vWuFl
	 PV2Lw+ClUfb5Wa9i0CzEr5/gbQjaNc1lhsiUA9x3JE32YVRIZDd9UTWR5UZvxE2L1yAoD
	 UlqxJxrUeUiWm8djl7EpTBQOmw93R85oSYcZKkXT+KiYcflnv+1pfPfP8mGtykPKoTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793315221;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=jouYVAIHfLjvnup8PLlQLtruSdsjeiTCBESkmSsM4WM=;
	b=oKYnOO9VryRdxh5Oj/NMjop1P2aIBfJmoVnHEblzpPMlHiWc9WvU5x/d9tHX/GXHN65I
	 PRMBnmTJ3c5o6nU0yBgPlNeWGfaxS9u7y/QXvFPcFcPqISvDrLHHbTPM6BvbiNCE2UHXC
	 d3vr1vyl2Ti65xB+HbQ09hPNZfjuGuumun3shq7NTq0P1K56NOto9wyRrImIztZ+v8HW7
	 goYpc9wY8krPyFMIBesBn0MNh7zfeioP1plRg4yg08qViOaTROxoV+9TY1AjstVL1KeOf
	 jyAvRHOKfIn6K3X0MLFLkvfF+ohpx39QKoBSmwmGK1W7cFtiLnZGS6XA4rd+ITsjBIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GA+TU7o5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03BB606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 23:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A03BB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GA+TU7o5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793315188;
	bh=jouYVAIHfLjvnup8PLlQLtruSdsjeiTCBESkmSsM4WM=;
	h=From:To:Subject:Date:From;
	b=GA+TU7o5sgm2aCHSgpjZ8uiVJWyhFlX1xRxNjQ1Of88jwJqem5kPpGccEObRbbjOY
	 odT6k5D3J5sgg9n8fNX7Zf0g40VOE3mi22u3fmxAVRLCwSn//XFdonOinHoslVP/5O
	 FUQlvT/XUfrZbEWWFdIP+aLRxDwc/c/HmHJbj3ir3vlbJwHLhx3KhXQKvfUhFdDrO/
	 Bc+QTVvBAgd9wHiIl7pM/o+NPrRBWVGSY8tGt/dUZKKYAR09FJ40v978+ls13HGfo9
	 sG5nZfYTuGoyIJjo6E0ZFjkv+3uMJ2+z44KE85oA5U2xM/Z2Xw/nA08+a5lSskVDnH
	 2tWj6qewg/rVA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8695C6005E
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 00:06:28 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Fri, 30 Oct 2026 00:06:25 +0100
Message-ID: <20261029230625.302347-1-pablo@netfilter.org>
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

