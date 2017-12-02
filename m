From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: reduce hook array sizes to what is needed
Date: Sun,  3 Dec 2017 00:58:48 +0100
Message-ID: <20171202235848.22737-3-fw@strlen.de>
References: <20171202235848.22737-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46492 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751494AbdLBX7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Dec 2017 18:59:49 -0500
In-Reply-To: <20171202235848.22737-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not all families share the same hook count.

Can't use the corresponding ARP, BRIDGE, DECNET defines because they are
defined in uapi headers and including them causes build failures.

struct net before:
/* size: 6592, cachelines: 103, members: 46 */
after:
/* size: 5952, cachelines: 93, members: 46 */

Also, no need to define hook points if the family isn't supported.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h     |  6 ++++++
 include/net/netns/netfilter.h | 19 ++++++++++++++-----
 net/netfilter/core.c          | 22 ++++++++++++++++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 80aa9a0b3d10..30a0d12a1f6d 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -202,15 +202,21 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	case NFPROTO_IPV6:
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	case NFPROTO_ARP:
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 		break;
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	case NFPROTO_BRIDGE:
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
 		break;
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
 		break;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		break;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index b39c563c2fce..2ede7bc4ecaa 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -17,11 +17,20 @@ struct netns_nf {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
 #endif
-	struct nf_hook_entries __rcu *hooks_ipv4[NF_MAX_HOOKS];
-	struct nf_hook_entries __rcu *hooks_ipv6[NF_MAX_HOOKS];
-	struct nf_hook_entries __rcu *hooks_arp[NF_MAX_HOOKS];
-	struct nf_hook_entries __rcu *hooks_bridge[NF_MAX_HOOKS];
-	struct nf_hook_entries __rcu *hooks_decnet[NF_MAX_HOOKS];
+	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
+	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
+	/* in/out/forward only */
+	struct nf_hook_entries __rcu *hooks_arp[3];
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+	/* note: 'BROUTE' isn't a real hook (called via function pointer) */
+	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
+	/* also supports a 'HELLO' and 'ROUTE' type */
+	struct nf_hook_entries __rcu *hooks_decnet[NF_INET_NUMHOOKS + 2];
+#endif
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1de3579056ec..5cb2a36ce4e1 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -242,16 +242,32 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	switch (reg->pf) {
 	case NFPROTO_NETDEV:
 		break;
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	case NFPROTO_ARP:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_arp) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_arp + reg->hooknum;
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	case NFPROTO_BRIDGE:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_bridge) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_bridge + reg->hooknum;
+#endif
 	case NFPROTO_IPV4:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_ipv4 + reg->hooknum;
 	case NFPROTO_IPV6:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv6) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_ipv6 + reg->hooknum;
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_decnet) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_decnet + reg->hooknum;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
@@ -596,9 +612,15 @@ static int __net_init netfilter_net_init(struct net *net)
 {
 	__netfilter_net_init(net->nf.hooks_ipv4);
 	__netfilter_net_init(net->nf.hooks_ipv6);
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	__netfilter_net_init(net->nf.hooks_arp);
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	__netfilter_net_init(net->nf.hooks_bridge);
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
 	__netfilter_net_init(net->nf.hooks_decnet);
+#endif
 
 #ifdef CONFIG_PROC_FS
 	net->nf.proc_netfilter = proc_net_mkdir(net, "netfilter",
-- 
2.13.6

