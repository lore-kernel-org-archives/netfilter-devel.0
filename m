From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: reduce hook array sizes to what is needed
Date: Thu,  7 Dec 2017 14:06:18 +0100
Message-ID: <20171207130620.7585-2-fw@strlen.de>
References: <20171207130620.7585-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43582 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754538AbdLGNGr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 08:06:47 -0500
In-Reply-To: <20171207130620.7585-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not all families share the same hook count.

Can't use the corresponding ARP, BRIDGE, DECNET defines because they are
defined in uapi headers and including them causes build failures.

struct net before:
/* size: 6592, cachelines: 103, members: 46 */
after:
/* size: 5952, cachelines: 93, members: 46 */

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netns/netfilter.h | 13 ++++++++-----
 net/netfilter/core.c          | 10 ++++++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index b39c563c2fce..46842a1f77fb 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -17,11 +17,14 @@ struct netns_nf {
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
+	/* in/out/forward only */
+	struct nf_hook_entries __rcu *hooks_arp[3];
+	/* note: 'BROUTE' isn't a real hook (called via function pointer) */
+	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
+	/* also supports a 'HELLO' and 'ROUTE' type */
+	struct nf_hook_entries __rcu *hooks_decnet[NF_INET_NUMHOOKS + 2];
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a6eaaf303be8..47e9690aea6e 100644
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
-- 
2.13.6

