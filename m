Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539582;
	b=mHFRrFE1AbLc4VlDIj+F84R/NCzOh31g3zmnv183QBbq0TU9vFOdwJ6Ta4olRK0e8HG9
	 V2zCLtMYG9qfCpPKFbh8ldB2D+l2IxNg7aqhkJpVN+WE+bcQQxDU0auNPE9+35JIYg2MP
	 oItGwxSL51HcII2bp8bkqjwrK7UKGngNuiHlVUv9vpPYH9+61ohoUAjo7NnHc2r7GEH9O
	 KwtFt9Os6mepIqMPHdzyuBfcTqta+NnXmE2OCjFPEQT6YJpAkjIw8s9wkheLBU1Sl29/U
	 JW2EgTPy+qjQu4vxSI2tWn1J6XoHY5YrVPoZBnJsBqHZVe6iMSjzBqq/MQ4ZvBOoqug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539582;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=oxNarDAU8ntLZYvcfh/EL/sVu2+NoiUKJvzwzwsSo4w=;
	b=vqGwsxKWbKQOO/c4c571Aj5h40/fPkiOQsuzV5ARbpeSMJGFBB9apdTPdVDRBYCFYR3T
	 4BbhYacqL4HTgq7RKwoFFE2S3ivht4u+xjeSIrenW1AWCNNOMuzfZjkofQnuGZtrtyLJ9
	 /Mgm9dRtLaOHZvm7/z5UGNMkOwjr0DcgJW9uAPhzgMNNi3f5Af9rR7+pVcfBC8AKL6g+L
	 oBAJVFN+9qZRlzpYH+VAJmP6/kbmaeqsxfUu8ggHS4awDXhhq2rZ0D2Z3V+9jcnWic/Wj
	 zjvfW40wUgeV8Xsao81REdC4A3h/ADrCpokREN/Pi3jkhuQjUO4GDVkZ+kbAg5zhFkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="dLG/URx+";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7B2606A323;
	Fri, 13 Nov 2026 03:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E7B2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dLG/URx+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539580;
	bh=oxNarDAU8ntLZYvcfh/EL/sVu2+NoiUKJvzwzwsSo4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLG/URx+tgjJ/SGJSbdDwI/fJa3xDvRk1L3vzbtxPPC8ICO4Qx5iAJXmd3H7Hkhiz
	 9B9RSBt5Z2fETSVz3JYjRBQhhruWKT2unXN7TtumvGg9hHloGheKE15g4+IuinnGrS
	 KberW6YVvUbFq5CTftd5DuEAuFpLnktwVJcLq7+BG3S6qEh5lBiIuBseP8GclqYm96
	 0rzV15GLjscKN2Iq5hOWIndFhbZVKWi2+NUdA6g/TAKADYWAaa+iehNccd6+AcKxVt
	 WOlGRBQQhJpWhXNEnsHSp8rs43jf5y8wyExIrLqOvix9MCV5tp+o4zUPxs2RjtuA6G
	 kZydNoN4SZQUg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D4CBD60058;
	Fri, 13 Nov 2026 04:12:59 +0100 (CET)
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
Subject: [PATCH net-next 03/15] netfilter: flowtable: retrieve stats on flow deletion
Date: Fri, 13 Nov 2026 04:12:39 +0100
Message-ID: <20261113031251.2437074-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
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
Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dreyksmail@gmail.com/
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 3a18fa48cadb..c302051489f2 100644
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
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
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

