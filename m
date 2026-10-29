Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273654;
	b=C6B2jMfvuEnmdDoVtJJpvoHK9xJTCckxXpsfjt5L3Adtu2nTALrHMl5mRC5iVooquEM8
	 w7oi4nxUqsx7wO82yTVnfaNYlQ0UxZcksHx0n24MoAM+o6PGXD+6pOWzwQxEWs4AxuAQ7
	 E0/d7e8n67ifz1qzMipxuFmD/WMAFIa0hll8SiKDNPpripGWAvHHT3UG6ackkHKQP8kjs
	 yacbacZ4cn5kS9gMzyLdW1C5c0p2u5/nYLCJT3h+rPNGOHKTNVIow5ZfNMzYfxs2+VmDK
	 kxeng0+4aqWltmZTejp8aYT/X8h7WyVyxCDTYDqGIYyExdpg35NTzm67hgE8P0aVATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273654;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=l9nuImjbz9Z/vF0j/FX1gkOiOAyFXxKCBprag8xumU4=;
	b=YkWeuwkTmjNbeFfLFtxTI27BoDoKsae+vq2UKLu17AkUIUtjdnc4MBgLe6XlNRAv2pmy
	 zc6z8ZckEwtGIqOfnxeqM/HcYXS2WMeA9bfziUjhvYorE4Oz8xHWzV2tyv+9yv6DKde6l
	 hExZ4iXs8aVbr/HtWaceqV4qFZkQSXMIxZytV2Am4Njn8mQzvgRPFIP28BGcFdEvI58E7
	 UZc2E3q4mv9coNglTx1kYC/xpJ+KjjBh1DPYcOeSnMRKtVKUR8KYNC8j6x+Tna17raean
	 vGZo6plnq6IF5TTMiW/i3EDfrM7298gVyxPBi1NgAzNAA33SnRld2fw7se0HajqIB8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mTAYfLDQ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D96606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3D96606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mTAYfLDQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793273650;
	bh=l9nuImjbz9Z/vF0j/FX1gkOiOAyFXxKCBprag8xumU4=;
	h=From:To:Cc:Subject:Date:From;
	b=mTAYfLDQQNI1u1iCanvk7r29eU74qMXs5rT99lqzeu5a0umHG68xLcYbXWHyMacyy
	 sbTH/ppNs/qfS8TtNkdSmaQzMgJugw3NGzvFG+x357Fqi052uvEdHz2NlcOqp7i1p4
	 mmmb9Hxl78Pz00lDmzHwAhEZXpD73HbRNu0xbd9sZKWcfa3VWavxlmxhdiOP3xbFeM
	 d+EW8XwUbSRpuJSTe8GacwQpvoStKhOAzomSbvAi7TcyBO0xZqPhdNgIIBSU/8c70q
	 PDr7+Tu6fsdVc6jKe2TB2PFoy3+2r3x95pIxD2YHjLSJBqKUXDXIJdRHeJJj2JThLU
	 tA4kFqroKgjAA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CDED66005A;
	Thu, 29 Oct 2026 12:34:09 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next,v2 1/2] netfilter: flowtable: retrieve stats on flow deletion
Date: Thu, 29 Oct 2026 12:34:04 +0100
Message-ID: <20261029113405.180889-1-pablo@netfilter.org>
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
v2: missing copy of stats to cls_flow.stats for FLOW_CLS_DESTROY

 net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++++++-----------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..63b557633f3e 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -928,12 +928,34 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	}
 	up_read(&flowtable->flow_block_lock);
 
-	if (cmd == FLOW_CLS_STATS)
+	if (cmd == FLOW_CLS_STATS ||
+	    cmd == FLOW_CLS_DESTROY)
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
@@ -948,10 +970,13 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 static void flow_offload_tuple_del(struct flow_offload_work *offload,
 				   enum flow_offload_tuple_dir dir)
 {
+	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+
 	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
 			      offload->flowtable->priority,
-			      FLOW_CLS_DESTROY, NULL,
+			      FLOW_CLS_DESTROY, stats,
 			      &offload->flowtable->flow_block.cb_list);
+	flow_offload_update_stats(offload, stats);
 }
 
 static int flow_offload_rule_add(struct flow_offload_work *offload,
@@ -1011,27 +1036,12 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
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

