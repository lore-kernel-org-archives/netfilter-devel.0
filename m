From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Made ct_sync running with 2.6.15.4...
Date: Sat, 11 Mar 2006 04:31:23 +0100
Message-ID: <20060311033122.GA23805@galois.math.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Hi!

I'm building a firewall solution for my departement and found ct_sync at [42]
while searching for a statefull failover solution.

I saw that the patches and the module code were written for kernel
version 2.6.10 and experienced rather big trouble patching kernel
version 2.6.15.4 :-/

So I began to update the files and got a running version of ct_sync
which is now running some days on my test firewalls and is working well
after some failovers.
The only thing I'm worrying about were many ct entries I produced by
nmap -sP <net behing the firewall>
which did not vanish after 10++ hours. I had to reboot to get rid of the
connections.

What I did:

 1. branches/netfilter-ha/linux-2.6/patches
   * make patches fit to 2.6.15.4 by "Index"-lines
   * removed hunks/patches which are allready in vanilla kernel
   * made the rest of the patches fit to newest vanilla kernel by diff-by-eyes
   * added ip_conntrack_hash_insert_nolock.patch (copied from
     linux-2.6-multigroup)
   * added ip_conntrack_hash_insert_lock.patck to add a non-locking function.

 2. branches/netfilter-ha/linux-2.6/ct_sync
   * Exchangened some things to fit to newest kernel
    (All these changes are more or less guessed by looking what has been
     changed in the upstream netfilter code between 2.6.10 and 2.6.15.4.)
     
    - WRITE_LOCK		->	write_lock_bh
    - WRITE_UNLOCK		->	write_unlock_bh
    - READ_LOCK			->	read_lock_bh
    - READ_UNLOCK		->	read_unlock_bh

    - __ip_ct_find_helper_by_name ->	__ip_conntrack_helper_find_byname

    - ct->nat.info.initialized	->	ct->status & IPS_NAT_DONE_MASK

    - h->ctrack			->	tuplehash_to_ctrack(h)

   Let's come to some more interesting changes... :)
   
   As 'ct->nat.num_manips' and 'ct->nat.manips' have been removed I had to
   fix the occurences in ct_sync, but how?
   I had a look at the linux-2.6-multigroup version of ct_sync and tried to
   "adjust" my version of ct_sync accordingly.
   So I just removed the parts with 'ct->nat.manips' and so on.
   I have the impression, that it works :)

   Again cheated with linux-2.6-multigroup I replaced 'place_in_hashes' with
   'ip_nat_hash_insert'.

   As 'ip_ct_selective_cleanup' does not exist anymore and google told me,
   that I should not use it for runtime reasons I switched to
   'ip_conntrack_cleanup' at init time, which should have the same effect.
   As it was not needed anymore I removed 'kill_all'.

   Because of __ip_conntrack_hash_insert(ct) being static and made me
   trouble while EXPORTing and requires hash_conntrack, which I didn't
   want to EXPORT I created ip_conntrack_hash_insert_nolock(ct) in
   ip_conntrack_core.c and EXPORTed it.

I would like someone who knows this code better than me (Harald?) to 
have a look at my changes and comment on it.
As an absolutly newbie in C and netfilter code I'm hoping I did not
too much bad things :)

Attached you could find my patches against the patches and the ct_sync code
each file to be patched as one patch.

Ciao
Max

[42] http://svn.netfilter.org/netfilter/branches/netfilter-ha/linux-2.6/
-- 
|           |                 Follow the white penguin.
|  |\/|  |  |-----------------------------------------------------------.
|  |  |/\|  |  Rechnerbetrieb Mathematik  |   Meine Baustellen:  TSM    |
|           |  Universitaet Paderborn     |   Hostmaster, Linux, LDAP   |

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="ct_sync.h.patch"

Index: ct_sync.h
===================================================================
--- ct_sync.h	(revision 6554)
+++ ct_sync.h	(working copy)
@@ -159,7 +159,9 @@
 	#ifdef CONFIG_IP_NF_NAT_NEEDED
 	int				nat_initialized;
 	__u8				nat_num_manips;
+#if 0
 	struct ip_nat_info_manip 	nat_manips[IP_NAT_MAX_MANIPS];
+#endif
 	char				nat_helper[CT_SYNC_NATHELPERSIZE];
 	union ip_conntrack_nat_help	nat_help;
 	struct ip_nat_seq		nat_seq[IP_CT_DIR_MAX];
@@ -183,7 +185,6 @@
 	struct ip_conntrack_tuple	tuple, mask;	/* expectation tuple and mask */
 	__u32				seq;		/* sequence number */
 	union ip_conntrack_expect_proto	proto;		/* protocol specific info */
-	union ip_conntrack_expect_help	help;		/* expectation helper specific info */
 };
 
 #ifdef __KERNEL__

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="ct_sync_main.c.patch"

Index: ct_sync_main.c
===================================================================
--- ct_sync_main.c	(revision 6554)
+++ ct_sync_main.c	(working copy)
@@ -58,8 +58,9 @@
 #define CT_SYNC_DUMP_TUPLE(x)
 #endif
 
-#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
-#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
 #include <linux/netfilter_ipv4/listhelp.h>
 
 #define CT_SYNC_VERSION	"0.20"
@@ -104,49 +105,7 @@
  * FILLING CTSYNC MESSAGES WITH DATA
  ***********************************************************************/
 
-#if 0
 static int
