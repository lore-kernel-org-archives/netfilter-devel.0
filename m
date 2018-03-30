From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 23/47] netfilter: conncount: Support count only use case
Date: Fri, 30 Mar 2018 13:43:10 +0200
Message-ID: <20180330114334.18664-4-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

Currently, nf_conncount_count() counts the number of connections that
matches key and inserts a conntrack 'tuple' with the same key into the
accounting data structure.  This patch supports another use case that only
counts the number of connections where 'tuple' is not provided.  Therefore,
proper changes are made on nf_conncount_count() to support the case where
'tuple' is NULL.  This could be useful for querying statistics or
debugging purpose.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 9305a08b4422..153e690e2893 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -104,7 +104,7 @@ static unsigned int check_hlist(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int length = 0;
 
-	*addit = true;
+	*addit = tuple ? true : false;
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
@@ -117,7 +117,7 @@ static unsigned int check_hlist(struct net *net,
 
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
-		if (nf_ct_tuple_equal(&conn->tuple, tuple)) {
+		if (tuple && nf_ct_tuple_equal(&conn->tuple, tuple)) {
 			/*
 			 * Just to be sure we have it only once in the list.
 			 * We should not see tuples twice unless someone hooks
@@ -220,6 +220,9 @@ count_tree(struct net *net, struct rb_root *root,
 		goto restart;
 	}
 
+	if (!tuple)
+		return 0;
+
 	/* no match, need to insert new node */
 	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
 	if (rbconn == NULL)
@@ -242,6 +245,9 @@ count_tree(struct net *net, struct rb_root *root,
 	return 1;
 }
 
+/* Count and return number of conntrack entries in 'net' with particular 'key'.
+ * If 'tuple' is not null, insert it into the accounting data structure.
+ */
 unsigned int nf_conncount_count(struct net *net,
 				struct nf_conncount_data *data,
 				const u32 *key,
-- 
2.11.0
