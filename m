Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300143;
	b=fuygIe6isDQFAYWGIr0Mbp02FbVrkR/StJxXtLggQyAIFIpUrX7RRuTpPr8uCYes/7kz
	 q5WZtOWGCZSVGDEM7qFRw3jeJk/9df6MbjVszODqqVzrX/Gcc68jXwLlV4kor98VRJv2+
	 q8IUj84s6EgnXLtw7cGUbEf66F6qwO00J5fX0n4twKWclaLpRu8F6bYDtbFuNobMFVTBl
	 TL+c9xoamao3Nr47v7gw31hPB/6tBE5oGTI8b8vCoPnE7jsCLDSuNl4i/Geuxtnaywvkf
	 vayVPCNnadFP/KsFPEkuX+4rL8cR35rcZr4DjyM4RgE77ZnqE3aeilkEoh4cVY3A1Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300143;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=A9Og13YBTJ4tfbFzdG0rWAMdoQ/S3lSUi3imAJEjl7U=;
	b=vaEyr9xe0qSH0ejwq5SOkFr4Ec+mYrcHTa4rdnMCuATU+pGg70DnyLP5s/hMeFn2DoDM
	 Yu/dXy8tpVzDmvuV2OWsP7diSsGWDJlFhuP1H7/nhutCL0but/ffFZ8XvA4HkxiH5ZUfL
	 IOL0By2luZ4FsL0lHrQt4n/9UHqD9KactXs79XcsQAwjbUW4ew86ky30Nxk2CtJYzITeK
	 h5Kpx1hwFCwl1+5cdlPD4OHTfe1G7MlZIH4pIAo2jSTkXcV4FfOFUZdbMC3YTKOtPFxsW
	 E4bg+HHYqXvTOa14Op1Lok7E4SjzhQkdK6Do7GyHYoAi1+n9eFrNTyNzuhEsOtuy2SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ALKSJJe4;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0889B606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 18:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0889B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ALKSJJe4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793300139;
	bh=A9Og13YBTJ4tfbFzdG0rWAMdoQ/S3lSUi3imAJEjl7U=;
	h=From:To:Subject:Date:From;
	b=ALKSJJe4csIbyN4x2zho4YysKEgeQmvdHiBJN9MSKTp3o7yIHQ1tkODWBnce2Wkxp
	 S04BLTk31FLR2FwfLSxQTGbWBOmXEua5SCC79Qcocl/fdBS/68ELdA6LZLFqxH0qRZ
	 X74ccmDIPKrl96MvYTF/3HfLP1rd4n13h6CcVe87BVtJDLo5cPUYsAOp3gJ9l8tX6C
	 bI37ASUZftGpUAj8mOMSDS6gnGK6YeHDknrrG9fzFduH8C26DugyztGhnpJNmfDIFa
	 jHfrNObQbmLzYK9XwddjOmJsnZqR8l8XfzcwN6nqnU1Jaw9aDpFwm46r4kHJi3hPaJ
	 QYuo9USy5ydEQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C59BC600A2
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 19:55:39 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Thu, 29 Oct 2026 19:55:36 +0100
Message-ID: <20261029185536.278477-1-pablo@netfilter.org>
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
v2: use rhashtable_free_and_destroy().

 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 22 ++++++++++++++++++----
 net/netfilter/nf_flow_table_offload.c | 23 +++++++++++++++--------
 3 files changed, 35 insertions(+), 13 deletions(-)

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
index 0d72dc8ae47a..52b562ed112e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -769,6 +769,22 @@ void nf_flow_table_cleanup(struct net_device *dev)
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
+	if (nf_flowtable_hw_offload(flow_table))
+		nf_flow_table_offload_purge(flow_table, flow);
+
+	flow_offload_del(flow_table, flow);
+}
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -778,10 +794,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
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

