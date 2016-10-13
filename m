From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 01/10] netfilter: get rid of useless debugging from core
Date: Thu, 13 Oct 2016 14:11:54 +0200
Message-ID: <1476360723-3291-2-git-send-email-pablo@netfilter.org>
References: <1476360723-3291-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755963AbcJMMMT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:12:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 369343EBA89
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29E1DDA842
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22A61BAC35
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:12:15 +0200 (CEST)
In-Reply-To: <1476360723-3291-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

