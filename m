From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Kill lockhelp.h
Date: Fri, 06 May 2005 01:36:13 +0200
Message-ID: <427AADED.8050301@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060207010606010402030005"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------060207010606010402030005
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Here's the patch to kill lockhelp.h in case you want it for 2.6.12,
otherwise I'm going to resend when 2.6.12 is out.


--------------060207010606010402030005
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Kill lockhelp.h

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e6fbeaa02b8f4447c283b7374e399a13ec7601cb
tree 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc
parent 28b4b5756c08e6c4f053e6298c6cc176dd51cc9c
author Patrick McHardy <kaber@trash.net> 1115335976 +0200
committer Patrick McHardy <kaber@trash.net> 1115335976 +0200

Index: include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/include/linux/netfilter_ipv4/ip_conntrack_core.h  (mode:100644 sha1:d84be02cb4fc09eace23a9576a8c0c72ccd32419)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/include/linux/netfilter_ipv4/ip_conntrack_core.h  (mode:100644 sha1:694aec9b478469dafd09d061bd48d4280d0f9f75)
@@ -1,7 +1,6 @@
 #ifndef _IP_CONNTRACK_CORE_H
 #define _IP_CONNTRACK_CORE_H
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
@@ -47,6 +46,6 @@
 
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
-DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
+extern rwlock_t ip_conntrack_lock;
 #endif /* _IP_CONNTRACK_CORE_H */
 
Index: include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/include/linux/netfilter_ipv4/ip_nat.h  (mode:100644 sha1:2b72b86176f0dbf62b455a2689abb5d0d011677a)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/include/linux/netfilter_ipv4/ip_nat.h  (mode:100644 sha1:e201ec6e990550004d03cb60c10ad07b96892882)
@@ -50,10 +50,9 @@
 
 #ifdef __KERNEL__
 #include <linux/list.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* Protects NAT hash tables, and NAT-private part of conntracks. */
-DECLARE_RWLOCK_EXTERN(ip_nat_lock);
+extern rwlock_t ip_nat_lock;
 
 /* The structure embedded in the conntrack structure. */
 struct ip_nat_info
Index: include/linux/netfilter_ipv4/listhelp.h
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/include/linux/netfilter_ipv4/listhelp.h  (mode:100644 sha1:f2ae7c5e57bb72bccfc46d3202e53b99a55aff19)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/include/linux/netfilter_ipv4/listhelp.h  (mode:100644 sha1:360429f4873755e758018a6915a591aaa6338e84)
@@ -2,7 +2,6 @@
 #define _LISTHELP_H
 #include <linux/config.h>
 #include <linux/list.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* Header to do more comprehensive job than linux/list.h; assume list
    is first entry in structure. */
