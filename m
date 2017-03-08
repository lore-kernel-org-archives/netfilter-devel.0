From: fgao@ikuai8.com
Subject: [PATCH nf-next v2 1/1] netfilter: Use bool type instead of int as the return type of some functions
Date: Wed,  8 Mar 2017 09:59:51 +0800
Message-ID: <1488938391-38965-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg328.qq.com ([14.17.43.160]:46736 "EHLO smtpbg328.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756425AbdCHCBZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 21:01:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

These functions return 1 and 0 as true and false, so it could use bool
type directly instead of int.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Convert the return type of other functions in nf_nat_core.c
 v1: Initial version

 include/net/netfilter/nf_conntrack.h |  2 +-
 include/net/netfilter/nf_nat.h       |  2 +-
 net/netfilter/nf_conntrack_core.c    |  6 +++---
 net/netfilter/nf_nat_core.c          | 22 +++++++++++-----------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f540f9a..32a0394 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -160,7 +160,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 
 /* Is this tuple taken? (ignoring any belonging to the given
    conntrack). */
-int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
+bool nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
 #define NFCT_INFOMASK	7UL
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index c327a43..cfcf25d 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -48,7 +48,7 @@ extern unsigned int nf_nat_alloc_null_binding(struct nf_conn *ct,
 struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct);
 
 /* Is this tuple already taken? (not by us)*/
-int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
+bool nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_conntrack);
 
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 071b97f..b0eaa24 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -837,7 +837,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 
 /* Returns true if a connection correspondings to the tuple (required
    for NAT). */
-int
+bool
 nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 const struct nf_conn *ignored_conntrack)
 {
@@ -870,7 +870,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 		if (nf_ct_key_equal(h, tuple, zone, net)) {
 			NF_CT_STAT_INC_ATOMIC(net, found);
 			rcu_read_unlock();
-			return 1;
+			return true;
 		}
 	}
 
@@ -881,7 +881,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 
 	rcu_read_unlock();
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 94b14c5..921629f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -135,7 +135,7 @@ static u32 nf_nat_bysource_hash(const void *data, u32 len, u32 seed)
 }
 
 /* Is this tuple already taken? (not by us) */
-int
+bool
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 		  const struct nf_conn *ignored_conntrack)
 {
@@ -155,27 +155,27 @@ static u32 nf_nat_bysource_hash(const void *data, u32 len, u32 seed)
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_nat_l3proto *l3proto,
-		    const struct nf_nat_l4proto *l4proto,
-		    const struct nf_conntrack_tuple *tuple,
-		    const struct nf_nat_range *range)
+static bool in_range(const struct nf_nat_l3proto *l3proto,
+		     const struct nf_nat_l4proto *l4proto,
+		     const struct nf_conntrack_tuple *tuple,
+		     const struct nf_nat_range *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
 	 * range specified, otherwise let this drag us onto a new src IP.
 	 */
 	if (range->flags & NF_NAT_RANGE_MAP_IPS &&
 	    !l3proto->in_range(tuple, range))
-		return 0;
+		return false;
 
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) ||
 	    l4proto->in_range(tuple, NF_NAT_MANIP_SRC,
 			      &range->min_proto, &range->max_proto))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static inline int
+static inline bool
 same_src(const struct nf_conn *ct,
 	 const struct nf_conntrack_tuple *tuple)
 {
@@ -210,7 +210,7 @@ static int nf_nat_bysource_cmp(struct rhashtable_compare_arg *arg,
 };
 
 /* Only called for SRC manip */
-static int
+static bool
 find_appropriate_src(struct net *net,
 		     const struct nf_conntrack_zone *zone,
 		     const struct nf_nat_l3proto *l3proto,
@@ -230,7 +230,7 @@ static int nf_nat_bysource_cmp(struct rhashtable_compare_arg *arg,
 	hl = rhltable_lookup(&nf_nat_bysource_table, &key,
 			     nf_nat_bysource_params);
 	if (!hl)
-		return 0;
+		return false;
 
 	ct = container_of(hl, typeof(*ct), nat_bysource);
 
-- 
1.9.1


