From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Thu, 09 Jan 2003 22:52:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1DEF2D.4080703@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070903000602090603010109"
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
--------------070903000602090603010109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

Attached is a trivial patch the converts the usage of the macros 
__MOD_INC_USAGE_COUNT and __MOD_DEC_USAGE_COUNT to try_modules_get and 
module_put.

Conversion enables module unloading on 2.5 kernels.
The patch is against 2.5.55. I have only tested ipv4 functionality, and 
I see no reason that ipv6 shound not work also.

Please examine the patch, and if ok I will send it to Linus for kernel 
inclusion (Unless someone on the list is the preferred person to do so - 
maybe Harald Welte?).

Regards
Anders Fugmann





--------------070903000602090603010109
Content-Type: text/plain;
 name="netfilter-2.5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netfilter-2.5.diff"

diff -r -u linux-2.5.55/net/ipv4/netfilter/arp_tables.c linux-2.5.55-new/net/ipv4/netfilter/arp_tables.c
--- linux-2.5.55/net/ipv4/netfilter/arp_tables.c	2003-01-09 05:04:22.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/arp_tables.c	2003-01-09 22:23:43.000000000 +0100
@@ -539,8 +539,7 @@
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto out;
 	}
-	if (target->me)
-		__MOD_INC_USE_COUNT(target->me);
+	try_module_get(target->me);
 	t->u.kernel.target = target;
 	up(&arpt_mutex);
 
@@ -554,8 +553,7 @@
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		if (t->u.kernel.target->me)
-			__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	        module_put(t->u.kernel.target->me);
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -622,8 +620,7 @@
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->data,
 					    t->u.target_size - sizeof(*t));
-	if (t->u.kernel.target->me)
-		__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	module_put(t->u.kernel.target->me);
 
 	return 0;
 }
@@ -918,12 +915,12 @@
 	/* Update module usage count based on number of rules */
 	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
 		oldinfo->number, oldinfo->initial_entries, newinfo->number);
