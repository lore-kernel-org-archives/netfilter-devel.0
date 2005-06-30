From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 3/6] kill lockhelp.h
Date: Thu, 30 Jun 2005 10:31:08 +0900 (JST)
Message-ID: <200506300131.j5U1V8C5004187@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:31:08_2005_624)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Jun_30_10:31:08_2005_624)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
        [NETFILTER]: Kill lockhelp.h

        Signed-off-by: Patrick McHardy <kaber@trash.net>
        Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Jun_30_10:31:08_2005_624)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-kill-lockhelp.patch"

Index: include/linux/netfilter/nf_conntrack_core.h
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/include/linux/netfilter/nf_conntrack_core.h  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/include/linux/netfilter/nf_conntrack_core.h  (mode:100644)
@@ -13,7 +13,6 @@
 #define _NF_CONNTRACK_CORE_H
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
@@ -68,5 +67,5 @@
 
 extern struct list_head *nf_conntrack_hash;
 extern struct list_head nf_conntrack_expect_list;
-DECLARE_RWLOCK_EXTERN(nf_conntrack_lock);
+extern rwlock_t nf_conntrack_lock;
 #endif /* _NF_CONNTRACK_CORE_H */
Index: net/netfilter/nf_conntrack_core.c
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_core.c  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/net/netfilter/nf_conntrack_core.c  (mode:100644)
@@ -41,11 +41,12 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/socket.h>
+#include <asm/semaphore.h>
 
-/* This rwlock protects the main hash table, protocol/helper/expected
+/* nf_conntrack protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&nf_conntrack_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&nf_conntrack_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter/nf_conntrack_l3proto.h>
@@ -62,7 +63,7 @@
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_RWLOCK(nf_conntrack_lock);
+DEFINE_RWLOCK(nf_conntrack_lock);
 
 /* nf_conntrack_standalone needs this */
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
@@ -109,7 +110,7 @@
 } nf_ct_cache[NF_CT_F_NUM];
 
 /* protect members of nf_ct_cache except of "use" */
-DECLARE_RWLOCK(nf_ct_cache_lock);
+DEFINE_RWLOCK(nf_ct_cache_lock);
 
 /* This avoids calling kmem_cache_create() with same name simultaneously */
 DECLARE_MUTEX(nf_ct_cache_mutex);
@@ -154,7 +155,7 @@
 
 	DEBUGP("alloc_conntrack: features=0x%x\n", features);
 
-	READ_LOCK(&nf_ct_cache_lock);
+	read_lock_bh(&nf_ct_cache_lock);
 
 	if (!nf_ct_cache[features].use) {
 		DEBUGP("alloc_conntrack: not supported features = 0x%x\n",
@@ -178,7 +179,7 @@
 	}
 
 out:
-	READ_UNLOCK(&nf_ct_cache_lock);
+	read_unlock_bh(&nf_ct_cache_lock);
 	return conntrack;
 }
 
@@ -223,7 +224,7 @@
 
 	down(&nf_ct_cache_mutex);
 
-	WRITE_LOCK(&nf_ct_cache_lock);
+	write_lock_bh(&nf_ct_cache_lock);
 	/* e.g: multiple helpers are loaded */
 	if (nf_ct_cache[features].use > 0) {
 		DEBUGP("nf_conntrack_register_cache: already resisterd.\n");
@@ -237,11 +238,11 @@
 		} else
 			ret = -EBUSY;
 
-		WRITE_UNLOCK(&nf_ct_cache_lock);
+		write_unlock_bh(&nf_ct_cache_lock);
 		up(&nf_ct_cache_mutex);
 		return ret;
 	}
