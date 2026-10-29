Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275141;
	b=nyEmpKtP/XuhPJwFrII5+wnI8zHvxR+bejSdWzfyUhx87s4ygfycZJx0JCZUHTsPDwNj
	 ZFRq7Xkd3m5mRucwQtFtBN0iPL8tYchjiX5MkAElTSxBAlFObEvV/LpgN5mGELdzfWai3
	 YfTLdPM4QiUaOXnN6ZxfcA9AuGVewor/XVpqHOAsmQXsmv5xkzAVdCsYl6Fa7VsY6MKY8
	 Z/HeE7L9h7SOD3DdQTI2pZgt6dGp0qjHBFQ4y/MdCwc4SKc5A+Ou29dKiFo6YlUveBe1L
	 T6d2wqnETqnZACEvp27MiK/5lCFTglTM5lcVvlQ6Zm+cW/ws4M2u30rFVcJ6wapk8+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275141;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=AmxekEw0qAF93wFVWLxEeXUaPUWQtwLgyEQclUaaMD0=;
	b=h+LEpBCpdv/Lwzz/2KD0/WDIkrjevnXR24Lxq0I7KH9SyAty97DkP1oMFHol6VQ0cfQp
	 Y9VmPb/1rhcwZttDzepR/t/Nxv1YPobJ1xrB9knfAePySfuIXuHc1dKKVU324zhTmXbBg
	 BK6cdJBgrGu8NMh8BaoT5i/2fPEyg/KTEW+QUWtPHgsDQpV6SzDVu+2f3ashIcVL2/6Qo
	 6Pk0rpnHI8oO3C2WCkWjiuLES4B7dEuo0O3GZyyh0qnL4uVGhgfd7gKzyC2jtFmhGndVd
	 P/1QecgaZXSM2VnKm9vxyc0squcVxQJ0RcmyowTwyGCc1mGYRCbm+/kv/+EzIPVhjeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jG8rGZxK;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38EE606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C38EE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jG8rGZxK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793275138;
	bh=AmxekEw0qAF93wFVWLxEeXUaPUWQtwLgyEQclUaaMD0=;
	h=From:To:Cc:Subject:Date:From;
	b=jG8rGZxK8pHeakOQ8fv+sE4arxjahgn8lfrsZqc3P6VNyDE7Bn9/elkEtKu8klRYe
	 ik8YqPeps2J52b7GxYiHeNFAyJc/DbC9S9L1NmnLM3q4yl+zkILpG5lhCLnpouylzr
	 G2HhfHrpp/gRjoECJMxKqDJMNiYzty2Y0xB3ihV/IwlJTswi47Ijaha/Wrab6y0FfU
	 5veIhlhcGXw/zWGy4gF0tgQuyUOQ6JB6tvZOOCMUyp4xin0lR5POtCZlgJSt0XOwYE
	 /pvxOUMEfrPnPgBuKSKSGMZ1ykMOlALs7Z+eHR+PoVgMlXtn/14hDiKnHA6y3phmLu
	 liN+0JLW07E1A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27EB76005B;
	Thu, 29 Oct 2026 12:58:58 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v3 1/2] netfilter: flowtable: retrieve stats on flow deletion
Date: Thu, 29 Oct 2026 12:58:53 +0100
Message-ID: <20261029115855.188023-1-pablo@netfilter.org>
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

Retrieve stats too when deleting a flow from hardware. Apparently, the
existing approach is missing last stats sync with the conntrack entry.
Pass the stats object to the driver so it has a chance to populate it
at deletion time. Drivers need to be updated to use this new approach.

Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - use if (stats) instead of checking cmd type in nf_flow_offload_tuple() as suggested by Lorenzo.
    - call flow_offload_update_stats() from flow_offload_work_del().

 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..022ea9d764ca 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -928,12 +928,33 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	}
 	up_read(&flowtable->flow_block_lock);
 
-	if (cmd == FLOW_CLS_STATS)
+	if (stats)
 		memcpy(stats, &cls_flow.stats, sizeof(*stats));
 
 	return i;
 }
 
+static void flow_offload_update_stats(struct flow_offload_work *offload,
+				      struct flow_stats *stats)
+{
+	u64 lastused;
+
+	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
+	offload->flow->timeout = max_t(u64, offload->flow->timeout,
+				       lastused + flow_offload_get_timeout(offload->flow));
+
+	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
+		if (stats[0].pkts)
+			nf_ct_acct_add(offload->flow->ct,
+				       FLOW_OFFLOAD_DIR_ORIGINAL,
+				       stats[0].pkts, stats[0].bytes);
+		if (stats[1].pkts)
+			nf_ct_acct_add(offload->flow->ct,
+				       FLOW_OFFLOAD_DIR_REPLY,
+				       stats[1].pkts, stats[1].bytes);
+	}
+}
+
 static int flow_offload_tuple_add(struct flow_offload_work *offload,
 				  struct nf_flow_rule *flow_rule,
 				  enum flow_offload_tuple_dir dir)
@@ -946,11 +967,12 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 }
 
 static void flow_offload_tuple_del(struct flow_offload_work *offload,
-				   enum flow_offload_tuple_dir dir)
+				   enum flow_offload_tuple_dir dir,
+				   struct flow_stats *stats)
 {
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
 			      offload->flowtable->priority,
-			      FLOW_CLS_DESTROY, NULL,
+			      FLOW_CLS_DESTROY, stats,
 			      &offload->flowtable->flow_block.cb_list);
 }
 
@@ -991,10 +1013,15 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
+	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL, stats);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY, stats);
+
+	flow_offload_update_stats(offload, stats);
+
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
@@ -1011,27 +1038,12 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 static void flow_offload_work_stats(struct flow_offload_work *offload)
 {
 	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
-	u64 lastused;
 
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
 					 &stats[1]);
-
-	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
-	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-				       lastused + flow_offload_get_timeout(offload->flow));
-
-	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
-		if (stats[0].pkts)
-			nf_ct_acct_add(offload->flow->ct,
-				       FLOW_OFFLOAD_DIR_ORIGINAL,
-				       stats[0].pkts, stats[0].bytes);
-		if (stats[1].pkts)
-			nf_ct_acct_add(offload->flow->ct,
-				       FLOW_OFFLOAD_DIR_REPLY,
-				       stats[1].pkts, stats[1].bytes);
-	}
+	flow_offload_update_stats(offload, stats);
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
2.47.3

