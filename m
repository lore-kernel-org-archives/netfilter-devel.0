From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 4/8]: Fix ip_ct_selective_cleanup(),
	and rename ip_ct_iterate_cleanup
Date: Fri, 04 Mar 2005 13:18:47 +0100
Message-ID: <42285227.80403@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="04.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 00:45:34+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_helper.c
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +2 -2
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +33 -14
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2005/03/04 00:45:32+01:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: Fix ip_ct_selective_cleanup(), and rename ip_ct_iterate_cleanup()
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Several places use ip_ct_selective_cleanup() as a general iterator, which it
#   was not intended for (it takes a const ip_conntrack *).  So rename it, and
#   make it take a non-const argument.
#   	
#   Also, it missed unconfirmed connections, which aren't in the hash table.  This
#   introduces a potential problem for users which expect to iterate all
#   connections (such as the helper deletion code).  So keep a linked list of
#   unconfirmed connections as well.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2005-03-04 01:52:04 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2005-03-04 01:52:04 +01:00
@@ -253,10 +253,10 @@
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user);
 
-/* Delete all conntracks which match. */
+/* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
-			void *data);
+ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *data),
+                      void *data);
 
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-04 01:52:04 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-04 01:52:04 +01:00
@@ -64,6 +64,7 @@
 static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
+static LIST_HEAD(unconfirmed);
 
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
 
@@ -329,6 +330,12 @@
 	if (ct->expecting)
 		remove_expectations(ct, 1);
 
+	/* We overload first tuple to link into unconfirmed list. */
+	if (!is_confirmed(ct)) {
+		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	}
+
 	/* Delete our master expectation */
 	if (ct->master) {
 		if (ct->master->expectant) {
@@ -463,6 +470,9 @@
 			  conntrack_tuple_cmp,
 			  struct ip_conntrack_tuple_hash *,
 			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
+		/* Remove from unconfirmed list */
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+
 		list_prepend(&ip_conntrack_hash[hash],
 			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
 		list_prepend(&ip_conntrack_hash[repl_hash],
@@ -736,6 +746,10 @@
 		expected->expectant->expecting--;
 		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
 	}
+	/* Overload tuple linked list to put us in unconfirmed list. */
+	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list,
+	         &unconfirmed);
+
 	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
@@ -1155,6 +1169,7 @@
 	LIST_DELETE(&helpers, me);
 
 	/* Get rid of expecteds, set helpers to NULL. */
+	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
 			    struct ip_conntrack_tuple_hash *, me);
@@ -1248,40 +1263,44 @@
 }
 
 static inline int
-do_kill(const struct ip_conntrack_tuple_hash *i,
-	int (*kill)(const struct ip_conntrack *i, void *data),
+do_iter(const struct ip_conntrack_tuple_hash *i,
+        int (*iter)(struct ip_conntrack *i, void *data),
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
 
-	READ_LOCK(&ip_conntrack_lock);
-	for (; !h && *bucket < ip_conntrack_htable_size; (*bucket)++) {
-		h = LIST_FIND(&ip_conntrack_hash[*bucket], do_kill,
-			      struct ip_conntrack_tuple_hash *, kill, data);
+	WRITE_LOCK(&ip_conntrack_lock);
+	for (; *bucket < ip_conntrack_htable_size; (*bucket)++) {
+		h = LIST_FIND_W(&ip_conntrack_hash[*bucket], do_iter,
+		                struct ip_conntrack_tuple_hash *, iter, data);
+		if (h)
+			break;
 	}
+	if (!h)
+		h = LIST_FIND_W(&unconfirmed, do_iter,
+		                struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
 		atomic_inc(&h->ctrack->ct_general.use);
-	READ_UNLOCK(&ip_conntrack_lock);
+	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	return h;
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
@@ -1350,7 +1369,7 @@
     SO_ORIGINAL_DST, SO_ORIGINAL_DST+1, &getorigdst,
     0, NULL };
 
-static int kill_all(const struct ip_conntrack *i, void *data)
+static int kill_all(struct ip_conntrack *i, void *data)
 {
 	return 1;
 }
@@ -1367,7 +1386,7 @@
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
  
  i_see_dead_people:
-	ip_ct_selective_cleanup(kill_all, NULL);
+	ip_ct_iterate_cleanup(kill_all, NULL);
 	if (atomic_read(&ip_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-04 01:52:04 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-04 01:52:04 +01:00
@@ -39,7 +39,7 @@
 
 MODULE_LICENSE("GPL");
 
-static int kill_proto(const struct ip_conntrack *i, void *data)
+static int kill_proto(struct ip_conntrack *i, void *data)
 {
 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == 
 			*((u_int8_t *) data));
@@ -440,7 +440,7 @@
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
 
 	/* Remove all contrack entries for this protocol */
-	ip_ct_selective_cleanup(kill_proto, &proto->proto);
+	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
 
 	MOD_DEC_USE_COUNT;
 }
@@ -467,7 +467,7 @@
 EXPORT_SYMBOL(ip_conntrack_get);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
-EXPORT_SYMBOL(ip_ct_selective_cleanup);
+EXPORT_SYMBOL(ip_ct_iterate_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh);
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2005-03-04 01:52:04 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2005-03-04 01:52:04 +01:00
@@ -1028,16 +1028,16 @@
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
diff -Nru a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	2005-03-04 01:52:04 +01:00
+++ b/net/ipv4/netfilter/ip_nat_helper.c	2005-03-04 01:52:04 +01:00
@@ -520,7 +520,7 @@
 }
 
 static int
-kill_helper(const struct ip_conntrack *i, void *helper)
+kill_helper(struct ip_conntrack *i, void *helper)
 {
 	int ret;
 
@@ -554,7 +554,7 @@
 	   forces admins to gen fake RSTs or bounce box, either of
 	   which is just a long-winded way of making things
 	   worse. --RR */
-	ip_ct_selective_cleanup(kill_helper, me);
+	ip_ct_iterate_cleanup(kill_helper, me);
 
 	if (found)
 		MOD_DEC_USE_COUNT;
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-03-04 01:52:04 +01:00
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-03-04 01:52:04 +01:00
@@ -125,7 +125,7 @@
 }
 
 static inline int
-device_cmp(const struct ip_conntrack *i, void *ifindex)
+device_cmp(struct ip_conntrack *i, void *ifindex)
 {
 	int ret;
 
@@ -148,7 +148,7 @@
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
  
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
@@ -167,7 +167,7 @@
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
 
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