Index: include/linux/netfilter_ipv4/lockhelp.h
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/include/linux/netfilter_ipv4/lockhelp.h  (mode:100644 sha1:a3288633ab46947fd55a305204ec1a23bc84f4aa)
+++ /dev/null  (tree:2c41b93e5bb6e40e4c8b01e745fae2a928378ecc)
@@ -1,129 +0,0 @@
-#ifndef _LOCKHELP_H
-#define _LOCKHELP_H
-#include <linux/config.h>
-
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <linux/interrupt.h>
-#include <linux/smp.h>
-
-/* Header to do help in lock debugging. */
-
-#ifdef CONFIG_NETFILTER_DEBUG
-struct spinlock_debug
-{
-	spinlock_t l;
-	atomic_t locked_by;
-};
-
-struct rwlock_debug
-{
-	rwlock_t l;
-	long read_locked_map;
-	long write_locked_map;
-};
-
-#define DECLARE_LOCK(l) 						\
-struct spinlock_debug l = { SPIN_LOCK_UNLOCKED, ATOMIC_INIT(-1) }
-#define DECLARE_LOCK_EXTERN(l) 			\
-extern struct spinlock_debug l
-#define DECLARE_RWLOCK(l)				\
-struct rwlock_debug l = { RW_LOCK_UNLOCKED, 0, 0 }
-#define DECLARE_RWLOCK_EXTERN(l)		\
-extern struct rwlock_debug l
-
-#define MUST_BE_LOCKED(l)						\
-do { if (atomic_read(&(l)->locked_by) != smp_processor_id())		\
-	printk("ASSERT %s:%u %s unlocked\n", __FILE__, __LINE__, #l);	\
-} while(0)
-
-#define MUST_BE_UNLOCKED(l)						\
-do { if (atomic_read(&(l)->locked_by) == smp_processor_id())		\
-	printk("ASSERT %s:%u %s locked\n", __FILE__, __LINE__, #l);	\
-} while(0)
-
-/* Write locked OK as well. */
-#define MUST_BE_READ_LOCKED(l)						    \
-do { if (!((l)->read_locked_map & (1UL << smp_processor_id()))		    \
-	 && !((l)->write_locked_map & (1UL << smp_processor_id())))	    \
-	printk("ASSERT %s:%u %s not readlocked\n", __FILE__, __LINE__, #l); \
-} while(0)
-
-#define MUST_BE_WRITE_LOCKED(l)						     \
-do { if (!((l)->write_locked_map & (1UL << smp_processor_id())))	     \
-	printk("ASSERT %s:%u %s not writelocked\n", __FILE__, __LINE__, #l); \
-} while(0)
-
-#define MUST_BE_READ_WRITE_UNLOCKED(l)					  \
-do { if ((l)->read_locked_map & (1UL << smp_processor_id()))		  \
-	printk("ASSERT %s:%u %s readlocked\n", __FILE__, __LINE__, #l);	  \
- else if ((l)->write_locked_map & (1UL << smp_processor_id()))		  \
-	 printk("ASSERT %s:%u %s writelocked\n", __FILE__, __LINE__, #l); \
-} while(0)
-
-#define LOCK_BH(lk)						\
-do {								\
-	MUST_BE_UNLOCKED(lk);					\
-	spin_lock_bh(&(lk)->l);					\
-	atomic_set(&(lk)->locked_by, smp_processor_id());	\
-} while(0)
-
-#define UNLOCK_BH(lk)				\
-do {						\
-	MUST_BE_LOCKED(lk);			\
-	atomic_set(&(lk)->locked_by, -1);	\
-	spin_unlock_bh(&(lk)->l);		\
-} while(0)
-
-#define READ_LOCK(lk) 						\
-do {								\
-	MUST_BE_READ_WRITE_UNLOCKED(lk);			\
-	read_lock_bh(&(lk)->l);					\
-	set_bit(smp_processor_id(), &(lk)->read_locked_map);	\
-} while(0)
-
-#define WRITE_LOCK(lk)							  \
-do {									  \
-	MUST_BE_READ_WRITE_UNLOCKED(lk);				  \
-	write_lock_bh(&(lk)->l);					  \
-	set_bit(smp_processor_id(), &(lk)->write_locked_map);		  \
-} while(0)
-
-#define READ_UNLOCK(lk)							\
-do {									\
-	if (!((lk)->read_locked_map & (1UL << smp_processor_id())))	\
-		printk("ASSERT: %s:%u %s not readlocked\n", 		\
-		       __FILE__, __LINE__, #lk);			\
-	clear_bit(smp_processor_id(), &(lk)->read_locked_map);		\
-	read_unlock_bh(&(lk)->l);					\
-} while(0)
-
-#define WRITE_UNLOCK(lk)					\
-do {								\
-	MUST_BE_WRITE_LOCKED(lk);				\
-	clear_bit(smp_processor_id(), &(lk)->write_locked_map);	\
-	write_unlock_bh(&(lk)->l);				\
-} while(0)
-
-#else
-#define DECLARE_LOCK(l) spinlock_t l = SPIN_LOCK_UNLOCKED
-#define DECLARE_LOCK_EXTERN(l) extern spinlock_t l
-#define DECLARE_RWLOCK(l) rwlock_t l = RW_LOCK_UNLOCKED
-#define DECLARE_RWLOCK_EXTERN(l) extern rwlock_t l
-
-#define MUST_BE_LOCKED(l)
-#define MUST_BE_UNLOCKED(l)
-#define MUST_BE_READ_LOCKED(l)
-#define MUST_BE_WRITE_LOCKED(l)
-#define MUST_BE_READ_WRITE_UNLOCKED(l)
-
-#define LOCK_BH(l) spin_lock_bh(l)
-#define UNLOCK_BH(l) spin_unlock_bh(l)
-
-#define READ_LOCK(l) read_lock_bh(l)
-#define WRITE_LOCK(l) write_lock_bh(l)
-#define READ_UNLOCK(l) read_unlock_bh(l)
-#define WRITE_UNLOCK(l) write_unlock_bh(l)
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
-#endif /* _LOCKHELP_H */
Index: net/ipv4/netfilter/arp_tables.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/arp_tables.c  (mode:100644 sha1:df79f5ed6a0a3e73e5e2b8361ff36ffe54044aaa)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/arp_tables.c  (mode:100644 sha1:fa1634256680d88f524727da2b48fdfe92360732)
@@ -60,7 +60,6 @@
 
 #define ASSERT_READ_LOCK(x) ARP_NF_ASSERT(down_trylock(&arpt_mutex) != 0)
 #define ASSERT_WRITE_LOCK(x) ARP_NF_ASSERT(down_trylock(&arpt_mutex) != 0)
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/listhelp.h>
 
 struct arpt_table_info {
Index: net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_amanda.c  (mode:100644 sha1:3dbddd062605a73fcb0d09a727aab0f521d18107)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_amanda.c  (mode:100644 sha1:a78a320eee082802eebb99d0b468eda935160934)
@@ -26,7 +26,6 @@
 #include <net/checksum.h>
 #include <net/udp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 
@@ -42,7 +41,7 @@
 
 /* This is slow, but it's simple. --RR */
 static char amanda_buffer[65536];
-static DECLARE_LOCK(amanda_buffer_lock);
+static DEFINE_SPINLOCK(amanda_buffer_lock);
 
 unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
 				   enum ip_conntrack_info ctinfo,
@@ -76,7 +75,7 @@
 		return NF_ACCEPT;
 	}
 
-	LOCK_BH(&amanda_buffer_lock);
+	spin_lock_bh(&amanda_buffer_lock);
 	skb_copy_bits(*pskb, dataoff, amanda_buffer, (*pskb)->len - dataoff);
 	data = amanda_buffer;
 	data_limit = amanda_buffer + (*pskb)->len - dataoff;
@@ -134,7 +133,7 @@
 	}
 
 out:
-	UNLOCK_BH(&amanda_buffer_lock);
+	spin_unlock_bh(&amanda_buffer_lock);
 	return ret;
 }
 
Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644 sha1:28d9425d5c390dac7601953e65043e973833e7aa)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644 sha1:c7831c6feebb4dd4e477519e573743c23a0666d8)
@@ -38,10 +38,10 @@
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
 
-/* This rwlock protects the main hash table, protocol/helper/expected
+/* ip_conntrack_lock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
@@ -57,7 +57,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_RWLOCK(ip_conntrack_lock);
+DEFINE_RWLOCK(ip_conntrack_lock);
 
 /* ip_conntrack_standalone needs this */
 atomic_t ip_conntrack_count = ATOMIC_INIT(0);
@@ -147,7 +147,7 @@
 
 static void unlink_expect(struct ip_conntrack_expect *exp)
 {
-	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 	list_del(&exp->list);
 	/* Logically in destroy_expect, but we hold the lock here. */
 	exp->master->expecting--;
@@ -157,9 +157,9 @@
 {
 	struct ip_conntrack_expect *exp = (void *)ul_expect;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	unlink_expect(exp);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 	destroy_expect(exp);
 }
 
@@ -209,7 +209,7 @@
 	unsigned int ho, hr;
 	
 	DEBUGP("clean_from_lists(%p)\n", ct);
-	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 
 	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	hr = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -240,7 +240,7 @@
 	if (ip_conntrack_destroyed)
 		ip_conntrack_destroyed(ct);
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	/* Expectations will have been removed in clean_from_lists,
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
@@ -254,7 +254,7 @@
 	}
 
 	CONNTRACK_STAT_INC(delete);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	if (ct->master)
 		ip_conntrack_put(ct->master);
@@ -268,12 +268,12 @@
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
 	CONNTRACK_STAT_INC(delete_list);
 	clean_from_lists(ct);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 	ip_conntrack_put(ct);
 }
 
@@ -282,7 +282,7 @@
 		    const struct ip_conntrack_tuple *tuple,
 		    const struct ip_conntrack *ignored_conntrack)
 {
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	return tuplehash_to_ctrack(i) != ignored_conntrack
 		&& ip_ct_tuple_equal(tuple, &i->tuple);
 }
@@ -294,7 +294,7 @@
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
 
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
 		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
 			CONNTRACK_STAT_INC(found);
@@ -313,11 +313,11 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 	h = __ip_conntrack_find(tuple, ignored_conntrack);
 	if (h)
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 
 	return h;
 }
@@ -352,7 +352,7 @@
 	IP_NF_ASSERT(!is_confirmed(ct));
 	DEBUGP("Confirming conntrack %p\n", ct);
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 
 	/* See if there's one in the list already, including reverse:
            NAT could have grabbed it without realizing, since we're
@@ -380,12 +380,12 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		CONNTRACK_STAT_INC(insert);
-		WRITE_UNLOCK(&ip_conntrack_lock);
+		write_unlock_bh(&ip_conntrack_lock);
 		return NF_ACCEPT;
 	}
 
 	CONNTRACK_STAT_INC(insert_failed);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	return NF_DROP;
 }
@@ -398,9 +398,9 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 	h = __ip_conntrack_find(tuple, ignored_conntrack);
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 
 	return h != NULL;
 }
@@ -419,13 +419,13 @@
 	struct ip_conntrack *ct = NULL;
 	int dropped = 0;
 
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 	h = LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
 	if (h) {
 		ct = tuplehash_to_ctrack(h);
 		atomic_inc(&ct->ct_general.use);
 	}
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 
 	if (!ct)
 		return dropped;
@@ -508,7 +508,7 @@
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	exp = find_expectation(tuple);
 
 	if (exp) {
@@ -532,7 +532,7 @@
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
 	atomic_inc(&ip_conntrack_count);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	if (exp) {
 		if (exp->expectfn)
@@ -723,17 +723,17 @@
 {
 	struct ip_conntrack_expect *i;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			unlink_expect(i);
-			WRITE_UNLOCK(&ip_conntrack_lock);
+			write_unlock_bh(&ip_conntrack_lock);
 			destroy_expect(i);
 			return;
 		}
 	}
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 }
 
 struct ip_conntrack_expect *ip_conntrack_expect_alloc(void)
@@ -808,7 +808,7 @@
 	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
 	DEBUGP("mask:  "); DUMP_TUPLE(&expect->mask);
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
@@ -832,7 +832,7 @@
 	ip_conntrack_expect_insert(expect);
 	ret = 0;
 out:
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
  	return ret;
 }
 
@@ -841,7 +841,7 @@
 void ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			      const struct ip_conntrack_tuple *newreply)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	/* Should be unconfirmed, so not in hash table yet */
 	IP_NF_ASSERT(!is_confirmed(conntrack));
 
@@ -851,15 +851,15 @@
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && conntrack->expecting == 0)
 		conntrack->helper = ip_ct_find_helper(newreply);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 }
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
 {
 	BUG_ON(me->timeout == 0);
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	list_prepend(&helpers, me);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	return 0;
 }
@@ -878,7 +878,7 @@
 	struct ip_conntrack_expect *exp, *tmp;
 
 	/* Need write lock here, to delete helper. */
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	LIST_DELETE(&helpers, me);
 
 	/* Get rid of expectations */
@@ -893,7 +893,7 @@
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
 			    struct ip_conntrack_tuple_hash *, me);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	/* Someone could be still looking at the helper in a bh. */
 	synchronize_net();
@@ -925,14 +925,14 @@
 		ct->timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
-		WRITE_LOCK(&ip_conntrack_lock);
+		write_lock_bh(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}
 		ct_add_counters(ct, ctinfo, skb);
-		WRITE_UNLOCK(&ip_conntrack_lock);
+		write_unlock_bh(&ip_conntrack_lock);
 	}
 }
 
