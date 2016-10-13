From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 07/10] netfilter: use switch() to handle verdict cases from nf_hook_slow()
Date: Thu, 13 Oct 2016 14:02:48 +0200
Message-ID: <1476360171-2991-8-git-send-email-pablo@netfilter.org>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46280 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbcJMMPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:15:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36AE69B806
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 206E8207D3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82FD420911
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 14:03:07 +0200 (CEST)
In-Reply-To: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use switch() for verdict handling and add explicit handling for
NF_STOLEN and other non-conventional verdicts.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 2a6ed7d29c6c..2b3b2f8e39c4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -328,29 +328,37 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
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
-		int err;
-
+		break;
+	case NF_QUEUE:
 		RCU_INIT_POINTER(state->hook_entries, entry);
-		err = nf_queue(skb, state, verdict >> NF_VERDICT_QBITS);
-		if (err < 0) {
-			if (err == -ESRCH &&
-			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
+		ret = nf_queue(skb, state, verdict >> NF_VERDICT_QBITS);
+		if (ret < 0) {
+			if (ret == -ESRCH &&
+			    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
 				goto next_hook;
 			kfree_skb(skb);
 		}
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

