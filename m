From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 7/8] netfilter: ipset: move registration message to init from net_init
Date: Thu,  6 Mar 2014 10:23:47 +0100
Message-ID: <1394097828-27901-8-git-send-email-kadlec@blackhole.kfki.hu>
References: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53960 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaCFJXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:23:53 -0500
In-Reply-To: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ilia Mirkin <imirkin@alum.mit.edu>

Commit 1785e8f473 ("netfiler: ipset: Add net namespace for ipset") moved
the initialization print into net_init, which can get called a lot due
to namespaces. Move it back into init, reduce to pr_info.

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c6c97b8..636cb8d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1945,7 +1945,6 @@ ip_set_net_init(struct net *net)
 		return -ENOMEM;
 	inst->is_deleted = 0;
 	rcu_assign_pointer(inst->ip_set_list, list);
-	pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
@@ -1996,6 +1995,7 @@ ip_set_init(void)
 		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
 		return ret;
 	}
+	pr_info("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
-- 
1.7.10.4

