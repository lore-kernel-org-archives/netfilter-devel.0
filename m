From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: reduce hook array sizes to what is needed
Date: Mon, 13 Nov 2017 17:41:06 +0100
Message-ID: <20171113164107.11259-4-fw@strlen.de>
References: <20171113164107.11259-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48590 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753802AbdKMQle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:41:34 -0500
In-Reply-To: <20171113164107.11259-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not all families share the same hook count.
Previous patch added build-time assert so reduce to what is
needed.

Can't use the corresponding ARP, BRIDGE, DECNET defines
because they sit in uapi headers and including them causes
various build failures.

ARP BUILD_BUG_ON test now needs a 'builtin_constant_p' guard.
A few call sites call nf_hook() with a non-compile-time-value
in POST_ROUTING (which doesn't exist in ARP family) with.

In this case the BUILD_BUG_ON will trigger, so elide them there.

struct net before:
/* size: 4672, cachelines: 73, members: 46 */
after:
/* size: 4544, cachelines: 71, members: 46 */

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h     |  2 +-
 include/net/netns/netfilter.h | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2e9896d42f96..48a2f0f93033 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -205,7 +205,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
 	case NFPROTO_ARP:
-		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_arp));
+		BUILD_BUG_ON(__builtin_constant_p(pf) && hook >= ARRAY_SIZE(net->nf.hooks_arp));
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 		break;
 	case NFPROTO_BRIDGE:
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index b39c563c2fce..96b20b872353 100644
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
+	struct nf_hook_entries __rcu *hooks_arp[3];
+	struct nf_hook_entries __rcu *hooks_bridge[6];
+	struct nf_hook_entries __rcu *hooks_decnet[7];
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	bool			defrag_ipv4;
 #endif
-- 
2.13.6

