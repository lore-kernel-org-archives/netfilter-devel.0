From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/64]: {ip,ip6}_tables: reformat to eliminate differences
Date: Tue, 18 Dec 2007 00:46:37 +0100 (MET)
Message-ID: <20071217234637.23601.37198.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38933 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbXLQXqi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:38 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6}_tables: reformat to eliminate differences

Reformat ip_tables.c and ip6_tables.c in order to eliminate non-functional
differences and minimize diff output.

This allows to get a view of the real differences using:

sed -e 's/IP6T/IPT/g' \
    -e 's/IP6/IP/g' \
    -e 's/INET6/INET/g' \
    -e 's/ip6t/ipt/g' \
    -e 's/ip6/ip/g' \
    -e 's/ipv6/ip/g' \
    -e 's/icmp6/icmp/g' \
    net/ipv6/netfilter/ip6_tables.c |
diff -wup /dev/stdin net/ipv4/netfilter/ip_tables.c

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 78122604ad05f50a11447c798605d985a4357843
tree 11cc6bcc105e7b9cd125a0b99a99954f51daeb43
parent 1d1b0c11ae4ac0beacfc129f003ddeb8c5b6f691
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 net/ipv4/netfilter/ip_tables.c  |   66 ++++++++++++++++++---------------------
 net/ipv6/netfilter/ip6_tables.c |   46 ++++++++++++++-------------
 2 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 07be12c..231f5d2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -74,7 +74,7 @@ do {								\
    Hence the start of any table is given by get_table() below.  */
 
 /* Returns whether matches rule or not. */
-static inline int
+static inline bool
 ip_packet_match(const struct iphdr *ip,
 		const char *indev,
 		const char *outdev,
@@ -102,7 +102,7 @@ ip_packet_match(const struct iphdr *ip,
 			NIPQUAD(ipinfo->dmsk.s_addr),
 			NIPQUAD(ipinfo->dst.s_addr),
 			ipinfo->invflags & IPT_INV_DSTIP ? " (INV)" : "");
-		return 0;
+		return false;
 	}
 
 	/* Look for ifname matches; this should unroll nicely. */
@@ -116,7 +116,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
 			indev, ipinfo->iniface,
 			ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
@@ -129,7 +129,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
 			outdev, ipinfo->outiface,
 			ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 	/* Check specific protocol */
@@ -138,7 +138,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("Packet protocol %hi does not match %hi.%s\n",
 			ip->protocol, ipinfo->proto,
 			ipinfo->invflags&IPT_INV_PROTO ? " (INV)":"");
-		return 0;
+		return false;
 	}
 
 	/* If we have a fragment rule but the packet is not a fragment
@@ -146,10 +146,10 @@ ip_packet_match(const struct iphdr *ip,
 	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG)) {
 		dprintf("Fragment rule but not fragment.%s\n",
 			ipinfo->invflags & IPT_INV_FRAG ? " (INV)" : "");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static inline bool
@@ -222,7 +222,7 @@ unconditional(const struct ipt_ip *ip)
 static const char *hooknames[] = {
 	[NF_INET_PRE_ROUTING]		= "PREROUTING",
 	[NF_INET_LOCAL_IN]		= "INPUT",
-	[NF_INET_FORWARD]			= "FORWARD",
+	[NF_INET_FORWARD]		= "FORWARD",
 	[NF_INET_LOCAL_OUT]		= "OUTPUT",
 	[NF_INET_POST_ROUTING]		= "POSTROUTING",
 };
@@ -467,8 +467,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	   to 0 as we leave), and comefrom to save source hook bitmask */
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
-		struct ipt_entry *e
-			= (struct ipt_entry *)(entry0 + pos);
+		struct ipt_entry *e = (struct ipt_entry *)(entry0 + pos);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -486,8 +485,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 				       hook, pos, e->comefrom);
 				return 0;
 			}
-			e->comefrom
-				|= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
+			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct ipt_entry)
@@ -589,7 +587,8 @@ check_entry(struct ipt_entry *e, const char *name)
 		return -EINVAL;
 	}
 
