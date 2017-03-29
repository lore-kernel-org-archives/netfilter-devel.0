From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] netfilter: nfnetlink_queue: fix secctx memory leak
Date: Wed, 29 Mar 2017 14:14:10 +0200
Message-ID: <1490789650-7294-9-git-send-email-pablo@netfilter.org>
References: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756002AbdC2MPs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 08:15:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7944CEBAC2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:15:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F5BADA39B
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:15:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FFE6DA916
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:15:41 +0200 (CEST)
In-Reply-To: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We must call security_release_secctx to free the memory returned by
security_secid_to_secctx, otherwise memory may be leaked forever.

Fixes: ef493bd930ae ("netfilter: nfnetlink_queue: add security context information")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3ee0b8a000a4..933509ebf3d3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -443,7 +443,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb) {
 		skb_tx_error(entskb);
-		return NULL;
+		goto nlmsg_failure;
 	}
 
 	nlh = nlmsg_put(skb, 0, 0,
@@ -452,7 +452,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (!nlh) {
 		skb_tx_error(entskb);
 		kfree_skb(skb);
-		return NULL;
+		goto nlmsg_failure;
 	}
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = entry->state.pf;
@@ -598,12 +598,17 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
+	if (seclen)
+		security_release_secctx(secdata, seclen);
 	return skb;
 
 nla_put_failure:
 	skb_tx_error(entskb);
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
+nlmsg_failure:
+	if (seclen)
+		security_release_secctx(secdata, seclen);
 	return NULL;
 }
 
-- 
2.1.4

