From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [RFC][PATCH] NAT reservations
Date: Thu, 04 Dec 2003 17:21:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCF5F23.5060800@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010705010500080500050406"
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

This is a multi-part message in MIME format.
--------------010705010500080500050406
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


   Hi,

   I've prepared the first public version of the NAT reservation patch. It 
provides roughly the same interface which was discussed here earlier. 
However, this is not yet tested at all, apart from that seeing that NAT 
still works after applying... :) So, I'm waiting for comments regarding 
the patch, especially I'd need help in the following:

   1. When registering a new reservation, it should be made sure that not 
only that it wasn't already registered, but that it is also not clashing 
with an already existing conntrack entry. However, we only have a struct 
ip_conntrack_manip at registration, so how could we check that?

   2. Some testing if reservations are really reserved, and not allocated 
by NAT unless explicitly requested.

   Any feedback is welcome. :)

-- 
   Regards,
     Krisztian KOVACS


--------------010705010500080500050406
Content-Type: text/plain;
 name="nat_reserved_200312041712.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat_reserved_200312041712.diff"

diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.23-nres/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.23-orig/include/linux/netfilter_ipv4/ip_conntrack.h	Fri Jun 13 16:51:38 2003
+++ linux-2.4.23-nres/include/linux/netfilter_ipv4/ip_conntrack.h	Tue Dec  2 14:18:44 2003
@@ -140,6 +140,9 @@
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
+	/* List of registered reservations */
+	struct list_head reserved_list;
+
 	/* Data filled out by the conntrack helpers follow: */
 
 	/* We expect this tuple, with the following mask */
@@ -249,6 +252,8 @@
 /* These are for NAT.  Icky. */
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
+/* Call when an expectation is destroyed. */
+extern void (*ip_conntrack_expect_destroyed)(struct ip_conntrack_expect *exp);
 
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/include/linux/netfilter_ipv4/ip_nat.h linux-2.4.23-nres/include/linux/netfilter_ipv4/ip_nat.h
--- linux-2.4.23-orig/include/linux/netfilter_ipv4/ip_nat.h	Fri Nov 29 00:53:15 2002
+++ linux-2.4.23-nres/include/linux/netfilter_ipv4/ip_nat.h	Tue Dec  2 17:28:58 2003
@@ -26,8 +26,9 @@
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_USE_RESERVED 4
 /* Used internally by get_unique_tuple(). */
-#define IP_NAT_RANGE_FULL 4
+#define IP_NAT_RANGE_FULL 8
 
 /* NAT sequence number modifications */
 struct ip_nat_seq {
@@ -116,6 +117,15 @@
 	struct ip_nat_seq seq[IP_CT_DIR_MAX];
 };
 
+/* Structure to store reserved manips */
+struct ip_nat_reserved {
+	struct list_head hash;			/* Hash chain */
+	struct list_head exp;			/* Per-expectation list */
+	atomic_t use;				/* Reference count */
+	struct ip_conntrack_manip manip;	/* Reserved manip */
+	u_int16_t proto;			/* Protocol number of reserved manip */
+};
+
 /* Set up the info structure to map into this range. */
 extern unsigned int ip_nat_setup_info(struct ip_conntrack *conntrack,
 				      const struct ip_nat_multi_range *mr,
@@ -123,11 +133,39 @@
 
 /* Is this tuple already taken? (not by us)*/
 extern int ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
-			     const struct ip_conntrack *ignored_conntrack);
+			     const struct ip_conntrack *ignored_conntrack,
+			     enum ip_nat_manip_type maniptype,
+			     unsigned int flags);
 
 /* Calculate relative checksum. */
 extern u_int16_t ip_nat_cheat_check(u_int32_t oldvalinv,
 				    u_int32_t newval,
 				    u_int16_t oldcheck);
