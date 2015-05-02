From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 06/34] netfilter: ipset: Fix parallel resizing and listing of the same set
Date: Sat,  2 May 2015 19:27:55 +0200
Message-ID: <1430587703-3387-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36668 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When elements added to a hash:* type of set and resizing triggered,
parallel listing could start to list the original set (before resizing)
and "continue" with listing the new set. Fix it by references and
using the original hash table for listing. Therefore the destroying of
the original hash table may happen from the resizing or listing functions.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 13 ++++++----
 net/netfilter/ipset/ip_set_core.c      | 29 ++++++++++++----------
 net/netfilter/ipset/ip_set_hash_gen.h  | 44 ++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index a6b7b58..77789e5 100644
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
@@ -380,12 +383,12 @@ ip_set_init_counter(struct ip_set_counter *counter,
 
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
index a8e55c8..90f1ede 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1177,12 +1177,16 @@ ip_set_swap(struct sock *ctnl, struct sk_buff *skb,
 static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
-	struct ip_set_net *inst = (struct ip_set_net *)cb->args[IPSET_CB_NET];
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
@@ -1213,12 +1217,6 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	nla_parse(cda, IPSET_ATTR_CMD_MAX,
 		  attr, nlh->nlmsg_len - min_len, ip_set_setname_policy);
 
-	/* cb->args[IPSET_CB_NET]:	net namespace
-	 *         [IPSET_CB_DUMP]:	dump single set/all sets
-	 *         [IPSET_CB_INDEX]: 	set index
-	 *         [IPSET_CB_ARG0]:	type specific
-	 */
-
 	if (cda[IPSET_ATTR_SETNAME]) {
 		struct ip_set *set;
 
@@ -1325,6 +1323,8 @@ dump_last:
 				goto release_refcount;
 			if (dump_flags & IPSET_FLAG_LIST_HEADER)
 				goto next_set;
+			if (set->variant->uref)
+				set->variant->uref(set, cb, true);
 			/* Fall through and add elements */
 		default:
 			rcu_read_lock_bh();
@@ -1341,6 +1341,8 @@ dump_last:
 		dump_type = DUMP_LAST;
 		cb->args[IPSET_CB_DUMP] = dump_type | (dump_flags << 16);
 		cb->args[IPSET_CB_INDEX] = 0;
+		if (set && set->variant->uref)
+			set->variant->uref(set, cb, false);
 		goto dump_last;
 	}
 	goto out;
@@ -1355,7 +1357,10 @@ next_set:
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
index a2ca17a..91e5327 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -76,6 +76,8 @@ struct hbucket {
 
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
+	atomic_t ref;		/* References for resizing */
+	atomic_t uref;		/* References for dumping */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	struct hbucket __rcu * bucket[0]; /* hashtable buckets */
 };
@@ -185,6 +187,7 @@ htable_bits(u32 hashsize)
 #undef mtype_del
 #undef mtype_test_cidrs
 #undef mtype_test
+#undef mtype_uref
 #undef mtype_expire
 #undef mtype_resize
 #undef mtype_head
@@ -226,6 +229,7 @@ htable_bits(u32 hashsize)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
 #define mtype_test		IPSET_TOKEN(MTYPE, _test)
+#define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
 #define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
 #define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
 #define mtype_head		IPSET_TOKEN(MTYPE, _head)
@@ -567,6 +571,8 @@ retry:
 
 	spin_lock_bh(&set->lock);
 	orig = __ipset_dereference_protected(h->table, 1);
+	atomic_set(&orig->ref, 1);
+	atomic_inc(&orig->uref);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
@@ -610,6 +616,8 @@ retry:
 						ret = -ENOMEM;
 				}
 				if (ret < 0) {
+					atomic_set(&orig->ref, 0);
+					atomic_dec(&orig->uref);
 					spin_unlock_bh(&set->lock);
 					mtype_ahash_destroy(set, t, false);
 					if (ret == -EAGAIN)
@@ -640,7 +648,11 @@ retry:
 
 	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
 		 orig->htable_bits, orig, t->htable_bits, t);
-	mtype_ahash_destroy(set, orig, false);
+	/* If there's nobody else dumping the table, destroy it */
+	if (atomic_dec_and_test(&orig->uref)) {
+		pr_debug("Table destroy by resize %p\n", orig);
+		mtype_ahash_destroy(set, orig, false);
+	}
 
 out:
 #ifdef IP_SET_HASH_WITH_NETS
@@ -1039,12 +1051,35 @@ nla_put_failure:
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
@@ -1059,11 +1094,11 @@ mtype_list(const struct ip_set *set,
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
@@ -1133,6 +1168,7 @@ static const struct ip_set_type_variant mtype_variant = {
 	.flush	= mtype_flush,
 	.head	= mtype_head,
 	.list	= mtype_list,
+	.uref	= mtype_uref,
 	.resize	= mtype_resize,
 	.same_set = mtype_same_set,
 };
-- 
1.8.5.1