-fill_expectmsg(void *buff, __u8 event,
-	       struct ip_conntrack *master,
-	       struct ip_conntrack_expect *expect)
-{
-	struct ct_sync_msghdr *hdr = buff;
-	struct ct_sync_expect *sexp = buff + sizeof(*hdr);
-
-	CT_SYNC_ENTER();
-
-	/* fill event header */
-	hdr->type = event;
-	hdr->resource = CT_SYNC_RES_EXPECT;
-	hdr->len = __constant_htons(sizeof(*sexp));
-
-	/* copy data from expectation */
-	memcpy(&sexp->tuple, &expect->tuple, sizeof(sexp->tuple));
-	memcpy(&sexp->mask, &expect->mask, sizeof(sexp->mask));
-	sexp->seq = expect->seq;
-	memcpy(&sexp->proto, &expect->proto, sizeof(sexp->proto));
-	sexp->help = expect->help;
-	if (expect->expectant)
-		memcpy(&sexp->expectant,
-			&master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			sizeof(sexp->expectant));
-	else
-		memset(&sexp->expectant, 0, sizeof(sexp->expectant));
-
-	if (expect->sibling)
-		memcpy(&sexp->sibling,
-			&expect->sibling->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			sizeof(sexp->sibling));
-	else
-		memset(&sexp->sibling, 0, sizeof(sexp->sibling));
-
-	CT_SYNC_LEAVE();
-
-	return 0;
-}
-#endif
-
-static int
 fill_ctmsg(void *buff, __u8 event, struct ip_conntrack *ct, __u8 flags)
 {
 	struct ct_sync_msghdr *hdr = buff;
@@ -198,21 +157,9 @@
 	memcpy(&sct->proto, &ct->proto, sizeof(sct->proto));
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
-	if (likely(ct->nat.info.initialized)) {
+	if (likely(ct->status & IPS_NAT_DONE_MASK)) {
 		const struct ip_nat_info *nat = &ct->nat.info;
 
-		sct->nat_initialized = nat->initialized;
-		sct->nat_num_manips = nat->num_manips;
-		memcpy(sct->nat_manips, &nat->manips, 
-			(nat->num_manips * sizeof(struct ip_nat_info_manip)));
-		if (unlikely(nat->helper != NULL)) {
-			strncpy(sct->nat_helper, nat->helper->name, 
-				sizeof(sct->nat_helper));
-			memcpy(&sct->nat_help, &ct->nat.help, 
-				sizeof(sct->nat_help));
-		} else
-			sct->nat_helper[0] = '\0';
-
 		memcpy(&sct->nat_seq, &nat->seq, sizeof(sct->nat_seq));
 #if  defined(CONFIG_IP_NF_TARGET_MASQUERADE) \
   || defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
@@ -286,33 +233,6 @@
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
 		ct->mark = (unsigned long) sct->mark;
 #endif
-		/* if conntrack has a helper, update helper info */
-		if (ct->helper)
-			memcpy(&ct->help, &sct->help, sizeof(ct->help));
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-		/* if there is a nat helper present, update helper info */
-		if (sct->nat_initialized && ct->nat.info.initialized &&
-		    ct->nat.info.helper)
-			memcpy(&ct->nat.help, &sct->nat_help, sizeof(ct->nat.help));
-
-		/* if there are more manips initialized in sct than in ct, update ct */
-		if (unlikely(sct->nat_num_manips > ct->nat.info.num_manips)) {
-			int m;
-			printk(KERN_DEBUG "more manips than first sync !!!\n");
-			for (m = ct->nat.info.num_manips; m < sct->nat_num_manips; m++) {
-				memcpy(&ct->nat.info.manips[m], &sct->nat_manips[m], 
-					sizeof(struct ip_nat_info_manip));
-			}
-			ct->nat.info.num_manips = sct->nat_num_manips;
-
-			WRITE_LOCK(&ip_nat_lock);
-			if (ct->nat.info.initialized)
-				replace_in_hashes(ct, &ct->nat.info);
-			else
-				place_in_hashes(ct, &ct->nat.info);
-			WRITE_UNLOCK(&ip_nat_lock);
-		}
-#endif
 	} else {
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 		struct ip_nat_info *nat = &ct->nat.info;
@@ -337,57 +257,28 @@
 			struct ip_conntrack_helper *helper;
 
 			sct->helper[CT_SYNC_CTHELPERSIZE - 1] = '\0';
-			READ_LOCK(&ip_conntrack_lock);
-			helper = __ip_ct_find_helper_by_name(sct->helper);
+			read_lock_bh(&ip_conntrack_lock);
+			helper = __ip_conntrack_helper_find_byname(sct->helper);
 			if (unlikely(!helper)) {
 				CT_SYNC_ERR("Unknown conntrack helper `%s', "
 					    "ignoring.\n", sct->helper);
 				ct->helper = NULL;
 			} else {
 				ct->helper = helper;
-				memcpy(&ct->help, &sct->help, sizeof(ct->help));
 			}
-			READ_UNLOCK(&ip_conntrack_lock);
+			read_unlock_bh(&ip_conntrack_lock);
 		}
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 		/* NAT */
 		INIT_LIST_HEAD(&nat->bysource);
-		INIT_LIST_HEAD(&nat->byipsproto);
 
-		if (likely(sct->nat_initialized &&
-			   sct->nat_num_manips <= IP_NAT_MAX_MANIPS)) {
+		if (likely(sct->status & IPS_NAT_DONE_MASK)) {
 #if  defined(CONFIG_IP_NF_TARGET_MASQUERADE) \
   || defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
 			struct net_device *masq_dev;
 #endif
 
-			nat->initialized = sct->nat_initialized;
-			/* do not set .conntrack, place_in_hashes will do */
-			nat->num_manips = sct->nat_num_manips;
-			memcpy(&nat->manips, sct->nat_manips, 
-			       (sct->nat_num_manips * sizeof(struct ip_nat_info_manip)));
-
-			/* NAT helper, if present */
-			if (unlikely(sct->nat_helper[0] != '\0')) {
-				struct ip_nat_helper *helper;
-				/* look up nat helper */
-				sct->nat_helper[CT_SYNC_NATHELPERSIZE - 1] = '\0';
-				READ_LOCK(&ip_nat_lock);
-				helper = __ip_nat_find_helper_by_name(sct->nat_helper);
-				if (unlikely(!helper)) {
-					CT_SYNC_ERR("Unknown NAT helper `%s', ignoring\n", sct->nat_helper);
-					nat->helper = NULL;
-					memset(&ct->nat.help, 0, sizeof(ct->nat.help));
-				} else {
-					nat->helper = helper;
-					memcpy(&ct->nat.help, &sct->nat_help,
-						sizeof(ct->nat.help));
-				}
-				READ_UNLOCK(&ip_nat_lock);
-				memcpy(&nat->seq, &sct->nat_seq, sizeof(nat->seq));
-			}
-
 #if  defined(CONFIG_IP_NF_TARGET_MASQUERADE) \
   || defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
 			if (sct->nat_masq_iface[0] != '\0') {
@@ -409,26 +300,24 @@
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
 		/* add to hash tables */
-		WRITE_LOCK(&ip_conntrack_lock);
+		write_lock_bh(&ip_conntrack_lock);
 		if (!__ip_conntrack_find(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, NULL) 
 		    && !__ip_conntrack_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
 			/* put in conntrack hash */
-			__ip_conntrack_hash_insert(ct);
+			ip_conntrack_hash_insert_nolock(ct);
 			atomic_inc(&ct->ct_general.use);
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 			/* put in NAT hashes if necessary */
-			if (ct->nat.info.initialized) {
-				WRITE_LOCK(&ip_nat_lock);
-				place_in_hashes(ct, &ct->nat.info);
-				WRITE_UNLOCK(&ip_nat_lock);
+			if (ct->status & IPS_NAT_DONE_MASK) {
+				ip_nat_hash_insert(ct);
 			}
 #endif
 
 		} else {
 			CT_SYNC_ERR("want to put conntrack in hash but is already there\n");
 		}
-		WRITE_UNLOCK(&ip_conntrack_lock);
+		write_unlock_bh(&ip_conntrack_lock);
 	} /* if (new) */
 
 	CT_SYNC_LEAVE();
@@ -443,9 +332,9 @@
 	CT_SYNC_ENTER();
 
 	del_timer(&ct->timeout);
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 	ip_conntrack_clean_from_lists(ct);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 	ip_conntrack_put(ct);
 
 	CT_SYNC_LEAVE();
@@ -457,7 +346,7 @@
 _start_ct_timer(const struct ip_conntrack_tuple_hash *h,
 		unsigned int *num, unsigned int *started)
 {
-	struct ip_conntrack *ct = h->ctrack;
+	struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 
 	if (DIRECTION(h))
 		return 0;
@@ -485,7 +374,7 @@
 
 	CT_SYNC_ENTER();
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 
 	for (i = 0; i < ip_conntrack_htable_size; i++) {
 		if (LIST_FIND(&ip_conntrack_hash[i], _start_ct_timer,
@@ -494,7 +383,7 @@
 			break;
 	}
 
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	CT_SYNC_INFO("started timer of %u (total %u) conntrack entries\n", 
 		     num_started, num_entries);
@@ -506,7 +395,7 @@
 _stop_ct_timer(const struct ip_conntrack_tuple_hash *h, 
 		unsigned int *num, unsigned int *stopped)
 {
-	struct ip_conntrack *ct = h->ctrack;
+	struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 
 	if (DIRECTION(h))
 		return 0;
@@ -534,7 +423,7 @@
 
 	CT_SYNC_ENTER();
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	write_lock_bh(&ip_conntrack_lock);
 
 	for (i = 0; i < ip_conntrack_htable_size; i++) {
 		if (LIST_FIND(&ip_conntrack_hash[i], _stop_ct_timer,
@@ -543,7 +432,7 @@
 			break;
 	}
 
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	CT_SYNC_INFO("stopped timer of %u (total %u) conntrack entries\n", 
 			num_stopped, num_entries);
@@ -580,7 +469,7 @@
 
 	h = ip_conntrack_find_get(&sct->orig, NULL);
 	if (h) {
-		ct = h->ctrack;
+		ct = tuplehash_to_ctrack(h);
 	} else {
 		CT_SYNC_DEBUG("Conntrack entry not found, creating.\n");
 		ct = ip_conntrack_alloc(&dummy_tuple, &dummy_tuple);
@@ -632,10 +521,12 @@
 
 	h = ip_conntrack_find_get(t, NULL);
 	if (h) {
-		_ct_sync_remove_conntrack(h->ctrack);
+		struct ip_conntrack *ct = tuplehash_to_ctrack(h);
+
+		_ct_sync_remove_conntrack(ct);
 		CT_SYNC_DEBUG("Deleting conntrack: ");
 		CT_SYNC_DUMP_TUPLE(t);
-		ip_conntrack_put(h->ctrack);
+		ip_conntrack_put(ct);
 	} else {
 		CTS_STAT_INC(rx.del_nothere);
 		CT_SYNC_DEBUG("Cannot delete nonexistent conntrack:");
@@ -650,8 +541,6 @@
 static int
 ct_sync_msg_process_updateexpect(void *data, u16 len)
 {
-	struct ct_sync_expect *exp = (struct ct_sync_expect *)data;
-
 	CT_SYNC_ENTER();
 
 	if (unlikely(len < sizeof(struct ct_sync_expect))) {
@@ -669,9 +558,6 @@
 static int
 ct_sync_msg_process_delexpect(void *data, u16 len)
 {
-	struct ct_sync_expect *sexp = (struct ct_sync_expect *)data;
-	struct ip_conntrack_expect *exp;
-
 	CT_SYNC_ENTER();
 
 	if (unlikely(len < sizeof(struct ct_sync_expect))) {
@@ -680,22 +566,7 @@
 		CT_SYNC_LEAVE();
 		return -1;
 	}
-#if 0
-	READ_LOCK(&ip_conntrack_lock);
-	WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
-	exp = LIST_FIND(&ip_conntrack_expect_list, expect_cmp,
-			struct ip_conntrack_expect *, exp->tuple);
-	if (!exp || !exp->expectant) 
-		goto unlock_out;
 
-	if (conntrack_tuple_cmp(&exp->expectant,
-			&exp->expectant->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
-		__unexpect_related(exp);
-
-unlock_out:
-	WRITE_INLOCK(&ip_conntrack_expect_tuple_lock);
-	READ_UNLOCK(&ip_donntrack_lock);
-#endif
 	CT_SYNC_LEAVE();
 	return 0;
 }
@@ -1181,7 +1052,7 @@
 static inline int
 _send_initsync(const struct ip_conntrack_tuple_hash *h, unsigned int *num)
 {
-	struct ip_conntrack *ct = h->ctrack;
+	struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 
 	if (DIRECTION(h))
 		return 0;
@@ -1280,13 +1151,13 @@
 			if (kthread_should_stop())
 				break;
 
-			READ_LOCK(&ip_conntrack_lock);
+			read_lock_bh(&ip_conntrack_lock);
 dump_bucket_locked:
 			if (LIST_FIND(&ip_conntrack_hash[i], 
 				      _send_initsync,
 			      	       struct ip_conntrack_tuple_hash *,
 				       &num_sent)) {
-				READ_UNLOCK(&ip_conntrack_lock);
+				read_unlock_bh(&ip_conntrack_lock);
 				break;
 			}
 			if (num_sent < 40 &&
@@ -1294,7 +1165,7 @@
 				i++;
 				goto dump_bucket_locked;
 			}
-			READ_UNLOCK(&ip_conntrack_lock);
+			read_unlock_bh(&ip_conntrack_lock);
 
 			num_sent_total += num_sent;
 
@@ -1411,66 +1282,7 @@
 	CT_SYNC_LEAVE();
 }
 
-#if 0
-/* conntrack expectation created notification */
-static void
-ct_sync_expect_create(struct ip_conntrack_expect *exp)
-{
-	struct cts_buff *csb;
-	struct ip_conntrack *master_ct = exp->expectant;
 
-	CT_SYNC_ENTER();
-
-	if (likely(cts_proto_is_master(cts_cfg.protoh) &&
-	           is_confirmed(master_ct))) {
-		void *buff;
-
-		buff = cts_proto_want_enqueue(cts_cfg.protoh, &csb,
-				CTMSG_SIZEOF(struct ct_sync_expect));
-		if (unlikely(!buff)) {
-			CT_SYNC_ERR("unable to enqueue event\n");
-			CT_SYNC_LEAVE();
-			return;
-		}
-		fill_expectmsg(buff, CT_SYNC_MSG_UPDATE, master_ct, exp);
-		csb_use_dec(cts_cfg.protoh, csb);
-	}
-
-	CT_SYNC_LEAVE();
-
-	return;
-}
-
-/* conntrack expectation destroyed notification */
-static void
-ct_sync_expect_destroy(struct ip_conntrack_expect *exp)
-{
-	struct cts_buff *csb;
-	struct ip_conntrack *master_ct = exp->expectant;
-
-	CT_SYNC_ENTER();
-
-	if (likely(cts_proto_is_master(cts_cfg.protoh) &&
-	    	   is_confirmed(master_ct))) {
-		void *buff;
-
-		buff = cts_proto_want_enqueue(cts_cfg.protoh, &csb, 
-				CTMSG_SIZEOF(struct ct_sync_expect));
-		if (unlikely(!buff)) {
-			CT_SYNC_ERR("unable to enqueue event\n");
-			CT_SYNC_LEAVE();
-			return;
-		}
-		// FIXME: implementation
-		csb_use_dec(cts_cfg.protoh, csb);
-	}
-
-	CT_SYNC_LEAVE();
-
-	return;
-}
-#endif
-
 static int
 ct_sync_notify(struct notifier_block *this,
 	       unsigned long events, void *conntrack)
@@ -1746,12 +1558,6 @@
  * MODULE INITIALIZATION
  ***********************************************************************/
 
-static int
-kill_all(const struct ip_conntrack *i, void *data)
-{
-	return 1;
-}
-
 static struct task_struct *rcv_thread, *send_thread, *initsync_thread;
 
 /* DO NOT declare this as __init!! */
@@ -1817,7 +1623,7 @@
 			goto error_hook1;
 		if (nf_register_hook(&cts_hook_ops[3]) < 0)
 			goto error_hook2;
-		ip_ct_selective_cleanup(kill_all, NULL);
+		ip_conntrack_cleanup();
 	}
 
 	/* init protocol layer */

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="ct_notifier_pkt.patch.patch"

Index: ct_notifier_pkt.patch
===================================================================
--- ct_notifier_pkt.patch	(revision 6474)
+++ ct_notifier_pkt.patch	(working copy)
@@ -1,9 +1,9 @@
 ===== include/linux/netfilter.h 1.13 vs edited =====
-Index: linux-2.6.10/include/linux/netfilter.h
+Index: linux-2.6.15.4/include/linux/netfilter.h
 ===================================================================
---- linux-2.6.10.orig/include/linux/netfilter.h	2005-01-10 20:23:19.000000000 +0100
-+++ linux-2.6.10/include/linux/netfilter.h	2005-01-10 20:41:44.015934800 +0100
-@@ -21,7 +21,7 @@
+--- linux-2.6.15.4.orig/include/linux/netfilter.h	2005-01-10 20:23:19.000000000 +0100
++++ linux-2.6.15.4/include/linux/netfilter.h	2005-01-10 20:41:44.015934800 +0100
+@@ -34,7 +34,7 @@
  #define NF_MAX_VERDICT NF_REPEAT
  
  /* Generic cache responses from hook functions.
@@ -12,214 +12,55 @@
  #define NFC_UNKNOWN 0x4000
  #define NFC_ALTERED 0x8000
  
-Index: linux-2.6.10/include/linux/netfilter_ipv4.h
+Index: linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack.h
 ===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4.h	2004-08-14 07:37:39.000000000 +0200
-+++ linux-2.6.10/include/linux/netfilter_ipv4.h	2005-01-10 20:41:44.017934496 +0100
-@@ -8,34 +8,6 @@
- #include <linux/config.h>
- #include <linux/netfilter.h>
+--- linux-2.6.15.4.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-10 20:23:19.000000000 +0100
++++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-10 20:41:44.020934040 +0100
+@@ -207,7 +207,7 @@
  
--/* IP Cache bits. */
--/* Src IP address. */
--#define NFC_IP_SRC		0x0001
--/* Dest IP address. */
--#define NFC_IP_DST		0x0002
--/* Input device. */
--#define NFC_IP_IF_IN		0x0004
--/* Output device. */
--#define NFC_IP_IF_OUT		0x0008
--/* TOS. */
--#define NFC_IP_TOS		0x0010
--/* Protocol. */
--#define NFC_IP_PROTO		0x0020
--/* IP options. */
--#define NFC_IP_OPTIONS		0x0040
--/* Frag & flags. */
--#define NFC_IP_FRAG		0x0080
--
--/* Per-protocol information: only matters if proto match. */
--/* TCP flags. */
--#define NFC_IP_TCPFLAGS		0x0100
--/* Source port. */
--#define NFC_IP_SRC_PT		0x0200
--/* Dest port. */
--#define NFC_IP_DST_PT		0x0400
--/* Something else about the proto */
--#define NFC_IP_PROTO_UNKNOWN	0x2000
--
- /* IP Hooks */
- /* After promisc drops, checksum checks. */
- #define NF_IP_PRE_ROUTING	0
-Index: linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack.h
-===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-10 20:23:19.000000000 +0100
-+++ linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-10 20:41:44.020934040 +0100
-@@ -47,6 +47,58 @@
- 	/* Connection is confirmed: originating packet has left box */
- 	IPS_CONFIRMED_BIT = 3,
- 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
-+
-+	/* Connection is destroyed (removed from lists), can not be unset. */
-+	IPS_DESTROYED_BIT = 4,
-+	IPS_DESTROYED = (1 << IPS_DESTROYED_BIT),
-+};
-+
-+/* Connection tracking event bits */
-+enum ip_conntrack_events
-+{
-+	/* New conntrack */
-+	IPCT_NEW_BIT = 0,
-+	IPCT_NEW = (1 << IPCT_NEW_BIT),
-+
-+	/* Expected connection */
-+	IPCT_RELATED_BIT = 1,
-+	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
-+
-+	/* Destroyed conntrack */
-+	IPCT_DESTROY_BIT = 2,
-+	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
-+
-+	/* Timer has been refreshed */
-+	IPCT_REFRESH_BIT = 3,
-+	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
-+
-+	/* Status has changed */
-+	IPCT_STATUS_BIT = 4,
-+	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
-+
-+	/* Update of protocol info */
-+	IPCT_PROTOINFO_BIT = 5,
-+	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
-+
-+	/* Volatile protocol info */
-+	IPCT_PROTOINFO_VOLATILE_BIT = 6,
-+	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
-+
-+	/* New helper for conntrack */
-+	IPCT_HELPER_BIT = 7,
-+	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
-+
-+	/* Update of helper info */
-+	IPCT_HELPINFO_BIT = 8,
-+	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
-+
-+	/* Volatile helper info */
-+	IPCT_HELPINFO_VOLATILE_BIT = 9,
-+	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
-+
-+	/* NAT info */
-+	IPCT_NATINFO_BIT = 10,
-+	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
- };
+ extern void __ip_ct_refresh_acct(struct ip_conntrack *ct,
+ 			         enum ip_conntrack_info ctinfo,
+-			         const struct sk_buff *skb,
++			         struct sk_buff *skb,
+ 			         unsigned long extra_jiffies,
+ 				 int do_acct);
+
+@@ -214,7 +214,7 @@
+ /* Refresh conntrack for this many jiffies and do accounting */
+ static inline void ip_ct_refresh_acct(struct ip_conntrack *ct, 
+ 				      enum ip_conntrack_info ctinfo,
+-				      const struct sk_buff *skb,
++				      struct sk_buff *skb,
+ 				      unsigned long extra_jiffies)
+ {
+ 	__ip_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, 1);
+@@ -222,7 +222,7 @@
  
- #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
-@@ -263,7 +315,7 @@
  /* Refresh conntrack for this many jiffies */
- extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
- 			       enum ip_conntrack_info ctinfo,
--			       const struct sk_buff *skb,
-+			       struct sk_buff *skb,
- 			       unsigned long extra_jiffies);
- 
- /* These are for NAT.  Icky. */
-@@ -294,6 +346,11 @@
+ static inline void ip_ct_refresh(struct ip_conntrack *ct,
+-				 const struct sk_buff *skb,
++				 struct sk_buff *skb,
+ 				 unsigned long extra_jiffies)
+ {
+ 	__ip_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
+@@ -294,6 +345,11 @@
  	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
  }
  
 +static inline int is_destroyed(struct ip_conntrack *ct)
 +{
-+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
++	return test_bit(IPCT_DESTROY_BIT, &ct->status);
 +}
 +
  extern unsigned int ip_conntrack_htable_size;
   
  struct ip_conntrack_stat
-@@ -317,6 +374,57 @@
- 
- #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
- 
-+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-+#include <linux/notifier.h>
-+ 
-+extern struct notifier_block *ip_conntrack_chain;
-+ 
-+static inline int ip_conntrack_register_notifier(struct notifier_block *nb)
-+{
-+	return notifier_chain_register(&ip_conntrack_chain, nb);
-+}
-+
-+static inline int ip_conntrack_unregister_notifier(struct notifier_block *nb)
-+{
-+	return notifier_chain_unregister(&ip_conntrack_chain, nb);
-+}
-+
-+static inline void ip_conntrack_event_cache_init(struct sk_buff *skb)
-+{
-+	/* Set to zero first 14 bits, see netfilter.h */
-+	skb->nfcache &= 0xc000;
-+}
-+
-+static inline void 
-+ip_conntrack_event_cache(enum ip_conntrack_events event, struct sk_buff *skb)
-+{
-+	skb->nfcache |= event;
-+}
-+
-+static inline void 
-+ip_conntrack_deliver_cached_events(struct sk_buff *skb)
-+{
-+	struct ip_conntrack *ct = (struct ip_conntrack *) skb->nfct;
-+
-+	if (ct != NULL && is_confirmed(ct) && !is_destroyed(ct) && skb->nfcache)
-+		notifier_call_chain(&ip_conntrack_chain, skb->nfcache, ct);
-+}
-+
-+static inline void ip_conntrack_event(enum ip_conntrack_events event,
-+				      struct ip_conntrack *ct)
-+{
-+	if (is_confirmed(ct) && !is_destroyed(ct))
-+		notifier_call_chain(&ip_conntrack_chain, event, ct);
-+}
-+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
-+static inline void ip_conntrack_event_cache_init(struct sk_buff *skb) {}
-+static inline void ip_conntrack_event_cache(enum ip_conntrack_events event,
-+					    struct sk_buff *skb) {}
-+static inline void ip_conntrack_event(enum ip_conntrack_events event,
-+				      struct ip_conntrack *ct) {}
-+static inline void ip_conntrack_deliver_cached_events(struct sk_buff *skb) {}
-+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
-+
- /* eg. PROVIDES_CONNTRACK(ftp); */
- #define PROVIDES_CONNTRACK(name)                        \
-         int needs_ip_conntrack_##name;                  \
-Index: linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h
+Index: linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
 ===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:15:47.000000000 +0100
-+++ linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:41:44.022933736 +0100
-@@ -39,10 +39,14 @@
- /* Confirm a connection: returns NF_DROP if packet must be dropped. */
- static inline int ip_conntrack_confirm(struct sk_buff *skb)
- {
-+	int ret = NF_ACCEPT;
-+	
- 	if (skb->nfct
- 	    && !is_confirmed((struct ip_conntrack *)skb->nfct))
--		return __ip_conntrack_confirm(skb);
--	return NF_ACCEPT;
-+		ret = __ip_conntrack_confirm(skb);
-+	ip_conntrack_deliver_cached_events(skb);
-+
-+	return ret;
- }
+--- linux-2.6.15.4.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-10 20:15:47.000000000 +0100
++++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-10 20:41:44.023933584 +0100
+@@ -35,7 +35,7 @@
  
- extern struct list_head *ip_conntrack_hash;
-Index: linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
-===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-10 20:15:47.000000000 +0100
-+++ linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-10 20:41:44.023933584 +0100
-@@ -34,7 +34,7 @@
- 
  	/* Returns verdict for packet, or -1 for invalid. */
  	int (*packet)(struct ip_conntrack *conntrack,
 -		      const struct sk_buff *skb,
@@ -227,11 +68,11 @@
  		      enum ip_conntrack_info ctinfo);
  
  	/* Called when a new connection for this protocol found;
-Index: linux-2.6.10/net/ipv4/netfilter/Kconfig
+Index: linux-2.6.15.4/net/ipv4/netfilter/Kconfig
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/Kconfig	2005-01-10 20:23:29.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/Kconfig	2005-01-10 20:41:44.027932976 +0100
-@@ -732,5 +732,15 @@
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/Kconfig	2005-01-10 20:23:29.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/Kconfig	2005-01-10 20:41:44.027932976 +0100
+@@ -842,5 +842,15 @@
  
  	  To compile it as a module, choose M here.  If unsure, say N.
  
@@ -247,11 +88,11 @@
 +
  endmenu
  
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-10 20:15:51.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-10 20:41:44.029932672 +0100
-@@ -89,7 +89,7 @@
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-10 20:15:51.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-10 20:41:44.029932672 +0100
+@@ -90,7 +90,7 @@
  
  /* Returns verdict for packet, or -1 for invalid. */
  static int icmp_packet(struct ip_conntrack *ct,
@@ -260,18 +101,11 @@
  		       enum ip_conntrack_info ctinfo)
  {
  	/* Try to delete connection immediately after all replies:
-@@ -102,6 +102,7 @@
- 			ct->timeout.function((unsigned long)ct);
- 	} else {
- 		atomic_inc(&ct->proto.icmp.count);
-+		ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
- 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
- 	}
  
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_generic.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_generic.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-01-10 20:15:51.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-01-10 20:41:44.031932368 +0100
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-01-10 20:15:51.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-01-10 20:41:44.031932368 +0100
 @@ -49,7 +49,7 @@
  
  /* Returns verdict for packet, or -1 for invalid. */
@@ -281,11 +115,11 @@
  		  enum ip_conntrack_info ctinfo)
  {
  	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-10 20:15:51.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-10 20:41:44.034931912 +0100
-@@ -310,7 +310,7 @@
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-10 20:15:51.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-10 20:41:44.034931912 +0100
+@@ -309,7 +309,7 @@
  
  /* Returns verdict for packet, or -1 for invalid. */
  static int sctp_packet(struct ip_conntrack *conntrack,
@@ -294,148 +128,31 @@
  		       enum ip_conntrack_info ctinfo)
  {
  	enum sctp_conntrack newconntrack, oldsctpstate;
-@@ -405,6 +405,8 @@
- 		}
- 
- 		conntrack->proto.sctp.state = newconntrack;
-+		if (oldsctpstate != newconntrack)
-+			ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
- 		WRITE_UNLOCK(&sctp_lock);
- 	}
- 
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:23:29.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:44:56.354694864 +0100
-@@ -37,6 +37,7 @@
- #include <linux/err.h>
- #include <linux/percpu.h>
- #include <linux/moduleparam.h>
-+#include <linux/notifier.h>
- 
- /* This rwlock protects the main hash table, protocol/helper/expected
-    registrations, conntrack timers*/
-@@ -75,6 +76,10 @@
- struct ip_conntrack ip_conntrack_untracked;
- unsigned int ip_ct_log_invalid;
- 
-+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-+struct notifier_block *ip_conntrack_chain;
-+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
-+
- DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
- 
- inline void 
-@@ -287,6 +292,8 @@
- 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
- 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
- 
-+	set_bit(IPS_DESTROYED_BIT, &ct->status);
-+
- 	/* To make sure we don't get any weird locking issues here:
- 	 * destroy_conntrack() MUST NOT be called with a write lock
- 	 * to ip_conntrack_lock!!! -HW */
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:23:29.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:44:56.354694864 +0100
 @@ -327,6 +334,7 @@
  {
  	struct ip_conntrack *ct = (void *)ul_conntrack;
  
 +	ip_conntrack_event(IPCT_DESTROY, ct);
- 	WRITE_LOCK(&ip_conntrack_lock);
+ 	write_lock_bh(&ip_conntrack_lock);
  	/* Inside lock so preempt is disabled on module removal path.
  	 * Otherwise we can get spurious warnings. */
-@@ -436,6 +444,14 @@
- 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
- 		CONNTRACK_STAT_INC(insert);
- 		WRITE_UNLOCK(&ip_conntrack_lock);
-+		if (ct->helper)
-+			ip_conntrack_event_cache(IPCT_HELPER, skb);
-+#ifdef CONFIG_IP_NF_NAT_NEEDED
-+		if (ct->nat.info.initialized)
-+			ip_conntrack_event_cache(IPCT_NATINFO, skb);
-+#endif
-+		ip_conntrack_event_cache(master_ct(ct) ?
-+					 IPCT_RELATED : IPCT_NEW, skb);
- 		return NF_ACCEPT;
- 	}
- 
-@@ -708,6 +724,8 @@
- 	/* FIXME: Do this right please. --RR */
- 	(*pskb)->nfcache |= NFC_UNKNOWN;
- 
-+	ip_conntrack_event_cache_init(*pskb);
-+
- /* Doesn't cover locally-generated broadcast, so not worth it. */
- #if 0
- 	/* Ignore broadcast: no `connection'. */
-@@ -769,8 +787,10 @@
- 			return NF_ACCEPT;
- 		}
- 	}
--	if (set_reply)
-+	if (set_reply && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
- 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
-+		ip_conntrack_event_cache(IPCT_STATUS, *pskb);
-+	}
- 
- 	return ret;
- }
-@@ -1052,6 +1072,7 @@
- 	if (i->ctrack->helper == me) {
- 		/* Get rid of any expected. */
- 		remove_expectations(i->ctrack, 0);
-+		ip_conntrack_event(IPCT_HELPER, i->ctrack);
- 		/* And *then* set helper to NULL */
- 		i->ctrack->helper = NULL;
- 	}
-@@ -1092,7 +1113,7 @@
- /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
- void ip_ct_refresh_acct(struct ip_conntrack *ct, 
+@@ -1119,7 +1130,7 @@
+ /* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
+ void __ip_ct_refresh_acct(struct ip_conntrack *ct, 
  		        enum ip_conntrack_info ctinfo,
 -			const struct sk_buff *skb,
 +			struct sk_buff *skb,
- 			unsigned long extra_jiffies)
+ 			unsigned long extra_jiffies,
+ 			int do_acct)
  {
- 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
-@@ -1107,6 +1128,7 @@
- 		if (del_timer(&ct->timeout)) {
- 			ct->timeout.expires = jiffies + extra_jiffies;
- 			add_timer(&ct->timeout);
-+			ip_conntrack_event_cache(IPCT_REFRESH, skb);
- 		}
- 		ct_add_counters(ct, ctinfo, skb);
- 		WRITE_UNLOCK(&ip_conntrack_lock);
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-10 20:23:29.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-10 20:41:44.044930392 +0100
-@@ -300,6 +300,7 @@
- 			ct_ftp_info->seq_aft_nl[dir] = 
- 						ntohl(th->seq) + datalen;
- 			ct_ftp_info->seq_aft_nl_set[dir] = 1;
-+			ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
- 		}
- 	}
- 
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c
-===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:23:29.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:41:44.048929784 +0100
-@@ -881,6 +881,11 @@
- {
- }
- 
-+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-+EXPORT_SYMBOL(ip_conntrack_chain);
-+EXPORT_SYMBOL(ip_conntrack_register_notifier);
-+EXPORT_SYMBOL(ip_conntrack_unregister_notifier);
-+#endif
- EXPORT_SYMBOL(ip_conntrack_protocol_register);
- EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
- EXPORT_SYMBOL(invert_tuplepr);
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
-===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-10 20:23:29.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-10 20:41:44.052929176 +0100
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-10 20:23:29.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-10 20:41:44.052929176 +0100
 @@ -826,7 +826,7 @@
  
  /* Returns verdict for packet, or -1 for invalid. */
@@ -456,10 +173,10 @@
  	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
  		/* If only reply is a RST, we can consider ourselves not to
  		   have an established connection: this is a fairly common
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_udp.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-01-10 20:15:51.000000000 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-01-10 20:41:44.055928720 +0100
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-01-10 20:15:51.000000000 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-01-10 20:41:44.055928720 +0100
 @@ -64,7 +64,7 @@
  
  /* Returns verdict for packet, and may modify conntracktype */
@@ -469,15 +186,3 @@
  		      enum ip_conntrack_info ctinfo)
  {
  	/* If we've seen traffic both ways, this is some kind of UDP
-@@ -73,7 +73,10 @@
- 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
- 				   ip_ct_udp_timeout_stream);
- 		/* Also, more likely to be important, and not a probe */
--		set_bit(IPS_ASSURED_BIT, &conntrack->status);
-+		if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
-+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
-+			ip_conntrack_event_cache(IPCT_STATUS, skb);
-+		}
- 	} else
- 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
- 

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment;
	filename="ct_sync_config_and_makefile.patch.patch"

Index: ct_sync_config_and_makefile.patch
===================================================================
--- ct_sync_config_and_makefile.patch	(revision 6474)
+++ ct_sync_config_and_makefile.patch	(working copy)
@@ -1,10 +1,10 @@
-Index: linux-2.6.10-ctsync/net/ipv4/netfilter/Makefile
+Index: netfilter-2.6.14/net/ipv4/netfilter/Makefile
 ===================================================================
---- linux-2.6.10-ctsync.orig/net/ipv4/netfilter/Makefile	2005-07-19 11:26:32.516195604 +0200
-+++ linux-2.6.10-ctsync/net/ipv4/netfilter/Makefile	2005-07-19 11:27:42.791714055 +0200
-@@ -16,6 +16,9 @@
- ipfwadm-objs		:= $(ip_nf_compat-objs) ipfwadm_core.o
- ipchains-objs		:= $(ip_nf_compat-objs) ipchains_core.o
+--- netfilter-2.6.14.orig/net/ipv4/netfilter/Makefile	2005-09-18 12:58:03.203433272 +0200
++++ netfilter-2.6.14/net/ipv4/netfilter/Makefile	2005-10-04 16:23:02.759253880 +0200
+@@ -10,6 +10,9 @@
+ ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o
+ iptable_nat-objs	:= ip_nat_standalone.o ip_nat_rule.o ip_nat_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip_nat_proto_icmp.o
  
 +# conntrack state synchronization
 +ct_sync-objs		:= ct_sync_main.o ct_sync_proto.o ct_sync_sock.o
@@ -12,20 +12,20 @@
  # connection tracking
  obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
  
-@@ -101,3 +104,5 @@
- obj-$(CONFIG_IP_NF_COMPAT_IPFWADM) += ipfwadm.o
+@@ -103,3 +113,5 @@
  
- obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
+ # l3 independent conntrack
+ obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
 +
 +obj-$(CONFIG_IP_NF_CT_SYNC) += ct_sync.o
-Index: linux-2.6.10-ctsync/net/ipv4/netfilter/Kconfig
+Index: netfilter-2.6.14/net/ipv4/netfilter/Kconfig
 ===================================================================
---- linux-2.6.10-ctsync.orig/net/ipv4/netfilter/Kconfig	2005-07-19 11:26:32.516195604 +0200
-+++ linux-2.6.10-ctsync/net/ipv4/netfilter/Kconfig	2005-07-19 11:30:00.179497725 +0200
-@@ -742,5 +742,23 @@
- 	  
- 	  IF unsure, say `N'.
+--- netfilter-2.6.14.orig/net/ipv4/netfilter/Kconfig	2005-09-18 12:58:02.826490576 +0200
++++ netfilter-2.6.14/net/ipv4/netfilter/Kconfig	2005-10-04 16:22:22.487376136 +0200
+@@ -852,5 +852,23 @@
  
+ 	  To compile it as a module, choose M here.  If unsure, say N.
+ 
 +config IP_NF_CT_SYNC
 +	tristate "Connection tracking state synchronization"
 +	depends on IP_NF_CONNTRACK_EVENTS

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment;
	filename="export_ip_conntrack_clean_from_lists.patch.patch"

Index: export_ip_conntrack_clean_from_lists.patch
===================================================================
--- export_ip_conntrack_clean_from_lists.patch	(revision 6474)
+++ export_ip_conntrack_clean_from_lists.patch	(working copy)
@@ -1,19 +1,19 @@
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_standalone.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:54:00.490973576 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:54:18.557227088 +0100
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:54:00.490973576 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:54:18.557227088 +0100
 @@ -915,6 +915,7 @@
- EXPORT_SYMBOL(ip_conntrack_untracked);
- EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
+
+ EXPORT_SYMBOL_GPL(ip_conntrack_flush);
  EXPORT_SYMBOL_GPL(__ip_conntrack_find);
 +EXPORT_SYMBOL_GPL(ip_conntrack_clean_from_lists);
- EXPORT_SYMBOL_GPL(ip_conntrack_put);
- #ifdef CONFIG_IP_NF_NAT_NEEDED
- EXPORT_SYMBOL(ip_conntrack_tcp_update);
-Index: linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h
+
+ EXPORT_SYMBOL_GPL(ip_conntrack_alloc);
+ EXPORT_SYMBOL_GPL(ip_conntrack_free);
+Index: linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_core.h
 ===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:00.492973272 +0100
-+++ linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:18.559226784 +0100
+--- linux-2.6.15.4.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:00.492973272 +0100
++++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:18.559226784 +0100
 @@ -54,6 +54,8 @@
  	return ret;
  }
@@ -23,10 +23,10 @@
  extern struct list_head *ip_conntrack_hash;
  extern struct list_head ip_conntrack_expect_list;
  DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:54:00.497972512 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:56:56.733180688 +0100
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:54:00.497972512 +0100
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:56:56.733180688 +0100
 @@ -265,12 +265,12 @@
  	}
  }
@@ -40,15 +40,24 @@
  	
 -	DEBUGP("clean_from_lists(%p)\n", ct);
 +	DEBUGP("ip_conntrack_clean_from_lists(%p)\n", ct);
- 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+ 	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
  
  	ho = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-@@ -339,7 +339,7 @@
+@@ -333,7 +333,7 @@
+ 		ip_conntrack_destroyed(ct);
+ 
+ 	write_lock_bh(&ip_conntrack_lock);
+-	/* Expectations will have been removed in clean_from_lists,
++	/* Expectations will have been removed in ip_conntrack_clean_from_lists,
+ 	 * except TFTP can create an expectation on the first packet,
+ 	 * before connection is in the list, so we need to clean here,
+ 	 * too. */
+@@ -363,7 +363,7 @@
  	/* Inside lock so preempt is disabled on module removal path.
  	 * Otherwise we can get spurious warnings. */
  	CONNTRACK_STAT_INC(delete_list);
 -	clean_from_lists(ct);
 +	ip_conntrack_clean_from_lists(ct);
- 	WRITE_UNLOCK(&ip_conntrack_lock);
+ 	write_unlock_bh(&ip_conntrack_lock);
  	ip_conntrack_put(ct);
  }

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="export_ip_conntrack_cleanup.patch"

--- linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c	2006-03-07 05:42:07.000000000 +0100
+++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.max.c	2006-03-07 06:00:34.000000000 +0100
@@ -1388,6 +1388,7 @@
 			    ip_conntrack_htable_size);
 	nf_unregister_sockopt(&so_getorigdst);
 }
+EXPORT_SYMBOL_GPL(ip_conntrack_cleanup);
 
 static struct list_head *alloc_hashtable(int size, int *vmalloced)
 {

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment;
	filename="export_ip_conntrack_find.patch.patch"

Index: export_ip_conntrack_find.patch
===================================================================
--- export_ip_conntrack_find.patch	(revision 6474)
+++ export_ip_conntrack_find.patch	(working copy)
@@ -1,20 +1,8 @@
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c
+Index: linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_core.h
 ===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:53:51.796295368 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-10 20:54:00.490973576 +0100
-@@ -914,6 +914,7 @@
- EXPORT_SYMBOL(ip_conntrack_hash);
- EXPORT_SYMBOL(ip_conntrack_untracked);
- EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
-+EXPORT_SYMBOL_GPL(__ip_conntrack_find);
- EXPORT_SYMBOL_GPL(ip_conntrack_put);
- #ifdef CONFIG_IP_NF_NAT_NEEDED
- EXPORT_SYMBOL(ip_conntrack_tcp_update);
-Index: linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h
-===================================================================
---- linux-2.6.10.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:41:44.022933736 +0100
-+++ linux-2.6.10/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:00.492973272 +0100
-@@ -34,6 +34,11 @@
+--- linux-2.6.15.4.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:41:44.022933736 +0100
++++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-10 20:54:00.492973272 +0100
+@@ -36,6 +36,11 @@
  ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
  		      const struct ip_conntrack *ignored_conntrack);
  
@@ -23,19 +11,6 @@
 +__ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
 +		    const struct ip_conntrack *ignored_conntrack);
 +
- extern int __ip_conntrack_confirm(struct sk_buff *skb);
+ extern int __ip_conntrack_confirm(struct sk_buff **pskb);
  
  /* Confirm a connection: returns NF_DROP if packet must be dropped. */
-Index: linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c
-===================================================================
---- linux-2.6.10.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:53:51.801294608 +0100
-+++ linux-2.6.10/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-10 20:54:00.497972512 +0100
-@@ -354,7 +354,7 @@
- 		&& ip_ct_tuple_equal(tuple, &i->tuple);
- }
- 
--static struct ip_conntrack_tuple_hash *
-+struct ip_conntrack_tuple_hash *
- __ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
- 		    const struct ip_conntrack *ignored_conntrack)
- {

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment;
	filename="export_ip_nat_lock_and_hash.patch.patch"

Index: export_ip_nat_lock_and_hash.patch
===================================================================
--- export_ip_nat_lock_and_hash.patch	(revision 6474)
+++ export_ip_nat_lock_and_hash.patch	(working copy)
@@ -1,12 +1,61 @@
-Index: linux-2.6.10-ctsync/net/ipv4/netfilter/ip_nat_standalone.c
+Index: linux-2.6.15.4/net/ipv4/netfilter/ip_nat_core.c
 ===================================================================
---- linux-2.6.10-ctsync.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-07-19 11:24:12.057142833 +0200
-+++ linux-2.6.10-ctsync/net/ipv4/netfilter/ip_nat_standalone.c	2005-07-19 11:27:16.136965119 +0200
-@@ -392,4 +392,7 @@
- EXPORT_SYMBOL(ip_nat_find_helper);
- EXPORT_SYMBOL(__ip_nat_find_helper);
- EXPORT_SYMBOL_GPL(__ip_nat_find_helper_by_name);
-+EXPORT_SYMBOL_GPL(ip_nat_lock);
-+EXPORT_SYMBOL_GPL(place_in_hashes);
-+EXPORT_SYMBOL_GPL(replace_in_hashes);
- MODULE_LICENSE("GPL");
+--- linux-2.6.15.4.orig/net/ipv4/netfilter/ip_nat_core.c	2005-10-04 17:39:04.944696272 +0200
++++ linux-2.6.15.4/net/ipv4/netfilter/ip_nat_core.c	2005-10-04 17:56:57.845590544 +0200
+@@ -101,6 +101,19 @@
+ 	write_unlock_bh(&ip_nat_lock);
+ }
+ 
++/* Place the conntrack entry in the nat hashtable. */
++void ip_nat_hash_insert(struct ip_conntrack *ct)
++{
++	unsigned int srchash
++		= hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL]
++			      .tuple);
++
++	write_lock_bh(&ip_nat_lock);
++	list_add(&ct->nat.info.bysource, &bysource[srchash]);
++	write_unlock_bh(&ip_nat_lock);
++}
++EXPORT_SYMBOL_GPL(ip_nat_hash_insert);
++
+ /* We do checksum mangling, so if they were wrong before they're still
+  * wrong.  Also works for incomplete packets (eg. ICMP dest
+  * unreachables.) */
+@@ -295,7 +309,6 @@
+ 		  unsigned int hooknum)
+ {
+ 	struct ip_conntrack_tuple curr_tuple, new_tuple;
+-	struct ip_nat_info *info = &conntrack->nat.info;
+ 	int have_to_hash = !(conntrack->status & IPS_NAT_DONE_MASK);
+ 	enum ip_nat_manip_type maniptype = HOOK2MANIP(hooknum);
+ 
+@@ -330,14 +343,8 @@
+ 	}
+ 
+ 	/* Place in source hash if this is the first time. */
+-	if (have_to_hash) {
+-		unsigned int srchash
+-			= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+-				      .tuple);
+-		write_lock_bh(&ip_nat_lock);
+-		list_add(&info->bysource, &bysource[srchash]);
+-		write_unlock_bh(&ip_nat_lock);
+-	}
++	if (have_to_hash)
++		ip_nat_hash_insert(conntrack);
+ 
+ 	/* It's done. */
+ 	if (maniptype == IP_NAT_MANIP_DST)
+Index: linux-2.6.15.4/include/linux/netfilter_ipv4/ip_nat_core.h
+===================================================================
+--- linux-2.6.15.4.orig/include/linux/netfilter_ipv4/ip_nat_core.h	2005-10-04 17:39:04.946695968 +0200
++++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_nat_core.h	2005-10-04 17:39:15.282124744 +0200
+@@ -15,4 +15,7 @@
+ 					 struct ip_conntrack *ct,
+ 					 enum ip_nat_manip_type manip,
+ 					 enum ip_conntrack_dir dir);
++
++extern void ip_nat_hash_insert(struct ip_conntrack *ct);
++
+ #endif /* _IP_NAT_CORE_H */

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment;
	filename="ip_conntrack_hash_insert_nolock.patch"

--- linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack.h	2006-03-08 01:03:37.079785975 +0100
+++ linux-2.6.15.4/include/linux/netfilter_ipv4/ip_conntrack.max.h	2006-03-08 01:07:52.091014039 +0100
@@ -270,6 +270,9 @@
 
 extern void ip_conntrack_hash_insert(struct ip_conntrack *ct);
 
+/* Non-Locking ip_conntrack_hash_insert for ct_sync */
+extern void ip_conntrack_hash_insert_nolock(struct ip_conntrack *ct);
+
 extern struct ip_conntrack_expect *
 __ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
 
--- linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.c	2006-03-08 01:03:37.139789604 +0100
+++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_core.max.c	2006-03-08 01:08:44.278068578 +0100
@@ -437,6 +437,17 @@
 	write_unlock_bh(&ip_conntrack_lock);
 }
 
+/* Non-Locking ip_conntrack_hash_insert for ct_sync */
+void ip_conntrack_hash_insert_nolock(struct ip_conntrack *ct)
+{
+	unsigned int hash, repl_hash;
+
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	__ip_conntrack_hash_insert(ct, hash, repl_hash);
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __ip_conntrack_confirm(struct sk_buff **pskb)
--- linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_standalone.c	2006-03-08 01:03:37.123788636 +0100
+++ linux-2.6.15.4/net/ipv4/netfilter/ip_conntrack_standalone.max.c	2006-03-08 01:06:48.643301648 +0100
@@ -1018,6 +1018,7 @@
 EXPORT_SYMBOL_GPL(ip_conntrack_alloc);
 EXPORT_SYMBOL_GPL(ip_conntrack_free);
 EXPORT_SYMBOL_GPL(ip_conntrack_hash_insert);
+EXPORT_SYMBOL_GPL(ip_conntrack_hash_insert_nolock);
 
 EXPORT_SYMBOL_GPL(ip_ct_remove_expectations);
 

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="pf_packet.patch.patch"

Index: pf_packet.patch
===================================================================
--- pf_packet.patch	(revision 6474)
+++ pf_packet.patch	(working copy)
@@ -1,8 +1,8 @@
 %patch
-Index: linux-2.6.10/include/linux/netfilter_packet.h
+Index: linux-2.6.15.4/include/linux/netfilter_packet.h
 ===================================================================
 --- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.10/include/linux/netfilter_packet.h	2005-01-10 20:45:51.363332280 +0100
++++ linux-2.6.15.4/include/linux/netfilter_packet.h	2005-01-10 20:45:51.363332280 +0100
 @@ -0,0 +1,17 @@
 +#ifndef __LINUX_NETFILTER_PACKET_H
 +#define __LINUX_NETFILTER_PACKET_H
@@ -21,165 +21,3 @@
 +#define NF_PACKET_OUTPUT       1
 +
 +#endif /* __LINUX_NETFILTER_PACKET_H */
-Index: linux-2.6.10/net/core/dev.c
-===================================================================
---- linux-2.6.10.orig/net/core/dev.c	2005-01-10 20:23:28.000000000 +0100
-+++ linux-2.6.10/net/core/dev.c	2005-01-10 21:24:31.645595760 +0100
-@@ -112,6 +112,7 @@
- #include <linux/wireless.h>		/* Note : will define WIRELESS_EXT */
- #include <net/iw_handler.h>
- #endif	/* CONFIG_NET_RADIO */
-+#include <linux/netfilter_packet.h>
- #include <asm/current.h>
- 
- /* This define, if set, will randomly drop a packet when congestion
-@@ -1215,35 +1216,12 @@
-  *	to congestion or traffic shaping.
-  */
- 
--int dev_queue_xmit(struct sk_buff *skb)
-+static int dev_queue_xmit_finish(struct sk_buff *skb)
- {
- 	struct net_device *dev = skb->dev;
- 	struct Qdisc *q;
- 	int rc = -ENOMEM;
- 
--	if (skb_shinfo(skb)->frag_list &&
--	    !(dev->features & NETIF_F_FRAGLIST) &&
--	    __skb_linearize(skb, GFP_ATOMIC))
--		goto out_kfree_skb;
--
--	/* Fragmented skb is linearized if device does not support SG,
--	 * or if at least one of fragments is in highmem and device
--	 * does not support DMA from it.
--	 */
--	if (skb_shinfo(skb)->nr_frags &&
--	    (!(dev->features & NETIF_F_SG) || illegal_highdma(dev, skb)) &&
--	    __skb_linearize(skb, GFP_ATOMIC))
--		goto out_kfree_skb;
--
--	/* If packet is not checksummed and device does not support
--	 * checksumming for this protocol, complete checksumming here.
--	 */
--	if (skb->ip_summed == CHECKSUM_HW &&
--	    (!(dev->features & (NETIF_F_HW_CSUM | NETIF_F_NO_CSUM)) &&
--	     (!(dev->features & NETIF_F_IP_CSUM) ||
--	      skb->protocol != htons(ETH_P_IP))))
--	      	if (skb_checksum_help(skb, 0))
--	      		goto out_kfree_skb;
- 
- 	/* Disable soft irqs for various locks below. Also 
- 	 * stops preemption for RCU. 
-@@ -1324,7 +1302,6 @@
- 	rc = -ENETDOWN;
- 	local_bh_enable();
- 
--out_kfree_skb:
- 	kfree_skb(skb);
- 	return rc;
- out:
-@@ -1332,6 +1309,41 @@
- 	return rc;
- }
- 
-+int dev_queue_xmit(struct sk_buff *skb)
-+{
-+	struct net_device *dev = skb->dev;
-+
-+	if (skb_shinfo(skb)->frag_list &&
-+	    !(dev->features & NETIF_F_FRAGLIST) &&
-+	    __skb_linearize(skb, GFP_ATOMIC))
-+		goto out_kfree_skb;
-+
-+	/* Fragmented skb is linearized if device does not support SG,
-+	 * or if at least one of fragments is in highmem and device
-+	 * does not support DMA from it.
-+	 */
-+	if (skb_shinfo(skb)->nr_frags &&
-+	    (!(dev->features & NETIF_F_SG) || illegal_highdma(dev, skb)) &&
-+	    __skb_linearize(skb, GFP_ATOMIC))
-+		goto out_kfree_skb;
-+
-+	/* If packet is not checksummed and device does not support
-+	 * checksumming for this protocol, complete checksumming here.
-+	 */
-+	if (skb->ip_summed == CHECKSUM_HW &&
-+	    (!(dev->features & (NETIF_F_HW_CSUM | NETIF_F_NO_CSUM)) &&
-+	     (!(dev->features & NETIF_F_IP_CSUM) ||
-+	      skb->protocol != htons(ETH_P_IP))))
-+	      	if (skb_checksum_help(skb, 0))
-+	      		goto out_kfree_skb;
-+
-+	return NF_HOOK(PF_PACKET, NF_PACKET_OUTPUT, skb, NULL, dev,
-+		       dev_queue_xmit_finish);
-+
-+out_kfree_skb:
-+	kfree_skb(skb);
-+	return -ENOMEM;
-+}
- 
- /*=======================================================================
- 			Receiver routines
-@@ -1622,29 +1634,12 @@
- }
- #endif
- 
--int netif_receive_skb(struct sk_buff *skb)
-+static int netif_receive_skb_finish(struct sk_buff *skb)
- {
- 	struct packet_type *ptype, *pt_prev;
- 	int ret = NET_RX_DROP;
- 	unsigned short type;
- 
--#ifdef CONFIG_NETPOLL
--	if (skb->dev->netpoll_rx && skb->dev->poll && netpoll_rx(skb)) {
--		kfree_skb(skb);
--		return NET_RX_DROP;
--	}
--#endif
--
--	if (!skb->stamp.tv_sec)
--		net_timestamp(&skb->stamp);
--
--	skb_bond(skb);
--
--	__get_cpu_var(netdev_rx_stat).total++;
--
--	skb->h.raw = skb->nh.raw = skb->data;
--	skb->mac_len = skb->nh.raw - skb->mac.raw;
--
- 	pt_prev = NULL;
- 
- 	rcu_read_lock();
-@@ -1713,7 +1708,30 @@
- 	return ret;
- }
- 
--static int process_backlog(struct net_device *backlog_dev, int *budget)
-+int netif_receive_skb(struct sk_buff *skb)
-+{
-+#ifdef CONFIG_NETPOLL
-+	if (skb->dev->netpoll_rx && skb->dev->poll && netpoll_rx(skb)) {
-+		kfree_skb(skb);
-+		return NET_RX_DROP;
-+	}
-+#endif
-+
-+	if (!skb->stamp.tv_sec)
-+		net_timestamp(&skb->stamp);
-+
-+	skb_bond(skb);
-+
-+	__get_cpu_var(netdev_rx_stat).total++;
-+
-+	skb->h.raw = skb->nh.raw = skb->data;
-+	skb->mac_len = skb->nh.raw - skb->mac.raw;
-+
-+	return NF_HOOK(PF_PACKET, NF_PACKET_INPUT, skb, skb->dev, NULL,
-+		       netif_receive_skb_finish);
-+}
-+
-+ static int process_backlog(struct net_device *backlog_dev, int *budget)
- {
- 	int work = 0;
- 	int quota = min(backlog_dev->quota, *budget);

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="series.patch"

Index: series
===================================================================
--- series	(revision 6474)
+++ series	(working copy)
@@ -1,11 +1,8 @@
 ct_notifier_pkt.patch 
 pf_packet.patch 
-pf_packet_remove_warning.patch 
-export_ip_conntrack_helpers.patch 
-export_ip_nat_helpers.patch 
 export_ip_conntrack_find.patch 
-export_ip_nat_lock_and_hash.patch 
+export_ip_nat_lock_and_hash.patch
 export_ip_conntrack_clean_from_lists.patch 
-conntrack_hash_manip.patch 
-conntrack_alloc.patch 
+export_ip_conntrack_cleanup.patch
+ip_conntrack_hash_insert_nolock.patch
 ct_sync_config_and_makefile.patch

--/04w6evG8XlLl3ft--
