From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Sun, 16 Feb 2003 20:43:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E4FE9DE.1070208@fugmann.dhs.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000803070005000709010206"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3E1DEF2D.4080703@fugmann.dhs.org>
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
--------------000803070005000709010206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a updated patch for covertion of MOD_(DEC|INC)_USE_COUNT 
macros to the new 2.5 kernel API.

The patch attached is for version 2.5.61.

If there are no comments on the patch, I request that this is sent to 
Linus for kernel inclusion. I will post a simmiliar patch for the ipv6 
netfilter modules soon.

Regards
Anders Fugmann





--------------000803070005000709010206
Content-Type: text/plain;
 name="netfilter-modules-2.5.61.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netfilter-modules-2.5.61.patch"

diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/arp_tables.c linux-2.5.61/net/ipv4/netfilter/arp_tables.c
--- linux-2.5.61-orig/net/ipv4/netfilter/arp_tables.c	2003-02-15 00:52:26.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/arp_tables.c	2003-01-16 15:39:19.000000000 +0100
@@ -539,8 +539,8 @@
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto out;
 	}
-	if (target->me)
-		__MOD_INC_USE_COUNT(target->me);
+	if (!try_module_get(target->me)) 
+		return -EAGAIN;
 	t->u.kernel.target = target;
 	up(&arpt_mutex);
 
@@ -554,8 +554,7 @@
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		if (t->u.kernel.target->me)
-			__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+		module_put(t->u.kernel.target->me);
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -622,8 +621,7 @@
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->data,
 					    t->u.target_size - sizeof(*t));
-	if (t->u.kernel.target->me)
-		__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	module_put(t->u.kernel.target->me);
 
 	return 0;
 }
@@ -910,20 +908,23 @@
 		ret = -EINVAL;
 		goto free_newinfo_counters_untrans_unlock;
 	}
+	if (!try_module_get(t->me)) {
+		ret = -EAGAIN;
+		goto free_newinfo_counters_untrans_unlock;
+	}
 
 	oldinfo = replace_table(t, tmp.num_counters, newinfo, &ret);
 	if (!oldinfo)
-		goto free_newinfo_counters_untrans_unlock;
+		goto free_newinfo_counters_untrans_unlock_module;
 
 	/* Update module usage count based on number of rules */
 	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
 		oldinfo->number, oldinfo->initial_entries, newinfo->number);
-	if (t->me && (oldinfo->number <= oldinfo->initial_entries) &&
- 	    (newinfo->number > oldinfo->initial_entries))
-		__MOD_INC_USE_COUNT(t->me);
-	else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
-	 	 (newinfo->number <= oldinfo->initial_entries))
-		__MOD_DEC_USE_COUNT(t->me);
+
+	if (oldinfo->number > oldinfo->initial_entries) 
+		module_put(t->me);
+	if (newinfo->number <= oldinfo->initial_entries)
+		module_put(t->me);
 
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
@@ -937,6 +938,8 @@
 	up(&arpt_mutex);
 	return 0;
 
+ free_newinfo_counters_untrans_unlock_module:
+	module_put(t->me);
  free_newinfo_counters_untrans_unlock:
 	up(&arpt_mutex);
  free_newinfo_counters_untrans:
@@ -1110,17 +1113,14 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
 	ret = down_interruptible(&arpt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 	if (!list_named_insert(&arpt_target, target)) {
 		duprintf("arpt_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
-		MOD_DEC_USE_COUNT;
 	}
 	up(&arpt_mutex);
 	return ret;
@@ -1131,7 +1131,6 @@
 	down(&arpt_mutex);
 	LIST_DELETE(&arpt_target, target);
 	up(&arpt_mutex);
-	MOD_DEC_USE_COUNT;
 }
 
 int arpt_register_table(struct arpt_table *table)
@@ -1141,12 +1140,10 @@
 	static struct arpt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
-	MOD_INC_USE_COUNT;
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 	memcpy(newinfo->entries, table->table->entries, table->table->size);
@@ -1159,14 +1156,12 @@
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 
 	ret = down_interruptible(&arpt_mutex);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 
@@ -1196,7 +1191,6 @@
 
  free_unlock:
 	vfree(newinfo);
-	MOD_DEC_USE_COUNT;
 	goto unlock;
 }
 
