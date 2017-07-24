From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: conntrack: destroy functions need to free queued packets
Date: Mon, 24 Jul 2017 18:57:23 +0200
Message-ID: <20170724165724.10576-4-fw@strlen.de>
References: <20170724165724.10576-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48308 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932731AbdGXQ5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 12:57:12 -0400
In-Reply-To: <20170724165724.10576-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

queued skbs might be using conntrack extensions that are being removed,
such as timeout.  This happens for skbs that have a skb->nfct in
unconfirmed state (i.e., not in hash table yet).

This is destructive, but there are only two use cases:
 - module removal (rare)
 - netns cleanup (most likely no conntracks exist, and if they do,
   they are removed anyway later on).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 4 ++++
 net/netfilter/nf_queue.c          | 1 +
 2 files changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c8b87eaa17a2..258077980a93 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -56,6 +56,8 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netns/hash.h>
 
+#include "nf_internals.h"
+
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
 int (*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
@@ -1695,6 +1697,7 @@ void nf_ct_unconfirmed_destroy(struct net *net)
 
 	if (atomic_read(&net->ct.count) > 0) {
 		__nf_ct_unconfirmed_destroy(net);
+		nf_queue_nf_hook_drop(net);
 		synchronize_net();
 	}
 }
@@ -1740,6 +1743,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 		if (atomic_read(&net->ct.count) == 0)
 			continue;
 		__nf_ct_unconfirmed_destroy(net);
+		nf_queue_nf_hook_drop(net);
 	}
 	rtnl_unlock();
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 043850c9d154..4f4d80a58fb5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -109,6 +109,7 @@ unsigned int nf_queue_nf_hook_drop(struct net *net)
 
 	return count;
 }
+EXPORT_SYMBOL_GPL(nf_queue_nf_hook_drop);
 
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		      struct nf_hook_entry *hook_entry, unsigned int queuenum)
-- 
2.13.0