-	if (t->me && (oldinfo->number <= oldinfo->initial_entries) &&
+	if ((oldinfo->number <= oldinfo->initial_entries) &&
  	    (newinfo->number > oldinfo->initial_entries))
-		__MOD_INC_USE_COUNT(t->me);
-	else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
+		try_module_get(t->me);
+	else if ((oldinfo->number > oldinfo->initial_entries) &&
 	 	 (newinfo->number <= oldinfo->initial_entries))
-		__MOD_DEC_USE_COUNT(t->me);
+		module_put(t->me);
 
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
@@ -1110,17 +1107,17 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	ret = down_interruptible(&arpt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 		return ret;
 	}
 	if (!list_named_insert(&arpt_target, target)) {
 		duprintf("arpt_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 	}
 	up(&arpt_mutex);
 	return ret;
@@ -1131,7 +1128,7 @@
 	down(&arpt_mutex);
 	LIST_DELETE(&arpt_target, target);
 	up(&arpt_mutex);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 int arpt_register_table(struct arpt_table *table)
@@ -1141,12 +1138,12 @@
 	static struct arpt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 	memcpy(newinfo->entries, table->table->entries, table->table->size);
@@ -1159,14 +1156,14 @@
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
 	ret = down_interruptible(&arpt_mutex);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
@@ -1196,7 +1193,7 @@
 
  free_unlock:
 	vfree(newinfo);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	goto unlock;
 }
 
@@ -1210,7 +1207,7 @@
 	ARPT_ENTRY_ITERATE(table->private->entries, table->private->size,
 			   cleanup_entry, NULL);
 	vfree(table->private);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 /* The built-in targets: standard (NULL) and error. */
diff -r -u linux-2.5.55/net/ipv4/netfilter/ip_conntrack_core.c linux-2.5.55-new/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.5.55/net/ipv4/netfilter/ip_conntrack_core.c	2003-01-09 05:03:49.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ip_conntrack_core.c	2003-01-09 22:23:43.000000000 +0100
@@ -1126,7 +1126,7 @@
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
 {
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	list_prepend(&helpers, me);
@@ -1165,7 +1165,7 @@
 	br_write_lock_bh(BR_NETPROTO_LOCK);
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 /* Refresh conntrack for this many jiffies. */
diff -r -u linux-2.5.55/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.5.55-new/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.5.55/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-01-09 05:04:13.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-01-09 22:23:43.000000000 +0100
@@ -310,7 +310,7 @@
 	}
 
 	list_prepend(&protocol_list, proto);
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 
  out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -333,7 +333,7 @@
 	/* Remove all contrack entries for this protocol */
 	ip_ct_selective_cleanup(kill_proto, &proto->proto);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 static int __init init(void)
diff -r -u linux-2.5.55/net/ipv4/netfilter/ip_nat_helper.c linux-2.5.55-new/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.5.55/net/ipv4/netfilter/ip_nat_helper.c	2003-01-09 05:03:55.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ip_nat_helper.c	2003-01-09 22:28:37.000000000 +0100
@@ -368,10 +368,9 @@
 	if (me->me && !(me->flags & IP_NAT_HELPER_F_STANDALONE)) {
 		struct ip_conntrack_helper *ct_helper;
 		
-		if ((ct_helper = ip_ct_find_helper(&me->tuple))
-		    && ct_helper->me) {
-			__MOD_INC_USE_COUNT(ct_helper->me);
-		} else {
+		if (!(ct_helper = ip_ct_find_helper(&me->tuple)) ||
+		    (!(try_module_get(ct_helper->me))))
+		{
 			/* We are a NAT helper for protocol X.  If we need
 			 * respective conntrack helper for protoccol X, compute
 			 * conntrack helper name and try to load module */
@@ -387,11 +386,9 @@
 			tmp += 6;
 			sprintf(name, "ip_conntrack%s", tmp);
 #ifdef CONFIG_KMOD
-			if (!request_module(name)
-			    && (ct_helper = ip_ct_find_helper(&me->tuple))
-			    && ct_helper->me) {
-				__MOD_INC_USE_COUNT(ct_helper->me);
-			} else {
+			if (request_module(name)
+			    || (!(ct_helper = ip_ct_find_helper(&me->tuple)))
+			    || (!try_module_get(ct_helper->me))) { 
 				printk("unable to load module %s\n", name);
 				return -EBUSY;
 			}
@@ -408,7 +405,8 @@
 		ret = -EBUSY;
 	else {
 		list_prepend(&helpers, me);
-		MOD_INC_USE_COUNT;
+
+		try_module_get(THIS_MODULE);
 	}
 	WRITE_UNLOCK(&ip_nat_lock);
 
@@ -453,22 +451,17 @@
 	ip_ct_selective_cleanup(kill_helper, me);
 
 	if (found)
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 
 	/* If we are no standalone NAT helper, we need to decrement usage count
 	 * on our conntrack helper */
 	if (me->me && !(me->flags & IP_NAT_HELPER_F_STANDALONE)) {
 		struct ip_conntrack_helper *ct_helper;
 		
-		if ((ct_helper = ip_ct_find_helper(&me->tuple))
-		    && ct_helper->me) {
-			__MOD_DEC_USE_COUNT(ct_helper->me);
-		}
-#ifdef CONFIG_MODULES
-		else 
-			printk("%s: unable to decrement usage count"
-			       " of conntrack helper %s\n",
-			       __FUNCTION__, me->me->name);
-#endif
+		if ((ct_helper = ip_ct_find_helper(&me->tuple)))
+		        if (!try_module_get(ct_helper->me))
+			        printk("%s: unable to decrement usage count"
+				       " of conntrack helper %s\n",
+				       __FUNCTION__, me->me->name);
 	}
 }
diff -r -u linux-2.5.55/net/ipv4/netfilter/ip_nat_standalone.c linux-2.5.55-new/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.5.55/net/ipv4/netfilter/ip_nat_standalone.c	2003-01-09 05:04:22.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ip_nat_standalone.c	2003-01-09 22:23:43.000000000 +0100
@@ -255,7 +255,7 @@
 	}
 
 	list_prepend(&protos, proto);
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 
  out:
 	WRITE_UNLOCK(&ip_nat_lock);
@@ -273,7 +273,7 @@
 	br_write_lock_bh(BR_NETPROTO_LOCK);
 	br_write_unlock_bh(BR_NETPROTO_LOCK);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 static int init_or_cleanup(int init)
@@ -314,13 +314,11 @@
 		goto cleanup_localoutops;
 	}
 #endif
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	try_module_get(ip_conntrack_module);
 	return ret;
 
  cleanup:
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	module_put(ip_conntrack_module);
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
diff -r -u linux-2.5.55/net/ipv4/netfilter/ip_tables.c linux-2.5.55-new/net/ipv4/netfilter/ip_tables.c
--- linux-2.5.55/net/ipv4/netfilter/ip_tables.c	2003-01-09 05:03:58.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ip_tables.c	2003-01-09 22:23:43.000000000 +0100
@@ -599,8 +599,7 @@
 		m->u.kernel.match->destroy(m->data,
 					   m->u.match_size - sizeof(*m));
 
-	if (m->u.kernel.match->me)
-		__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+	module_put(m->u.kernel.match->me);
 
 	return 0;
 }
@@ -650,8 +649,7 @@
 		duprintf("check_match: `%s' not found\n", m->u.user.name);
 		return ret;
 	}
-	if (match->me)
-		__MOD_INC_USE_COUNT(match->me);
+	try_module_get(match->me);
 	m->u.kernel.match = match;
 	up(&ipt_mutex);
 
@@ -659,8 +657,7 @@
 	    && !m->u.kernel.match->checkentry(name, ip, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
-		if (m->u.kernel.match->me)
-			__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+		module_put(m->u.kernel.match->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		return -EINVAL;
@@ -697,8 +694,7 @@
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto cleanup_matches;
 	}
-	if (target->me)
-		__MOD_INC_USE_COUNT(target->me);
+	try_module_get(target->me);
 	t->u.kernel.target = target;
 	up(&ipt_mutex);
 
@@ -712,8 +708,7 @@
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		if (t->u.kernel.target->me)
-			__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+		module_put(t->u.kernel.target->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -785,8 +780,7 @@
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->data,
 					    t->u.target_size - sizeof(*t));
-	if (t->u.kernel.target->me)
-		__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	module_put(t->u.kernel.target->me);
 
 	return 0;
 }
@@ -1115,12 +1109,12 @@
 	/* Update module usage count based on number of rules */
 	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
 		oldinfo->number, oldinfo->initial_entries, newinfo->number);