@@ -1210,7 +1204,6 @@
 	ARPT_ENTRY_ITERATE(table->private->entries, table->private->size,
 			   cleanup_entry, NULL);
 	vfree(table->private);
-	MOD_DEC_USE_COUNT;
 }
 
 /* The built-in targets: standard (NULL) and error. */
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.5.61/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ip_conntrack_core.c	2003-02-15 00:51:04.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ip_conntrack_core.c	2003-02-15 14:45:54.000000000 +0100
@@ -11,6 +11,8 @@
  * 16 Jul 2002: Harald Welte <laforge@gnumonks.org>
  * 	- add usage/reference counts to ip_conntrack_expect
  *	- export ip_conntrack[_expect]_{find_get,put} functions
+ * 14 Jan 2003: Anders Fugmann <afu@fugmann.dhs.org>
+ *      - Convert to 2.5 module API.
  * */
 
 #ifdef MODULE
@@ -1131,8 +1133,6 @@
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
 {
-	MOD_INC_USE_COUNT;
-
 	WRITE_LOCK(&ip_conntrack_lock);
 	list_prepend(&helpers, me);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1169,8 +1169,6 @@
 	/* Someone could be still looking at the helper in a bh. */
 	br_write_lock_bh(BR_NETPROTO_LOCK);
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
-
-	MOD_DEC_USE_COUNT;
 }
 
 /* Refresh conntrack for this many jiffies. */
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.5.61/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-02-15 00:51:42.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-01-16 15:39:19.000000000 +0100
@@ -310,7 +310,6 @@
 	}
 
 	list_prepend(&protocol_list, proto);
-	MOD_INC_USE_COUNT;
 
  out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -333,7 +332,6 @@
 	/* Remove all contrack entries for this protocol */
 	ip_ct_selective_cleanup(kill_proto, &proto->proto);
 
-	MOD_DEC_USE_COUNT;
 }
 
 static int __init init(void)
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ip_nat_helper.c linux-2.5.61/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ip_nat_helper.c	2003-02-15 00:51:19.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ip_nat_helper.c	2003-02-10 23:34:43.000000000 +0100
@@ -11,6 +11,8 @@
  *	16 Aug 2002 Brian J. Murrell <netfilter@interlinx.bc.ca>:
  *		- make ip_nat_resize_packet more generic (TCP and UDP)
  *		- add ip_nat_mangle_udp_packet
+ *     13 Jan 2003 Anders Fugmann <afu@fugmann.dhs.org>
+ *              - convert to 2.5 module API.
  */
 #include <linux/version.h>
 #include <linux/config.h>
