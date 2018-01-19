From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: remove messages print and boot/module load time
Date: Fri, 19 Jan 2018 13:47:02 +0100
Message-ID: <20180119124702.2650-1-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbeASMrK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:47:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6209C20A521
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:47:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DB80DA857
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:47:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several reasons for this:

* Several modules maintain internal version numbers, that they print at
  boot/module load time, that are not exposed to userspace, as a
  primitive mechanism to make revision number control from the earlier
  days of Netfilter.

* IPset shows the protocol version at boot/module load time, instead
  display this via module description, as Jozsef suggested.

* Remove copyright notice at boot/module load time in two spots, the
  Netfilter codebase is a collective development effort, if we would
  have to display copyrights for each contributor at boot/module load
  time for each extensions we have, we would probably fill up logs with
  lots of useless information - from a technical standpoint.

So let's be consistent and remove them all.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c    | 3 ++-
 net/netfilter/nf_conntrack_netlink.c | 5 -----
 net/netfilter/nf_tables_api.c        | 1 -
 net/netfilter/nfnetlink.c            | 4 ----
 net/netfilter/nfnetlink_acct.c       | 2 --
 net/netfilter/nft_compat.c           | 2 --
 6 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 728bf31bb386..975a85a48d39 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2122,7 +2122,6 @@ ip_set_init(void)
 		return ret;
 	}
 
-	pr_info("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
@@ -2138,3 +2137,5 @@ ip_set_fini(void)
 
 module_init(ip_set_init);
 module_exit(ip_set_fini);
+
+MODULE_DESCRIPTION("ip_set: protocol " __stringify(IPSET_PROTOCOL));
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7c7921a53b13..dd177ebee9aa 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -57,8 +57,6 @@
 
 MODULE_LICENSE("GPL");
 
-static char __initdata version[] = "0.93";
-
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_l4proto *l4proto)
@@ -3425,7 +3423,6 @@ static int __init ctnetlink_init(void)
 {
 	int ret;
 
-	pr_info("ctnetlink v%s: registering with nfnetlink.\n", version);
 	ret = nfnetlink_subsys_register(&ctnl_subsys);
 	if (ret < 0) {
 		pr_err("ctnetlink_init: cannot register with nfnetlink.\n");
@@ -3459,8 +3456,6 @@ static int __init ctnetlink_init(void)
 
 static void __exit ctnetlink_exit(void)
 {
-	pr_info("ctnetlink: unregistering from nfnetlink.\n");
-
 	unregister_pernet_subsys(&ctnetlink_net_ops);
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 	nfnetlink_subsys_unregister(&ctnl_subsys);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f87314c6dcc4..0791813a1e7d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6603,7 +6603,6 @@ static int __init nf_tables_module_init(void)
 
 	register_netdevice_notifier(&nf_tables_flowtable_notifier);
 
-	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
 err3:
 	nf_tables_core_module_exit();
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 733d3e4a30d8..03ead8a9e90c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -37,8 +37,6 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 	rcu_dereference_protected(table[(id)].subsys, \
 				  lockdep_nfnl_is_held((id)))
 
-static char __initdata nfversion[] = "0.30";
-
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
@@ -580,13 +578,11 @@ static int __init nfnetlink_init(void)
 	for (i=0; i<NFNL_SUBSYS_COUNT; i++)
 		mutex_init(&table[i].mutex);
 
-	pr_info("Netfilter messages via NETLINK v%s.\n", nfversion);
 	return register_pernet_subsys(&nfnetlink_net_ops);
 }
 
 static void __exit nfnetlink_exit(void)
 {
-	pr_info("Removing netfilter NETLINK layer.\n");
 	unregister_pernet_subsys(&nfnetlink_net_ops);
 }
 module_init(nfnetlink_init);
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c45e6d4358ab..88d427f9f9e6 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -527,7 +527,6 @@ static int __init nfnl_acct_init(void)
 		goto err_out;
 	}
 
-	pr_info("nfnl_acct: registering with nfnetlink.\n");
 	ret = nfnetlink_subsys_register(&nfnl_acct_subsys);
 	if (ret < 0) {
 		pr_err("nfnl_acct_init: cannot register with nfnetlink.\n");
@@ -543,7 +542,6 @@ static int __init nfnl_acct_init(void)
 
 static void __exit nfnl_acct_exit(void)
 {
-	pr_info("nfnl_acct: unregistering from nfnetlink.\n");
 	nfnetlink_subsys_unregister(&nfnl_acct_subsys);
 	unregister_pernet_subsys(&nfnl_acct_ops);
 }
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7fa17e241c14..8e23726b9081 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -812,8 +812,6 @@ static int __init nft_compat_module_init(void)
 		goto err_target;
 	}
 
-	pr_info("nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>\n");
-
 	return ret;
 
 err_target:
-- 
2.11.0

