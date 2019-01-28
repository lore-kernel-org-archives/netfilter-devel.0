From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/33] netfilter: nat: un-export nf_nat_used_tuple
Date: Tue, 29 Jan 2019 00:57:42 +0100
Message-ID: <20190128235750.18412-26-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Not used since 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h | 4 ----
 net/netfilter/nf_nat_core.c    | 3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index a17eb2f8d40e..8aff77cafb8b 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -47,10 +47,6 @@ extern unsigned int nf_nat_alloc_null_binding(struct nf_conn *ct,
 
 struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct);
 
-/* Is this tuple already taken? (not by us)*/
-int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
-		      const struct nf_conn *ignored_conntrack);
-
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
 #if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 44f97b3a215a..35e61038ae96 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -146,7 +146,7 @@ hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
 }
 
 /* Is this tuple already taken? (not by us) */
-int
+static int
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		  const struct nf_conn *ignored_conntrack)
 {
@@ -161,7 +161,6 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 	nf_ct_invert_tuple(&reply, tuple);
 	return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
-EXPORT_SYMBOL(nf_nat_used_tuple);
 
 static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
 				 const struct nf_nat_range2 *range)
-- 
2.11.0
