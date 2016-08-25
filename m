From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 1/7] netfilter: restart search if moved to other chain
Date: Thu, 25 Aug 2016 15:33:29 +0200
Message-ID: <1472132015-10264-2-git-send-email-fw@strlen.de>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932996AbcHYNd2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 09:33:28 -0400
In-Reply-To: <1472132015-10264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case nf_conntrack_tuple_taken did not find a conflicting entry
check that all entries in this hash slot were tested and restart
in case an entry was moved to another chain.

Reported-by: Eric Dumazet <edumazet@google.com>
Fixes: ea781f197d6a ("netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of call_rcu()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_conntrack_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7d90a5d..887926a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -809,6 +809,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_conntrack);
 
 	rcu_read_lock();
+ begin:
 	nf_conntrack_get_ht(&ct_hash, &hsize);
 	hash = __hash_conntrack(net, tuple, hsize);
 
@@ -822,6 +823,12 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		}
 		NF_CT_STAT_INC_ATOMIC(net, searched);
 	}
+
+	if (get_nulls_value(n) != hash) {
+		NF_CT_STAT_INC_ATOMIC(net, search_restart);
+		goto begin;
+	}
+
 	rcu_read_unlock();
 
 	return 0;
-- 
2.7.3

