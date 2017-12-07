From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: don't allocate space for decnet hooks unless needed
Date: Thu,  7 Dec 2017 14:06:19 +0100
Message-ID: <20171207130620.7585-3-fw@strlen.de>
References: <20171207130620.7585-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43586 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754869AbdLGNGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 08:06:50 -0500
In-Reply-To: <20171207130620.7585-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

no need to define hook points if the family isn't supported.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h     | 2 ++
 include/net/netns/netfilter.h | 2 ++
 net/netfilter/core.c          | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9dcbcdfa3b82..ce4e91df8b56 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -219,9 +219,11 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	case NFPROTO_BRIDGE:
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
 		break;
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
 		break;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		break;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 46842a1f77fb..56100800718a 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -23,8 +23,10 @@ struct netns_nf {
 	struct nf_hook_entries __rcu *hooks_arp[3];
 	/* note: 'BROUTE' isn't a real hook (called via function pointer) */
 	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
+#if IS_ENABLED(CONFIG_DECNET)
 	/* also supports a 'HELLO' and 'ROUTE' type */
 	struct nf_hook_entries __rcu *hooks_decnet[NF_INET_NUMHOOKS + 2];
+#endif
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 47e9690aea6e..0a28889835a7 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -283,10 +283,12 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv6) <= reg->hooknum))
 			return NULL;
 		return net->nf.hooks_ipv6 + reg->hooknum;
+#if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_decnet) <= reg->hooknum))
 			return NULL;
 		return net->nf.hooks_decnet + reg->hooknum;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
@@ -573,7 +575,9 @@ static int __net_init netfilter_net_init(struct net *net)
 	__netfilter_net_init(net->nf.hooks_ipv6);
 	__netfilter_net_init(net->nf.hooks_arp);
 	__netfilter_net_init(net->nf.hooks_bridge);
+#if IS_ENABLED(CONFIG_DECNET)
 	__netfilter_net_init(net->nf.hooks_decnet);
+#endif
 
 #ifdef CONFIG_PROC_FS
 	net->nf.proc_netfilter = proc_net_mkdir(net, "netfilter",
-- 
2.13.6