+struct ip_conntrack_expect;
+
+/* NAT port reservation: allocate and hash a new entry */
+extern struct ip_nat_reserved *__ip_nat_reserved_new_hash(const struct ip_conntrack_manip *manip,
+					 const u_int16_t proto);
+
+/* NAT port reservation: unhash an entry */
+extern struct ip_nat_reserved *__ip_nat_reserved_unhash(const struct ip_conntrack_manip *manip,
+				       const u_int16_t proto);
+
+/* NAT port reservation: free a reservation */
+extern void __ip_nat_reserved_free(struct ip_nat_reserved *res);
+
+/* NAT port reservation: register a new reservation */
+extern int ip_nat_reserved_register(struct ip_conntrack_expect *exp,
+				    const struct ip_conntrack_manip *manip,
+				    const u_int16_t proto);
+
+/* NAT port reservation: unregister a reservation */
+extern int ip_nat_reserved_unregister(struct ip_conntrack_expect *exp,
+				      const struct ip_conntrack_manip *manip,
+				      const u_int16_t proto);
+
+/* NAT port reservation: unregister all reservations for a given expectation */
+extern void ip_nat_reserved_unregister_all(struct ip_conntrack_expect *exp);
+
 #endif /*__KERNEL__*/
 #endif
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.23-nres/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_conntrack_core.c	Fri Nov 28 19:26:21 2003
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_conntrack_core.c	Tue Dec  2 14:18:44 2003
@@ -56,6 +56,7 @@
 DECLARE_RWLOCK(ip_conntrack_expect_tuple_lock);
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
+void (*ip_conntrack_expect_destroyed)(struct ip_conntrack_expect *expect) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
 LIST_HEAD(protocol_list);
 static LIST_HEAD(helpers);
@@ -177,6 +178,9 @@
 	DEBUGP("destroy_expect(%p) use=%d\n", exp, atomic_read(&exp->use));
 	IP_NF_ASSERT(atomic_read(&exp->use));
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
+
+	if (ip_conntrack_expect_destroyed)
+		ip_conntrack_expect_destroyed(exp);
 
 	kfree(exp);
 }
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.23-nres/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Nov 28 19:26:21 2003
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Dec  2 14:18:44 2003
@@ -478,6 +478,7 @@
 EXPORT_SYMBOL(ip_ct_gather_frags);
 EXPORT_SYMBOL(ip_conntrack_htable_size);
 EXPORT_SYMBOL(ip_conntrack_expect_list);
+EXPORT_SYMBOL(ip_conntrack_expect_destroyed);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_core.c linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_core.c	Fri Nov 28 19:26:21 2003
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_core.c	Thu Dec  4 17:11:26 2003
@@ -10,6 +10,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/brlock.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include <net/checksum.h>
 #include <net/icmp.h>
 #include <net/ip.h>
@@ -40,8 +41,12 @@
 /* Calculated at init based on memory size */
 static unsigned int ip_nat_htable_size;
 
+static kmem_cache_t *ip_nat_reserved_cachep;
+static atomic_t ip_nat_reserved_count;
+
 static struct list_head *bysource;
 static struct list_head *byipsproto;
+static struct list_head *natreserved;
 LIST_HEAD(protos);
 LIST_HEAD(helpers);
 
@@ -118,10 +123,251 @@
 	return i;
 }
 
