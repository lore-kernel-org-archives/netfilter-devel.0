From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 26/31] netns nat: fix MASQUERADE in netns
Date: Mon, 21 Jul 2008 20:54:05 +0400
Message-ID: <20080721165405.GL13390@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	dev@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	dlezcano@fr.ibm.com, benjamin.thery@bull.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:9885 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYGUQzx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:55:53 -0400
Received: by ug-out-1314.google.com with SMTP id h2so277496ugf.16
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:55:51 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do conntrack cleanup in netns which messenger netdevice came from.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/ipt_MASQUERADE.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -120,16 +120,13 @@ static int masq_device_event(struct notifier_block *this,
 {
 	const struct net_device *dev = ptr;
 
-	if (!net_eq(dev_net(dev), &init_net))
-		return NOTIFY_DONE;
-
 	if (event == NETDEV_DOWN) {
 		/* Device was downed.  Search entire table for
 		   conntracks which were associated with that device,
 		   and forget them. */
 		NF_CT_ASSERT(dev->ifindex != 0);
 
-		nf_ct_iterate_cleanup(&init_net, device_cmp, (void *)(long)dev->ifindex);
+		nf_ct_iterate_cleanup(dev_net(dev), device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
-- 
1.5.4.5


