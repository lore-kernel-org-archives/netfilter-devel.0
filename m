From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 07/10] netfilter: use switch() to handle verdict cases from nf_hook_slow()
Date: Thu,  3 Nov 2016 13:37:49 +0100
Message-ID: <1478176672-1334-7-git-send-email-pablo@netfilter.org>
References: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42850 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbcKCMiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:38:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F29758D050E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFABEDA801
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDCBCDA7F6
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:01 +0100 (CET)
In-Reply-To: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use switch() for verdict handling and add explicit handling for
NF_STOLEN and other non-conventional verdicts.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebased on top on nf-next that now includes the nf_queue fix dependency.
    No changes.

 net/netfilter/core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 14f97b624f98..64623374bc5f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -328,22 +328,32 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
 {
 	struct nf_hook_entry *entry;
 	unsigned int verdict;
-	int ret = 0;
+	int ret;
 
 	entry = rcu_dereference(state->hook_entries);
 next_hook:
 	verdict = nf_iterate(skb, state, &entry);
-	if (verdict == NF_ACCEPT) {
+	switch (verdict & NF_VERDICT_MASK) {
+	case NF_ACCEPT:
 		ret = 1;
-	} else if ((verdict & NF_VERDICT_MASK) == NF_DROP) {
+		break;
+	case NF_DROP:
 		kfree_skb(skb);
 		ret = NF_DROP_GETERR(verdict);
 		if (ret == 0)
 			ret = -EPERM;
-	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
+		break;
+	case NF_QUEUE:
 		ret = nf_queue(skb, state, &entry, verdict);
 		if (ret == 1 && entry)
 			goto next_hook;
+		/* Fall through. */
+	default:
+		/* Implicit handling for NF_STOLEN, as well as any other non
+		 * conventional verdicts.
+		 */
+		ret = 0;
+		break;
 	}
 	return ret;
 }
-- 
2.1.4

