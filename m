Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2931415B82
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 10:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160980; cv=none; b=LcqxVSY1iCrYN6EOdL1aLnuVeufHTwwozNnVl9rwpfKmu32OGQOo2P90MZb8BIeUKPaX6QuA+y6SRVkrwQNVSsahjBFPrYBCJtZWOVVZH5zbbXeg8qS0Zc3webP79Q5WOJQ93lBz0tqC+pV4KLXfRNJm/A4upsP66kqPJxDRydY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160980; c=relaxed/simple;
	bh=D1UjMPBvqKpxLXa0L/kD02cIJqyf1j2Skhf7zusiCIU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ntsomLaiXrUl1hg28rUGTK5yb6Tf8gaObNs4JXc5VYF9k70ciLNH52k3f6lWqKxgK75JSkdr5E8F+3Lkjrynl2JLU8ZgL5zb40tibLEwijcIyttqauVxCYn+1KCsdA+r4d6SmytCkMWRlwzhCZm65I179Z4OP/6twpdKZpFQ2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MqFto7O2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MqFto7O2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790160970;
	bh=eBOw7fLZNKy8KN/A4SGqxu1s9YSuPbNAYRSALxh+OdQ=;
	h=From:To:Subject:Date:From;
	b=MqFto7O2++Y9GSz9W4TG3wcwhjqDGEh+sKhIt4xUM0htWtsA/39Eic8E1FhIttggr
	 WwwHBnHcmH0/BLecLOwZ6hq8Y8fhHv7IyunL3G7+0thewxVip2J0e0UGi8bLi8iMES
	 vyr/F1ccBa0sC0/nSrHENkYqJkdmsOuQLCOp1qOTY+IVFXC/S9qpPcb7ZbL+G7aPIs
	 6Ypf9P1Ka7WZHOIL3EUgeUG6pbacTcudo0RKJopXBBuxfy+kfiCoMCBVAzt7T8ydni
	 JvxvRC66JMU/bUdJ0uZ6YNFErG69aLm0P2OIyhrG33ONUNYIljXoNHvxjpREIZZpUx
	 8e1/Huyz7II6Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05CD56005B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 12:56:09 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: flowtable: generalize pending status bit
Date: Wed, 23 Sep 2026 12:56:06 +0200
Message-ID: <20260923105606.33592-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename NF_FLOW_HW_PENDING to NF_FLOW_PENDING and use it to inhibit the
flowtable GC worker until pending offload work has been completed.

Apparently, nf_flow_offload_stats() can schedule work to retrieve stats
while the flow is being removed by GC.

And this bit can also be used in a follow up patch to disable GC until
the flow has been fully added in both directions.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: just a rebase on top of net.git

 include/net/netfilter/nf_flow_table.h | 2 +-
 net/netfilter/nf_flow_table_core.c    | 7 ++++++-
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 net/sched/act_ct.c                    | 2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..f14fd70e8289 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -186,7 +186,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_PENDING,
+	NF_FLOW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
 	NF_FLOW_HW_ESTABLISHED,
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 934c6151f558..36bbc7be2f74 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -575,7 +575,12 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	if (test_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
+	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6757fd89c1f1..4d1de88ce5d5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1057,7 +1057,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			WARN_ON_ONCE(1);
 	}
 
-	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	clear_bit(NF_FLOW_PENDING, &offload->flow->flags);
 	if (offload->cmd == FLOW_CLS_DESTROY) {
 		/* Publish after the worker's last flow access. */
 		smp_mb__before_atomic();
@@ -1089,12 +1089,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
-	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
+	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
 	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
 	if (!offload) {
-		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
 		return NULL;
 	}
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9080cb386c16..97d38608a451 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -289,7 +289,7 @@ static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
 	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
-	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
+	       !test_bit(NF_FLOW_PENDING, &flow->flags) &&
 	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 
-- 
2.47.3

