Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC61422522
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985263; cv=none; b=nOSwcf8UC/WT07yGc/oE2jnAZjPQcJ7ucEjGJLfLkk0lp0WCoSzzQUCv1Ovg6ZwbdXmGQOmAPCvVq4kVhm9+4oEAY1B88GZCX6pbNDQ6ONZGF6iv9IASfPRRE2VESN+CCKYbEm8KvYtIKnfCwN0GFqDBsyPnP3j0eni4j73J6iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985263; c=relaxed/simple;
	bh=fyq2OsCfWN2iUa7TyQOrns/hAVxadQ4VdE5cgGro0yM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dyydoQtxOrLrP+MJAnZZSCb1sjfU30leqG3wIX6ErsSCnrufdv2sBgTqtwCFqqly6ZDP3f/9nAaaJVzl+4BKDCVwnl0UQcW0zEfXh7oGWoYvTNxe3u5006LxOtBgCOe3XfC2pVDc/+OrAUSs6ETneJILgPu1octvj/VzFF8ipqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AR7EqD86; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AR7EqD86"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786985260;
	bh=4j8Qy4WC+Jqi3RvhZvRX9SGNiJ9cHFYSfBzFXlu4e+M=;
	h=From:To:Subject:Date:From;
	b=AR7EqD86t+Cp5DKCftDEwBJ+XMkAaM6ksx3zQxe9Vx61hmpVsLR7TlwR7uF2Aa0aV
	 5VdIs05RecSHlZVEKXyi8CJr/XKGpNEa0yeSbInEZYjsDbWtxbntshxPxzZr10LVCG
	 niM76xe+uZkDioxXR7hcNl2qMZS3EfGZCg/AftIOY/v0A7PLd2DNY4PpldaKQQICVS
	 kocoIx19KmfbxXfPlnI5Dt+z/ugBE+G11gxroUyWFabGU48SxdEHOeq585Hqls1PZR
	 oNjGgy/l79XrcbIeaBGsUD+KVD/ApWC/VVncN4WYWTBAlwRJy8SiavHKFe4DZfEE59
	 lq93eS2dBOamw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DBB6460076
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:47:39 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 1/4] netfilter: flowtable: add and use NF_FLOW_CONFIRMED bit to skip GC
Date: Mon, 17 Aug 2026 18:47:32 +0200
Message-ID: <20260817164735.1207999-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new NF_FLOW_CONFIRMED bit is set on once the flow entry has fully
been set up, so it can be exposed to the GC.

Apparently, there is a narrow window where GC might walk over a flow
entry while it is in a partial state, ie. flow entry has been inserted
in the hashes but the NF_FLOW_HW has not been set up yet. While packets
are flowing in the software datapath that could teardown the flow.

This reverts commit 2014ac62df9d ("netfilter: flowtable: publish
GC-visible tuple last") since reversing the tuple order insertion only
mitigates the issue for one scenario.

Note that the flowtable iterators can still find reach flows in partial
state. This is fine because they are used for cleanup scenario (ie.
netdevice is gone) where the teardown bit is set on. On flowtable
removal, no flow is seen in partial state because the flow_offload
action already does not see packets (ie. flowtable in detached from
rule).

The datapath lookup function still can find the flow in partial state,
this is addressed by a follow up patch which adds a check to skip
expired flows.

Fixes: 2014ac62df9d ("netfilter: flowtable: publish GC-visible tuple last")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - remove check from lookup path
    - add smp_mb__before_atomic() before set_bit(NF_FLOW_CONFIRMED, ...

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ce414118962f..618d26e49fdf 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -189,6 +189,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
 	NF_FLOW_HW_ESTABLISHED,
+	NF_FLOW_CONFIRMED,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8b1165f2b5a4..cbb56ca94717 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -332,18 +332,17 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0)
 		return err;
 
-	/* GC only iterates original-direction entries; publish original last. */
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0) {
 		rhashtable_remove_fast(&flow_table->rhashtable,
-				       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
+				       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 				       nf_flow_offload_rhash_params);
 		return err;
 	}
@@ -353,6 +352,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
 
+	smp_mb__before_atomic();
+	set_bit(NF_FLOW_CONFIRMED, &flow->flags);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
@@ -568,8 +570,12 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	if (!test_bit(NF_FLOW_CONFIRMED, &flow->flags))
+		return;
 
+	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
-- 
2.47.3