-	if (t->me && (oldinfo->number <= oldinfo->initial_entries) &&
+	if ((oldinfo->number <= oldinfo->initial_entries) &&
  	    (newinfo->number > oldinfo->initial_entries))
-		__MOD_INC_USE_COUNT(t->me);
-	else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
+		try_module_get(t->me);
+	else if ((oldinfo->number > oldinfo->initial_entries) &&
 	 	 (newinfo->number <= oldinfo->initial_entries))
-		__MOD_DEC_USE_COUNT(t->me);
+		module_put(t->me);
 
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
@@ -1319,17 +1313,17 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 		return ret;
 	}
 	if (!list_named_insert(&ipt_target, target)) {
 		duprintf("ipt_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 	}
 	up(&ipt_mutex);
 	return ret;
@@ -1341,7 +1335,7 @@
 	down(&ipt_mutex);
 	LIST_DELETE(&ipt_target, target);
 	up(&ipt_mutex);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 int
@@ -1349,16 +1343,16 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 		return ret;
 	}
 	if (!list_named_insert(&ipt_match, match)) {
 		duprintf("ipt_register_match: `%s' already in list!\n",
 			 match->name);
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 		ret = -EINVAL;
 	}
 	up(&ipt_mutex);
@@ -1372,7 +1366,7 @@
 	down(&ipt_mutex);
 	LIST_DELETE(&ipt_match, match);
 	up(&ipt_mutex);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 int ipt_register_table(struct ipt_table *table)
@@ -1382,12 +1376,12 @@
 	static struct ipt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 	memcpy(newinfo->entries, table->table->entries, table->table->size);
@@ -1399,14 +1393,14 @@
 			      table->table->underflow);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
@@ -1436,7 +1430,7 @@
 
  free_unlock:
 	vfree(newinfo);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	goto unlock;
 }
 
@@ -1450,7 +1444,7 @@
 	IPT_ENTRY_ITERATE(table->private->entries, table->private->size,
 			  cleanup_entry, NULL);
 	vfree(table->private);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */
diff -r -u linux-2.5.55/net/ipv4/netfilter/ipchains_core.c linux-2.5.55-new/net/ipv4/netfilter/ipchains_core.c
--- linux-2.5.55/net/ipv4/netfilter/ipchains_core.c	2003-01-09 05:04:24.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ipchains_core.c	2003-01-09 22:23:43.000000000 +0100
@@ -839,7 +839,7 @@
 			i->branch->refcount--;
 		kfree(i);
 		i = tmp;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 	}
 	return 0;
 }
