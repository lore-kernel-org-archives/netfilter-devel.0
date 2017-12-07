From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 2/5] netfilter: reduce hook array sizes to what is needed
Date: Thu,  7 Dec 2017 16:28:24 +0100
Message-ID: <20171207152827.24317-3-fw@strlen.de>
References: <20171207152827.24317-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45018 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750779AbdLGP24 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 10:28:56 -0500
In-Reply-To: <20171207152827.24317-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not all families share the same hook count, adjust sizes to what is
needed.

struct net before:
/* size: 6592, cachelines: 103, members: 46 */
after:
/* size: 5952, cachelines: 93, members: 46 */

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 changes since v2:
  - use ARP/DN defines instead of magic number in struct netns_nf
  - fix __netfilter_net_init to use correct size, not NF_MAX_HOOKS

 include/net/netns/netfilter.h | 10 +++++-----
 net/netfilter/core.c          | 24 +++++++++++++++++-------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index b39c563c2fce..8f756a4b9205 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -17,11 +17,11 @@ struct netns_nf {
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
+	struct nf_hook_entries __rcu *hooks_arp[NF_ARP_NUMHOOKS];
+	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
+	struct nf_hook_entries __rcu *hooks_decnet[NF_DN_NUMHOOKS];
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a6eaaf303be8..43643427b560 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -268,14 +268,24 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	case NFPROTO_NETDEV:
 		break;
 	case NFPROTO_ARP:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_arp) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_arp + reg->hooknum;
 	case NFPROTO_BRIDGE:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_bridge) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_bridge + reg->hooknum;
 	case NFPROTO_IPV4:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_ipv4 + reg->hooknum;
 	case NFPROTO_IPV6:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv6) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_ipv6 + reg->hooknum;
 	case NFPROTO_DECNET:
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_decnet) <= reg->hooknum))
+			return NULL;
 		return net->nf.hooks_decnet + reg->hooknum;
 	default:
 		WARN_ON_ONCE(1);
@@ -549,21 +559,21 @@ void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
 EXPORT_SYMBOL(nf_nat_decode_session_hook);
 #endif
 
-static void __net_init __netfilter_net_init(struct nf_hook_entries *e[NF_MAX_HOOKS])
+static void __net_init __netfilter_net_init(struct nf_hook_entries **e, int max)
 {
 	int h;
 
-	for (h = 0; h < NF_MAX_HOOKS; h++)
+	for (h = 0; h < max; h++)
 		RCU_INIT_POINTER(e[h], NULL);
 }
 
 static int __net_init netfilter_net_init(struct net *net)
 {
-	__netfilter_net_init(net->nf.hooks_ipv4);
-	__netfilter_net_init(net->nf.hooks_ipv6);
-	__netfilter_net_init(net->nf.hooks_arp);
-	__netfilter_net_init(net->nf.hooks_bridge);
-	__netfilter_net_init(net->nf.hooks_decnet);
+	__netfilter_net_init(net->nf.hooks_ipv4, ARRAY_SIZE(net->nf.hooks_ipv4));
+	__netfilter_net_init(net->nf.hooks_ipv6, ARRAY_SIZE(net->nf.hooks_ipv6));
+	__netfilter_net_init(net->nf.hooks_arp, ARRAY_SIZE(net->nf.hooks_arp));
+	__netfilter_net_init(net->nf.hooks_bridge, ARRAY_SIZE(net->nf.hooks_bridge));
+	__netfilter_net_init(net->nf.hooks_decnet, ARRAY_SIZE(net->nf.hooks_decnet));
 
 #ifdef CONFIG_PROC_FS
 	net->nf.proc_netfilter = proc_net_mkdir(net, "netfilter",
-- 
2.13.6

