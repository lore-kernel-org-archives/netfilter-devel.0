Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A05EEB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 23:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjGQXdD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 19:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjGQXdC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 19:33:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174441B5
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2023 16:32:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qLXfz-0001Op-4P; Tue, 18 Jul 2023 01:30:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: can't schedule in nft_chain_validate
Date:   Tue, 18 Jul 2023 01:30:33 +0200
Message-ID: <20230717233036.26472-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Can be called via nft set element list iteration, which may acquire
rcu and/or bh read lock (depends on set type).

BUG: sleeping function called from invalid context at net/netfilter/nf_tables_api.c:3353
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1232, name: nft
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by nft/1232:
 #0: ffff8881180e3ea8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
 #1: ffffffff83f5f540 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire
Call Trace:
 nft_chain_validate
 nft_lookup_validate_setelem
 nft_pipapo_walk
 nft_lookup_validate
 nft_chain_validate
 nft_immediate_validate
 nft_chain_validate
 nf_tables_validate
 nf_tables_abort

No choice but to move it to nf_tables_validate().

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 237f739da3ca..f12164df1f27 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3685,8 +3685,6 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
-
-		cond_resched();
 	}
 
 	return 0;
@@ -3710,6 +3708,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			return err;
+
+		cond_resched();
 	}
 
 	return 0;
-- 
2.41.0