-	WRITE_UNLOCK(&nf_ct_cache_lock);
+	write_unlock_bh(&nf_ct_cache_lock);
 
 	/*
 	 * The memory space for name of slab cache must be alive until
@@ -270,13 +271,13 @@
 		goto out_free_name;
 	}
 
-	WRITE_LOCK(&nf_ct_cache_lock);
+	write_lock_bh(&nf_ct_cache_lock);
 	nf_ct_cache[features].use = 1;
 	nf_ct_cache[features].size = size;
 	nf_ct_cache[features].init_conntrack = init;
 	nf_ct_cache[features].cachep = cachep;
 	nf_ct_cache[features].name = cache_name;
-	WRITE_UNLOCK(&nf_ct_cache_lock);
+	write_unlock_bh(&nf_ct_cache_lock);
 
 	goto out_up_mutex;
 
@@ -300,9 +301,9 @@
 	DEBUGP("nf_conntrack_unregister_cache: 0x%04x\n", features);
 	down(&nf_ct_cache_mutex);
 
-	WRITE_LOCK(&nf_ct_cache_lock);
+	write_lock_bh(&nf_ct_cache_lock);
 	if (--nf_ct_cache[features].use > 0) {
-		WRITE_UNLOCK(&nf_ct_cache_lock);
+		write_unlock_bh(&nf_ct_cache_lock);
 		up(&nf_ct_cache_mutex);
 		return;
 	}
@@ -312,7 +313,7 @@
 	nf_ct_cache[features].name = NULL;
 	nf_ct_cache[features].init_conntrack = NULL;
 	nf_ct_cache[features].size = 0;
-	WRITE_UNLOCK(&nf_ct_cache_lock);
+	write_unlock_bh(&nf_ct_cache_lock);
 
 	synchronize_net();
 
@@ -373,7 +374,7 @@
 
 static void unlink_expect(struct nf_conntrack_expect *exp)
 {
-	MUST_BE_WRITE_LOCKED(&nf_conntrack_lock);
+	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 	list_del(&exp->list);
 	/* Logically in destroy_expect, but we hold the lock here. */
 	exp->master->expecting--;
@@ -383,9 +384,9 @@
 {
 	struct nf_conntrack_expect *exp = (void *)ul_expect;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	unlink_expect(exp);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	destroy_expect(exp);
 }
 
@@ -435,7 +436,7 @@
 	unsigned int ho, hr;
 	
 	DEBUGP("clean_from_lists(%p)\n", ct);
-	MUST_BE_WRITE_LOCKED(&nf_conntrack_lock);
+	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
 
 	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	hr = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -472,7 +473,7 @@
 	if (nf_conntrack_destroyed)
 		nf_conntrack_destroyed(ct);
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	/* Expectations will have been removed in clean_from_lists,
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
@@ -486,7 +487,7 @@
 	}
 
 	NF_CT_STAT_INC(delete);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	if (ct->master)
 		nf_ct_put(ct->master);
@@ -500,12 +501,12 @@
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
 	NF_CT_STAT_INC(delete_list);
 	clean_from_lists(ct);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	nf_ct_put(ct);
 }
 
@@ -514,7 +515,7 @@
 		    const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack)
 {
-	MUST_BE_READ_LOCKED(&nf_conntrack_lock);
+	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	return nf_ct_tuplehash_to_ctrack(i) != ignored_conntrack
 		&& nf_ct_tuple_equal(tuple, &i->tuple);
 }
@@ -526,7 +527,7 @@
 	struct nf_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
 
-	MUST_BE_READ_LOCKED(&nf_conntrack_lock);
+	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	list_for_each_entry(h, &nf_conntrack_hash[hash], list) {
 		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
 			NF_CT_STAT_INC(found);
@@ -545,11 +546,11 @@
 {
 	struct nf_conntrack_tuple_hash *h;
 
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 	h = __nf_conntrack_find(tuple, ignored_conntrack);
 	if (h)
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	return h;
 }
@@ -584,7 +585,7 @@
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 	DEBUGP("Confirming conntrack %p\n", ct);
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
@@ -612,12 +613,12 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		NF_CT_STAT_INC(insert);
-		WRITE_UNLOCK(&nf_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 		return NF_ACCEPT;
 	}
 
 	NF_CT_STAT_INC(insert_failed);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	return NF_DROP;
 }
 
@@ -629,9 +630,9 @@
 {
 	struct nf_conntrack_tuple_hash *h;
 
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 	h = __nf_conntrack_find(tuple, ignored_conntrack);
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	return h != NULL;
 }
@@ -651,13 +652,13 @@
 	struct nf_conn *ct = NULL;
 	int dropped = 0;
 
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 	h = LIST_FIND_B(chain, unreplied, struct nf_conntrack_tuple_hash *);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		atomic_inc(&ct->ct_general.use);
 	}
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	if (!ct)
 		return dropped;
@@ -727,12 +728,12 @@
 
 	/*  find features needed by this conntrack. */
 	features = l3proto->get_features(tuple);
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_find_helper(&repl_tuple) != NULL) {
 		features |= NF_CT_F_HELP;
 		helper_used = 1;
 	}
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 
 	conntrack = alloc_conntrack(features);
 	if (!conntrack) {
@@ -754,7 +755,7 @@
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	exp = find_expectation(tuple);
 
 	if (exp) {
@@ -778,7 +779,7 @@
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
 	atomic_inc(&nf_conntrack_count);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	if (exp) {
 		if (exp->expectfn)
@@ -965,17 +966,17 @@
 {
 	struct nf_conntrack_expect *i;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			unlink_expect(i);
-			WRITE_UNLOCK(&nf_conntrack_lock);
+			write_unlock_bh(&nf_conntrack_lock);
 			destroy_expect(i);
 			return;
 		}
 	}
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 }
 
 struct nf_conntrack_expect *nf_conntrack_expect_alloc(void)
@@ -1050,7 +1051,7 @@
 	DEBUGP("tuple: "); NF_CT_DUMP_TUPLE(&expect->tuple);
 	DEBUGP("mask:  "); NF_CT_DUMP_TUPLE(&expect->mask);
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
@@ -1073,7 +1074,7 @@
 	nf_conntrack_expect_insert(expect);
 	ret = 0;
 out:
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	return ret;
 }
 
