From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/10] netfilter: handle queue bypass flag from nf_queue
Date: Mon, 17 Oct 2016 13:10:35 +0200
Message-ID: <1476702636-3303-10-git-send-email-pablo@netfilter.org>
References: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43230 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935036AbcJQLK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 07:10:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 589B31324CC
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 406A07842D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F268F7842D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:52 +0200 (CEST)
In-Reply-To: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move queue bypass logic from nf_hook_slow() into nf_queue() that resides
in net/netfilter/nf_queue.c, away from the core path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c         | 13 ++++---------
 net/netfilter/nf_internals.h |  4 ++--
 net/netfilter/nf_queue.c     | 39 ++++++++++++++++++++++++---------------
 3 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index fa5a3694c4b6..f299fbde150d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -343,15 +343,10 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 			ret = -EPERM;
 		break;
 	case NF_QUEUE:
-		ret = nf_queue(skb, state, entry,
-			       verdict >> NF_VERDICT_QBITS);
-		if (ret < 0) {
-			if (ret == -ESRCH &&
-			    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
-				goto next_hook;
-			kfree_skb(skb);
-		}
-		/* Fall through. */
+		ret = nf_queue(skb, state, entry, verdict);
+		if (ret == 1)
+			goto next_hook;
+		break;
 	default:
 		/* Implicit handling for NF_STOLEN, as well as any other non
 		 * conventional verdicts.
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 301cc02257ad..a46f2635b71f 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -17,8 +17,8 @@ unsigned int nf_iterate(struct sk_buff *skb, struct nf_hook_state *state,
 			struct nf_hook_entry **entryp);
 
 /* nf_queue.c */
-int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     struct nf_hook_entry *entry, unsigned int queuenum);
+int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+	     struct nf_hook_entry *entry, unsigned int verdict);
 void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_entry *entry);
 int __init netfilter_queue_init(void);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 091130bc890a..c5e0d534d352 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -107,12 +107,8 @@ void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_entry *entry)
 	rcu_read_unlock();
 }
 
-/*
- * Any packet that leaves via this function must come back
- * through nf_reinject().
- */
-int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     struct nf_hook_entry *hook_entry, unsigned int queuenum)
+static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+		      struct nf_hook_entry *hook_entry, unsigned int queuenum)
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
@@ -161,13 +157,32 @@ int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	return status;
 }
 
+/* Any packet that leaves via this function must come back through
+ * nf_reinject().
+ */
+int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
+	     struct nf_hook_entry *entry, unsigned int verdict)
+{
+	int ret;
+
+	ret = __nf_queue(skb, state, entry, verdict >> NF_VERDICT_QBITS);
+	if (ret < 0) {
+		if (ret == -ESRCH &&
+		    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
+			return 1;
+
+		kfree_skb(skb);
+	}
+
+	return 0;
+}
+
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct nf_hook_entry *hook_entry = entry->hook;
 	struct nf_hook_ops *elem = &hook_entry->ops;
 	struct sk_buff *skb = entry->skb;
 	const struct nf_afinfo *afinfo;
-	int err;
 
 	nf_queue_entry_release_refs(entry);
 
@@ -196,14 +211,8 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		err = nf_queue(skb, &entry->state, hook_entry,
-			       verdict >> NF_VERDICT_QBITS);
-		if (err < 0) {
-			if (err == -ESRCH &&
-			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
-				goto next_hook;
-			kfree_skb(skb);
-		}
+		if (nf_queue(skb, &entry->state, hook_entry, verdict) == 1)
+			goto next_hook;
 		break;
 	case NF_STOLEN:
 		break;
-- 
2.1.4

