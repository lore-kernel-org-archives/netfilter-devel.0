From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: do not propagate nf_queue errors in nf_hook_slow
Date: Mon, 31 Oct 2011 12:20:16 +0100
Message-ID: <1320060016-9390-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35881 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729Ab1JaLSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Oct 2011 07:18:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f15850861860636c905b33a9a5be3dcbc2b0d56a
(netfilter: nfnetlink_queue: return error number to caller)
erronously assigns the return value of nf_queue() to the "ret" value.

This can cause bogus return values if we encounter QUEUE verdict
when bypassing is enabled, the listener does not exist and the
next hook returns NF_STOLEN.

In this case nf_hook_slow returned -ESRCH instead of 0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3346829..afca6c7 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -180,17 +180,16 @@ next_hook:
 		if (ret == 0)
 			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
-		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-			       verdict >> NF_VERDICT_QBITS);
-		if (ret < 0) {
-			if (ret == -ECANCELED)
+		int err = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+						verdict >> NF_VERDICT_QBITS);
+		if (err < 0) {
+			if (err == -ECANCELED)
 				goto next_hook;
-			if (ret == -ESRCH &&
+			if (err == -ESRCH &&
 			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
 				goto next_hook;
 			kfree_skb(skb);
 		}
-		ret = 0;
 	}
 	rcu_read_unlock();
 	return ret;
-- 
1.7.3.4

