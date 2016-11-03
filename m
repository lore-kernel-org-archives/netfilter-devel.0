From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 01/10] netfilter: get rid of useless debugging from core
Date: Thu,  3 Nov 2016 13:37:43 +0100
Message-ID: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbcKCMiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:38:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F3F48D050C
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80402B5040
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 687CFCF896
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch remove compile time code to catch inconventional verdicts.
We have better ways to handle this case these days, eg. pr_debug() but
even though I don't think this is useful at all, so let's remove this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebased on top on nf-next that now includes the nf_queue fix dependency.
    No changes.

 net/netfilter/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 004af030ef1a..3d4aa96cb219 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -323,15 +323,6 @@ unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
 		if (verdict != NF_ACCEPT) {
-#ifdef CONFIG_NETFILTER_DEBUG
-			if (unlikely((verdict & NF_VERDICT_MASK)
-							> NF_MAX_VERDICT)) {
-				NFDEBUG("Evil return from %p(%u).\n",
-					(*entryp)->ops.hook, state->hook);
-				*entryp = rcu_dereference((*entryp)->next);
-				continue;
-			}
-#endif
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.1.4

