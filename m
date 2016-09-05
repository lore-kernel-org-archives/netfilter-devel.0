From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/29] netfilter: restart search if moved to other chain
Date: Mon,  5 Sep 2016 12:58:36 +0200
Message-ID: <1473073124-5015-22-git-send-email-pablo@netfilter.org>
References: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case nf_conntrack_tuple_taken did not find a conflicting entry
check that all entries in this hash slot were tested and restart
in case an entry was moved to another chain.

Reported-by: Eric Dumazet <edumazet@google.com>
Fixes: ea781f197d6a ("netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of call_rcu()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