@@ -1009,7 +1009,7 @@
 {
 	struct ip_conntrack_tuple_hash *h = NULL;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	for (; *bucket < ip_conntrack_htable_size; (*bucket)++) {
 		h = LIST_FIND_W(&ip_conntrack_hash[*bucket], do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
@@ -1021,7 +1021,7 @@
 				struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	return h;
 }
@@ -1213,14 +1213,14 @@
 	}
 
 	/* Don't NEED lock here, but good form anyway. */
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	for (i = 0; i < MAX_IP_CT_PROTO; i++)
 		ip_ct_protos[i] = &ip_conntrack_generic_protocol;
 	/* Sew in builtin protocols. */
 	ip_ct_protos[IPPROTO_TCP] = &ip_conntrack_protocol_tcp;
 	ip_ct_protos[IPPROTO_UDP] = &ip_conntrack_protocol_udp;
 	ip_ct_protos[IPPROTO_ICMP] = &ip_conntrack_protocol_icmp;
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
Index: net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_ftp.c  (mode:100644 sha1:dd86503aa7881917715839aa81c62fcdeb3f6391)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_ftp.c  (mode:100644 sha1:fea6dd2a00b6b2db30e2ab348f02b354ff40d443)
@@ -16,7 +16,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/moduleparam.h>
@@ -28,7 +27,7 @@
 /* This is slow, but it's simple. --RR */
 static char ftp_buffer[65536];
 
-static DECLARE_LOCK(ip_ftp_lock);
+static DEFINE_SPINLOCK(ip_ftp_lock);
 
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
@@ -319,7 +318,7 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
-	LOCK_BH(&ip_ftp_lock);
+	spin_lock_bh(&ip_ftp_lock);
 	fb_ptr = skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, ftp_buffer);
 	BUG_ON(fb_ptr == NULL);
