From: Francesco Sportolari <francesco@unipg.it>
Subject: [PATCH] New behaviour for early_drop()
Date: Mon, 14 Apr 2003 11:40:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304141140.18647.francesco@unipg.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_6VUB5MNRZP9TCJ26CW6J"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_6VUB5MNRZP9TCJ26CW6J
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,
this is a little patch to modify the behaviour of the early_drop() functi=
on;=20
now it uses the ip_conntrack_drop_list, a double-linked list of all the=20
non-assured connections. It costs 2 bytes more for the ip_conntrack struc=
t
and a pair of list_append() and list_del() ops, but would have to do bett=
er=20
under heavy loads and some type of attacks against the hash chains.

Ciao,

-- Francesco=20
--------------Boundary-00=_6VUB5MNRZP9TCJ26CW6J
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack-earlydrop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="conntrack-earlydrop.patch"

--- ../../benh-kernel/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-20 20:17:49.000000000 +0200
+++ linux/net/ipv4/netfilter/ip_conntrack_core.c	2003-03-25 13:18:15.000000000 +0100
@@ -58,6 +58,7 @@
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
+LIST_HEAD(ip_conntrack_drop_list);
 LIST_HEAD(protocol_list);
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size = 0;
@@ -176,7 +177,7 @@
 static void
 destroy_expect(struct ip_conntrack_expect *exp)
 {
-	DEBUGP("destroy_expect(%p) use=%d\n", exp, atomic_read(exp->use));
+	DEBUGP("destroy_expect(%p) use=%d\n", exp, atomic_read(&exp->use));
 	IP_NF_ASSERT(atomic_read(exp->use));
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
 
@@ -301,7 +302,8 @@
 	LIST_DELETE(&ip_conntrack_hash
 		    [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)],
 		    &ct->tuplehash[IP_CT_DIR_REPLY]);
-
+	if (ct->drop_list.next)
+		list_del(&ct->drop_list);
 	/* Destroy all un-established, pending expectations */
 	remove_expectations(ct);
 }
@@ -337,6 +339,8 @@
 		list_del(&ct->master->expected_list);
 		kfree(ct->master);
 	}
+	if (ct->drop_list.next)
+		list_del(&ct->drop_list);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
@@ -581,33 +585,35 @@
 	return h->ctrack;
 }
 
-/* There's a small race here where we may free a just-assured
-   connection.  Too bad: we're in trouble anyway. */
-static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
-{
-	return !(i->ctrack->status & IPS_ASSURED);
-}
-
-static int early_drop(struct list_head *chain)
+static int early_drop(void)
 {
 	/* Traverse backwards: gives us oldest, which is roughly LRU */
-	struct ip_conntrack_tuple_hash *h;
+	/* Pop from ip_conntrack_drop_list, which is LRU */
+	struct list_head * entry;
+	struct ip_conntrack * ct;
 	int dropped = 0;
 
-	READ_LOCK(&ip_conntrack_lock);
-	h = LIST_FIND(chain, unreplied, struct ip_conntrack_tuple_hash *);
-	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
-	READ_UNLOCK(&ip_conntrack_lock);
+	DEBUGP("early_drop(): called.\n");
 
-	if (!h)
+	WRITE_LOCK(&ip_conntrack_lock);
+	entry = list_pop(&ip_conntrack_drop_list);
+	
+	if (entry) { 
+		ct = list_entry(entry, 
+				struct ip_conntrack, 
+				drop_list);
+		atomic_inc(&ct->ct_general.use);
+	}
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	if (!entry)
 		return dropped;
 
-	if (del_timer(&h->ctrack->timeout)) {
-		death_by_timeout((unsigned long)h->ctrack);
+	if (del_timer(&ct->timeout)) {
+		death_by_timeout((unsigned long)ct);
 		dropped = 1;
 	}
-	ip_conntrack_put(h->ctrack);
+	ip_conntrack_put(ct);
 	return dropped;
 }
 
@@ -636,23 +642,19 @@
 	size_t hash, repl_hash;
 	struct ip_conntrack_expect *expected;
 	int i;
-	static unsigned int drop_next = 0;
 
 	hash = hash_conntrack(tuple);
 
 	if (ip_conntrack_max &&
 	    atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
-		/* Try dropping from random chain, or else from the
-                   chain about to put into (in case they're trying to
-                   bomb one hash chain). */
-		unsigned int next = (drop_next++)%ip_conntrack_htable_size;
-
-		if (!early_drop(&ip_conntrack_hash[next])
-		    && !early_drop(&ip_conntrack_hash[hash])) {
+		/* Drop from ip_conntrack_drop_list if we reach
+		 * ip_conntrack_max */
+		if (!early_drop()) {
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "ip_conntrack: table full, dropping"
-				       " packet.\n");
+				       " packet, current connections: %d.\n", 
+					atomic_read(&ip_conntrack_count));
 			return ERR_PTR(-ENOMEM);
 		}
 	}
@@ -855,6 +857,16 @@
 		return NF_ACCEPT;
 	}
 
+	/* not-assured connections LRU list management */
+	WRITE_LOCK(&ip_conntrack_lock);
+	if (!(ct->status & IPS_ASSURED)
+	    && !(ct->drop_list.next))
+		list_append(&ip_conntrack_drop_list,&ct->drop_list);
+	else if ((ct->status & IPS_ASSURED)
+	         && (ct->drop_list.next)) 
+		list_del(&ct->drop_list);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+		
 	if (ret != NF_DROP && ct->helper) {
 		ret = ct->helper->help((*pskb)->nh.iph, (*pskb)->len,
 				       ct, ctinfo);
--- ../../benh-kernel/include/linux/netfilter_ipv4/ip_conntrack.h	2003-03-23 10:51:12.000000000 +0100
+++ linux/include/linux/netfilter_ipv4/ip_conntrack.h	2003-03-24 13:17:08.000000000 +0100
@@ -5,6 +5,7 @@
    extension. */
 
 #include <linux/config.h>
+#include <linux/list.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #include <asm/atomic.h>
 
@@ -112,7 +113,7 @@
 {
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
-
+	
 	/* reference count */
 	atomic_t use;
 
@@ -181,6 +182,8 @@
            packet has to the conntrack */
 	struct nf_ct_info infos[IP_CT_NUMBER];
 
+	struct list_head drop_list;
+
 	/* Storage reserved for other modules: */
 
 	union ip_conntrack_proto proto;
--- ../../benh-kernel/include/linux/netfilter_ipv4/listhelp.h	2003-03-25 14:04:29.000000000 +0100
+++ benh-kernel/include/linux/netfilter_ipv4/listhelp.h	2003-03-21 21:50:58.000000000 +0100
@@ -79,6 +79,19 @@
 	list_add(new, head);
 }
 
+/* Pop. */
+static inline void *
+list_pop(struct list_head *head)
+{
+	void * entry;
+	ASSERT_WRITE_LOCK(head);
+	if (head->next == head)
+		return NULL;
+	entry = head->next;
+	list_del(head->next);
+	return entry;
+}
+
 /* Insert according to ordering function; insert before first true. */
 #define LIST_INSERT(head, new, cmpfn)				\
 do {								\

--------------Boundary-00=_6VUB5MNRZP9TCJ26CW6J--
