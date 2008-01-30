From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 35/69]: nf_conntrack: use RCU for conntrack helpers
Date: Wed, 30 Jan 2008 21:17:48 +0100 (MET)
Message-ID: <20080130201746.29874.18916.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60733 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765446AbYA3URv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:51 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: use RCU for conntrack helpers

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4e4ce3f8b47acaf70dc99ce8c50fe64e4f1a098f
tree f39893b7e3ff63a4aa51dd5f15f3887a3831bf61
parent 717ef6587331d45fecc0d1fa2a9f473f9d9ae1c9
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:10 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:06 +0100

 include/net/netfilter/nf_conntrack_helper.h |    4 --
 net/netfilter/nf_conntrack_helper.c         |   58 ++++++++-------------------
 net/netfilter/nf_conntrack_netlink.c        |    9 ++--
 3 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 2f3af00..4ca125e 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -43,12 +43,8 @@ extern struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
 
 extern struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
-
-extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
 
-extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 96aa637..42f781f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -28,6 +28,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
+static DEFINE_MUTEX(nf_ct_helper_mutex);
 static struct hlist_head *nf_ct_helper_hash __read_mostly;
 static unsigned int nf_ct_helper_hsize __read_mostly;
 static unsigned int nf_ct_helper_count __read_mostly;
@@ -54,42 +55,13 @@ __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 		return NULL;
 
 	h = helper_hash(tuple);
-	hlist_for_each_entry(helper, n, &nf_ct_helper_hash[h], hnode) {
+	hlist_for_each_entry_rcu(helper, n, &nf_ct_helper_hash[h], hnode) {
 		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
 			return helper;
 	}
 	return NULL;
 }
-
-struct nf_conntrack_helper *
-nf_ct_helper_find_get(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_helper *helper;
-
-	/* need nf_conntrack_lock to assure that helper exists until
-	 * try_module_get() is called */
-	read_lock_bh(&nf_conntrack_lock);
-
-	helper = __nf_ct_helper_find(tuple);
-	if (helper) {
-		/* need to increase module usage count to assure helper will
-		 * not go away while the caller is e.g. busy putting a
-		 * conntrack in the hash that uses the helper */
-		if (!try_module_get(helper->me))
-			helper = NULL;
-	}
-
-	read_unlock_bh(&nf_conntrack_lock);
-
-	return helper;
-}
-EXPORT_SYMBOL_GPL(nf_ct_helper_find_get);
-
-void nf_ct_helper_put(struct nf_conntrack_helper *helper)
-{
-	module_put(helper->me);
-}
-EXPORT_SYMBOL_GPL(nf_ct_helper_put);
+EXPORT_SYMBOL_GPL(__nf_ct_helper_find);
 
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name)
@@ -99,7 +71,7 @@ __nf_conntrack_helper_find_byname(const char *name)
 	unsigned int i;
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry(h, n, &nf_ct_helper_hash[i], hnode) {
+		hlist_for_each_entry_rcu(h, n, &nf_ct_helper_hash[i], hnode) {
 			if (!strcmp(h->name, name))
 				return h;
 		}
@@ -140,10 +112,10 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 
 	BUG_ON(me->timeout == 0);
 
-	write_lock_bh(&nf_conntrack_lock);
-	hlist_add_head(&me->hnode, &nf_ct_helper_hash[h]);
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_helper_mutex);
 
 	return 0;
 }
@@ -156,10 +128,17 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	struct hlist_node *n, *next;
 	unsigned int i;
 
-	/* Need write lock here, to delete helper. */
-	write_lock_bh(&nf_conntrack_lock);
-	hlist_del(&me->hnode);
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
 	nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	/* Make sure every nothing is still using the helper unless its a
+	 * connection in the hash.
+	 */
+	synchronize_rcu();
+
+	write_lock_bh(&nf_conntrack_lock);
 
 	/* Get rid of expectations */
 	for (i = 0; i < nf_ct_expect_hsize; i++) {
@@ -182,9 +161,6 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 			unhelp(h, me);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
-
-	/* Someone could be still looking at the helper in a bh. */
-	synchronize_net();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bdae292..b6c0935 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1167,11 +1167,12 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
 #endif
 
-	helper = nf_ct_helper_find_get(rtuple);
+	rcu_read_lock();
+	helper = __nf_ct_helper_find(rtuple);
 	if (helper) {
 		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 		if (help == NULL) {
-			nf_ct_helper_put(helper);
+			rcu_read_unlock();
 			err = -ENOMEM;
 			goto err;
 		}
@@ -1187,9 +1188,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
-
-	if (helper)
-		nf_ct_helper_put(helper);
+	rcu_read_unlock();
 
 	return 0;
 
