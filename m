From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: Use bool type instead of int as the return value of nf_conntrack_tuple_taken and nf_nat_used_tuple
Date: Tue,  7 Mar 2017 12:28:55 +0800
Message-ID: <1488860935-525-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg340.qq.com ([14.17.44.35]:60189 "EHLO smtpbg340.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753408AbdCGElb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 23:41:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

These two functions return 1/0 as true or false, so it could use bool
type directly instead of int.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 include/net/netfilter/nf_nat.h       | 2 +-
 net/netfilter/nf_conntrack_core.c    | 6 +++---
 net/netfilter/nf_nat_core.c          | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

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
index 94b14c5..887a08e 100644
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
-- 
1.9.1


