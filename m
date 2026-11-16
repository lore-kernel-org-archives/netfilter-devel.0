Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788184;
	b=jXOyVdbzftfLD5n53fQEPR3qp3n+vqWqH0iOXb6f3K8i3cyhVVc9/ERY2JAaVWew4+L1
	 dQZNBKd6yf8ZbnN3iGSB+lJBQxiw7pYoVlmUuJ7F873kRlOoxo6GI4PGiy6VUqmKZCP59
	 8KWVANwQ4k0dSROCawck5W+S94Uoae4+8ZixPW/MNN878RauXuJkH/edIXY74Xhztd/DE
	 Uy8e7F2EuQN35MDE+YPEqsEWK7WkOPqN1HtsMsLt+0VSsg7v4pEuXxDNMlKSnXszjUYAu
	 3/2UVzSLCo60gaynNCUlLiGtmt5UgcBAjoSUTfN4Y16wLpGloWqTRJQ8/x/jp8H7+Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788184;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=oxNarDAU8ntLZYvcfh/EL/sVu2+NoiUKJvzwzwsSo4w=;
	b=xJAJGcIy+kowGBR/hosIuTVF/GtfhEMny4786+PbMlBvcbHQaRq3DhL1SCxLOAzXAxXh
	 p4xTfM0mTb+5fUAWw33nB0KgNHRRza/F5R72GKoEHdUy65zxu7GnekFRdYmBPePCNEmtF
	 xUfs++9eYeXD1z7iuG3qSAZuiy3mXRHjZO9nH5meQ+4ucTg1z9Y0mb83mXg0M0LR7RntA
	 o/jDxSELPZ3BYj5GvvkGANrxFUvp9dsVJUSEJmnF7g+17pG6IDAJ/yjPdkzf2LDVLuMLm
	 PIv1NGsS8KQ2PqEHi78DkOaBju9z9e7AtseOTiB53VLJZw/XPMPkkYydGlKl1yvWkvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Rhbtz07a;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0C606A333;
	Mon, 16 Nov 2026 00:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60B0C606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Rhbtz07a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788182;
	bh=oxNarDAU8ntLZYvcfh/EL/sVu2+NoiUKJvzwzwsSo4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rhbtz07aHduioKuaMO/91NczrtPLwi6yv+VxUM9Yf/jkx6N8fBGBkRQ7hgDsjyysJ
	 8nK1Q8zY+2cJ5xNgcD2oNmiI/qiFvbaglnl5jesdBRjqE5OEY+nxSjC19vx7PgdQW6
	 KnEZhZpD0BCAPp8LTyoe1zKFa5UvDqc6StsE4P0hX1PGgXK5kBpJcCSztJngGY7TvR
	 9G8vmWPnGki9GV66L5FPymLOepAcA06GKRnxv7Jw/RkzKCMeo/kmiPrf4qs54nJpdi
	 jxbbTv2v1DMDgTDU3QpyqqPvcYUoHwKDxlt6ur2so4dJ7c49mKj8RHe7O4JAMXT6yH
	 2IfBm8DKRbY8Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6E1C6005B;
	Mon, 16 Nov 2026 01:16:21 +0100 (CET)
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
Subject: [PATCH net-next 02/13] netfilter: flowtable: retrieve stats on flow deletion
Date: Mon, 16 Nov 2026 01:16:01 +0100
Message-ID: <20261116001612.2806263-3-pablo@netfilter.org>
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