@@ -480,7 +482,8 @@
 		
 		if ((ct_helper = ip_ct_find_helper(&me->tuple))
 		    && ct_helper->me) {
-			__MOD_INC_USE_COUNT(ct_helper->me);
+			if (!try_module_get(ct_helper->me))
+				return -EAGAIN;
 		} else {
 			/* We are a NAT helper for protocol X.  If we need
 			 * respective conntrack helper for protoccol X, compute
@@ -500,7 +503,8 @@
 			if (!request_module(name)
 			    && (ct_helper = ip_ct_find_helper(&me->tuple))
 			    && ct_helper->me) {
-				__MOD_INC_USE_COUNT(ct_helper->me);
+				if (!try_module_get(ct_helper->me))
+				    return -EAGAIN;
 			} else {
 				printk("unable to load module %s\n", name);
 				return -EBUSY;
@@ -518,7 +522,6 @@
 		ret = -EBUSY;
 	else {
 		list_prepend(&helpers, me);
-		MOD_INC_USE_COUNT;
 	}
 	WRITE_UNLOCK(&ip_nat_lock);
 
@@ -562,9 +565,6 @@
 	   worse. --RR */
 	ip_ct_selective_cleanup(kill_helper, me);
 
-	if (found)
-		MOD_DEC_USE_COUNT;
-
 	/* If we are no standalone NAT helper, we need to decrement usage count
 	 * on our conntrack helper */
 	if (me->me && !(me->flags & IP_NAT_HELPER_F_STANDALONE)) {
@@ -572,7 +572,7 @@
 		
 		if ((ct_helper = ip_ct_find_helper(&me->tuple))
 		    && ct_helper->me) {
-			__MOD_DEC_USE_COUNT(ct_helper->me);
+			module_put(ct_helper->me);
 		}
 #ifdef CONFIG_MODULES
 		else 
--- linux-2.5.61-orig/net/ipv4/netfilter/ip_nat_standalone.c	2003-02-15 00:52:26.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ip_nat_standalone.c	2003-01-16 15:39:19.000000000 +0100
@@ -10,6 +10,8 @@
  * 23 Apr 2001: Harald Welte <laforge@gnumonks.org>
  * 	- new API and handling of conntrack/nat helpers
  * 	- now capable of multiple expectations for one master
+ * 13 Jan 2003 Anders Fugmann <afu@fugmann.dhs.org>
+ *      - Convert to 2.5 module API.
  * */
 
 #include <linux/config.h>
@@ -253,9 +255,12 @@
 			goto out;
 		}
 	}
+	if (!try_module_get(THIS_MODULE)) {
+	    ret = -EAGAIN;
+	    goto out;
+	}
 
 	list_prepend(&protos, proto);
-	MOD_INC_USE_COUNT;
 
  out:
 	WRITE_UNLOCK(&ip_nat_lock);
@@ -273,7 +278,7 @@
 	br_write_lock_bh(BR_NETPROTO_LOCK);
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 static int init_or_cleanup(int init)
@@ -314,13 +319,16 @@
 		goto cleanup_localoutops;
 	}
 #endif
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	if (! try_module_get(ip_conntrack_module)) {
+		ret = -EAGAIN;
+		goto cleanup_module;
+	}    
 	return ret;
 
  cleanup:
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	    module_put(ip_conntrack_module);
+ cleanup_module:
+
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ip_tables.c linux-2.5.61/net/ipv4/netfilter/ip_tables.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ip_tables.c	2003-02-15 00:51:21.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ip_tables.c	2003-01-16 15:39:19.000000000 +0100
@@ -7,6 +7,8 @@
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
  * 	  a table
+ * 14 Jan 2003 Anders Fugmann <afu@fugmann.dhs.org>
+ *      - convert to 2.5 module API.
  */
 #include <linux/config.h>
 #include <linux/cache.h>
@@ -599,8 +601,7 @@
 		m->u.kernel.match->destroy(m->data,
 					   m->u.match_size - sizeof(*m));
 
-	if (m->u.kernel.match->me)
-		__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+	module_put(m->u.kernel.match->me);
 
 	return 0;
 }
@@ -650,8 +651,9 @@
 		duprintf("check_match: `%s' not found\n", m->u.user.name);
 		return ret;
 	}
-	if (match->me)
-		__MOD_INC_USE_COUNT(match->me);
+	if (!try_module_get(match->me))
+	    return -EAGAIN;
+	    
 	m->u.kernel.match = match;
 	up(&ipt_mutex);
 
