From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/10] netfilter: get rid of useless debugging from core
Date: Mon, 17 Oct 2016 13:10:27 +0200
Message-ID: <1476702636-3303-2-git-send-email-pablo@netfilter.org>
References: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933344AbcJQLKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 07:10:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6516E1324CC
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 557BD78435
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A13878435
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:46 +0200 (CEST)
In-Reply-To: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch remove compile time code to catch inconventional verdicts.
We have better ways to handle this case these days, eg. pr_debug() but
even though I don't think this is useful at all, so let's remove this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index fcb5d1df11e9..7b723bcd2522 100644
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

