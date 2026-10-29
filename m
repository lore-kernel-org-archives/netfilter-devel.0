Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313060;
	b=GNV/0JGWnZtGtZud3ZPQEEe+ZyvS12nlbnz7BbJCKQlOYI7BBsOQ1DHYqnqmGXXtQ1+l
	 mG2RjSEy4Npdq6F2CjL2oDeTUWuKouFmMgBXpEXAb3YbBcFAX1V5edzkABMAhXPQfFfxM
	 5B4s60idVRiJ5SdGxTyJaE2rkky9i1PSqPse+Fp+rV2ZGaiGdl4x8VX+1rrb67bmBxOgQ
	 xpE++TCng6DOEj/PbdumQmi/qxPDyA1TTjU2hADprZ0Y4nMbG9o1LpPonXIN6dlPpGhX6
	 3ZdUG803m4JPuFLLEpSw+lM7O7eqPByUxgRZx3gTrlj3q0dB899R8zuiREPZsNEmw8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313060;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=338UXp0xVzJoUGvFMMcnowU9KDbA227Rm7nRYcLFsiE=;
	b=ZPetSwPsOLg3Fi7KXzRh+aTonYckjwIy5OY8Pb1cnjg7pJ2PY0FNm7zGG8Ow1/3tC4qK
	 xA6t87xldxsNHLhTQmGe6ktcdrGimHQKh6aMhQfc3baOTUybWwMeMCa2YvcxCdvJOr3xJ
	 UD9i9xEOZn4UlMYI9ufVUl5cXP8gYIsvI/AmYMKcmXnvS4q3+/S6zP0fc8uwpkEkK5o0u
	 bA/2uA9wCTaAOUJqXA0E646U1vl3iKfXbJv+/pnEpnhHvW6eAvXAz60LG46yAsEsrYS39
	 NyBRlfiPtPze99v5u7RBZ0tdYkJBHRo31PurPSgkLlQ8ZZftngRftH+1wpTWQUjJoSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O0z8vrEQ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0B2606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 22:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF0B2606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O0z8vrEQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793313057;
	bh=338UXp0xVzJoUGvFMMcnowU9KDbA227Rm7nRYcLFsiE=;
	h=From:To:Subject:Date:From;
	b=O0z8vrEQXrQHIZ+N/UiGzuv9VAUTV03qBjmNogB8NJVjzqF5Dgeg2brnxMoZBBCDF
	 gbp+zPKhBuEZDvs2cOY9Uufhc+v10rXdkfBO+vtrAlj67xqvLISbHNpDy2YFpigJBq
	 yqGAaNo8pc/KDmopp82W4pKiVpcPa1lQP0O4cgs0wAwhVflqDq0NRo5hWe73OdSXe2
	 ZezLVSWxhWnGHlhAhxAlMYVzQurKqi6KBGAOhAtOZK0L9NTtqbAj3NU5SmXoQ3PLLx
	 wuscqmMDLPWo5oMPc4mhKik8GF6rmUUXF+vit7wNmWSMNgOVzqwbn1jAeZsuVLfS1i
	 2GdtRcgQUekDg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5185760190
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 23:30:57 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Thu, 29 Oct 2026 23:30:54 +0100
Message-ID: <20261029223054.288984-1-pablo@netfilter.org>
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

Fixes: c921ffe85333 ("netfilter: flowtable: Fix flushing of offloaded flows on free")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - do not call flow_offload_del() from free_and_destroy(), release flow instead.
    - skip reply direction free_and_destroy() free_fn callback.
    - skip hardware release if NF_FLOW_HW_DEAD is set on.

 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 27 +++++++++++++++++++++++----
 net/netfilter/nf_flow_table_offload.c | 23 +++++++++++++++--------
 3 files changed, 40 insertions(+), 13 deletions(-)

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
index 0d72dc8ae47a..e60780348686 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -769,6 +769,27 @@ void nf_flow_table_cleanup(struct net_device *dev)
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
+	if (dir != FLOW_OFFLOAD_DIR_ORIGINAL)
+		return;
+
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
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
@@ -778,10 +799,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
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