@@ -659,8 +661,7 @@
 	    && !m->u.kernel.match->checkentry(name, ip, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
-		if (m->u.kernel.match->me)
-			__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+		module_put(m->u.kernel.match->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		return -EINVAL;
@@ -697,8 +698,8 @@
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto cleanup_matches;
 	}
-	if (target->me)
-		__MOD_INC_USE_COUNT(target->me);
+	if (!try_module_get(target->me))
+		return -EAGAIN;
 	t->u.kernel.target = target;
 	up(&ipt_mutex);
 
@@ -712,8 +713,7 @@
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		if (t->u.kernel.target->me)
-			__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+		module_put(t->u.kernel.target->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -785,8 +785,7 @@
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->data,
 					    t->u.target_size - sizeof(*t));
-	if (t->u.kernel.target->me)
-		__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	module_put(t->u.kernel.target->me);
 
 	return 0;
 }
@@ -1107,20 +1106,23 @@
 		ret = -EINVAL;
 		goto free_newinfo_counters_untrans_unlock;
 	}
+	if (!try_module_get(t->me)) {
+		ret = -EAGAIN;
+		goto free_newinfo_counters_untrans_unlock;
+	}
 
 	oldinfo = replace_table(t, tmp.num_counters, newinfo, &ret);
 	if (!oldinfo)
-		goto free_newinfo_counters_untrans_unlock;
+		goto free_newinfo_counters_untrans_unlock_module;
 
 	/* Update module usage count based on number of rules */
 	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
 		oldinfo->number, oldinfo->initial_entries, newinfo->number);
-	if (t->me && (oldinfo->number <= oldinfo->initial_entries) &&
- 	    (newinfo->number > oldinfo->initial_entries))
-		__MOD_INC_USE_COUNT(t->me);
-	else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
-	 	 (newinfo->number <= oldinfo->initial_entries))
-		__MOD_DEC_USE_COUNT(t->me);
+
+	if (oldinfo->number > oldinfo->initial_entries) 
+		module_put(t->me);
+	if (newinfo->number <= oldinfo->initial_entries)
+		module_put(t->me);
 
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
@@ -1134,6 +1136,8 @@
 	up(&ipt_mutex);
 	return 0;
 
+ free_newinfo_counters_untrans_unlock_module:
+	module_put(t->me);
  free_newinfo_counters_untrans_unlock:
 	up(&ipt_mutex);
  free_newinfo_counters_untrans:
@@ -1319,17 +1323,14 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 	if (!list_named_insert(&ipt_target, target)) {
 		duprintf("ipt_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
-		MOD_DEC_USE_COUNT;
 	}
 	up(&ipt_mutex);
 	return ret;
@@ -1341,7 +1342,6 @@
 	down(&ipt_mutex);
 	LIST_DELETE(&ipt_target, target);
 	up(&ipt_mutex);
-	MOD_DEC_USE_COUNT;
 }
 
 int
@@ -1349,16 +1349,13 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 	if (!list_named_insert(&ipt_match, match)) {
 		duprintf("ipt_register_match: `%s' already in list!\n",
 			 match->name);
-		MOD_DEC_USE_COUNT;
 		ret = -EINVAL;
 	}
 	up(&ipt_mutex);
@@ -1372,7 +1369,6 @@
 	down(&ipt_mutex);
 	LIST_DELETE(&ipt_match, match);
 	up(&ipt_mutex);
-	MOD_DEC_USE_COUNT;
 }
 
 int ipt_register_table(struct ipt_table *table)
@@ -1382,12 +1378,10 @@
 	static struct ipt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
-	MOD_INC_USE_COUNT;
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 	memcpy(newinfo->entries, table->table->entries, table->table->size);
@@ -1399,14 +1393,12 @@
 			      table->table->underflow);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
 		return ret;
 	}
 
@@ -1436,7 +1428,6 @@
 
  free_unlock:
 	vfree(newinfo);
-	MOD_DEC_USE_COUNT;
 	goto unlock;
 }
 
@@ -1450,7 +1441,6 @@
 	IPT_ENTRY_ITERATE(table->private->entries, table->private->size,
 			  cleanup_entry, NULL);
 	vfree(table->private);