@@ -442,7 +441,7 @@
 	if (ends_in_nl)
 		update_nl_seq(seq, ct_ftp_info,dir);
  out:
-	UNLOCK_BH(&ip_ftp_lock);
+	spin_unlock_bh(&ip_ftp_lock);
 	return ret;
 }
 
Index: net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_irc.c  (mode:100644 sha1:33cc7348b6eee161c8c61a1d658070d42a977626)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_irc.c  (mode:100644 sha1:cd98772cc332a2bf3ac5ea6b91c5df9a60f06355)
@@ -29,7 +29,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 #include <linux/moduleparam.h>
@@ -41,7 +40,7 @@
 static unsigned int dcc_timeout = 300;
 /* This is slow, but it's simple. --RR */
 static char irc_buffer[65536];
-static DECLARE_LOCK(irc_buffer_lock);
+static DEFINE_SPINLOCK(irc_buffer_lock);
 
 unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
@@ -141,7 +140,7 @@
 	if (dataoff >= (*pskb)->len)
 		return NF_ACCEPT;
 
-	LOCK_BH(&irc_buffer_lock);
+	spin_lock_bh(&irc_buffer_lock);
 	ib_ptr = skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, irc_buffer);
 	BUG_ON(ib_ptr == NULL);
@@ -237,7 +236,7 @@
 	} /* while data < ... */
 
  out:
-	UNLOCK_BH(&irc_buffer_lock);
+	spin_unlock_bh(&irc_buffer_lock);
 	return ret;
 }
 
Index: net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_proto_sctp.c  (mode:100644 sha1:ff8c34a860ff2545148f921ff5a3fbc071a4b1cd)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_proto_sctp.c  (mode:100644 sha1:31d75390bf12b5e648b1b4cd73f701e75764a48d)
@@ -26,7 +26,6 @@
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 #if 0
 #define DEBUGP(format, ...) printk(format, ## __VA_ARGS__)
@@ -35,7 +34,7 @@
 #endif
 
 /* Protects conntrack->proto.sctp */
-static DECLARE_RWLOCK(sctp_lock);
+static DEFINE_RWLOCK(sctp_lock);
 
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
    closely.  They're more complex. --RR 
@@ -199,9 +198,9 @@
 	DEBUGP(__FUNCTION__);
 	DEBUGP("\n");
 
-	READ_LOCK(&sctp_lock);
+	read_lock_bh(&sctp_lock);
 	state = conntrack->proto.sctp.state;
-	READ_UNLOCK(&sctp_lock);
+	read_unlock_bh(&sctp_lock);
 
 	return seq_printf(s, "%s ", sctp_conntrack_names[state]);
 }
@@ -343,13 +342,13 @@
 
 	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, count) {
-		WRITE_LOCK(&sctp_lock);
+		write_lock_bh(&sctp_lock);
 
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
 			/* Sec 8.5.1 (A) */
 			if (sh->vtag != 0) {
-				WRITE_UNLOCK(&sctp_lock);
+				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_ABORT) {
@@ -357,7 +356,7 @@
 			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)])) {
-				WRITE_UNLOCK(&sctp_lock);
+				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
@@ -366,13 +365,13 @@
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)] 
 					&& (sch->flags & 1))) {
-				WRITE_UNLOCK(&sctp_lock);
+				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
 			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
-				WRITE_UNLOCK(&sctp_lock);
+				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		}
@@ -384,7 +383,7 @@
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
 			DEBUGP("ip_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
 			       CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
-			WRITE_UNLOCK(&sctp_lock);
+			write_unlock_bh(&sctp_lock);
 			return -1;
 		}
 
@@ -396,7 +395,7 @@
 			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
 			                        sizeof(_inithdr), &_inithdr);
 			if (ih == NULL) {
-					WRITE_UNLOCK(&sctp_lock);
+					write_unlock_bh(&sctp_lock);
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
@@ -405,7 +404,7 @@
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
-		WRITE_UNLOCK(&sctp_lock);
+		write_unlock_bh(&sctp_lock);
 	}
 
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
Index: net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:721ddbf522b422d554479a7ab15c0955798f16ee)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:809dfed766d4274962fcd949c17814a1011ccace)
@@ -36,7 +36,6 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 #if 0
 #define DEBUGP printk
@@ -46,7 +45,7 @@
 #endif
 
 /* Protects conntrack->proto.tcp */
