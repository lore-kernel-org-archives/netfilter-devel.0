From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/19]: nfnetlink: use nlmsg_notify()
Date: Fri, 28 Sep 2007 18:30:43 +0200 (MEST)
Message-ID: <20070928163043.8394.70303.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55929 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbXI1Qao (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:44 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: use nlmsg_notify()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6e4c97ee8ad0d54a48057f7fd1ec4e7cd2571556
tree 2eef13fec6d3ba46845b3c7da26ae4811d3e80ef
parent 46958d51af5d65a36b04e8c8aabba6d86b19b4c7
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:13 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:13 +0200

 net/netfilter/nfnetlink.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 3cfa76b..e212102 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -148,16 +148,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 
 int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, int echo)
 {
-	int err = 0;
-
-	NETLINK_CB(skb).dst_group = group;
-	if (echo)
-		atomic_inc(&skb->users);
-	netlink_broadcast(nfnl, skb, pid, group, gfp_any());
-	if (echo)
-		err = netlink_unicast(nfnl, skb, pid, MSG_DONTWAIT);
-
-	return err;
+	return nlmsg_notify(nfnl, skb, pid, group, echo, gfp_any());
 }
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 
