From: pablo@netfilter.org
Subject: [PATCH 1/1] netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()
Date: Thu, 13 Jan 2011 17:19:27 +0100
Message-ID: <1294935567-4137-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44533 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965Ab1AMQTi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:19:38 -0500
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
 net/netfilter/nf_conntrack_netlink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
1.7.2.3