-static DECLARE_RWLOCK(tcp_lock);
+static DEFINE_RWLOCK(tcp_lock);
 
 /* "Be conservative in what you do, 
     be liberal in what you accept from others." 
@@ -330,9 +329,9 @@
 {
 	enum tcp_conntrack state;
 
-	READ_LOCK(&tcp_lock);
+	read_lock_bh(&tcp_lock);
 	state = conntrack->proto.tcp.state;
-	READ_UNLOCK(&tcp_lock);
+	read_unlock_bh(&tcp_lock);
 
 	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
 }
@@ -738,14 +737,14 @@
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, iph, tcph);
 	
-	WRITE_LOCK(&tcp_lock);
+	write_lock_bh(&tcp_lock);
 	/*
 	 * We have to worry for the ack in the reply packet only...
 	 */
 	if (after(end, conntrack->proto.tcp.seen[dir].td_end))
 		conntrack->proto.tcp.seen[dir].td_end = end;
 	conntrack->proto.tcp.last_end = end;
-	WRITE_UNLOCK(&tcp_lock);
+	write_unlock_bh(&tcp_lock);
 	DEBUGP("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
@@ -857,7 +856,7 @@
 				sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
 	
-	WRITE_LOCK(&tcp_lock);
+	write_lock_bh(&tcp_lock);
 	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
@@ -879,7 +878,7 @@
 			 * that the client cannot but retransmit its SYN and 
 			 * thus initiate a clean new session.
 			 */
-		    	WRITE_UNLOCK(&tcp_lock);
+		    	write_unlock_bh(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					  "ip_ct_tcp: killing out of sync session ");
@@ -894,7 +893,7 @@
 		conntrack->proto.tcp.last_end = 
 		    segment_seq_plus_len(ntohl(th->seq), skb->len, iph, th);
 		
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid packet ignored ");
@@ -904,7 +903,7 @@
 		DEBUGP("ip_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
 		       dir, get_conntrack_index(th),
 		       old_state);
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid state ");
@@ -918,13 +917,13 @@
 		    	     conntrack->proto.tcp.seen[dir].td_end)) {	
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
-		    	WRITE_UNLOCK(&tcp_lock);
+		    	write_unlock_bh(&tcp_lock);
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_REPEAT;
 		} else {
-			WRITE_UNLOCK(&tcp_lock);
+			write_unlock_bh(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				              "ip_ct_tcp: invalid SYN");
@@ -949,7 +948,7 @@
 
 	if (!tcp_in_window(&conntrack->proto.tcp, dir, index, 
 			   skb, iph, th)) {
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		return -NF_ACCEPT;
 	}
     in_window:
@@ -972,7 +971,7 @@
 	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
-	WRITE_UNLOCK(&tcp_lock);
+	write_unlock_bh(&tcp_lock);
 
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
Index: net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_conntrack_standalone.c  (mode:100644 sha1:46ca45f74d85b6e543304df6eb6f89b9db2098d4)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_conntrack_standalone.c  (mode:100644 sha1:e8982b2a73bd718dd1186c3156fc16966067a3ef)
@@ -28,8 +28,8 @@
 #include <net/checksum.h>
 #include <net/ip.h>
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
@@ -119,7 +119,7 @@
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 	return ct_get_idx(seq, *pos);
 }
 
@@ -131,7 +131,7 @@
   
 static void ct_seq_stop(struct seq_file *s, void *v)
 {
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 }
  
 static int ct_seq_show(struct seq_file *s, void *v)
@@ -140,7 +140,7 @@
 	const struct ip_conntrack *conntrack = tuplehash_to_ctrack(hash);
 	struct ip_conntrack_protocol *proto;
 
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	IP_NF_ASSERT(conntrack);
 
 	/* we only want to print DIR_ORIGINAL */
@@ -239,7 +239,7 @@
 
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 
 	if (list_empty(e))
 		return NULL;
@@ -266,7 +266,7 @@
 
 static void exp_seq_stop(struct seq_file *s, void *v)
 {
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
@@ -920,22 +920,22 @@
 {
 	int ret = 0;
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	if (ip_ct_protos[proto->proto] != &ip_conntrack_generic_protocol) {
 		ret = -EBUSY;
 		goto out;
 	}
 	ip_ct_protos[proto->proto] = proto;
  out:
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 	return ret;
 }
 
 void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	ip_ct_protos[proto->proto] = &ip_conntrack_generic_protocol;
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 	
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();
Index: net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_nat_core.c  (mode:100644 sha1:9fc6f93af0dd15de8933a14e053bf8cdf41dfb69)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_nat_core.c  (mode:100644 sha1:739b6dde1c826e3e77ef246ba240234a3b31c3f6)
@@ -22,8 +22,8 @@
 #include <linux/udp.h>
 #include <linux/jhash.h>
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
@@ -41,7 +41,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_RWLOCK(ip_nat_lock);
+DEFINE_RWLOCK(ip_nat_lock);
 
 /* Calculated at init based on memory size */
 static unsigned int ip_nat_htable_size;
@@ -65,9 +65,9 @@
 	if (!(conn->status & IPS_NAT_DONE_MASK))
 		return;
 
-	WRITE_LOCK(&ip_nat_lock);
+	write_lock_bh(&ip_nat_lock);
 	list_del(&conn->nat.info.bysource);
-	WRITE_UNLOCK(&ip_nat_lock);
+	write_unlock_bh(&ip_nat_lock);
 }
 
 /* We do checksum mangling, so if they were wrong before they're still
@@ -142,7 +142,7 @@
 	unsigned int h = hash_by_src(tuple);
 	struct ip_conntrack *ct;
 
-	READ_LOCK(&ip_nat_lock);
+	read_lock_bh(&ip_nat_lock);
 	list_for_each_entry(ct, &bysource[h], nat.info.bysource) {
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
@@ -151,12 +151,12 @@
 			result->dst = tuple->dst;
 
 			if (in_range(result, range)) {
-				READ_UNLOCK(&ip_nat_lock);
+				read_unlock_bh(&ip_nat_lock);
 				return 1;
 			}
 		}
 	}
-	READ_UNLOCK(&ip_nat_lock);
+	read_unlock_bh(&ip_nat_lock);
 	return 0;
 }
 
@@ -297,9 +297,9 @@
 		unsigned int srchash
 			= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 				      .tuple);
-		WRITE_LOCK(&ip_nat_lock);
+		write_lock_bh(&ip_nat_lock);
 		list_add(&info->bysource, &bysource[srchash]);
-		WRITE_UNLOCK(&ip_nat_lock);
+		write_unlock_bh(&ip_nat_lock);
 	}
 
 	/* It's done. */