@@ -886,7 +886,7 @@
 	if (rule->branch) rule->branch->refcount++;
 
 append_successful:
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	return 0;
 }
 
@@ -917,7 +917,7 @@
 	f->next = frwl;
 
 insert_successful:
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	return 0;
 }
 
@@ -952,7 +952,7 @@
 		kfree(tmp);
 	}
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	return 0;
 }
 
@@ -1059,7 +1059,7 @@
 		else
 			chainptr->chain = ftmp->next;
 		kfree(ftmp);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		break;
 	}
 
@@ -1101,7 +1101,7 @@
 	tmp->next = tmp2->next;
 	kfree(tmp2);
 
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	return 0;
 }
 
@@ -1154,7 +1154,7 @@
 					      * user defined chain *
 					      * and therefore can be
 					      * deleted */
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	return 0;
 }
 
diff -r -u linux-2.5.55/net/ipv4/netfilter/ipfwadm_core.c linux-2.5.55-new/net/ipv4/netfilter/ipfwadm_core.c
--- linux-2.5.55/net/ipv4/netfilter/ipfwadm_core.c	2003-01-09 05:04:12.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ipfwadm_core.c	2003-01-09 22:23:43.000000000 +0100
@@ -705,7 +705,7 @@
 		ftmp = *chainptr;
 		*chainptr = ftmp->fw_next;
 		kfree(ftmp);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 	}
 	WRITE_UNLOCK(&ip_fw_lock);
 }
@@ -746,7 +746,7 @@
 	ftmp->fw_next = *chainptr;
        	*chainptr=ftmp;
 	WRITE_UNLOCK(&ip_fw_lock);
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	return(0);
 }
 
@@ -794,7 +794,7 @@
 	else
         	*chainptr=ftmp;
 	WRITE_UNLOCK(&ip_fw_lock);
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	return(0);
 }
 
@@ -867,7 +867,7 @@
 	}
 	WRITE_UNLOCK(&ip_fw_lock);
 	if (was_found) {
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return 0;
 	} else
 		return(EINVAL);
diff -r -u linux-2.5.55/net/ipv4/netfilter/ipt_conntrack.c linux-2.5.55-new/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.5.55/net/ipv4/netfilter/ipt_conntrack.c	2003-01-09 05:04:25.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ipt_conntrack.c	2003-01-09 22:23:43.000000000 +0100
@@ -106,16 +106,14 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	try_module_get(ip_conntrack_module);
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
diff -r -u linux-2.5.55/net/ipv4/netfilter/ipt_helper.c linux-2.5.55-new/net/ipv4/netfilter/ipt_helper.c
--- linux-2.5.55/net/ipv4/netfilter/ipt_helper.c	2003-01-09 05:04:20.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ipt_helper.c	2003-01-09 22:23:43.000000000 +0100
@@ -95,16 +95,14 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	try_module_get(ip_conntrack_module);
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
diff -r -u linux-2.5.55/net/ipv4/netfilter/ipt_state.c linux-2.5.55-new/net/ipv4/netfilter/ipt_state.c
--- linux-2.5.55/net/ipv4/netfilter/ipt_state.c	2003-01-09 05:04:27.000000000 +0100
+++ linux-2.5.55-new/net/ipv4/netfilter/ipt_state.c	2003-01-09 22:23:43.000000000 +0100
@@ -47,16 +47,14 @@
 static int __init init(void)
 {
 	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	try_module_get(ip_conntrack_module);
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
diff -r -u linux-2.5.55/net/ipv6/netfilter/ip6_tables.c linux-2.5.55-new/net/ipv6/netfilter/ip6_tables.c
--- linux-2.5.55/net/ipv6/netfilter/ip6_tables.c	2003-01-09 05:04:24.000000000 +0100
+++ linux-2.5.55-new/net/ipv6/netfilter/ip6_tables.c	2003-01-09 22:23:43.000000000 +0100
@@ -672,8 +672,7 @@
 		m->u.kernel.match->destroy(m->data,
 					   m->u.match_size - sizeof(*m));
 
-	if (m->u.kernel.match->me)
-		__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+	module_put(m->u.kernel.match->me);
 
 	return 0;
 }
