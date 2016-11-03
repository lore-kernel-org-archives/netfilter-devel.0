From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 02/10] netfilter: remove comments that predate rcu days
Date: Thu,  3 Nov 2016 13:37:44 +0100
Message-ID: <1478176672-1334-2-git-send-email-pablo@netfilter.org>
References: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754333AbcKCMiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:38:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8ACC8D050E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89889B5052
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79194CF89A
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:37:57 +0100 (CET)
In-Reply-To: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot block/sleep on nf_iterate because netfilter runs under rcu
read lock these days, where blocking is well-known to be illegal. So
let's remove these old comments.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebased on top on nf-next that now includes the nf_queue fix dependency.
    No changes.

 net/netfilter/core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3d4aa96cb219..76014ad72ec5 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -308,18 +308,11 @@ unsigned int nf_iterate(struct sk_buff *skb,
 {
 	unsigned int verdict;
 
-	/*
-	 * The caller must not block between calls to this
-	 * function because of risk of continuing from deleted element.
-	 */
 	while (*entryp) {
 		if (state->thresh > (*entryp)->ops.priority) {
 			*entryp = rcu_dereference((*entryp)->next);
 			continue;
 		}
-
-		/* Optimization: we don't need to hold module
-		   reference here, since function can't sleep. --RR */
 repeat:
 		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
 		if (verdict != NF_ACCEPT) {
-- 
2.1.4