-	if (e->target_offset + sizeof(struct ipt_entry_target) > e->next_offset)
+	if (e->target_offset + sizeof(struct ipt_entry_target) >
+	    e->next_offset)
 		return -EINVAL;
 
 	t = ipt_get_target(e);
@@ -633,7 +632,7 @@ find_check_match(struct ipt_entry_match *m,
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						   m->u.user.revision),
+						      m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
@@ -959,7 +958,6 @@ copy_entries_to_user(unsigned int total_size,
 	 * allowed to migrate to another cpu)
 	 */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
@@ -1169,15 +1167,13 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 	t = xt_find_table_lock(AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
-		duprintf("t->private->number = %u\n",
-			 private->number);
+		duprintf("t->private->number = %u\n", private->number);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size,
-				 get.size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		module_put(t->me);
@@ -1281,7 +1277,7 @@ do_replace(void __user *user, unsigned int len)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy that is our node/cpu */
+	/* choose the copy that is on our node/cpu */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
@@ -1304,7 +1300,7 @@ do_replace(void __user *user, unsigned int len)
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1651,7 +1647,8 @@ static inline int compat_check_entry(struct ipt_entry *e, const char *name,
 	int j, ret;
 
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
+	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip,
+				e->comefrom, &j);
 	if (ret)
 		goto cleanup_matches;
 
@@ -1744,8 +1741,8 @@ translate_compat_table(const char *name,
 	pos = entry1;
 	size = total_size;
 	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
-				       compat_copy_entry_from_user, &pos, &size,
-				       name, newinfo, entry1);
+				       compat_copy_entry_from_user,
+				       &pos, &size, name, newinfo, entry1);
 	xt_compat_flush_offsets(AF_INET);
 	xt_compat_unlock(AF_INET);
 	if (ret)
@@ -1813,7 +1810,7 @@ compat_do_replace(void __user *user, unsigned int len)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy that is our node/cpu */
+	/* choose the copy that is on our node/cpu */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
@@ -1934,16 +1931,14 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		struct xt_table_info info;
-		duprintf("t->private->number = %u\n",
-			 private->number);
+		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size) {
 			ret = compat_copy_entries_to_user(private->size,
 							  t, uptr->entrytable);
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size,
-				 get.size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		xt_compat_flush_offsets(AF_INET);
@@ -1981,7 +1976,7 @@ compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 #endif
 
 static int
-do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user, unsigned int len)
+do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	int ret;
 
@@ -2068,9 +2063,7 @@ int ipt_register_table(struct xt_table *table, const struct ipt_replace *repl)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy on our node/cpu
-	 * but dont care of preemption
-	 */
+	/* choose the copy on our node/cpu, but dont care about preemption */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
@@ -2112,7 +2105,8 @@ icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		     u_int8_t type, u_int8_t code,
 		     bool invert)
 {
-	return ((test_type == 0xFF) || (type == test_type && code >= min_code && code <= max_code))
+	return ((test_type == 0xFF) ||
+		(type == test_type && code >= min_code && code <= max_code))
 		^ invert;
 }
 
