From: Mikael Pettersson <mikpe@it.uu.se>
Subject: [BISECTED][2.6.35 regression] iptables busted on Mac G5
Date: Mon, 23 Aug 2010 14:11:14 +0200
Message-ID: <19570.25954.196694.563887@pilspetsen.it.uu.se>
References: <19546.53659.970308.750410@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:62750 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0HWMLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:11:19 -0400
In-Reply-To: <19546.53659.970308.750410@pilspetsen.it.uu.se>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Aug 2010, Mikael Pettersson wrote:
 > The machine is a Mac G5 (ppc64) with Fedora 11 user-space,
 > most of it 32-bit.  Everything worked fine with kernel 2.6.34.
 > 
 > With kernel 2.6.35 however the machine comes up, seemingly with
 > networking operational according to the kernel log, but neither
 > NIC will actually send or receive anything including pings.  There
 > are no errors, just no traffic.
 > 
 > Initial investigation shows that 2.6.34-git5 was the last kernel
 > that worked, and from 2.6.34-git6 up to 2.6.35-git2 all kernels
 > malfunction as described (and 2.6.35-rc1 won't boot at all).
 > 
 > As a final experiment I disabled iptables (via chkconfig + reboot)
 > and that restored networking.  This is clearly not the solution.
 > 
 > I'll try to narrow it down further next week when I'm at the
 > machine's location again.  Meanwhile I would be grateful if
 > anyone has any ideas about what the issue might be.  I'll add
 > that a Mac G4 (ppc32) with similar kernel configuration and
 > user-space works fine with 2.6.35 and iptables.

The bug is still present in 2.6.36-rc2.

Meanwhile git bisect identified

git bisect start
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [67a3e12b05e055c0415c556a315a3d3eb637e29e] Linux 2.6.35-rc1
git bisect bad 67a3e12b05e055c0415c556a315a3d3eb637e29e
# bad: [f8965467f366fd18f01feafb5db10512d7b4422c] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
git bisect bad f8965467f366fd18f01feafb5db10512d7b4422c
# good: [fb091be08d1acf184e8801dfdcace6e0cb19b1fe] Merge branch 'v4l_for_2.6.35' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git bisect good fb091be08d1acf184e8801dfdcace6e0cb19b1fe
# good: [ec7d2f2cf3a1b76202986519ec4f8ec75b2de232] net: __alloc_skb() speedup
git bisect good ec7d2f2cf3a1b76202986519ec4f8ec75b2de232
# bad: [380fefb2ddabd4cd5f14dbe090481f0544e65078] dm9000: fix "BUG: spinlock recursion"
git bisect bad 380fefb2ddabd4cd5f14dbe090481f0544e65078
# bad: [b56f2d55c6c22b0c5774b3b22e336fb6cc5f4094] netfilter: use rcu_dereference_protected()
git bisect bad b56f2d55c6c22b0c5774b3b22e336fb6cc5f4094
# good: [0294b6f78f2dd9d94fa0deec28e8845a7fb43ac3] netdev: octeon_mgmt: Remove some gratuitous blank lines.
git bisect good 0294b6f78f2dd9d94fa0deec28e8845a7fb43ac3
# good: [9e56c21486f2a64473f36fa49475fd253422fbf6] netfilter: only do skb_checksum_help on CHECKSUM_PARTIAL in ip_queue
git bisect good 9e56c21486f2a64473f36fa49475fd253422fbf6
# good: [a33fa66bcf365ffe5b79d1ae1d3582cc261ae56e] bnx2: Add prefetches to rx path.
git bisect good a33fa66bcf365ffe5b79d1ae1d3582cc261ae56e
# good: [e281b19897dc21c1071802808d461627d747a877] netfilter: xtables: inclusion of xt_TEE
git bisect good e281b19897dc21c1071802808d461627d747a877
# bad: [cecc74de25d2cfb08e7702cd38e3f195950f1228] netfilter: ip_tables: convert pr_devel() to pr_debug()
git bisect bad cecc74de25d2cfb08e7702cd38e3f195950f1228
# bad: [22265a5c3c103cf8c50be62e6c90d045eb649e6d] netfilter: xt_TEE: resolve oif using netdevice notifiers
git bisect bad 22265a5c3c103cf8c50be62e6c90d045eb649e6d
# bad: [cd58bcd9787ef4c16ab6e442c4f1bf3539b3ab39] netfilter: xt_TEE: have cloned packet travel through Xtables too
git bisect bad cd58bcd9787ef4c16ab6e442c4f1bf3539b3ab39
# bad: [f3c5c1bfd430858d3a05436f82c51e53104feb6b] netfilter: xtables: make ip_tables reentrant
git bisect bad f3c5c1bfd430858d3a05436f82c51e53104feb6b

which is

> From: Jan Engelhardt <jengelh@medozas.de>
> Date: Mon, 19 Apr 2010 16:05:10 +0200
> Subject: [PATCH] netfilter: xtables: make ip_tables reentrant

as the cause or trigger for this bug.

Doing a partial revert of that from 2.6.34-git6 (see below) makes that
kernel work again.  I haven't tried forward-porting the revert yet.

/Mikael

--- linux-2.6.34-git6/net/ipv4/netfilter/ip_tables.c.~1~	2010-08-10 11:51:57.000000000 +0200
+++ linux-2.6.34-git6/net/ipv4/netfilter/ip_tables.c	2010-08-23 13:08:02.000000000 +0200
@@ -301,14 +301,15 @@ ipt_do_table(struct sk_buff *skb,
 	     const struct net_device *out,
 	     struct xt_table *table)
 {
+#define tb_comefrom ((struct ipt_entry *)table_base)->comefrom
+
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
 	const char *indev, *outdev;
 	const void *table_base;
-	struct ipt_entry *e, **jumpstack;
-	unsigned int *stackptr, origptr, cpu;
+	struct ipt_entry *e, *back;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
 
@@ -333,23 +334,19 @@ ipt_do_table(struct sk_buff *skb,
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 	xt_info_rdlock_bh();
 	private = table->private;
-	cpu        = smp_processor_id();
-	table_base = private->entries[cpu];
-	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
-	stackptr   = &private->stackptr[cpu];
-	origptr    = *stackptr;
+	table_base = private->entries[smp_processor_id()];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
-	pr_debug("Entering %s(hook %u); sp at %u (UF %p)\n",
-		 table->name, hook, origptr,
-		 get_entry(table_base, private->underflow[hook]));
+	/* For return from builtin chain */
+	back = get_entry(table_base, private->underflow[hook]);
 
 	do {
 		const struct ipt_entry_target *t;
 		const struct xt_entry_match *ematch;
 
 		IP_NF_ASSERT(e);
+		IP_NF_ASSERT(back);
 		if (!ip_packet_match(ip, indev, outdev,
 		    &e->ip, acpar.fragoff)) {
  no_match:
@@ -387,28 +384,17 @@ ipt_do_table(struct sk_buff *skb,
 					verdict = (unsigned)(-v) - 1;
 					break;
 				}
-				if (*stackptr == 0) {
-					e = get_entry(table_base,
-					    private->underflow[hook]);
-					pr_debug("Underflow (this is normal) "
-						 "to %p\n", e);
-				} else {
-					e = jumpstack[--*stackptr];
-					pr_debug("Pulled %p out from pos %u\n",
-						 e, *stackptr);
-					e = ipt_next_entry(e);
-				}
+				e = back;
+				back = get_entry(table_base, back->comefrom);
 				continue;
 			}
 			if (table_base + v != ipt_next_entry(e) &&
 			    !(e->ip.flags & IPT_F_GOTO)) {
-				if (*stackptr >= private->stacksize) {
-					verdict = NF_DROP;
-					break;
-				}
-				jumpstack[(*stackptr)++] = e;
-				pr_debug("Pushed %p into pos %u\n",
-					 e, *stackptr - 1);
+				/* Save old back ptr in next entry */
+				struct ipt_entry *next = ipt_next_entry(e);
+				next->comefrom = (void *)back - table_base;
+				/* set back pointer to next entry */
+				back = next;
 			}
 
 			e = get_entry(table_base, v);
@@ -428,9 +414,7 @@ ipt_do_table(struct sk_buff *skb,
 			break;
 	} while (!acpar.hotdrop);
 	xt_info_rdunlock_bh();
-	pr_debug("Exiting %s; resetting sp from %u to %u\n",
-		 __func__, *stackptr, origptr);
-	*stackptr = origptr;
+
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
 #else
@@ -438,6 +422,8 @@ ipt_do_table(struct sk_buff *skb,
 		return NF_DROP;
 	else return verdict;
 #endif
+
+#undef tb_comefrom
 }
 
 /* Figures out from what hook each rule can be called: returns 0 if
@@ -819,9 +805,6 @@ translate_table(struct net *net, struct 
 		if (ret != 0)
 			return ret;
 		++i;
-		if (strcmp(ipt_get_target(iter)->u.user.name,
-		    XT_ERROR_TARGET) == 0)
-			++newinfo->stacksize;
 	}
 
 	if (i != repl->num_entries) {
--- linux-2.6.34-git6/net/netfilter/x_tables.c.~1~	2010-08-10 11:51:58.000000000 +0200
+++ linux-2.6.34-git6/net/netfilter/x_tables.c	2010-08-23 13:08:03.000000000 +0200
@@ -63,9 +63,6 @@ static const char *const xt_prefix[NFPRO
 	[NFPROTO_IPV6]   = "ip6",
 };
 
-/* Allow this many total (re)entries. */
-static const unsigned int xt_jumpstack_multiplier = 2;
-
 /* Registration hooks for targets. */
 int
 xt_register_target(struct xt_target *target)
@@ -684,26 +681,6 @@ void xt_free_table_info(struct xt_table_
 		else
 			vfree(info->entries[cpu]);
 	}
-
-	if (info->jumpstack != NULL) {
-		if (sizeof(void *) * info->stacksize > PAGE_SIZE) {
-			for_each_possible_cpu(cpu)
-				vfree(info->jumpstack[cpu]);
-		} else {
-			for_each_possible_cpu(cpu)
-				kfree(info->jumpstack[cpu]);
-		}
-	}
-
-	if (sizeof(void **) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->jumpstack);
-	else
-		kfree(info->jumpstack);
-	if (sizeof(unsigned int) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->stackptr);
-	else
-		kfree(info->stackptr);
-
 	kfree(info);
 }
 EXPORT_SYMBOL(xt_free_table_info);
@@ -748,49 +725,6 @@ EXPORT_SYMBOL_GPL(xt_compat_unlock);
 DEFINE_PER_CPU(struct xt_info_lock, xt_info_locks);
 EXPORT_PER_CPU_SYMBOL_GPL(xt_info_locks);
 
-static int xt_jumpstack_alloc(struct xt_table_info *i)
-{
-	unsigned int size;
-	int cpu;
-
-	size = sizeof(unsigned int) * nr_cpu_ids;
-	if (size > PAGE_SIZE)
-		i->stackptr = vmalloc(size);
-	else
-		i->stackptr = kmalloc(size, GFP_KERNEL);
-	if (i->stackptr == NULL)
-		return -ENOMEM;
-	memset(i->stackptr, 0, size);
-
-	size = sizeof(void **) * nr_cpu_ids;
-	if (size > PAGE_SIZE)
-		i->jumpstack = vmalloc(size);
-	else
-		i->jumpstack = kmalloc(size, GFP_KERNEL);
-	if (i->jumpstack == NULL)
-		return -ENOMEM;
-	memset(i->jumpstack, 0, size);
-
-	i->stacksize *= xt_jumpstack_multiplier;
-	size = sizeof(void *) * i->stacksize;
-	for_each_possible_cpu(cpu) {
-		if (size > PAGE_SIZE)
-			i->jumpstack[cpu] = vmalloc_node(size,
-				cpu_to_node(cpu));
-		else
-			i->jumpstack[cpu] = kmalloc_node(size,
-				GFP_KERNEL, cpu_to_node(cpu));
-		if (i->jumpstack[cpu] == NULL)
-			/*
-			 * Freeing will be done later on by the callers. The
-			 * chain is: xt_replace_table -> __do_replace ->
-			 * do_replace -> xt_free_table_info.
-			 */
-			return -ENOMEM;
-	}
-
-	return 0;
-}
 
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
@@ -799,13 +733,6 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
-	int ret;
-
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0) {
-		*error = ret;
-		return NULL;
-	}
 
 	/* Do the substitution. */
 	local_bh_disable();
@@ -844,10 +771,6 @@ struct xt_table *xt_register_table(struc
 	struct xt_table_info *private;
 	struct xt_table *t, *table;
 
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	/* Don't add one object to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
 	if (!table) {