@@ -474,23 +474,23 @@
 {
 	int ret = 0;
 
-	WRITE_LOCK(&ip_nat_lock);
+	write_lock_bh(&ip_nat_lock);
 	if (ip_nat_protos[proto->protonum] != &ip_nat_unknown_protocol) {
 		ret = -EBUSY;
 		goto out;
 	}
 	ip_nat_protos[proto->protonum] = proto;
  out:
-	WRITE_UNLOCK(&ip_nat_lock);
+	write_unlock_bh(&ip_nat_lock);
 	return ret;
 }
 
 /* Noone stores the protocol anywhere; simply delete it. */
 void ip_nat_protocol_unregister(struct ip_nat_protocol *proto)
 {
-	WRITE_LOCK(&ip_nat_lock);
+	write_lock_bh(&ip_nat_lock);
 	ip_nat_protos[proto->protonum] = &ip_nat_unknown_protocol;
-	WRITE_UNLOCK(&ip_nat_lock);
+	write_unlock_bh(&ip_nat_lock);
 
 	/* Someone could be still looking at the proto in a bh. */
 	synchronize_net();
@@ -509,13 +509,13 @@
 		return -ENOMEM;
 
 	/* Sew in builtin protocols. */
-	WRITE_LOCK(&ip_nat_lock);
+	write_lock_bh(&ip_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
 		ip_nat_protos[i] = &ip_nat_unknown_protocol;
 	ip_nat_protos[IPPROTO_TCP] = &ip_nat_protocol_tcp;
 	ip_nat_protos[IPPROTO_UDP] = &ip_nat_protocol_udp;
 	ip_nat_protos[IPPROTO_ICMP] = &ip_nat_protocol_icmp;
-	WRITE_UNLOCK(&ip_nat_lock);
+	write_unlock_bh(&ip_nat_lock);
 
 	for (i = 0; i < ip_nat_htable_size; i++) {
 		INIT_LIST_HEAD(&bysource[i]);
Index: net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644 sha1:1637b96d8c0110c155efd1fe7492570cfdb34650)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644 sha1:9cd51f180dcf01a2d1a0fe5479f8b488d18a9484)
@@ -28,8 +28,8 @@
 #include <net/tcp.h>
 #include <net/udp.h>
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -47,7 +47,7 @@
 #define DUMP_OFFSET(x)
 #endif
 
-static DECLARE_LOCK(ip_nat_seqofs_lock);
+static DEFINE_SPINLOCK(ip_nat_seqofs_lock);
 
 /* Setup TCP sequence correction given this change at this sequence */
 static inline void 
@@ -70,7 +70,7 @@
 	DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
 
-	LOCK_BH(&ip_nat_seqofs_lock);
+	spin_lock_bh(&ip_nat_seqofs_lock);
 
 	/* SYN adjust. If it's uninitialized, or this is after last
 	 * correction, record it: we don't handle more than one
@@ -82,7 +82,7 @@
 		    this_way->offset_before = this_way->offset_after;
 		    this_way->offset_after += sizediff;
 	}
-	UNLOCK_BH(&ip_nat_seqofs_lock);
+	spin_unlock_bh(&ip_nat_seqofs_lock);
 
 	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
 	DUMP_OFFSET(this_way);
Index: net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_nat_rule.c  (mode:100644 sha1:581f097f5a247b43504c1290d71e75008434dd8a)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_nat_rule.c  (mode:100644 sha1:60d70fa41a156a63bd4abb9a04a894297a8fa0d7)
@@ -19,8 +19,8 @@
 #include <net/route.h>
 #include <linux/bitops.h>
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
Index: net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644 sha1:79f56f662b336bb1a48298af7c0d03c1e1d73b89)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644 sha1:bc59d0d6e89ef5bf16512ea6cc0a5d246d6a4f2d)
@@ -31,8 +31,8 @@
 #include <net/checksum.h>
 #include <linux/spinlock.h>
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
@@ -373,7 +373,6 @@
  cleanup_rule_init:
 	ip_nat_rule_cleanup();
  cleanup_nothing:
-	MUST_BE_READ_WRITE_UNLOCKED(&ip_nat_lock);
 	return ret;
 }
 
Index: net/ipv4/netfilter/ip_tables.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ip_tables.c  (mode:100644 sha1:8a54f92b8496a4218a243c35ab2b55ec659e7d18)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ip_tables.c  (mode:100644 sha1:c88dfcd38c5623792e9876810129be204e010915)
@@ -67,7 +67,6 @@
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
Index: net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ipt_CLUSTERIP.c  (mode:100644 sha1:0f12e3a3dc73dc9e4c6a535a717581c2f89d3958)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ipt_CLUSTERIP.c  (mode:100644 sha1:dc4362b57cfa497746a100b4cd8ed5079e499b29)
@@ -29,7 +29,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 #define CLUSTERIP_VERSION "0.6"
 
@@ -41,6 +40,8 @@
 #define DEBUGP
 #endif
 
+#define ASSERT_READ_LOCK(x)
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables target for CLUSTERIP");
@@ -67,7 +68,7 @@
 
 /* clusterip_lock protects the clusterip_configs list _AND_ the configurable
  * data within all structurses (num_local_nodes, local_nodes[]) */
-static DECLARE_RWLOCK(clusterip_lock);
+static DEFINE_RWLOCK(clusterip_lock);
 
 #ifdef CONFIG_PROC_FS
 static struct file_operations clusterip_proc_fops;
@@ -82,9 +83,9 @@
 static inline void
 clusterip_config_put(struct clusterip_config *c) {
 	if (atomic_dec_and_test(&c->refcount)) {
-		WRITE_LOCK(&clusterip_lock);
+		write_lock_bh(&clusterip_lock);
 		list_del(&c->list);
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		dev_mc_delete(c->dev, c->clustermac, ETH_ALEN, 0);
 		dev_put(c->dev);
 		kfree(c);
@@ -97,7 +98,7 @@
 {
 	struct list_head *pos;
 
-	MUST_BE_READ_LOCKED(&clusterip_lock);
+	ASSERT_READ_LOCK(&clusterip_lock);
 	list_for_each(pos, &clusterip_configs) {
 		struct clusterip_config *c = list_entry(pos, 
 					struct clusterip_config, list);
@@ -114,14 +115,14 @@
 {
 	struct clusterip_config *c;
 
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
 	c = __clusterip_config_find(clusterip);
 	if (!c) {
-		READ_UNLOCK(&clusterip_lock);
+		read_unlock_bh(&clusterip_lock);
 		return NULL;
 	}
 	atomic_inc(&c->refcount);
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
 
 	return c;
 }
@@ -160,9 +161,9 @@
 	c->pde->data = c;
 #endif
 
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
 	list_add(&c->list, &clusterip_configs);
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
 
 	return c;
 }
@@ -172,25 +173,25 @@
 {
 	int i;
 
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
 
 	if (c->num_local_nodes >= CLUSTERIP_MAX_NODES
 	    || nodenum > CLUSTERIP_MAX_NODES) {
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		return 1;
 	}
 
 	/* check if we alrady have this number in our array */
 	for (i = 0; i < c->num_local_nodes; i++) {
 		if (c->local_nodes[i] == nodenum) {
-			WRITE_UNLOCK(&clusterip_lock);
+			write_unlock_bh(&clusterip_lock);
 			return 1;
 		}
 	}
 
 	c->local_nodes[c->num_local_nodes++] = nodenum;
 
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
 	return 0;
 }
 
@@ -199,10 +200,10 @@
 {
 	int i;
 
-	WRITE_LOCK(&clusterip_lock);
+	write_lock_bh(&clusterip_lock);
 
 	if (c->num_local_nodes <= 1 || nodenum > CLUSTERIP_MAX_NODES) {
-		WRITE_UNLOCK(&clusterip_lock);
+		write_unlock_bh(&clusterip_lock);
 		return 1;
 	}
 		
@@ -211,12 +212,12 @@
 			int size = sizeof(u_int16_t)*(c->num_local_nodes-(i+1));
 			memmove(&c->local_nodes[i], &c->local_nodes[i+1], size);
 			c->num_local_nodes--;
-			WRITE_UNLOCK(&clusterip_lock);
+			write_unlock_bh(&clusterip_lock);
 			return 0;
 		}
 	}
 
-	WRITE_UNLOCK(&clusterip_lock);
+	write_unlock_bh(&clusterip_lock);
 	return 1;
 }
 
@@ -286,21 +287,21 @@
 {
 	int i;
 
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
 
 	if (config->num_local_nodes == 0) {
-		READ_UNLOCK(&clusterip_lock);
+		read_unlock_bh(&clusterip_lock);
 		return 0;
 	}
 
 	for (i = 0; i < config->num_local_nodes; i++) {
 		if (config->local_nodes[i] == hash) {
-			READ_UNLOCK(&clusterip_lock);
+			read_unlock_bh(&clusterip_lock);
 			return 1;
 		}
 	}
 
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
 
 	return 0;
 }
@@ -578,7 +579,7 @@
 	struct clusterip_config *c = pde->data;
 	unsigned int *nodeidx;
 
-	READ_LOCK(&clusterip_lock);
+	read_lock_bh(&clusterip_lock);
 	if (*pos >= c->num_local_nodes)
 		return NULL;
 
@@ -608,7 +609,7 @@
 {
 	kfree(v);
 
-	READ_UNLOCK(&clusterip_lock);
+	read_unlock_bh(&clusterip_lock);
 }
 
 static int clusterip_seq_show(struct seq_file *s, void *v)
Index: net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ipt_MASQUERADE.c  (mode:100644 sha1:57e9f6cf1c36d5eac1574351a96a9768cea82b2c)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ipt_MASQUERADE.c  (mode:100644 sha1:91e74502c3d36ae652eca8041cc8dc66690eaf44)
@@ -33,7 +33,7 @@
 #endif
 
 /* Lock protects masq region inside conntrack */
-static DECLARE_RWLOCK(masq_lock);
+static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
 static int
@@ -103,9 +103,9 @@
 		return NF_DROP;
 	}
 
-	WRITE_LOCK(&masq_lock);
+	write_lock_bh(&masq_lock);
 	ct->nat.masq_index = out->ifindex;
-	WRITE_UNLOCK(&masq_lock);
+	write_unlock_bh(&masq_lock);
 
 	/* Transfer from original range. */
 	newrange = ((struct ip_nat_range)
@@ -122,9 +122,9 @@
 {
 	int ret;
 
-	READ_LOCK(&masq_lock);
+	read_lock_bh(&masq_lock);
 	ret = (i->nat.masq_index == (int)(long)ifindex);
-	READ_UNLOCK(&masq_lock);
+	read_unlock_bh(&masq_lock);
 
 	return ret;
 }
Index: net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ipt_ULOG.c  (mode:100644 sha1:6f2cefbe16cd8ccfcd3987b33e4b4e18ad1cc5cd)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ipt_ULOG.c  (mode:100644 sha1:52a0076302a7668a4e627f86c4b4186f964cd9e2)
@@ -56,7 +56,6 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <net/sock.h>
 #include <linux/bitops.h>
 
@@ -99,8 +98,8 @@
 
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
 
-static struct sock *nflognl;	/* our socket */
-static DECLARE_LOCK(ulog_lock);	/* spinlock */
+static struct sock *nflognl;		/* our socket */
+static DEFINE_SPINLOCK(ulog_lock);	/* spinlock */
 
 /* send one ulog_buff_t to userspace */
 static void ulog_send(unsigned int nlgroupnum)
@@ -135,9 +134,9 @@
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
-	LOCK_BH(&ulog_lock);
+	spin_lock_bh(&ulog_lock);
 	ulog_send(data);
-	UNLOCK_BH(&ulog_lock);
+	spin_unlock_bh(&ulog_lock);
 }
 
 static struct sk_buff *ulog_alloc_skb(unsigned int size)
@@ -193,7 +192,7 @@
 
 	ub = &ulog_buffers[groupnum];
 	
-	LOCK_BH(&ulog_lock);
+	spin_lock_bh(&ulog_lock);
 
 	if (!ub->skb) {
 		if (!(ub->skb = ulog_alloc_skb(size)))
@@ -278,7 +277,7 @@
 		ulog_send(groupnum);
 	}
 
-	UNLOCK_BH(&ulog_lock);
+	spin_unlock_bh(&ulog_lock);
 
 	return;
 
@@ -288,7 +287,7 @@
 alloc_failure:
 	PRINTR("ipt_ULOG: Error building netlink message\n");
 
-	UNLOCK_BH(&ulog_lock);
+	spin_unlock_bh(&ulog_lock);
 }
 
 static unsigned int ipt_ulog_target(struct sk_buff **pskb,
Index: net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ipt_hashlimit.c  (mode:100644 sha1:f1937190cd771c57f3904a2f605b7702764c9427)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ipt_hashlimit.c  (mode:100644 sha1:564b49bfebcf6feda673d223713d911da17145a1)
@@ -37,7 +37,6 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_hashlimit.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* FIXME: this is just for IP_NF_ASSERRT */
 #include <linux/netfilter_ipv4/ip_conntrack.h>
@@ -92,7 +91,7 @@
 	struct hlist_head hash[0];	/* hashtable itself */
 };
 
