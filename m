Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276875;
	b=XBrsH6h2dQ+lwiRqPzPPhlqCshqYqmQSOj397fvb3XJGQ6ImweMvX2q6yZReX9RdJRHj
	 zwdMsTUnxldhMp6i2V3kaCzNaAPF4dI6aUeatv7SD69IqDEwNsuiNAdiDRfWEjLSphN4s
	 Hv8xoUioNgxt1Yr4w+hPOUieqzUVZpmzY9yX2J2l8QkwI5tmU55I+8T23olGH19P1gyUC
	 vidt7k9OHrD+5KZUuf2fz2ATVYMQ5sblS4mLb2Ib1k044+SI9ZZomZzA//jngvp+eBAEu
	 miSp2aqL/UbouKJJd90R6FiKm6oXhGDg+c3VKT+UpHTlKZ8K5wRGsiuP1xuCdOggvaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276875;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=OB2pY07f1MQzS563W3f49Js9L/PCuYpCwyZ4opGjt0g=;
	b=Yy3VSv4Lqh8yBAUmsJO2baG54CTELzMTvgS/7Bh9QX1hhvEyl4PaFsEIxKqhXlIFh5e7
	 NgPmMRDoJ3s6144C7DXuylW9pfjCOlv0HUNB3CpGVKEJeY7jv80XTJYEOJHx7PNGSVkI0
	 cS0HNhZTJcPGf1WuusORVA0f6F8jK9GoakjK7cb7pQe5f8PLZorD3BTPCts74AoS5O9ag
	 m2d1O0kzjsG+ZwfH6Z3DG+WWnMhI1v96EH283ohfnSwG3UhXIXZyaC3uVpoe78a+o4DKC
	 r29tKVnR+m0hqDMi12gTIUZpzbH7zkVR4tNEnWYh8hU+NJhXCVWPveMOHUg5J1XdD7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QJkm55Pj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766D606A326
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 12:27:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A766D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QJkm55Pj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793276872;
	bh=OB2pY07f1MQzS563W3f49Js9L/PCuYpCwyZ4opGjt0g=;
	h=From:To:Cc:Subject:Date:From;
	b=QJkm55PjKCdOkX33m1QcJKq9v1WtwRcPyJYi7UD1FQ2ez0F0GFSekx98r5s1g9ViU
	 UphO62EDmUYBv26twA6XGNeNMeyqpzhTH/lqKBtTCkpp/WZFEt7a9zNLiJo/ppEoPl
	 GFy0FIFG51TeG1cHi1H7mh0js1oFUjtxvQkAoO3lTBSKHNpXCts+tEP06xmL0L7Ewr
	 5oGJic3jh/mcnSXS/qgCcb+2aWC2ctnTesXdvO18mFKDa31wUx7GT17L4NnmDypUb1
	 bNXspE5gpOIAoJDs29XJNjzvRpjRCEOsTvb3HPN2K1GZSnbqaLBeFgwqFAV+XPHTyN
	 5G5B0nbRw47Bw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 66B2160054;
	Thu, 29 Oct 2026 13:27:52 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v4 1/2] netfilter: flowtable: retrieve stats on flow deletion
Date: Thu, 29 Oct 2026 13:27:48 +0100
Message-ID: <20261029122749.196486-1-pablo@netfilter.org>
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

Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dreyksmail@gmail.com/
Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: pass stats[0] and stats[1] to flow_offload_tuple_del() to avoid overwrite

 net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..da2013ceeee2 100644
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

