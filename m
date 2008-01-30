From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 40/69]: nf_conntrack: optimize __nf_conntrack_find()
Date: Wed, 30 Jan 2008 21:17:56 +0100 (MET)
Message-ID: <20080130201754.29874.91390.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765777AbYA3UR5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:57 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: optimize __nf_conntrack_find()

Ignoring specific entries in __nf_conntrack_find() is only needed by NAT
for nf_conntrack_tuple_taken(). Remove it from __nf_conntrack_find()
and make nf_conntrack_tuple_taken() search the hash itself.

Saves 54 bytes of text in the hotpath on x86_64:

  __nf_conntrack_find      |  -54 # 321 -> 267, # inlines: 3 -> 2, size inlines: 181 -> 127
  nf_conntrack_tuple_taken | +305 # 15 -> 320, lexblocks: 0 -> 3, # inlines: 0 -> 3, size inlines: 0 -> 181
  nf_conntrack_find_get    |   -2 # 90 -> 88
 3 functions changed, 305 bytes added, 56 bytes removed, diff: +249

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 419fd8e88eba9f4c35fd1bdc27aaa22578f202fb
tree a1a0c6ac4b3543a127ee27cad47d5b4aa77862ec
parent 0d9d7643b39dae81d0b16b54365d7985a278227f
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:13 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:07 +0100

 include/net/netfilter/nf_conntrack.h |    3 +--
 net/netfilter/nf_conntrack_core.c    |   22 +++++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c |    6 +++---
 net/netfilter/xt_connlimit.c         |    2 +-
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 561ae76..14e0cc8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -178,8 +178,7 @@ extern void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced,
 				 unsigned int size);
 
 extern struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
-		    const struct nf_conn *ignored_conntrack);
+__nf_conntrack_find(const struct nf_conntrack_tuple *tuple);
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f284ddd..ce4c4ba 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -246,16 +246,14 @@ static void death_by_timeout(unsigned long ul_conntrack)
 }
 
 struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
-		    const struct nf_conn *ignored_conntrack)
+__nf_conntrack_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_node *n;
 	unsigned int hash = hash_conntrack(tuple);
 
 	hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash], hnode) {
-		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
-		    nf_ct_tuple_equal(tuple, &h->tuple)) {
+		if (nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
 			return h;
 		}
@@ -274,7 +272,7 @@ nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple)
 	struct nf_conn *ct;
 
 	rcu_read_lock();
-	h = __nf_conntrack_find(tuple, NULL);
+	h = __nf_conntrack_find(tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
@@ -395,12 +393,22 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 const struct nf_conn *ignored_conntrack)
 {
 	struct nf_conntrack_tuple_hash *h;
+	struct hlist_node *n;
+	unsigned int hash = hash_conntrack(tuple);
 
 	rcu_read_lock();
-	h = __nf_conntrack_find(tuple, ignored_conntrack);
+	hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash], hnode) {
+		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
+		    nf_ct_tuple_equal(tuple, &h->tuple)) {
+			NF_CT_STAT_INC(found);
+			rcu_read_unlock();
+			return 1;
+		}
+		NF_CT_STAT_INC(searched);
+	}
 	rcu_read_unlock();
 
-	return h != NULL;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b6a8c08..bf86fdd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1222,9 +1222,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	spin_lock_bh(&nf_conntrack_lock);
 	if (cda[CTA_TUPLE_ORIG])
-		h = __nf_conntrack_find(&otuple, NULL);
+		h = __nf_conntrack_find(&otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = __nf_conntrack_find(&rtuple, NULL);
+		h = __nf_conntrack_find(&rtuple);
 
 	if (h == NULL) {
 		struct nf_conntrack_tuple master;
@@ -1239,7 +1239,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			if (err < 0)
 				goto out_unlock;
 
-			master_h = __nf_conntrack_find(&master, NULL);
+			master_h = __nf_conntrack_find(&master);
 			if (master_h == NULL) {
 				err = -ENOENT;
 				goto out_unlock;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index f9b59a6..3b01119 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -124,7 +124,7 @@ static int count_them(struct xt_connlimit_data *data,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, tmp, hash, list) {
-		found    = __nf_conntrack_find(&conn->tuple, NULL);
+		found    = __nf_conntrack_find(&conn->tuple);
 		found_ct = NULL;
 
 		if (found != NULL)
