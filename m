From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/10] netfilter: ipset: Fix parallel resizing and listing of the same set
Date: Mon, 24 Nov 2014 21:46:52 +0100
Message-ID: <1416862012-31139-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51377 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaKXUqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:46:00 -0500
In-Reply-To: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When elements added to a hash:* type of set and resizing triggered,
parallel listing could start to list the original set (before resizing)
and "continue" with listing the new set. Fix it by references and
using the original hash table for listing. Therefore the destroying
the original hash table may happen from the resizing or listing functions.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 13 ++++++----
 net/netfilter/ipset/ip_set_core.c      | 30 +++++++++++++----------
 net/netfilter/ipset/ip_set_hash_gen.h  | 44 ++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b0cfe42..42c6ce0 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -176,6 +176,9 @@ struct ip_set_type_variant {
 	/* List elements */
 	int (*list)(const struct ip_set *set, struct sk_buff *skb,
 		    struct netlink_callback *cb);
+	/* Keep listing private when resizing runs parallel */
+	void (*uref)(struct ip_set *set, struct netlink_callback *cb,
+		     bool start);
 
 	/* Return true if "b" set is the same as "a"
 	 * according to the create set parameters */
@@ -423,12 +426,12 @@ ip_set_init_counter(struct ip_set_counter *counter,
 
 /* Netlink CB args */
 enum {
-	IPSET_CB_NET = 0,
-	IPSET_CB_DUMP,
-	IPSET_CB_INDEX,
-	IPSET_CB_ARG0,
+	IPSET_CB_NET = 0,	/* net namespace */
+	IPSET_CB_DUMP,		/* dump single set/all sets */
+	IPSET_CB_INDEX,		/* set index */
+	IPSET_CB_PRIVATE,	/* set private data */
+	IPSET_CB_ARG0,		/* type specific */
 	IPSET_CB_ARG1,
-	IPSET_CB_ARG2,
 };
 
 /* register and unregister set references */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 957ec91..5dafbb7 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1179,13 +1179,16 @@ ip_set_swap(struct sock *ctnl, struct sk_buff *skb,
 static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
-	struct ip_set_net *inst = (struct ip_set_net *)cb->args[IPSET_CB_NET];
-
 	if (cb->args[IPSET_CB_ARG0]) {
-		pr_debug("release set %s\n",
-			 ip_set(inst, cb->args[IPSET_CB_INDEX])->name);
-		__ip_set_put_byindex(inst,
-			(ip_set_id_t) cb->args[IPSET_CB_INDEX]);
+		struct ip_set_net *inst =
+			(struct ip_set_net *)cb->args[IPSET_CB_NET];
+		ip_set_id_t index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
+		struct ip_set *set = ip_set(inst, index);
+
+		if (set->variant->uref)
+			set->variant->uref(set, cb, false);
+		pr_debug("release set %s\n", set->name);
+		__ip_set_put_byindex(inst, index);
 	}
 	return 0;
 }
@@ -1216,12 +1219,6 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	nla_parse(cda, IPSET_ATTR_CMD_MAX,
 		  attr, nlh->nlmsg_len - min_len, ip_set_setname_policy);
 
-	/* cb->args[IPSET_CB_NET]:	net namespace
-	 *         [IPSET_CB_DUMP]:	dump single set/all sets
-	 *         [IPSET_CB_INDEX]:	set index
-	 *         [IPSET_CB_ARG0]:	type specific
-	 */
-
 	if (cda[IPSET_ATTR_SETNAME]) {
 		struct ip_set *set;
 
@@ -1329,6 +1326,8 @@ dump_last:
 				goto release_refcount;
 			if (dump_flags & IPSET_FLAG_LIST_HEADER)
 				goto next_set;
+			if (set->variant->uref)
+				set->variant->uref(set, cb, true);
 			/* Fall through and add elements */
 		default:
 			rcu_read_lock_bh();
@@ -1345,6 +1344,8 @@ dump_last:
 		dump_type = DUMP_LAST;
 		cb->args[IPSET_CB_DUMP] = dump_type | (dump_flags << 16);
 		cb->args[IPSET_CB_INDEX] = 0;
+		if (set && set->variant->uref)
+			set->variant->uref(set, cb, false);
 		goto dump_last;
 	}
 	goto out;
@@ -1359,7 +1360,10 @@ next_set:
 release_refcount:
 	/* If there was an error or set is done, release set */
 	if (ret || !cb->args[IPSET_CB_ARG0]) {
-		pr_debug("release set %s\n", ip_set(inst, index)->name);
+		set = ip_set(inst, index);
+		if (set->variant->uref)
+			set->variant->uref(set, cb, false);
+		pr_debug("release set %s\n", set->name);
 		__ip_set_put_byindex(inst, index);
 		cb->args[IPSET_CB_ARG0] = 0;
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index f889d98..6ac789b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -75,6 +75,8 @@ struct hbucket {
 
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
+	atomic_t ref;		/* References for resizing */
+	atomic_t uref;		/* References for dumping */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	struct hbucket * __rcu bucket[0]; /* hashtable buckets */
 };
@@ -184,6 +186,7 @@ htable_bits(u32 hashsize)
 #undef mtype_del
 #undef mtype_test_cidrs
 #undef mtype_test
+#undef mtype_uref
 #undef mtype_expire
 #undef mtype_resize
 #undef mtype_head
@@ -225,6 +228,7 @@ htable_bits(u32 hashsize)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
 #define mtype_test		IPSET_TOKEN(MTYPE, _test)
+#define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
 #define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
 #define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
 #define mtype_head		IPSET_TOKEN(MTYPE, _head)
@@ -562,6 +566,8 @@ retry:
 
 	spin_lock_bh(&set->lock);
 	orig = h->table;
+	atomic_set(&orig->ref, 1);
+	atomic_inc(&orig->uref);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
@@ -605,6 +611,8 @@ retry:
 						ret = -ENOMEM;
 				}
 				if (ret < 0) {
+					atomic_set(&orig->ref, 0);
+					atomic_dec(&orig->uref);
 					spin_unlock_bh(&set->lock);
 					mtype_ahash_destroy(set, t, false);
 					if (ret == -EAGAIN)
@@ -634,7 +642,11 @@ retry:
 
 	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
 		 orig->htable_bits, orig, t->htable_bits, t);
-	mtype_ahash_destroy(set, orig, false);
+	/* If there's nobody else dumping the table, destroy it */
+	if (atomic_dec_and_test(&orig->uref)) {
+		pr_debug("Table destroy by resize %p\n", orig);
+		mtype_ahash_destroy(set, orig, false);
+	}
 
 	return 0;
 
@@ -1032,12 +1044,35 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+/* Make possible to run dumping parallel with resizing */
+static void
+mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
+{
+	struct htype *h = set->data;
+	struct htable *t;
+
+	if (start) {
+		rcu_read_lock_bh();
+		t = rcu_dereference_bh_nfnl(h->table);
+		atomic_inc(&t->uref);
+		cb->args[IPSET_CB_PRIVATE] = (unsigned long) t;
+		rcu_read_unlock_bh();
+	} else if (cb->args[IPSET_CB_PRIVATE]) {
+		t = (struct htable *) cb->args[IPSET_CB_PRIVATE];
+		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+			/* Resizing didn't destroy the hash table */
+			pr_debug("Table destroy by dump: %p\n", t);
+			mtype_ahash_destroy(set, t, false);
+		}
+		cb->args[IPSET_CB_PRIVATE] = 0;
+	}
+}
+
 /* Reply a LIST/SAVE request: dump the elements of the specified set */
 static int
 mtype_list(const struct ip_set *set,
 	   struct sk_buff *skb, struct netlink_callback *cb)
 {
-	const struct htype *h = set->data;
 	const struct htable *t;
 	struct nlattr *atd, *nested;
 	const struct hbucket *n;
@@ -1052,11 +1087,11 @@ mtype_list(const struct ip_set *set,
 		return -EMSGSIZE;
 
 	pr_debug("list hash set %s\n", set->name);
-	t = rcu_dereference_bh_nfnl(h->table);
+	t = (const struct htable *) cb->args[IPSET_CB_PRIVATE];
 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
 	     cb->args[IPSET_CB_ARG0]++) {
 		incomplete = skb_tail_pointer(skb);
-		n = rcu_dereference_bh(hbucket(t, cb->args[IPSET_CB_ARG0]));
+		n = hbucket(t, cb->args[IPSET_CB_ARG0]);
 		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
 			 cb->args[IPSET_CB_ARG0], t, n);
 		if (n == NULL)
@@ -1126,6 +1161,7 @@ static const struct ip_set_type_variant mtype_variant = {
 	.flush	= mtype_flush,
 	.head	= mtype_head,
 	.list	= mtype_list,
+	.uref	= mtype_uref,
 	.resize	= mtype_resize,
 	.same_set = mtype_same_set,
 };
-- 
1.8.5.1

