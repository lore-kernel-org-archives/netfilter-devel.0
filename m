From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Fix conntrack iteration.
Date: Fri, 24 Dec 2004 22:35:57 +1100
Message-ID: <1103888157.4000.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Found this bug while searching for another.  Potential crash on unload
(unlikely though, unless packets are queued).

Name: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Several places use ip_ct_selective_cleanup() as a general iterator,
which it was not intended for (it takes a const ip_conntrack *).  So
rename it, and make it take a non-const argument.

Also, it missed unconfirmed connections, which aren't in the hash
table.  This introduces a potential problem for users which expect to
iterate all connections (such as the helper deletion code).  So keep a
linked list of unconfirmed connections as well.

Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-12-24 22:11:43.372205240 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-12-24 22:15:18.980427808 +1100
@@ -974,16 +974,16 @@
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
-static int clean_nat(const struct ip_conntrack *i, void *data)
+static int clean_nat(struct ip_conntrack *i, void *data)
 {
-	memset((void *)&i->nat, 0, sizeof(i->nat));
+	memset(&i->nat, 0, sizeof(i->nat));
 	return 0;
 }
 
 /* Not __exit: called from ip_nat_standalone.c:init_or_cleanup() --RR */
 void ip_nat_cleanup(void)
 {
-	ip_ct_selective_cleanup(&clean_nat, NULL);
+	ip_ct_iterate_cleanup(&clean_nat, NULL);
 	ip_conntrack_destroyed = NULL;
 	vfree(bysource);
 }
Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2004-12-24 22:11:35.844349648 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2004-12-24 22:15:18.988426592 +1100
@@ -444,7 +444,7 @@
 }
 
 static int
-kill_helper(const struct ip_conntrack *i, void *helper)
+kill_helper(struct ip_conntrack *i, void *helper)
 {
 	int ret;
 
@@ -474,5 +474,5 @@
 	   forces admins to gen fake RSTs or bounce box, either of
 	   which is just a long-winded way of making things
 	   worse. --RR */
-	ip_ct_selective_cleanup(kill_helper, me);
+	ip_ct_iterate_cleanup(kill_helper, me);
 }
Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-24 22:11:40.023714288 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-24 22:15:18.987426744 +1100
@@ -48,7 +48,7 @@
 extern atomic_t ip_conntrack_count;
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
-static int kill_proto(const struct ip_conntrack *i, void *data)
+static int kill_proto(struct ip_conntrack *i, void *data)
 {
 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == 
 			*((u_int8_t *) data));
@@ -859,7 +859,7 @@
 	synchronize_net();
 
 	/* Remove all contrack entries for this protocol */
-	ip_ct_selective_cleanup(kill_proto, &proto->proto);
+	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
 }
 
 static int __init init(void)
@@ -889,7 +889,7 @@
 EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
-EXPORT_SYMBOL(ip_ct_selective_cleanup);
+EXPORT_SYMBOL(ip_ct_iterate_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh_acct);
 EXPORT_SYMBOL(ip_ct_protos);
 EXPORT_SYMBOL(ip_ct_find_proto);
Index: linux-2.6.10-rc3-bk16-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2004-12-24 22:11:37.794053248 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2004-12-24 22:15:18.989426440 +1100
@@ -283,10 +283,10 @@
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb);
 