@@ -723,8 +722,7 @@
 	  //		duprintf("check_match: `%s' not found\n", m->u.name);
 		return ret;
 	}
-	if (match->me)
-		__MOD_INC_USE_COUNT(match->me);
+	try_module_get(match->me);
 	m->u.kernel.match = match;
 	up(&ip6t_mutex);
 
@@ -732,8 +730,7 @@
 	    && !m->u.kernel.match->checkentry(name, ipv6, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
-		if (m->u.kernel.match->me)
-			__MOD_DEC_USE_COUNT(m->u.kernel.match->me);
+	        module_put(m->u.kernel.match->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		return -EINVAL;
@@ -770,8 +767,7 @@
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto cleanup_matches;
 	}
-	if (target->me)
-		__MOD_INC_USE_COUNT(target->me);
+	try_module_get(target->me);
 	t->u.kernel.target = target;
 	up(&ip6t_mutex);
 
@@ -785,8 +781,7 @@
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		if (t->u.kernel.target->me)
-			__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+		module_put(t->u.kernel.target->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -858,8 +853,7 @@
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->data,
 					    t->u.target_size - sizeof(*t));
-	if (t->u.kernel.target->me)
-		__MOD_DEC_USE_COUNT(t->u.kernel.target->me);
+	module_put(t->u.kernel.target->me);
 
 	return 0;
 }
@@ -1184,12 +1178,12 @@
 	/* Update module usage count based on number of rules */
 	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
 		oldinfo->number, oldinfo->initial_entries, newinfo->number);
-	if (t->me && (oldinfo->number <= oldinfo->initial_entries) &&
+	if ((oldinfo->number <= oldinfo->initial_entries) &&
  	    (newinfo->number > oldinfo->initial_entries))
-		__MOD_INC_USE_COUNT(t->me);
-	else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
+		try_module_get(t->me);
+	else if ((oldinfo->number > oldinfo->initial_entries) &&
 	 	 (newinfo->number <= oldinfo->initial_entries))
-		__MOD_DEC_USE_COUNT(t->me);
+		module_put(t->me);
 
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
@@ -1388,17 +1382,17 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	ret = down_interruptible(&ip6t_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 	if (!list_named_insert(&ip6t_target, target)) {
 		duprintf("ip6t_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 	}
 	up(&ip6t_mutex);
 	return ret;
@@ -1410,7 +1404,7 @@
 	down(&ip6t_mutex);
 	LIST_DELETE(&ip6t_target, target);
 	up(&ip6t_mutex);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 int
@@ -1418,16 +1412,16 @@
 {
 	int ret;
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	ret = down_interruptible(&ip6t_mutex);
 	if (ret != 0) {
-		MOD_DEC_USE_COUNT;
+	        module_put(THIS_MODULE);
 		return ret;
 	}
 	if (!list_named_insert(&ip6t_match, match)) {
 		duprintf("ip6t_register_match: `%s' already in list!\n",
 			 match->name);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		ret = -EINVAL;
 	}
 	up(&ip6t_mutex);
@@ -1441,7 +1435,7 @@
 	down(&ip6t_mutex);
 	LIST_DELETE(&ip6t_match, match);
 	up(&ip6t_mutex);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 int ip6t_register_table(struct ip6t_table *table)
@@ -1451,12 +1445,12 @@
 	static struct ip6t_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { }, { } };
 
-	MOD_INC_USE_COUNT;
+	try_module_get(THIS_MODULE);
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 	memcpy(newinfo->entries, table->table->entries, table->table->size);
@@ -1468,14 +1462,14 @@
 			      table->table->underflow);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
 	ret = down_interruptible(&ip6t_mutex);
 	if (ret != 0) {
 		vfree(newinfo);
-		MOD_DEC_USE_COUNT;
+		module_put(THIS_MODULE);
 		return ret;
 	}
 
@@ -1505,7 +1499,7 @@
 
  free_unlock:
 	vfree(newinfo);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 	goto unlock;
 }
 
@@ -1519,7 +1513,7 @@
 	IP6T_ENTRY_ITERATE(table->private->entries, table->private->size,
 			  cleanup_entry, NULL);
 	vfree(table->private);
-	MOD_DEC_USE_COUNT;
+	module_put(THIS_MODULE);
 }
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */

--------------070903000602090603010109--
