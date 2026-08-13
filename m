Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351541A6803
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 00:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786579968; cv=none; b=QanRJJRFAROeYNIUx9Fe0RUDLfH+mrTcVwwgNP5iwaq5/A5pI0tPiVydOn0/eWkMIde+b4wkcbhKQQi4uhjvEnCMnVV0dijT1KmUztDrxPgStLV//1RmLSUhCtDbn/2/zmdEG0bDxuuMimBqRsd8E2LPRKH/ecniGf4e0mUwYoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786579968; c=relaxed/simple;
	bh=DgE0375wXTsc96h1/XaQeFISn64Kd0VwJnPDMjYsrX8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dVWzwRhpvqUJoK46Uomp3eP00oNtMlSnyNAVB7L8z9HGov58xhZ0h1OyJq+ttIlesfHsTLlTQW2b8fCPlq/s5C15b5K3fl8nEzR4sLBgpSUooHs0e8plqzCKFCVW97e0oyQ7YSi7n/dGEGmYBOAoFsKYG1ZwYSiF3sWbSJSwk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o1+jHOCA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o1+jHOCA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786579964;
	bh=ULzqCbNLHYo20mixdWCAH4uoJeYUbwpHPwrcArZdzk8=;
	h=From:To:Subject:Date:From;
	b=o1+jHOCAx+fuehYUmIJMdtGiLGwBqXPMNUYpSrI9GJTJ8uLsTQnR9mRm6olgfqSim
	 wtdxdkU/NQkAUtqb96sRP3OaBmn3Fv5RjToZpxQnPXSsK88wJJ4T26V9NDaP9fwT4N
	 751sz7y43CZprgjz4aWG6MZKZnTyc5hh0GCw3gyu9a89SOckjwwCil1TMxnhZZlggt
	 oy3+UvN7y7RTOQQjZpLGF6TF7N1H4GZVAFiUqNRLptqDsrhCSrR8mqHP7JO+6vCH/Y
	 gCYSM0blxXLdNLllTDb9gMsbUbI1jCmFoqixgImzglf51z4cMe/83V+y5FK6XKAS0J
	 PRFtoSyBb8EmQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04E6A6005D
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 02:12:43 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: add and use NF_FLOW_CONFIRMED bit
Date: Thu, 13 Aug 2026 02:12:40 +0200
Message-ID: <20260813001240.1061955-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new NF_FLOW_CONFIRMED bit is set on once the flow entry has fully
been set up, so it can be exposed to the GC and software datapath via
lookup.

Apparently, there is a narrow window where GC might walk over a flow
entry which is in intermediate state, ie. flow entry has inserted in the
hashes but the NF_FLOW_HW has not been set up yet. While packets are
flowing in the software datapath that could teardown the flow.

This reverts commit 2014ac62df9d ("netfilter: flowtable: publish
GC-visible tuple last") since reversing the tuple order insertion only
mitigates the issue for one scenario.

Fixes: 2014ac62df9d ("netfilter: flowtable: publish GC-visible tuple last")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

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
index 8b1165f2b5a4..1e2c4a1db9a7 100644
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
@@ -353,6 +352,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
 
+	set_bit(NF_FLOW_CONFIRMED, &flow->flags);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
@@ -412,7 +413,8 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+	if (unlikely(!test_bit(NF_FLOW_CONFIRMED, &flow->flags)) ||
+	    test_bit(NF_FLOW_TEARDOWN, &flow->flags))
 		return NULL;
 
 	if (unlikely(nf_ct_is_dying(flow->ct)))
@@ -568,15 +570,19 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	if (!test_bit(NF_FLOW_CONFIRMED, &flow->flags))
+		return;
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
-	} else if (!teardown) {
+	} else if (!test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		nf_flow_table_extend_ct_timeout(flow->ct);
+		teardown = false;
 	}
 
 	if (teardown) {
-- 
2.47.3