@@ -1082,7 +1083,7 @@
 void nf_conntrack_alter_reply(struct nf_conn *conntrack,
 			      const struct nf_conntrack_tuple *newreply)
 {
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(conntrack));
 
@@ -1092,7 +1093,7 @@
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && conntrack->expecting == 0)
 		conntrack->helper = nf_ct_find_helper(newreply);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 }
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
@@ -1109,9 +1110,9 @@
 		printk(KERN_ERR "nf_conntrack_helper_reigster: Unable to create slab cache for conntracks\n");
 		return ret;
 	}
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	list_prepend(&helpers, me);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	return 0;
 }
@@ -1130,7 +1131,7 @@
 	struct nf_conntrack_expect *exp, *tmp;
 
 	/* Need write lock here, to delete helper. */
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	LIST_DELETE(&helpers, me);
 
 	/* Get rid of expectations */
@@ -1146,7 +1147,7 @@
 	for (i = 0; i < nf_conntrack_htable_size; i++)
 		LIST_FIND_W(&nf_conntrack_hash[i], unhelp,
 			    struct nf_conntrack_tuple_hash *, me);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	/* Someone could be still looking at the helper in a bh. */
 	synchronize_net();
@@ -1180,14 +1181,14 @@
 		ct->timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
-		WRITE_LOCK(&nf_conntrack_lock);
+		write_lock_bh(&nf_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}
 		ct_add_counters(ct, ctinfo, skb);
-		WRITE_UNLOCK(&nf_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 	}
 }
 
@@ -1225,7 +1226,7 @@
 {
 	struct nf_conntrack_tuple_hash *h = NULL;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
 		h = LIST_FIND_W(&nf_conntrack_hash[*bucket], do_iter,
 				struct nf_conntrack_tuple_hash *, iter, data);
@@ -1237,7 +1238,7 @@
 				struct nf_conntrack_tuple_hash *, iter, data);
 	if (h)
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	return h;
 }
@@ -1366,10 +1367,10 @@
 	}
 
 	/* Don't NEED lock here, but good form anyway. */
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
         for (i = 0; i < PF_MAX; i++)
 		nf_ct_l3protos[i] = &nf_conntrack_generic_l3proto;
-        WRITE_UNLOCK(&nf_conntrack_lock);
+        write_unlock_bh(&nf_conntrack_lock);
 
 	for (i = 0; i < nf_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&nf_conntrack_hash[i]);
Index: net/netfilter/nf_conntrack_ftp.c
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_ftp.c  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/net/netfilter/nf_conntrack_ftp.c  (mode:100644)
@@ -26,7 +26,6 @@
 #include <net/tcp.h>
 
 #include <linux/netfilter/nf_conntrack.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
@@ -37,7 +36,7 @@
 /* This is slow, but it's simple. --RR */
 static char ftp_buffer[65536];
 
-static DECLARE_LOCK(nf_ftp_lock);
+static DEFINE_SPINLOCK(nf_ftp_lock);
 
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
@@ -464,7 +463,7 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
-	LOCK_BH(&nf_ftp_lock);
+	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb_header_pointer(*pskb, dataoff, datalen, ftp_buffer);
 	BUG_ON(fb_ptr == NULL);
 