-static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
+static DEFINE_SPINLOCK(hashlimit_lock);	/* protects htables list */
 static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static HLIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
@@ -233,9 +232,9 @@
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
 
-	LOCK_BH(&hashlimit_lock);
+	spin_lock_bh(&hashlimit_lock);
 	hlist_add_head(&hinfo->node, &hashlimit_htables);
-	UNLOCK_BH(&hashlimit_lock);
+	spin_unlock_bh(&hashlimit_lock);
 
 	return 0;
 }
@@ -301,15 +300,15 @@
 	struct ipt_hashlimit_htable *hinfo;
 	struct hlist_node *pos;
 
-	LOCK_BH(&hashlimit_lock);
+	spin_lock_bh(&hashlimit_lock);
 	hlist_for_each_entry(hinfo, pos, &hashlimit_htables, node) {
 		if (!strcmp(name, hinfo->pde->name)) {
 			atomic_inc(&hinfo->use);
-			UNLOCK_BH(&hashlimit_lock);
+			spin_unlock_bh(&hashlimit_lock);
 			return hinfo;
 		}
 	}
-	UNLOCK_BH(&hashlimit_lock);
+	spin_unlock_bh(&hashlimit_lock);
 
 	return NULL;
 }
@@ -317,9 +316,9 @@
 static void htable_put(struct ipt_hashlimit_htable *hinfo)
 {
 	if (atomic_dec_and_test(&hinfo->use)) {
-		LOCK_BH(&hashlimit_lock);
+		spin_lock_bh(&hashlimit_lock);
 		hlist_del(&hinfo->node);
-		UNLOCK_BH(&hashlimit_lock);
+		spin_unlock_bh(&hashlimit_lock);
 		htable_destroy(hinfo);
 	}
 }