+static inline int
+reserved_manip_cmp(const struct ip_nat_reserved *i,
+		   const struct ip_conntrack_manip *manip,
+		   u_int16_t proto)
+{
+	DEBUGP("reserved_manip_cmp: manip proto %u %u.%u.%u.%u:%u and reservation proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all), i->proto, NIPQUAD(i->manip.ip), ntohs(i->manip.u.all));
+	return (i->proto == proto &&
+		(i->manip.ip == manip->ip && i->manip.u.all == manip->u.all));
+}
+
+/* Is this manip reserved? */
+static struct ip_nat_reserved *
+__ip_nat_reserved_find_manip(const struct ip_conntrack_manip *manip, u_int16_t proto)
+{
+	struct ip_nat_reserved *i;
+	unsigned int h = hash_by_src(manip, proto);
+
+	MUST_BE_READ_LOCKED(&ip_nat_lock);
+
+	DEBUGP("__ip_nat_reserved_find_manip: find proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+	i = LIST_FIND(&natreserved[h], reserved_manip_cmp, struct ip_nat_reserved *, manip, proto);
+
+	return i;
+}
+
+/* Is this tuple clashing with a reserved manip? */
+static struct ip_nat_reserved *
+__ip_nat_reserved_find_tuple(const struct ip_conntrack_tuple *tuple,
+			     enum ip_nat_manip_type maniptype)
+{
+	struct ip_conntrack_manip m;
+
+	MUST_BE_READ_LOCKED(&ip_nat_lock);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		DEBUGP("__ip_nat_reserved_find_tuple: IP_NAT_MANIP_SRC search\n");
+		return __ip_nat_reserved_find_manip(&tuple->src, tuple->dst.protonum);
+	} else {
+		DEBUGP("__ip_nat_reserved_find_tuple: IP_NAT_MANIP_DST search\n");
+		m.ip = tuple->dst.ip;
+		m.u.all = tuple->dst.u.all;
+		return __ip_nat_reserved_find_manip(&m, tuple->dst.protonum);
+	}
+}
+
+/* Create a new reservation */
+struct ip_nat_reserved *
+__ip_nat_reserved_new_hash(const struct ip_conntrack_manip *manip,
+			    const u_int16_t proto)
+{
+	struct ip_nat_reserved *res;
+	unsigned int h;
+
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+
+	DEBUGP("__ip_nat_reserved_new_hash: manip proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+
+	/* check if it's already reserved */
+	if (__ip_nat_reserved_find_manip(manip, proto)) {
+		DEBUGP("__ip_nat_reserved_new_hash: already reserved\n");	
+		return NULL;
+	}
+
+	/* FIXME: check if a clashing connection exists... This is problematic,
+	 * since the final decision in ip_nat_used_tuple() is based on a full
+	 * tuple, but we only have a manip... =(:< */
+
+
+	/* else allocate a new structure */
+	res = kmem_cache_alloc(ip_nat_reserved_cachep, GFP_ATOMIC);
+	if (!res)
+		return NULL;
+
+	memset(res, 0, sizeof(*res));
+	res->proto = proto;
+	res->manip = *manip;
+
+	/* put it into the hash */
+	h = hash_by_src(manip, proto);
+	atomic_inc(&ip_nat_reserved_count);
+	list_prepend(&natreserved[h], &res->hash);
+	DEBUGP("__ip_nat_reserved_new_hash: hashed manip proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+	
+	return res;
+}
+
+/* Register a new reservation */
+static int
+__ip_nat_reserved_register(struct ip_conntrack_expect *expect,
+			   const struct ip_conntrack_manip *manip,
+			   const u_int16_t proto)
+{
+	struct ip_nat_reserved *res;
+
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+
+	DEBUGP("__ip_nat_reserved_register: registering proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+
+	/* allocate and put into the hash */
+	res = __ip_nat_reserved_new_hash(manip, proto);
+	if (!res)
+		return 0;
+
+	/* append to the per-expectation reserved list */
+	list_append(&expect->reserved_list, &res->exp);
+	
+	return 1;
+}
+
+int
+ip_nat_reserved_register(struct ip_conntrack_expect *expect,
+			 const struct ip_conntrack_manip *manip,
+			 const u_int16_t proto)
+{
+	int ret;
+
+	WRITE_LOCK(&ip_nat_lock);
+
+	ret = __ip_nat_reserved_register(expect, manip, proto);
+
+	WRITE_UNLOCK(&ip_nat_lock);
+
+	return ret;
+}
+
+/* Unhash a reservation */
+struct ip_nat_reserved *
+__ip_nat_reserved_unhash(const struct ip_conntrack_manip *manip,
+			      const u_int16_t proto)
+{
+	struct ip_nat_reserved *res;
+
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+
+	DEBUGP("__ip_nat_reserved_unhash: unhashing proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+
+	/* check if it's really reserved */
+	if (!(res = __ip_nat_reserved_find_manip(manip, proto))) {
+		DEBUGP("__ip_nat_reserved_unhash: trying to unreg a nonexisting reservation\n");
+		return NULL;
+	}
+
+	/* delete from the hash table */
+	list_del(&res->hash);
+
+	atomic_dec(&ip_nat_reserved_count);
+
+	return res;
+}
+
+/* Return a reservation structure into the slab cache */
+void
+__ip_nat_reserved_free(struct ip_nat_reserved *res)
+{
+	kmem_cache_free(ip_nat_reserved_cachep, res);
+}
+
+/* Unregister a reservation */
+static int
+__ip_nat_reserved_unregister(struct ip_conntrack_expect *expect,
+			     const struct ip_conntrack_manip *manip,
+			     const u_int16_t proto)
+{
+	struct ip_nat_reserved *res;
+
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+
+	DEBUGP("__ip_nat_reserved_unregister: unregistering proto %u %u.%u.%u.%u:%u\n",
+			proto, NIPQUAD(manip->ip), ntohs(manip->u.all));
+
+	/* look up and unhash */
+	res = __ip_nat_reserved_unhash(manip, proto);
+	if (!res)
+		return 0;
+
+	/* delete from the per-expectation list */
+	list_del(&res->exp);
+
+	/* free the structure */
+	__ip_nat_reserved_free(res);
+
+	return 1;
+}
+
+int
+ip_nat_reserved_unregister(struct ip_conntrack_expect *expect,
+			   const struct ip_conntrack_manip *manip,
+			   const u_int16_t proto)
+{
+	int ret;
+
+	WRITE_LOCK(&ip_nat_lock);
+
+	ret = __ip_nat_reserved_unregister(expect, manip, proto);
+
+	WRITE_UNLOCK(&ip_nat_lock);
+
+	return ret;
+}
+
+/* Unregister all reservations for a given expectation */
+void
+ip_nat_reserved_unregister_all(struct ip_conntrack_expect *expect)
+{
+	struct list_head *i;
+	struct ip_nat_reserved *res;
+
+	DEBUGP("ip_nat_reserved_unregister_all: deleting all reservations for expectation %p\n",
+			expect);
+
+	WRITE_LOCK(&ip_nat_lock);
+
+	i = expect->reserved_list.next;
+	while (i != &expect->reserved_list) {
+		res = list_entry(i, struct ip_nat_reserved, exp);
+		i = i->next;
+
+		/* clear from lists */
+		list_del(&res->hash);
+		list_del(&res->exp);
+
+		kmem_cache_free(ip_nat_reserved_cachep, res);
+	}
+
+	WRITE_UNLOCK(&ip_nat_lock);
+}
+
+static void
+ip_nat_reserved_cleanup_expect(struct ip_conntrack_expect *expect)
+{
+	ip_nat_reserved_unregister_all(expect);
+}
+
 /* Is this tuple already taken? (not by us) */
 int
 ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
-		  const struct ip_conntrack *ignored_conntrack)
+		  const struct ip_conntrack *ignored_conntrack,
+		  enum ip_nat_manip_type maniptype,
+		  unsigned int flags)
 {
 	/* Conntrack tracking doesn't keep track of outgoing tuples; only
 	   incoming ones.  NAT means they don't have a fixed mapping,
@@ -129,6 +375,16 @@
 
 	   We could keep a separate hash if this proves too slow. */
 	struct ip_conntrack_tuple reply;
+	struct ip_nat_reserved *res;
+	int ret;
+
+	if (atomic_read(&ip_nat_reserved_count)) {
+		res = __ip_nat_reserved_find_tuple(tuple, maniptype);
+
+		/* If we may not allocate reserved ports, return */
+		if ((flags & IP_NAT_RANGE_USE_RESERVED) == 0 && res)
+			return 1;
+	}
 
 	invert_tuplepr(&reply, tuple);
 	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
@@ -439,7 +695,7 @@
 		if ((!(rptr->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
 		     || proto->in_range(tuple, HOOK2MANIP(hooknum),
 					&rptr->min, &rptr->max))
-		    && !ip_nat_used_tuple(tuple, conntrack)) {
+		    && !ip_nat_used_tuple(tuple, conntrack, HOOK2MANIP(hooknum), rptr->flags)) {
 			ret = 1;
 			goto clear_fulls;
 		} else {
@@ -448,7 +704,7 @@
 						conntrack)) {
 				/* Must be unique. */
 				IP_NF_ASSERT(!ip_nat_used_tuple(tuple,
-								conntrack));
+								conntrack, HOOK2MANIP(hooknum), rptr->flags));
 				ret = 1;
 				goto clear_fulls;
 			} else if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
@@ -465,7 +721,7 @@
 							conntrack)) {
 					/* Must be unique. */
 					IP_NF_ASSERT(!ip_nat_used_tuple
-						     (tuple, conntrack));
+						     (tuple, conntrack, IP_NAT_MANIP_DST, 0));
 					ret = 1;
 					goto clear_fulls;
 				}
