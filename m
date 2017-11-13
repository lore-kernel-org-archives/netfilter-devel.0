From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: add ifdefs to avoid memory waste if family is not supported
Date: Mon, 13 Nov 2017 17:41:07 +0100
Message-ID: <20171113164107.11259-5-fw@strlen.de>
References: <20171113164107.11259-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48592 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753802AbdKMQlh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:41:37 -0500
In-Reply-To: <20171113164107.11259-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No need to allocate space for families that are not supported
in the kernel configuration.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h     |  6 ++++++
 include/net/netns/netfilter.h |  6 ++++++
 net/netfilter/core.c          | 12 ++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 48a2f0f93033..da03bfcc5084 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -204,18 +204,24 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_ipv6));
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	case NFPROTO_ARP:
 		BUILD_BUG_ON(__builtin_constant_p(pf) && hook >= ARRAY_SIZE(net->nf.hooks_arp));
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 		break;
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	case NFPROTO_BRIDGE:
 		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_bridge));
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
 		break;
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_decnet));
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
 		break;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		break;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 96b20b872353..2f9b445fe161 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -19,9 +19,15 @@ struct netns_nf {
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	struct nf_hook_entries __rcu *hooks_arp[3];
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	struct nf_hook_entries __rcu *hooks_bridge[6];
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
 	struct nf_hook_entries __rcu *hooks_decnet[7];
+#endif
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index fd5f550dc625..aeb7a4f8f080 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -242,16 +242,22 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	switch (reg->pf) {
 	case NFPROTO_NETDEV:
 		break;
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
 	case NFPROTO_ARP:
 		return net->nf.hooks_arp+reg->hooknum;
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 	case NFPROTO_BRIDGE:
 		return net->nf.hooks_bridge+reg->hooknum;
+#endif
 	case NFPROTO_IPV4:
 		return net->nf.hooks_ipv4+reg->hooknum;
 	case NFPROTO_IPV6:
 		return net->nf.hooks_ipv6+reg->hooknum;
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		return net->nf.hooks_decnet+reg->hooknum;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
@@ -597,9 +603,15 @@ static int __net_init netfilter_net_init(struct net *net)
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

