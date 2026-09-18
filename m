Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF2331222
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 12:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735546; cv=none; b=JfOuLaYQXMRRwP6Tf9rTHCsMRa1mtBkl0Fw10q05stQtUm41GtPSVpf1/UvcK40MQ0ZRhS7aJKHNbgawlCeUlV+K/i8eWu32bI5GGtAeyAm+SJM8kymUo0e0J8jTrdEevR3AXLGX7xj3Srygzc2RGCs2bJ8wB+FfPi6/emtDtvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735546; c=relaxed/simple;
	bh=PXI0N/nAV12GIr9D1SbLMD+w+u+m1UZL9XQKb0SveXs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=W/mK0hWQkj76RGMw5DFHZkir29hGyTbuIRkHOfnuySQY5r8gdjsP12rGnIq+YUA7qehfO5gFD6hJfOnSxxOEIsetz33endT4JZGYVO/tGCu0H04WpC1E9ciUFlIRs/V73BgPgyly/YP4vJT4rTy2ciAp9y8apipI78NKBCGET0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sdQkpync; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sdQkpync"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789735539;
	bh=UzzItHO8EDihsQZ8QTxesTl/BUJH/l6EWlncQeKcas8=;
	h=From:To:Subject:Date:From;
	b=sdQkpync+uHn1FEAZlRMdlQ/4zELKnzva4sBr/z3Jz9pj49UiqTVCbWhVAWqeKAME
	 30skwXfDXTBMjJXIsJ/orx0Sia1T7ZIgRdEECNm9jd6dTgJhhfnmYuULKJUIFMH8nw
	 27clrspHpPBAhmdLhc8qUDSwcaITc799f/eV4avGPxzYEu+n33FWBupubrWDnMY/by
	 Pgk3/KUyuYo+k7BbGkFimnneW1YyN+/tud8eGqgiC/Yo/bXUGQpbSHrTqRXnYKLm7s
	 w3tKO+pSqkMs6dnaGsKyIT08DDYZ8WOYJ+AMYhS6x5VqPt9LEcqlpxRWRZE9cYPtiv
	 ZihHTJ1D8g/ag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 94EFE60057
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 14:45:39 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: flowtable: generalize pending status bit
Date: Fri, 18 Sep 2026 14:45:35 +0200
Message-ID: <20260918124535.209897-1-pablo@netfilter.org>
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
v2: rename sched/act_ct.c too.

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
index 801a3dd9ceea..2409cbd44a02 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1058,7 +1058,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			WARN_ON_ONCE(1);
 	}
 
-	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	clear_bit(NF_FLOW_PENDING, &offload->flow->flags);
 	kfree(offload);
 }
 
@@ -1084,12 +1084,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
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

