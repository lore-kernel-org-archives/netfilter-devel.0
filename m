Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C536EC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Jul 2022 19:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbiGGTbD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbiGGTbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 15:31:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2424621260
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Jul 2022 12:31:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o9XDI-0004FP-Kn; Thu, 07 Jul 2022 21:31:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: flowtable: prefer refcount_inc
Date:   Thu,  7 Jul 2022 21:30:56 +0200
Message-Id: <20220707193056.29833-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With refcount_inc_not_zero, we'd also need a smp_rmb or similar,
followed by a test of the CONFIRMED bit.

However, the ct pointer is taken from skb->_nfct, its refcount must
not be 0 (else, we'd already have a use-after-free bug).

Use refcount_inc() instead to clarify the ct refcount is expected to
be at least 1.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 A followp to 'netfilter: conntrack: fix crash due to confirmed bit load reordering',
 but target next as current code works fine.

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f2def06d1070..cca2358c10a1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -53,14 +53,14 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 {
 	struct flow_offload *flow;
 
-	if (unlikely(nf_ct_is_dying(ct) ||
-	    !refcount_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(nf_ct_is_dying(ct)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
 	if (!flow)
-		goto err_ct_refcnt;
+		return NULL;
 
+	refcount_inc(&ct->ct_general.use);
 	flow->ct = ct;
 
 	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -72,11 +72,6 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 		__set_bit(NF_FLOW_DNAT, &flow->flags);
 
 	return flow;
-
-err_ct_refcnt:
-	nf_ct_put(ct);
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-- 
2.35.1

