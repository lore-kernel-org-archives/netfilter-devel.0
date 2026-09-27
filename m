Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C57D3D524F;
	Sun, 27 Sep 2026 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546921; cv=none; b=p+YnUNcG8JPAZO8RpVcGyB3YYZOjmPCrH5AoEQY25MDyU4DzQllomjF0O75P+vVEAH9AXl+wMAgiUG+RFjztks7AcTMVUSRTEG0aVqU6SuA8EoB6yVi8oXHY6vwlQhgTvMVAkCbfJIbp0IIc0RwbRbR7qQklA7nCAVqSDs72Oek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546921; c=relaxed/simple;
	bh=wBc++mCfPaS6FjIZmWcp565DpScfiZGYNQWZXr/U4hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9P3x+hnOd6R4Y90v3rBxKcuZu0tYk3DpkLsE72l6TEm3O2daCs5STnMimquuvlsRMC8Dgp08cQXpcWald5CnfNX+fUpeLipQTpIqLuJv9pYdP7GccZyOx5UaurAjs1bNpMquREPU/PxYZ64abJ2LDfzi2gu9cdWzjUZrdSC8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DUSPllSE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DUSPllSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546914;
	bh=l6ZYG3ENvfaATxlov92K9ik/HcWbzHrlF/HtWiL9XWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUSPllSEhQhTyeGvXzXbSoK+YoQ+V4BDXU5LFVLN++utcjB0+auEW6QANnS2sVDza
	 hhhV01dhJwlbNi525KdfJA3ty0d87ZvxnZd5+f3plkPMLWUf8QNBZfDGc+H38SeO4A
	 hkLj1Z3Iusp8e57s/JHmo+x4tJ1642/d+YtcQspr6FkD77J3uzQ749zZe8fLqi1uT/
	 sfH6DdOr3MKTZeidpSkU/4Ki4B+VNbcPqGZ7jIJHVADE/nmQ0uUbVvIiAuBTGvj7fy
	 zs9ab4+ITO8Zh0h39Eczbe1Hawr1ub8aDUgdaJHjQY1NrvGsl7yFlIHB6REVgbISm1
	 E/Vh8q6Sr5gNg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BF843603E5;
	Mon, 28 Sep 2026 00:08:33 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 10/11] netfilter: flowtable: generalize pending status bit
Date: Mon, 28 Sep 2026 00:08:15 +0200
Message-ID: <20260927220816.268206-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename NF_FLOW_HW_PENDING to NF_FLOW_PENDING and use it to inhibit the
flowtable GC worker until pending hw offload work has been completed.

Apparently, nf_flow_offload_stats() can schedule work to retrieve stats
while the flow is being removed by GC.

And this bit can also be used in a follow up patch to disable GC until
the flow has been fully added in both directions.

Revert the reordering done in commit d644b23afe1e ("netfilter:
flowtable: publish HW_DEAD after worker is done") to prevent a race
between GC and hw offload handler.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    |  7 ++++++-
 net/netfilter/nf_flow_table_offload.c | 14 +++++---------
 net/sched/act_ct.c                    |  2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..5b611efaa3cd 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -183,10 +183,10 @@ enum nf_flow_flags {
 	NF_FLOW_DNAT,
 	NF_FLOW_CLOSING,
 	NF_FLOW_TEARDOWN,
+	NF_FLOW_PENDING,
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_PENDING,
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
index 6757fd89c1f1..4365859220e6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -995,6 +995,7 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -1056,13 +1057,8 @@ static void flow_offload_work_handler(struct work_struct *work)
 		default:
 			WARN_ON_ONCE(1);
 	}
-
-	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
-	if (offload->cmd == FLOW_CLS_DESTROY) {
-		/* Publish after the worker's last flow access. */
-		smp_mb__before_atomic();
-		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
-	}
+	smp_mb__before_atomic();
+	clear_bit(NF_FLOW_PENDING, &offload->flow->flags);
 
 	kfree(offload);
 }
@@ -1089,12 +1085,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
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
index 55f3521edb4c..626c9a5af0ef 100644
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

