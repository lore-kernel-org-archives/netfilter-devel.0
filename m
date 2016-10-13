From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 02/10] netfilter: remove comments that predate rcu days
Date: Thu, 13 Oct 2016 14:02:43 +0200
Message-ID: <1476360171-2991-3-git-send-email-pablo@netfilter.org>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753205AbcJMMLJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:11:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43A179B802
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C55A20900
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B470F20C78
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:02 +0200 (CEST)
In-Reply-To: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot block/sleep on nf_iterate because netfilter runs under rcu
read lock these days, where blocking is illegal. So let's remove these
old comments.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 7b723bcd2522..b193bd46ac30 100644
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

