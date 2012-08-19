From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] netfilter: nf_conntrack: remove unnecessary RTNL locking
Date: Sun, 19 Aug 2012 22:16:10 +0200
Message-ID: <1345407370-30009-4-git-send-email-kaber@trash.net>
References: <1345407370-30009-1-git-send-email-kaber@trash.net>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2HSUQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Aug 2012 16:16:13 -0400
In-Reply-To: <1345407370-30009-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Locking the rtnl was added to nf_conntrack_l{3,4}_proto_unregister()
for walking the network namespace list. This is not done anymore since
we have proper namespace support in the protocols now, so we don't
need to take the RTNL anymore.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_conntrack_proto.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 0dc6385..51e928d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -21,7 +21,6 @@
 #include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-#include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -294,9 +293,7 @@ void nf_conntrack_l3proto_unregister(struct net *net,
 	nf_ct_l3proto_unregister_sysctl(net, proto);
 
 	/* Remove all contrack entries for this protocol */
-	rtnl_lock();
 	nf_ct_iterate_cleanup(net, kill_l3proto, proto);
-	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -502,9 +499,7 @@ void nf_conntrack_l4proto_unregister(struct net *net,
 	nf_ct_l4proto_unregister_sysctl(net, pn, l4proto);
 
 	/* Remove all contrack entries for this protocol */
-	rtnl_lock();
 	nf_ct_iterate_cleanup(net, kill_l4proto, l4proto);
-	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
 
-- 
1.7.1