-	MOD_DEC_USE_COUNT;
 }
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ipchains_core.c linux-2.5.61/net/ipv4/netfilter/ipchains_core.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ipchains_core.c	2003-02-15 00:52:29.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ipchains_core.c	2003-01-16 15:39:19.000000000 +0100
@@ -44,6 +44,8 @@
  * 23-Jul-1999: Fixed small fragment security exposure opened on 15-May-1998.
  *              John McDonald <jm@dataprotect.com>
  *              Thomas Lopatic <tl@dataprotect.com>
+ * 14-Jan-2003  Convert to 2.5 module API.
+ *              Anders Fugmann <afu@fugmann.dhs.org>
  */
 
 /*
@@ -839,7 +841,7 @@
 			i->branch->refcount--;
 		kfree(i);
 		i = tmp;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 	}
 	return 0;
 }
@@ -869,6 +871,9 @@
 {
 	struct ip_fwkernel *i;
 
+	if (!try_module_get(THIS_MODULE))
+	    return EAGAIN;
+
 	FWC_HAVE_LOCK(fwc_wlocks);
 	/* Special case if no rules already present */
 	if (chainptr->chain == NULL) {
@@ -886,7 +891,6 @@
 	if (rule->branch) rule->branch->refcount++;
 
 append_successful:
-	MOD_INC_USE_COUNT;
 	return 0;
 }
 
@@ -897,8 +901,12 @@
 			   struct ip_fwkernel *frwl,
 			   __u32 position)
 {
+	int ret=0;
 	struct ip_fwkernel *f = chainptr->chain;
 
+	if (!try_module_get(THIS_MODULE))
+	    return EAGAIN;
+
 	FWC_HAVE_LOCK(fwc_wlocks);
 	/* special case if the position is number 1 */
 	if (position == 1) {
@@ -909,16 +917,20 @@
 	}
 	position--;
 	while (--position && f != NULL) f = f->next;
-	if (f == NULL)
-		return EINVAL;
+	if (f == NULL) {
+		ret = EINVAL;
+		goto insert_unsuccessful;
+	}
 	if (frwl->branch) frwl->branch->refcount++;
 	frwl->next = f->next;
 
 	f->next = frwl;
 
-insert_successful:
-	MOD_INC_USE_COUNT;
-	return 0;
+ insert_unsuccessful:
+        module_put(THIS_MODULE);
+ insert_successful:
+	return ret;
+
 }
 
 /* This function deletes the a rule from a given rulenum and chain.
@@ -952,7 +964,7 @@
 		kfree(tmp);
 	}
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	return 0;
 }
 
@@ -1059,7 +1071,7 @@
 		else
 			chainptr->chain = ftmp->next;
 		kfree(ftmp);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		break;
 	}
 
@@ -1101,7 +1113,7 @@
 	tmp->next = tmp2->next;
 	kfree(tmp2);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	return 0;
 }
 
@@ -1149,12 +1161,15 @@
 	if (strcmp(tmp->label,label) == 0)
 		return EEXIST;
 
+	if (!try_module_get(THIS_MODULE))
+		return EGAGIN;
+
 	tmp->next = ip_init_chain(label, 0, FW_SKIP); /* refcount is
 					      * zero since this is a
 					      * user defined chain *
 					      * and therefore can be
 					      * deleted */
-	MOD_INC_USE_COUNT;
+	
 	return 0;
 }
 
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ipfwadm_core.c linux-2.5.61/net/ipv4/netfilter/ipfwadm_core.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ipfwadm_core.c	2003-02-15 00:51:31.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ipfwadm_core.c	2003-01-16 15:39:19.000000000 +0100
@@ -55,6 +55,8 @@
  *		Jos Vos <jos@xos.nl> 18/5/1996.
  *	Added trap out of bad frames.
  *		Alan Cox <alan@cymru.net> 17/11/1996