@@ -969,12 +1225,22 @@
 	/* Leave them the same for the moment. */
 	ip_nat_htable_size = ip_conntrack_htable_size;
 
+	/* Create nat_reserved slab cache */
+	ip_nat_reserved_cachep = kmem_cache_create("ip_nat_reserved",
+						   sizeof(struct ip_nat_reserved), 0,
+						   SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!ip_nat_reserved_cachep) {
+		printk(KERN_ERR "Unable to create ip_nat_reserved slab cache\n");
+		return -ENOMEM;
+	}
+
 	/* One vmalloc for both hash tables */
-	bysource = vmalloc(sizeof(struct list_head) * ip_nat_htable_size*2);
+	bysource = vmalloc(sizeof(struct list_head) * ip_nat_htable_size*3);
 	if (!bysource) {
-		return -ENOMEM;
+		goto free_reserved_slab;
 	}
 	byipsproto = bysource + ip_nat_htable_size;
+	natreserved = byipsproto + ip_nat_htable_size;
 
 	/* Sew in builtin protocols. */
 	WRITE_LOCK(&ip_nat_lock);
@@ -986,13 +1252,20 @@
 	for (i = 0; i < ip_nat_htable_size; i++) {
 		INIT_LIST_HEAD(&bysource[i]);
 		INIT_LIST_HEAD(&byipsproto[i]);
+		INIT_LIST_HEAD(&natreserved[i]);
 	}
 
 	/* FIXME: Man, this is a hack.  <SIGH> */
 	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
