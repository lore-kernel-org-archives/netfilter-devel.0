Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793272488;
	b=mAcSTpglcCSmvf+uy0xXr6TdMCRXK04tDe+kpZ8F5MpuJWhLCNgh3We0ZlVFuKevRuGB
	 mx+TsHhb7tY6f2hdAt9DwBAGnpJtjLatCjTFJoI3vnwsvo0IVD141nfzaKBWP8jUY+n3C
	 G0kwzJ4ymFZ9X059FRN4hDu1SztLFGZ2obzZRgpD9RLzNFvXEVmeLhztFrUDeBXzSnvw9
	 KheL6exzbU8WbhzDzRy9a6WFf2YROuiJyZZhcthW9CtFXEaK1yxJ94hfvMOfpG8tfk8yR
	 IgSu7z7hYHASlsIrOOsXTUjW4U57sdSOZ9LiIiboaLGW6fQISPdbLFHrjFiaiNX6Dcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793272488;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=pgfnHfvGX4ol33aKul20Iedt1+Xs2RdQlE8+ysOvVJ8=;
	b=SYInVSOwH7Sa8nXQQWY6ogkF/hEqLlzd5gg7tojdobetFDrGEYAd7c0lRaV6nh1Pww4w
	 6GYPlwBf9FniATFQJ+NUVH6aRUhIywDwRl9HMO5C5l/O27MP28nBLI0KZqgfzddKABZXv
	 d57ffiQzPgfInsyKhPAXRUKn1bh85SFsaIag3intxSYDL+vT/8fC67mGk/77Xep0QA2I/
	 0frxV6PiDcmIB/qsjuGh0+unnJ+38mry9Ss6dBxhHtOnyGacVhkGapbYy3bQPUn30Unxd
	 uzg9Btrzzl1FwtswxoLvLHtPfzz6bLV3DfqdEsJZLG4e3HuDuPgSZGeeaz2Upvegf8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ph4f20le;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F00606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96F00606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ph4f20le
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793272477;
	bh=pgfnHfvGX4ol33aKul20Iedt1+Xs2RdQlE8+ysOvVJ8=;
	h=From:To:Cc:Subject:Date:From;
	b=Ph4f20leSvITSdg2wbqt+jrW0V+/Uucs2PZ5O6KQntiOgCEhMqrWl4PywslhYIYT8
	 Of9q+LKJyheHGG9D2wTJrtoZ49nxcuvonrhwrybJpg02TH6mhpwzZUsJ0jMLlf3Vc2
	 P12XozAYk+zWwVsuvNxFWZ+nr6KN7d5m9IUy671UQZuSyvn7Eib6pR3mErSy3eZGfA
	 zqug3q5lot8Gb75/HunNfFvuvTB5qF30/RHqKu8TSdVxvSrvkiI16Y9/yBYpSJkuxa
	 oC4JFZEwOzKpxV69Wra9SWCaGa0B0GOIHV1yr2J8GUIKJtck2AqHLfvk6dLW3Tnf1P
	 RQY76UQb+1Leg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8D90760078;
	Thu, 29 Oct 2026 12:14:37 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow deletion
Date: Thu, 29 Oct 2026 12:14:30 +0100
Message-ID: <20261029111431.179813-1-pablo@netfilter.org>
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
 net/netfilter/nf_flow_table_offload.c | 43 ++++++++++++++++-----------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..53182323f73c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -934,6 +934,27 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
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
@@ -948,10 +969,13 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
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
@@ -1011,27 +1035,12 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
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

