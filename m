From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/09]: nfnetlink: use nlmsg_notify()
Date: Thu, 27 Sep 2007 15:46:05 +0200 (MEST)
Message-ID: <20070927134605.10198.73310.sendpatchset@localhost.localdomain>
References: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58745 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbXI0NqG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:06 -0400
In-Reply-To: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: use nlmsg_notify()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e8e16c2608c3a4ac863db49f3c30cae87c582c45
tree 471f3adb0e0324ef5dcf031c43748c2179419287
parent e8efc3dbdb2ca9fc956fe50db54ed4c2d5734b80
author Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:06:42 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:06:42 +0200

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
 
