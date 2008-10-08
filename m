From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 39/79: netns nat: fix ipt_MASQUERADE in netns
Date: Wed,  8 Oct 2008 12:47:13 +0200 (MEST)
Message-ID: <20081008104713.10423.69680.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45975 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYJHKrO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:14 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b8b8063e0d0835fb44c88d9fded2be31c9a1757e
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:10 2008 +0200

    netfilter: netns nat: fix ipt_MASQUERADE in netns
    
    First, allow entry in notifier hook.
    Second, start conntrack cleanup in netns to which netdevice belongs.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 5e1c817..65c811b 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -119,9 +119,7 @@ static int masq_device_event(struct notifier_block *this,
 			     void *ptr)
 {
 	const struct net_device *dev = ptr;
-
-	if (!net_eq(dev_net(dev), &init_net))
-		return NOTIFY_DONE;
+	struct net *net = dev_net(dev);
 
 	if (event == NETDEV_DOWN) {
 		/* Device was downed.  Search entire table for
@@ -129,7 +127,7 @@ static int masq_device_event(struct notifier_block *this,
 		   and forget them. */
 		NF_CT_ASSERT(dev->ifindex != 0);
 
-		nf_ct_iterate_cleanup(&init_net, device_cmp,
+		nf_ct_iterate_cleanup(net, device_cmp,
 				      (void *)(long)dev->ifindex);
 	}
 
