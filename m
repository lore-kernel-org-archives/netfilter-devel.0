From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/39] netfilter: remove comments that predate rcu days
Date: Sun, 13 Nov 2016 23:24:56 +0100
Message-ID: <1479075933-4491-3-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964776AbcKMW0B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Nov 2016 17:26:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40D4EA7E8F
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32DAADA811
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D93DA801
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:25:58 +0100 (CET)
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot block/sleep on nf_iterate because netfilter runs under rcu
read lock these days, where blocking is well-known to be illegal. So
let's remove these old comments.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

