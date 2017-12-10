From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 7/7] netfilter: core: remove struct nf_afinfo and its helper functions
Date: Sun, 10 Dec 2017 21:43:45 +0100
Message-ID: <20171210204345.13292-8-pablo@netfilter.org>
References: <20171210204345.13292-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47132 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdLJUn5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:43:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDE7D1C4423
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9650DA840
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D517DA840
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:53 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4E5B74265A4E
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:53 +0100 (CET)
In-Reply-To: <20171210204345.13292-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This abstraction has no clients anymore after converting many of them to
direct function call, now that is useless this patch removes it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h               | 14 ---------
 net/bridge/netfilter/nf_tables_bridge.c | 51 +++------------------------------
 net/ipv4/netfilter.c                    | 10 -------
 net/ipv6/netfilter.c                    |  7 +----
 net/netfilter/core.c                    | 22 --------------
 5 files changed, 5 insertions(+), 99 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6bdb0e5706a9..ba1d2c5a37ae 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -309,17 +309,6 @@ int skb_make_writable(struct sk_buff *skb, unsigned int writable_len);
 struct flowi;
 struct nf_queue_entry;
 
-struct nf_afinfo {
-	unsigned short	family;
-	int		route_key_size;
-};
-
-extern const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO];
-static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
-{
-	return rcu_dereference(nf_afinfo[family]);
-}
-
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u_int8_t protocol,
 		    unsigned short family);
@@ -329,9 +318,6 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry);
 void nf_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 
-int nf_register_afinfo(const struct nf_afinfo *afinfo);
-void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
-
 #include <net/flow.h>
 extern void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
 
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 74260ffec74d..86774b5c3b73 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -95,65 +95,23 @@ static const struct nf_chain_type filter_bridge = {
 	},
 };
 
-static void nf_br_saveroute(const struct sk_buff *skb,
-			    struct nf_queue_entry *entry)
-{
-}
-
-static int nf_br_reroute(struct net *net, struct sk_buff *skb,
-			 const struct nf_queue_entry *entry)
-{
-	return 0;
-}
-
-static __sum16 nf_br_checksum(struct sk_buff *skb, unsigned int hook,
-			      unsigned int dataoff, u_int8_t protocol)
-{
-	return 0;
-}
-
-static __sum16 nf_br_checksum_partial(struct sk_buff *skb, unsigned int hook,
-				      unsigned int dataoff, unsigned int len,
-				      u_int8_t protocol)
-{
-	return 0;
-}
-
-static int nf_br_route(struct net *net, struct dst_entry **dst,
-		       struct flowi *fl, bool strict __always_unused)
-{
-	return 0;
-}
-
-static const struct nf_afinfo nf_br_afinfo = {
-	.family                 = AF_BRIDGE,
-	.checksum               = nf_br_checksum,
-	.checksum_partial       = nf_br_checksum_partial,
-	.route                  = nf_br_route,
-	.saveroute              = nf_br_saveroute,
-	.reroute                = nf_br_reroute,
-	.route_key_size         = 0,
-};
-
 static int __init nf_tables_bridge_init(void)
 {
 	int ret;
 
-	nf_register_afinfo(&nf_br_afinfo);
 	ret = nft_register_chain_type(&filter_bridge);
 	if (ret < 0)
-		goto err1;
+		return ret;
 
 	ret = register_pernet_subsys(&nf_tables_bridge_net_ops);
 	if (ret < 0)
-		goto err2;
+		goto err_register_subsys;
 
 	return ret;
 
-err2:
+err_register_subsys:
 	nft_unregister_chain_type(&filter_bridge);
-err1:
-	nf_unregister_afinfo(&nf_br_afinfo);
+
 	return ret;
 }
 
@@ -161,7 +119,6 @@ static void __exit nf_tables_bridge_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_bridge_net_ops);
 	nft_unregister_chain_type(&filter_bridge);
-	nf_unregister_afinfo(&nf_br_afinfo);
 }
 
 module_init(nf_tables_bridge_init);
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 9a27029038b5..e42314b30809 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -173,13 +173,3 @@ int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	return 0;
 }
 EXPORT_SYMBOL(nf_ip_route);
-
-static const struct nf_afinfo nf_ip_afinfo = {
-	.family			= AF_INET,
-};
-
-static int __init ipv4_netfilter_init(void)
-{
-	return nf_register_afinfo(&nf_ip_afinfo);
-}
-subsys_initcall(ipv4_netfilter_init);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 319ff0655060..f32bf3aea423 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -184,14 +184,10 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.fragment	= ip6_fragment
 };
 
-static const struct nf_afinfo nf_ip6_afinfo = {
-	.family			= AF_INET6,
-};
-
 int __init ipv6_netfilter_init(void)
 {
 	RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
-	return nf_register_afinfo(&nf_ip6_afinfo);
+	return 0;
 }
 
 /* This can be called from inet6_init() on errors, so it cannot
@@ -200,5 +196,4 @@ int __init ipv6_netfilter_init(void)
 void ipv6_netfilter_fini(void)
 {
 	RCU_INIT_POINTER(nf_ipv6_ops, NULL);
-	nf_unregister_afinfo(&nf_ip6_afinfo);
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 606efc9b14e1..3e25e7628fa2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -28,34 +28,12 @@
 
 #include "nf_internals.h"
 
-static DEFINE_MUTEX(afinfo_mutex);
-
-const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
-EXPORT_SYMBOL(nf_afinfo);
 const struct nf_ipv6_ops __rcu *nf_ipv6_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ipv6_ops);
 
 DEFINE_PER_CPU(bool, nf_skb_duplicated);
 EXPORT_SYMBOL_GPL(nf_skb_duplicated);
 
-int nf_register_afinfo(const struct nf_afinfo *afinfo)
-{
-	mutex_lock(&afinfo_mutex);
-	RCU_INIT_POINTER(nf_afinfo[afinfo->family], afinfo);
-	mutex_unlock(&afinfo_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_register_afinfo);
-
-void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
-{
-	mutex_lock(&afinfo_mutex);
-	RCU_INIT_POINTER(nf_afinfo[afinfo->family], NULL);
-	mutex_unlock(&afinfo_mutex);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
-
 #ifdef HAVE_JUMP_LABEL
 struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
-- 
2.11.0

