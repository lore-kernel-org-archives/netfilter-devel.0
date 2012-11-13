From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] Introduce notification chain for routing changes
Date: Tue, 13 Nov 2012 21:17:36 +0100
Message-ID: <1352837857-22087-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:45081 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab2KMURk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:17:40 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 92FEE4D4015
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vs9JPN5BUVSP for <netfilter-devel@vger.kernel.org>;
	Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 769834D4005
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
In-Reply-To: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/inetdevice.h |    2 ++
 include/linux/netdevice.h  |    1 +
 net/ipv4/fib_trie.c        |   18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index d032780..cf16dab 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -170,6 +170,8 @@ struct in_ifaddr {
 
 extern int register_inetaddr_notifier(struct notifier_block *nb);
 extern int unregister_inetaddr_notifier(struct notifier_block *nb);
+extern int register_iproute_notifier(struct notifier_block *nb);
+extern int unregister_iproute_notifier(struct notifier_block *nb);
 
 extern struct net_device *__ip_dev_find(struct net *net, __be32 addr, bool devref);
 static inline struct net_device *ip_dev_find(struct net *net, __be32 addr)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f8eda02..f61b5f4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1540,6 +1540,7 @@ struct packet_type {
 #define NETDEV_RELEASE		0x0012
 #define NETDEV_NOTIFY_PEERS	0x0013
 #define NETDEV_JOIN		0x0014
+#define NETDEV_ROUTE_CHANGED	0x0015
 
 extern int register_netdevice_notifier(struct notifier_block *nb);
 extern int unregister_netdevice_notifier(struct notifier_block *nb);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 31d771c..5caf26b 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -73,6 +73,7 @@
 #include <linux/slab.h>
 #include <linux/prefetch.h>
 #include <linux/export.h>
+#include <linux/notifier.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/protocol.h>
@@ -178,6 +179,8 @@ static const int sync_pages = 128;
 static struct kmem_cache *fn_alias_kmem __read_mostly;
 static struct kmem_cache *trie_leaf_kmem __read_mostly;
 
+static BLOCKING_NOTIFIER_HEAD(iproute_chain);
+
 /*
  * caller must hold RTNL
  */
@@ -1337,6 +1340,8 @@ int fib_table_insert(struct fib_table *tb, struct fib_config *cfg)
 	rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen, tb->tb_id,
 		  &cfg->fc_nlinfo, 0);
 succeeded:
+	blocking_notifier_call_chain(&iproute_chain,
+				     NETDEV_ROUTE_CHANGED, fi);
 	return 0;
 
 out_free_new_fa:
@@ -1713,6 +1718,8 @@ int fib_table_delete(struct fib_table *tb, struct fib_config *cfg)
 	if (fa->fa_state & FA_S_ACCESSED)
 		rt_cache_flush(cfg->fc_nlinfo.nl_net);
 
+	blocking_notifier_call_chain(&iproute_chain,
+				     NETDEV_ROUTE_CHANGED, fa->fa_info);
 	fib_release_info(fa->fa_info);
 	alias_free_mem_rcu(fa);
 	return 0;
@@ -1979,6 +1986,17 @@ void __init fib_trie_init(void)
 					   0, SLAB_PANIC, NULL);
 }
 
+int register_iproute_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&iproute_chain, nb);
+}
+EXPORT_SYMBOL(register_iproute_notifier);
+
+int unregister_iproute_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&iproute_chain, nb);
+}
+EXPORT_SYMBOL(unregister_iproute_notifier);
 
 struct fib_table *fib_trie_table(u32 id)
 {
-- 
1.7.0.4