@@ -611,7 +610,7 @@
 	if (ends_in_nl)
 		update_nl_seq(seq, ct_ftp_info,dir);
  out:
-	UNLOCK_BH(&nf_ftp_lock);
+	spin_unlock_bh(&nf_ftp_lock);
 	return ret;
 }
 
Index: net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_proto_sctp.c  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/net/netfilter/nf_conntrack_proto_sctp.c  (mode:100644)
@@ -31,7 +31,6 @@
 
 #include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter/nf_conntrack_protocol.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 #if 0
 #define DEBUGP(format, ...) printk(format, ## __VA_ARGS__)
@@ -40,7 +39,7 @@
 #endif
 
 /* Protects conntrack->proto.sctp */
-static DECLARE_RWLOCK(sctp_lock);
+static DEFINE_RWLOCK(sctp_lock);
 
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
    closely.  They're more complex. --RR 
@@ -204,9 +203,9 @@
 	DEBUGP(__FUNCTION__);
 	DEBUGP("\n");
 
-	READ_LOCK(&sctp_lock);
+	read_lock_bh(&sctp_lock);
 	state = conntrack->proto.sctp.state;
-	READ_UNLOCK(&sctp_lock);
+	read_unlock_bh(&sctp_lock);
 
 	return seq_printf(s, "%s ", sctp_conntrack_names[state]);
 }
@@ -351,13 +350,13 @@
 
 	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
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
@@ -365,7 +364,7 @@
 			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)])) {
-				WRITE_UNLOCK(&sctp_lock);
+				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
@@ -374,13 +373,13 @@
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
@@ -392,7 +391,7 @@
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
 			DEBUGP("nf_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
 			       CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
-			WRITE_UNLOCK(&sctp_lock);
+			write_unlock_bh(&sctp_lock);
 			return -1;
 		}
 
@@ -404,7 +403,7 @@
 			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
 			                        sizeof(_inithdr), &_inithdr);
 			if (ih == NULL) {
-					WRITE_UNLOCK(&sctp_lock);
+					write_unlock_bh(&sctp_lock);
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
@@ -413,7 +412,7 @@
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
-		WRITE_UNLOCK(&sctp_lock);
+		write_unlock_bh(&sctp_lock);
 	}
 
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
Index: net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_proto_tcp.c  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/net/netfilter/nf_conntrack_proto_tcp.c  (mode:100644)
@@ -43,7 +43,6 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter/nf_conntrack_protocol.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 #if 0
 #define DEBUGP printk
@@ -53,7 +52,7 @@
 #endif
 
 /* Protects conntrack->proto.tcp */
-static DECLARE_RWLOCK(tcp_lock);
+static DEFINE_RWLOCK(tcp_lock);
 
 /* "Be conservative in what you do, 
     be liberal in what you accept from others." 
@@ -337,9 +336,9 @@
 {
 	enum tcp_conntrack state;
 
-	READ_LOCK(&tcp_lock);
+	read_lock_bh(&tcp_lock);
 	state = conntrack->proto.tcp.state;
-	READ_UNLOCK(&tcp_lock);
+	read_unlock_bh(&tcp_lock);
 
 	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
 }
@@ -747,14 +746,14 @@
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, dataoff, tcph);
 
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
@@ -903,7 +902,7 @@
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
 
-	WRITE_LOCK(&tcp_lock);
+	write_lock_bh(&tcp_lock);
 	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
@@ -925,7 +924,7 @@
 			 * that the client cannot but retransmit its SYN and 
 			 * thus initiate a clean new session.
 			 */
-		    	WRITE_UNLOCK(&tcp_lock);
+		    	write_unlock_bh(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(pf, 0, skb, NULL, NULL, 
 					  "nf_ct_tcp: killing out of sync session ");
@@ -940,7 +939,7 @@
 		conntrack->proto.tcp.last_end =
 		    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
 
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, 
 				  "nf_ct_tcp: invalid packed ignored ");
@@ -950,7 +949,7 @@
 		DEBUGP("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
 		       dir, get_conntrack_index(th),
 		       old_state);
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, 
 				  "nf_ct_tcp: invalid state ");