Index: net/ipv4/netfilter/ipt_helper.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv4/netfilter/ipt_helper.c  (mode:100644 sha1:33fdf364d3d37eab3b1e78f3586d21c4b990464b)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv4/netfilter/ipt_helper.c  (mode:100644 sha1:3e7dd014de4363c8fda5b08cc11ee6d3925b75fa)
@@ -53,7 +53,7 @@
 		return ret;
 	}
 
-	READ_LOCK(&ip_conntrack_lock);
+	read_lock_bh(&ip_conntrack_lock);
 	if (!ct->master->helper) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n", 
 			exp->expectant);
@@ -69,7 +69,7 @@
 		ret ^= !strncmp(ct->master->helper->name, info->name, 
 		                strlen(ct->master->helper->name));
 out_unlock:
-	READ_UNLOCK(&ip_conntrack_lock);
+	read_unlock_bh(&ip_conntrack_lock);
 	return ret;
 }
 
Index: net/ipv6/netfilter/ip6_tables.c
===================================================================
--- 37a577077717c6fc76b74317dd95502e3c0b0803/net/ipv6/netfilter/ip6_tables.c  (mode:100644 sha1:c735276fdd5fbcd6c31f040d470bb79cd5998032)
+++ 2c41b93e5bb6e40e4c8b01e745fae2a928378ecc/net/ipv6/netfilter/ip6_tables.c  (mode:100644 sha1:73034511c8db49d8b03ec2f441899a2118523af1)
@@ -71,7 +71,6 @@
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) != 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) != 0)
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0

--------------060207010606010402030005--
