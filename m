Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294396;
	b=j9ZeBcwQp/wbQxl5l7GjjLg3U4Tdm/Bpt4cSF7MsDVvAILIjOPpVrAPnjybNKsfYAeKt
	 4Qetbtugy8e0lO4Wwdh7prrBIiddOam4ZOpkUG5chPPncpf4H6609k93a0QiWgiWffVyQ
	 miS5u+56nKHzev/zfc8AGBZb7IBJlx+cI4SRbUKgChbKF+3gPZTre7r3m3d3EGJo0MSXe
	 4my3JTiuFfUQQixjmvTZHqQ9O8pEyP/u2i555cYsH2meeSLxY9iM4GHQ6zA2HNIiBN2mz
	 QkB3x/tXFfc9OcjmRWwW+EjaKH7cnb3NX0azTDFG7VOGDMCGGHzIpG24njGAFuu2a8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294396;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=0Pb2rv4Dtr74xrHwIOzhlDn7v4yxiwtXMKGD+4IWQQo=;
	b=b6TYvSBteXegeOLvxoCu8KguLZobH8qrjdrh9mr5RecgoG6iH76w9T9A9EmSgAqXAGup
	 2T+y36+B+aDOOutCj4TYxELl+UWbONbPXhhUJN/HVWBCZbLojYJTedR1+0f488t50EsFl
	 ulgT0SeqjTfrPn1KihaQFiB/3nHJMlRnh8DkQJpONC/lkP/dwXZOKvXIZE3hiIWagKCD9
	 pa3mGhkmon5US/LhY9D0vnpSMq6PxKH7Yk7bGjP27jDkSULNFcBwKIW+OVDsaEubmkzrV
	 yzPUDxxdS3XM0sAcQXTxsEemFiSaKwHI0BMqebY6SGey0jNSb6E+GnWtEGyzCDi65TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XSl0LIWm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CED6606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CED6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XSl0LIWm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793294393;
	bh=0Pb2rv4Dtr74xrHwIOzhlDn7v4yxiwtXMKGD+4IWQQo=;
	h=From:To:Subject:Date:From;
	b=XSl0LIWmgj9o0AtU7/c59HeLgQw8KW17s+YYBfRGeucnBny2/b/83dDgSFhVyf+RP
	 hDAS+WOb1Q31FabOtkg1z0x8aPzrmJrb29HsPhJwuWjgtsb/oS15G3GMUwOi0qLN/b
	 pDpl4VbjcRR3TkK0thEjn9NXZK3WvBfX35jxZn7FyznSOzcbKumE9AItr5DZTTk4+a
	 pnCLiHaMh+zui0Z20S7ImTMUtubsmAWF5QVQe/Iw1URBCvW/3MMs7t8Hq3U/mTzLHT
	 D6h5RNNcwHMX/hc35daSJ6J+Wf2WM2Kenipe0gXGEzxJpY4+ICxPLxE53qekdXHb9S
	 1aWCCcKPfnosw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 61CA260079
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 18:19:53 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Thu, 29 Oct 2026 18:19:50 +0100
Message-ID: <20261029171950.222776-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 12 +++++++++---
 net/netfilter/nf_flow_table_offload.c | 20 ++++++++++++--------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b611efaa3cd..12b8a764a1a3 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -374,7 +374,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
-void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_purge(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow);
 
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 36bbc7be2f74..4923e73ba5f0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -772,6 +772,14 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static void nf_flow_table_do_purge(struct nf_flowtable *flow_table,
+				   struct flow_offload *flow, void *data)
+{
+	if (nf_flowtable_hw_offload(flow_table))
+		nf_flow_table_offload_purge(flow_table, flow);
+	nf_flow_offload_del(flow_table, flow);
+}
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -781,9 +789,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_offload_flush(flow_table);
 	/* ... no more pending work after this stage ... */
-	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_gc_run(flow_table);
-	nf_flow_table_offload_flush_cleanup(flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_table_do_purge, NULL);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index da2013ceeee2..1b1f7e676e83 100644
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
@@ -1192,6 +1184,18 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
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
+	flow_offload_work_del(&offload);
+}
+
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 				     struct flow_block_offload *bo,
 				     enum flow_block_command cmd)
-- 
2.47.3