@@ -964,7 +963,7 @@
 			     conntrack->proto.tcp.seen[dir].td_end)) {
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
-		    	WRITE_UNLOCK(&tcp_lock);
+		    	write_unlock_bh(&tcp_lock);
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
@@ -989,7 +988,7 @@
 
 	if (!tcp_in_window(&conntrack->proto.tcp, dir, index,
 			   skb, dataoff, th, pf)) {
-		WRITE_UNLOCK(&tcp_lock);
+		write_unlock_bh(&tcp_lock);
 		return -NF_ACCEPT;
 	}
      in_window:
@@ -1012,7 +1011,7 @@
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
-	WRITE_UNLOCK(&tcp_lock);
+	write_unlock_bh(&tcp_lock);
 
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
Index: net/netfilter/nf_conntrack_standalone.c
===================================================================
--- 943a81f457fa24df61ea4c6e469854149645aa1c/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
+++ 2c563bbd248355b4755af27e4ba819b2488b35fc/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
@@ -30,8 +30,8 @@
 #include <linux/sysctl.h>
 #endif
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&nf_conntrack_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&nf_conntrack_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter/nf_conntrack_l3proto.h>
@@ -131,7 +131,7 @@
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 	return ct_get_idx(seq, *pos);
 }
 
@@ -143,7 +143,7 @@
 
 static void ct_seq_stop(struct seq_file *s, void *v)
 {
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 }
 
 /* return 0 on success, 1 in case of error */
@@ -154,7 +154,7 @@
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_protocol *proto;
 
-	MUST_BE_READ_LOCKED(&nf_conntrack_lock);
+	ASSERT_READ_LOCK(&nf_conntrack_lock);
 	NF_CT_ASSERT(conntrack);
 
 	/* we only want to print DIR_ORIGINAL */
@@ -263,7 +263,7 @@
 
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
-	READ_LOCK(&nf_conntrack_lock);
+	read_lock_bh(&nf_conntrack_lock);
 
 	if (list_empty(e))
 		return NULL;
@@ -291,7 +291,7 @@
 
 static void exp_seq_stop(struct seq_file *s, void *v)
 {
-	READ_UNLOCK(&nf_conntrack_lock);
+	read_unlock_bh(&nf_conntrack_lock);
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
@@ -710,23 +710,23 @@
 {
 	int ret = 0;
 
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_generic_l3proto) {
 		ret = -EBUSY;
 		goto out;
 	}
 	nf_ct_l3protos[proto->l3proto] = proto;
 out:
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	return ret;
 }
 
 void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 {
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_generic_l3proto;
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();
@@ -742,7 +742,7 @@
 	int ret = 0;
 
 retry:
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_protos[proto->l3proto]) {
 		if (nf_ct_protos[proto->l3proto][proto->proto]
 				!= &nf_conntrack_generic_protocol) {
@@ -754,7 +754,7 @@
 		struct nf_conntrack_protocol **proto_array;
 		int i;
 
-		WRITE_UNLOCK(&nf_conntrack_lock);
+		write_unlock_bh(&nf_conntrack_lock);
 
 		proto_array = (struct nf_conntrack_protocol **)
 				kmalloc(MAX_NF_CT_PROTO *
@@ -767,14 +767,14 @@
 		for (i = 0; i < MAX_NF_CT_PROTO; i++)
 			proto_array[i] = &nf_conntrack_generic_protocol;
 
-		WRITE_LOCK(&nf_conntrack_lock);
+		write_lock_bh(&nf_conntrack_lock);
 		if (nf_ct_protos[proto->l3proto]) {
 			/* bad timing, but no problem */
-			WRITE_UNLOCK(&nf_conntrack_lock);
+			write_unlock_bh(&nf_conntrack_lock);
 			kfree(proto_array);
 		} else {
 			nf_ct_protos[proto->l3proto] = proto_array;
-			WRITE_UNLOCK(&nf_conntrack_lock);
+			write_unlock_bh(&nf_conntrack_lock);
 		}
 
 		/*
@@ -787,17 +787,17 @@
 	nf_ct_protos[proto->l3proto][proto->proto] = proto;
 
 out_unlock:
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 out:
 	return ret;
 }
 
 void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto)
 {
-	WRITE_LOCK(&nf_conntrack_lock);
+	write_lock_bh(&nf_conntrack_lock);
 	nf_ct_protos[proto->l3proto][proto->proto]
 		= &nf_conntrack_generic_protocol;
-	WRITE_UNLOCK(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 	
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();

----Next_Part(Thu_Jun_30_10:31:08_2005_624)----
