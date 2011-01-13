From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH] netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()
Date: Thu, 13 Jan 2011 14:19:55 +0100
Message-ID: <1294924795-20816-1-git-send-email-fwestphal@astaro.com>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-53.dex002.intermedia.net ([64.78.21.155]:54721 "EHLO
	dhost002-53.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720Ab1AMNd5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:33:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes a loop in ctnetlink_get_conntrack() that can be
triggered if you use the same socket to receive events and to
perform a GET operation. Under heavy load, netlink_unicast()
may return -EAGAIN, this error code is reserved in nfnetlink for
the module load-on-demand. Instead, we return -ENOBUFS which is
the appropriate error code that has to be propagated to
user-space.

Reported-by: Holger Eitzenberger <holger@eitzenberger.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Looks like this patch got lost -- I cannot find in in linus' or net-2.6 trees...

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5cb8d30..2b7eef3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -972,7 +972,8 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 free:
 	kfree_skb(skb2);
 out:
-	return err;
+	/* this avoids a loop in nfnetlink. */
+	return err == -EAGAIN ? -ENOBUFS : err;
 }
 
 #ifdef CONFIG_NF_NAT_NEEDED
-- 
1.7.2.2