@@ -2153,7 +2147,7 @@ icmp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static bool
 icmp_checkentry(const char *tablename,
-	   const void *info,
+	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int hook_mask)
@@ -2204,9 +2198,9 @@ static struct xt_match icmp_matchstruct __read_mostly = {
 	.name		= "icmp",
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
+	.checkentry	= icmp_checkentry,
 	.proto		= IPPROTO_ICMP,
 	.family		= AF_INET,
-	.checkentry	= icmp_checkentry,
 };
 
 static int __init ip_tables_init(void)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index db0dc96..0a2ec4b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -371,8 +371,8 @@ ip6t_do_table(struct sk_buff *skb,
 	 * match it. */
 
 	read_lock_bh(&table->lock);
-	private = table->private;
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
+	private = table->private;
 	table_base = (void *)private->entries[smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -496,9 +496,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	   to 0 as we leave), and comefrom to save source hook bitmask */
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
-		struct ip6t_entry *e
-			= (struct ip6t_entry *)(entry0 + pos);
-		int visited = e->comefrom & (1 << hook);
+		struct ip6t_entry *e = (struct ip6t_entry *)(entry0 + pos);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -509,14 +507,14 @@ mark_source_chains(struct xt_table_info *newinfo,
 		for (;;) {
 			struct ip6t_standard_target *t
 				= (void *)ip6t_get_target(e);
+			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
 				printk("iptables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
-			e->comefrom
-				|= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
+			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct ip6t_entry)
@@ -663,7 +661,7 @@ find_check_match(struct ip6t_entry_match *m,
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
-					m->u.user.revision),
+						      m->u.user.revision),
 					"ip6t_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
@@ -885,7 +883,7 @@ translate_table(const char *name,
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
-	return 0;
+	return ret;
 }
 
 /* Gets counters. */
@@ -984,7 +982,10 @@ copy_entries_to_user(unsigned int total_size,
 	if (IS_ERR(counters))
 		return PTR_ERR(counters);
 
-	/* choose the copy that is on ourc node/cpu */
+	/* choose the copy that is on our node/cpu, ...
+	 * This choice is lazy (because current thread is
+	 * allowed to migrate to another cpu)
+	 */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
@@ -1199,7 +1200,7 @@ get_entries(struct ip6t_get_entries __user *uptr, int *len)
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, entries->size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		module_put(t->me);
@@ -1361,8 +1362,8 @@ do_add_counters(void __user *user, unsigned int len, int compat)
 	char *name;
 	int size;
 	void *ptmp;
-	struct xt_table_info *private;
 	struct xt_table *t;
+	struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
 #ifdef CONFIG_COMPAT
@@ -1829,7 +1830,7 @@ compat_do_replace(void __user *user, unsigned int len)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy that is our node/cpu */
+	/* choose the copy that is on our node/cpu */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
@@ -1950,16 +1951,14 @@ compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		struct xt_table_info info;
-		duprintf("t->private->number = %u\n",
-			 private->number);
+		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size) {
 			ret = compat_copy_entries_to_user(private->size,
 							  t, uptr->entrytable);
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size,
-				 get.size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		xt_compat_flush_offsets(AF_INET6);
@@ -2072,8 +2071,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-int ip6t_register_table(struct xt_table *table,
-			const struct ip6t_replace *repl)
+int ip6t_register_table(struct xt_table *table, const struct ip6t_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -2085,7 +2083,7 @@ int ip6t_register_table(struct xt_table *table,
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy on our node/cpu */
+	/* choose the copy on our node/cpu, but dont care about preemption */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
@@ -2141,17 +2139,18 @@ icmp6_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmp6hdr _icmp, *ic;
+	struct icmp6hdr _icmph, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
 	if (offset)
 		return false;
 
-	ic = skb_header_pointer(skb, protoff, sizeof(_icmp), &_icmp);
+	ic = skb_header_pointer(skb, protoff, sizeof(_icmph), &_icmph);
 	if (ic == NULL) {
 		/* We've been asked to examine this packet, and we
-		   can't.  Hence, no choice but to drop. */
+		 * can't.  Hence, no choice but to drop.
+		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
 		*hotdrop = true;
 		return false;
@@ -2216,7 +2215,7 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 
 static struct xt_match icmp6_matchstruct __read_mostly = {
 	.name		= "icmp6",
-	.match		= &icmp6_match,
+	.match		= icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
 	.checkentry	= icmp6_checkentry,
 	.proto		= IPPROTO_ICMPV6,
@@ -2265,6 +2264,7 @@ err1:
 static void __exit ip6_tables_fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
+
 	xt_unregister_match(&icmp6_matchstruct);
 	xt_unregister_target(&ip6t_error_target);
 	xt_unregister_target(&ip6t_standard_target);