+ *      Convert to 2.5 module API.
+ *              Anders Fugmann <afu@fugmann.dhs.org>
  *
  *
  * Masquerading functionality
@@ -705,7 +707,7 @@
 		ftmp = *chainptr;
 		*chainptr = ftmp->fw_next;
 		kfree(ftmp);
-		MOD_DEC_USE_COUNT;
+		try_module_put(THIS_MODULE);
 	}
 	WRITE_UNLOCK(&ip_fw_lock);
 }
@@ -716,6 +718,9 @@
 {
 	struct ip_fw *ftmp;
 
+	if (!try_module_get(THIS_MODULE))
+	    return EAGAIN;
+
 	ftmp = kmalloc( sizeof(struct ip_fw), GFP_KERNEL );
 	if ( ftmp == NULL )
 	{
@@ -746,7 +751,6 @@
 	ftmp->fw_next = *chainptr;
        	*chainptr=ftmp;
 	WRITE_UNLOCK(&ip_fw_lock);
-	MOD_INC_USE_COUNT;
 	return(0);
 }
 
@@ -756,6 +760,9 @@
 	struct ip_fw *chtmp=NULL;
 	struct ip_fw *volatile chtmp_prev=NULL;
 
+	if (!try_module_get(THIS_MODULE))
+	    return EAGAIN;
+
 	ftmp = kmalloc( sizeof(struct ip_fw), GFP_KERNEL );
 	if ( ftmp == NULL )
 	{
@@ -794,7 +801,6 @@
 	else
         	*chainptr=ftmp;
 	WRITE_UNLOCK(&ip_fw_lock);
-	MOD_INC_USE_COUNT;
 	return(0);
 }
 
@@ -867,7 +873,7 @@
 	}
 	WRITE_UNLOCK(&ip_fw_lock);
 	if (was_found) {
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return 0;
 	} else
 		return(EINVAL);
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ipt_conntrack.c linux-2.5.61/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ipt_conntrack.c	2003-02-15 00:52:38.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ipt_conntrack.c	2003-01-16 15:39:19.000000000 +0100
@@ -106,16 +106,16 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	if (!try_module_get(ip_conntrack_module))
+		return -EAGAIN;
+
 	return ipt_register_match(&conntrack_match);
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&conntrack_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	module_put(ip_conntrack_module);
 }
 
 module_init(init);
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ipt_helper.c linux-2.5.61/net/ipv4/netfilter/ipt_helper.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ipt_helper.c	2003-02-15 00:52:24.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ipt_helper.c	2003-01-16 15:39:19.000000000 +0100
@@ -6,6 +6,8 @@
  *
  *   19 Mar 2002 Harald Welte <laforge@gnumonks.org>:
  *   		 - Port to newnat infrastructure
+ *   13 Jan 2003 Anders Fugmann <afu@fugmann.dhs.org>
+ *              - convert to 2.5 module API.
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -95,16 +97,15 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+        if (! try_module_get(ip_conntrack_module))
+		return -EAGAIN;
 	return ipt_register_match(&helper_match);
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&helper_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	module_put(ip_conntrack_module);
 }
 
 module_init(init);
diff -r -uBb linux-2.5.61-orig/net/ipv4/netfilter/ipt_state.c linux-2.5.61/net/ipv4/netfilter/ipt_state.c
--- linux-2.5.61-orig/net/ipv4/netfilter/ipt_state.c	2003-02-15 00:53:02.000000000 +0100
+++ linux-2.5.61/net/ipv4/netfilter/ipt_state.c	2003-01-16 15:39:19.000000000 +0100
@@ -47,16 +47,15 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+       if (! try_module_get(ip_conntrack_module))
+		return -EAGAIN;
 	return ipt_register_match(&state_match);
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&state_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	module_put(ip_conntrack_module);
 }
 
 module_init(init);

--------------000803070005000709010206--
