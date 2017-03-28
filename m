From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nfnetlink_queue: fix secctx memory leak
Date: Tue, 28 Mar 2017 22:59:25 +0800
Message-ID: <1490713165-60445-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, r.kubiak@samsung.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:44731 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752655AbdC1PAr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 11:00:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We must call security_release_secctx to free the memory returned by
security_secid_to_secctx, otherwise memory may be leaked forever.

Fixes: ef493bd930ae ("netfilter: nfnetlink_queue: add security context information")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3ee0b8a..933509e 100644
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
2.5.5


