From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/6] netfilter: nfnetlink_queue: do not free skb on error
Date: Mon, 27 Dec 2010 00:58:21 +0100
Message-ID: <1293407904-31464-4-git-send-email-fw@strlen.de>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53934 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0L0ADX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:03:23 -0500
In-Reply-To: <1293407904-31464-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move free responsibility from nf_queue to caller.
This enables more flexible error handling; we could
now accept the skb instead of freeing it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c     |    5 ++++-
 net/netfilter/nf_queue.c |   10 +++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 518a2e3..73e44c4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -179,8 +179,11 @@ next_hook:
 		if (ret == 0)
 			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
-		nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
 			       verdict >> NF_VERDICT_BITS);
+		if (ret < 0)
+			kfree_skb(skb);
+		ret = 0;
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a417458..2a9b80c 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -185,7 +185,6 @@ static int __nf_queue(struct sk_buff *skb,
 err_unlock:
 	rcu_read_unlock();
 err:
-	kfree_skb(skb);
 	kfree(entry);
 	return error;
 }
@@ -216,7 +215,6 @@ int nf_queue(struct sk_buff *skb,
 	}
 
 	segs = skb_gso_segment(skb, 0);
-	kfree_skb(skb);
 	if (IS_ERR(segs))
 		return -ENOMEM;
 
@@ -235,8 +233,12 @@ int nf_queue(struct sk_buff *skb,
 		segs = nskb;
 	} while (segs);
 
+	/* also free orig skb if only some segments were queued */
 	if (unlikely(error && queued))
 		error = 0;
+
+	if (error == 0)
+		kfree_skb(skb);
 	return error;
 }
 
@@ -279,9 +281,11 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		__nf_queue(skb, elem, entry->pf, entry->hook,
+		err = __nf_queue(skb, elem, entry->pf, entry->hook,
 				 entry->indev, entry->outdev, entry->okfn,
 				 verdict >> NF_VERDICT_BITS);
+		if (err < 0)
+			kfree_skb(skb);
 		break;
 	case NF_STOLEN:
 	default:
-- 
1.7.2.2

