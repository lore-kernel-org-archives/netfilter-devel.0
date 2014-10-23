From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3] netfilter: nf_log: release skbuff on nlmsg put failure
Date: Thu, 23 Oct 2014 10:36:08 +0200
Message-ID: <1414053368-29037-4-git-send-email-fw@strlen.de>
References: <1414053368-29037-1-git-send-email-fw@strlen.de>
Cc: Houcheng Lin <houcheng@gmail.com>, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49323 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbaJWIgT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:36:19 -0400
In-Reply-To: <1414053368-29037-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Houcheng Lin <houcheng@gmail.com>

The kernel should reserve enough room in the skb so that the DONE
message can always be appended.  However, in case of e.g. new attribute
erronously not being size-accounted for, __nfulnl_send() will still
try to put next nlmsg into this full skbuf, causing the skb to be stuck
forever and blocking delivery of further messages.

Fix issue by releasing skb immediately after nlmsg_put error and
WARN() so we can track down the cause of such size mismatch.

[ fw@strlen.de: add tailroom/len info to WARN ]

Signed-off-by: Houcheng Lin <houcheng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2d02eac3..5f1be5b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -346,26 +346,25 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
 	return skb;
 }
 
-static int
+static void
 __nfulnl_send(struct nfulnl_instance *inst)
 {
-	int status = -1;
-
 	if (inst->qlen > 1) {
 		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
 						 NLMSG_DONE,
 						 sizeof(struct nfgenmsg),
 						 0);
-		if (!nlh)
+		if (WARN_ONCE(!nlh, "bad nlskb size: %u, tailroom %d\n",
+			      inst->skb->len, skb_tailroom(inst->skb))) {
+			kfree_skb(inst->skb);
 			goto out;
+		}
 	}
-	status = nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
-				   MSG_DONTWAIT);
-
+	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
+			  MSG_DONTWAIT);
+out:
 	inst->qlen = 0;
 	inst->skb = NULL;
-out:
-	return status;
 }
 
 static void
-- 
2.0.4