+	IP_NF_ASSERT(ip_conntrack_expect_destroyed == NULL);
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
+	ip_conntrack_expect_destroyed = &ip_nat_reserved_cleanup_expect;
 
 	return 0;
+
+free_reserved_slab:
+	kmem_cache_destroy(ip_nat_reserved_cachep);
+	return -ENOMEM;
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
@@ -1007,5 +1280,6 @@
 {
 	ip_ct_selective_cleanup(&clean_nat, NULL);
 	ip_conntrack_destroyed = NULL;
+	ip_conntrack_expect_destroyed = NULL;
 	vfree(bysource);
 }
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_icmp.c linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_icmp.c	Fri Mar 17 19:56:20 2000
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_icmp.c	Tue Dec  2 14:47:14 2003
@@ -36,7 +36,7 @@
 
 	for (i = 0; i < range_size; i++, id++) {
 		tuple->src.u.icmp.id = range->min.icmp.id + (id % range_size);
-		if (!ip_nat_used_tuple(tuple, conntrack))
+		if (!ip_nat_used_tuple(tuple, conntrack, maniptype, range->flags))
 			return 1;
 	}
 	return 0;
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_tcp.c linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_tcp.c	Fri Nov 29 00:53:15 2002
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_tcp.c	Tue Dec  2 14:47:41 2003
@@ -66,7 +66,7 @@
 
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
-		if (!ip_nat_used_tuple(tuple, conntrack)) {
+		if (!ip_nat_used_tuple(tuple, conntrack, maniptype, range->flags)) {
 			return 1;
 		}
 	}
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_udp.c linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_udp.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_proto_udp.c	Fri Aug  4 22:07:24 2000
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_proto_udp.c	Tue Dec  2 14:49:08 2003
@@ -66,7 +66,7 @@
 
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
-		if (!ip_nat_used_tuple(tuple, conntrack))
+		if (!ip_nat_used_tuple(tuple, conntrack, maniptype, range->flags))
 			return 1;
 	}
 	return 0;
diff --exclude .depend --exclude *.o --exclude *.ko --exclude .*.flags --exclude *.orig --exclude *.rej --exclude *.cmd --exclude *.mod.c --exclude *~ -Naur linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_standalone.c linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.4.23-orig/net/ipv4/netfilter/ip_nat_standalone.c	Fri Nov 28 19:26:21 2003
+++ linux-2.4.23-nres/net/ipv4/netfilter/ip_nat_standalone.c	Tue Dec  2 17:30:30 2003
@@ -356,4 +356,10 @@
 EXPORT_SYMBOL(ip_nat_mangle_tcp_packet);
 EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
 EXPORT_SYMBOL(ip_nat_used_tuple);
+EXPORT_SYMBOL(ip_nat_reserved_register);
+EXPORT_SYMBOL(__ip_nat_reserved_new_hash);
+EXPORT_SYMBOL(__ip_nat_reserved_unhash);
+EXPORT_SYMBOL(__ip_nat_reserved_free);
+EXPORT_SYMBOL(ip_nat_reserved_unregister);
+EXPORT_SYMBOL(ip_nat_reserved_unregister_all);
 MODULE_LICENSE("GPL");

--------------010705010500080500050406--
