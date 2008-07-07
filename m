From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/13: nf_conntrack: add allocation flag to nf_conntrack_alloc
Date: Mon,  7 Jul 2008 14:05:19 +0200 (MEST)
Message-ID: <20080707120518.4975.19386.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58372 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYGGMFU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:20 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack: add allocation flag to nf_conntrack_alloc

ctnetlink does not need to allocate the conntrack entries with GFP_ATOMIC
as its code is executed in user context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fb5471afe6b8e29f1319ca85ecc830f6b8b54143
tree 87f3fb0f9a0a1f50795dcde601891c35c99228dd
parent 8b373c6315ac2b28c32ba26fd24a47b28d489b0b
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 07 Jul 2008 13:00:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:16 +0200

 include/net/netfilter/nf_conntrack.h |    3 ++-
 net/netfilter/nf_conntrack_core.c    |    7 ++++---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d77dec7..d5d76ec 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -258,7 +258,8 @@ nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
 nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
-		   const struct nf_conntrack_tuple *repl);
+		   const struct nf_conntrack_tuple *repl,
+		   gfp_t gfp);
 
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int nf_ct_is_confirmed(struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f27c992..212a088 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -464,7 +464,8 @@ static noinline int early_drop(unsigned int hash)
 }
 
 struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
-				   const struct nf_conntrack_tuple *repl)
+				   const struct nf_conntrack_tuple *repl,
+				   gfp_t gfp)
 {
 	struct nf_conn *ct = NULL;
 
@@ -489,7 +490,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		}
 	}
 
-	ct = kmem_cache_zalloc(nf_conntrack_cachep, GFP_ATOMIC);
+	ct = kmem_cache_zalloc(nf_conntrack_cachep, gfp);
 	if (ct == NULL) {
 		pr_debug("nf_conntrack_alloc: Can't alloc conntrack.\n");
 		atomic_dec(&nf_conntrack_count);
@@ -542,7 +543,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		return NULL;
 	}
 
-	ct = nf_conntrack_alloc(tuple, &repl_tuple);
+	ct = nf_conntrack_alloc(tuple, &repl_tuple, GFP_ATOMIC);
 	if (ct == NULL || IS_ERR(ct)) {
 		pr_debug("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)ct;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 63c4e1f..dd23339 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1128,7 +1128,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
 
-	ct = nf_conntrack_alloc(otuple, rtuple);
+	ct = nf_conntrack_alloc(otuple, rtuple, GFP_KERNEL);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;
 
