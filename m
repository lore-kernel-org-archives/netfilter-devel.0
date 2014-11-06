From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: nfnetlink_log: remove unnecessary error messages
Date: Thu,  6 Nov 2014 12:32:28 +0100
Message-ID: <1415273550-3526-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, mleitner@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFLay (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:30:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case of OOM, there's nothing userspace can do.

If there's no room to put the payload in __build_packet_message(),
jump to nla_put_failure which already performs the corresponding
error reporting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 5f1be5b..cd99294 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -337,9 +337,6 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
 
 			skb = nfnetlink_alloc_skb(net, pkt_size,
 						  peer_portid, GFP_ATOMIC);
-			if (!skb)
-				pr_err("nfnetlink_log: can't even alloc %u bytes\n",
-				       pkt_size);
 		}
 	}
 
@@ -570,10 +567,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		struct nlattr *nla;
 		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(inst->skb) < nla_total_size(data_len)) {
-			printk(KERN_WARNING "nfnetlink_log: no tailroom!\n");
-			return -1;
-		}
+		if (skb_tailroom(inst->skb) < nla_total_size(data_len))
+			goto nla_put_failure;
 
 		nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
 		nla->nla_type = NFULA_PAYLOAD;
-- 
1.7.10.4