-/* Delete all conntracks which match. */
+/* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
-			void *data);
+ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *data),
+		      void *data);
 
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-12-24 22:11:38.325972384 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-12-24 22:18:31.594146072 +1100
@@ -118,7 +118,7 @@
 }
 
 static inline int
-device_cmp(const struct ip_conntrack *i, void *ifindex)
+device_cmp(struct ip_conntrack *i, void *ifindex)
 {
 	int ret;
 
@@ -141,7 +141,7 @@
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
 
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
@@ -159,7 +159,7 @@
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
 
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
Index: linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-rc3-bk16-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-24 22:11:37.763057960 +1100
+++ linux-2.6.10-rc3-bk16-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-24 22:18:31.592146376 +1100
@@ -74,6 +74,7 @@
 static kmem_cache_t *ip_conntrack_expect_cachep;
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
+static LIST_HEAD(unconfirmed);
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
@@ -298,9 +299,13 @@
 		ip_conntrack_destroyed(ct);
 
 	WRITE_LOCK(&ip_conntrack_lock);
-	/* Make sure don't leave any orphaned expectations lying around */
-	if (ct->expecting)
-		remove_expectations(ct, 1);
+	BUG_ON(ct->expecting);
+
+	/* We overload first tuple to link into unconfirmed list. */
+	if (!is_confirmed(ct)) {
+		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	}
 
 	/* Delete our master expectation */
 	if (ct->master) {
@@ -412,6 +417,10 @@
 	DEBUGP("Confirming conntrack %p\n", ct);
 
 	WRITE_LOCK(&ip_conntrack_lock);
+
+	/* Remove from unconfirmed list */
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+
 	/* See if there's one in the list already, including reverse:
            NAT could have grabbed it without realizing, since we're
            not in the hash.  If there is, we lost race. */
@@ -603,6 +612,10 @@
 
 		/* this is a braindead... --pablo */
 		atomic_inc(&ip_conntrack_count);
+
+		/* Overload tuple linked list to put us in unconfirmed list. */
+		list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list,
+			 &unconfirmed);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 
 		if (expected->expectfn)
@@ -617,7 +630,11 @@
 		CONNTRACK_STAT_INC(new);
 	}
 
-end:	atomic_inc(&ip_conntrack_count);
+end:
+	/* Overload tuple linked list to put us in unconfirmed list. */
+	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
+
+	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
@@ -1067,6 +1084,7 @@
 	LIST_DELETE(&helpers, me);
 
 	/* Get rid of expecteds, set helpers to NULL. */
+	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
 			    struct ip_conntrack_tuple_hash *, me);
@@ -1179,25 +1197,28 @@
 }
 
 static inline int
-do_kill(const struct ip_conntrack_tuple_hash *i,
-	int (*kill)(const struct ip_conntrack *i, void *data),
+do_iter(const struct ip_conntrack_tuple_hash *i,
+	int (*iter)(struct ip_conntrack *i, void *data),
 	void *data)
 {
-	return kill(i->ctrack, data);
+	return iter(i->ctrack, data);
 }
 
 /* Bring out ya dead! */
 static struct ip_conntrack_tuple_hash *
-get_next_corpse(int (*kill)(const struct ip_conntrack *i, void *data),
+get_next_corpse(int (*iter)(struct ip_conntrack *i, void *data),
 		void *data, unsigned int *bucket)
 {
 	struct ip_conntrack_tuple_hash *h = NULL;
 
 	READ_LOCK(&ip_conntrack_lock);
 	for (; !h && *bucket < ip_conntrack_htable_size; (*bucket)++) {
-		h = LIST_FIND(&ip_conntrack_hash[*bucket], do_kill,
-			      struct ip_conntrack_tuple_hash *, kill, data);
+		h = LIST_FIND_W(&ip_conntrack_hash[*bucket], do_iter,
+				struct ip_conntrack_tuple_hash *, iter, data);
 	}
+	if (*bucket == ip_conntrack_htable_size)
+		h = LIST_FIND_W(&unconfirmed, do_iter,
+				struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
 		atomic_inc(&h->ctrack->ct_general.use);
 	READ_UNLOCK(&ip_conntrack_lock);
@@ -1206,13 +1227,12 @@
 }
 
 void
-ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
-			void *data)
+ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *), void *data)
 {
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int bucket = 0;
 
-	while ((h = get_next_corpse(kill, data, &bucket)) != NULL) {
+	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&h->ctrack->timeout))
 			death_by_timeout((unsigned long)h->ctrack);
@@ -1283,7 +1303,7 @@
 	.get		= &getorigdst,
 };
 
-static int kill_all(const struct ip_conntrack *i, void *data)
+static int kill_all(struct ip_conntrack *i, void *data)
 {
 	return 1;
 }
@@ -1299,7 +1319,7 @@
 	synchronize_net();
  
  i_see_dead_people:
-	ip_ct_selective_cleanup(kill_all, NULL);
+	ip_ct_iterate_cleanup(kill_all, NULL);
 	if (atomic_read(&ip_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
