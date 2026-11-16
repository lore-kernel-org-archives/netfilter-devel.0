Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788216;
	b=4DM+zQrPmfDmjUC+souVwV3t8h561IYyxznUmjUlJlr5OUFXmcRw4PWdtP7SE6l+H864
	 95JArNT+ka1pKPRMGNS/nMrpFmNfpPN8gvabQdtezFqf+Lj41moMNH/pyJMDPR2nkCmUP
	 lW4WFe/iWJrzMGyMcT9Td9TuVp9nsUAH3yVBGacRJqhUnzn/tJrQ2hBtH/Bk2NkrDc6Ms
	 85Murkg5uv5L9ULq3KDGrbwxhnCRVrZvyIRC+t0nggvleip8h2+QzVUy7O5dwfdXprZny
	 Dt6/QpOR5m3LZovtQzyzDlzusEYg+TUh1HHTPuGcdprOmA8nQO3K17Z3H84LMXT0cvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788216;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2X/ESR4oJ+B1WlY0s0sl7YqeheiQBxd5Aklrg4+e/XA=;
	b=dz9imhUIMuv0Ae3msyudFyRfaxd2bq0XbEOztmddLiuoZvW2Q/heEwYxWcWMhjRM3zl9
	 mQe0+4lHwIYWGYxzMDgUvJANPYGmXecrBHaHatCyxkQgdZF8yUzL1TfsDU7/0ln9l6Xng
	 JvwOCQw3d9OOogw8mDLwFGaPj44y2X0HD3fIm7q3qSDjOtiCrRc3WUldpMkCrqQYeCZOI
	 9b7WHU+zFLKz5J3toXtDtyTCVIWdo0GtTyqkPBErNvbxGK4koUGTtIPXXt4+nM253apqX
	 IKGSc9njZS1aEGoIZ0H3gjFDCs3IMpjC86QtybysduXkOokG7+cedSq9Z9vtotY+5qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=leLd0356;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67959606A329;
	Mon, 16 Nov 2026 00:16:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67959606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=leLd0356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788209;
	bh=2X/ESR4oJ+B1WlY0s0sl7YqeheiQBxd5Aklrg4+e/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leLd0356vzOus+vVKw+tUtnp7jn4MmE4oRPgP98MTwZV7FmuEJ4IHqusl1nr0+YiS
	 SgI2ARqUKlNIZ3FBhRYqG2Hnw8tRyiz01ix/ojAGQmSe/OMctBmbjA36lMJ4kDDJ5L
	 gf5hrLJggD8DPQVzXAvG6J67gr/mgJfBAvE1UkrzXqFCpiWakE2DQk0nCrJSwmsKFm
	 YR1My1cL3rQ4jzC75pZ+4VqY/qwyBPTgBQWr/V0mh9kBo9gRM1qZT2KXQ6G0A3CfMc
	 EyKzOAwoYgv0Dz6IJFNAusacOObuNkrUYX0uHyTDKgaWa3iuJx66LvBzHH1y7WQMhV
	 WWPt5FPcV7K5g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D865860081;
	Mon, 16 Nov 2026 01:16:48 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/13] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Mon, 16 Nov 2026 01:16:06 +0100
Message-ID: <20261116001612.2806263-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
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
index 2aa2647ed9df..733107180d56 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -770,6 +770,29 @@ void nf_flow_table_cleanup(struct net_device *dev)
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
@@ -779,10 +802,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
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
index c302051489f2..11434cfb105b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1181,14 +1181,6 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
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
@@ -1198,6 +1190,21 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
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

