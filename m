From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next] netfilter: ip_tables: get rid of old debugging instrumentation
Date: Tue,  3 May 2016 14:24:39 +0200
Message-ID: <1462278279-11019-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660AbcECMYs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 08:24:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A4F55C2B1E
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:24:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DD17FAB45
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:24:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F07BA868
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 14:24:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dprintf() and duprintf() functions are enabled at compile time,
these days we have better runtime debugging through pr_debug() and
static keys.

On top of this, this debugging is so old that I don't expect anyone
using this anymore, so let's get rid of this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Is anyone here using this stuff these days? If not, I will be happy to
get rid of these old stuff.

I would consider replacing this by pr_debug() if anyone raises the hand
to tell me that it is using this in some reasonable way.

I can follow up with other x_tables clones.

 net/ipv4/netfilter/ip_tables.c | 213 +++++++----------------------------------
 1 file changed, 35 insertions(+), 178 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 21ccc19..fa9290e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -35,34 +35,12 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv4 packet filter");
 
-/*#define DEBUG_IP_FIREWALL*/
-/*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
-/*#define DEBUG_IP_FIREWALL_USER*/
-
-#ifdef DEBUG_IP_FIREWALL
-#define dprintf(format, args...) pr_info(format , ## args)
-#else
-#define dprintf(format, args...)
-#endif
-
-#ifdef DEBUG_IP_FIREWALL_USER
-#define duprintf(format, args...) pr_info(format , ## args)
-#else
-#define duprintf(format, args...)
-#endif
-
 #ifdef CONFIG_NETFILTER_DEBUG
 #define IP_NF_ASSERT(x)		WARN_ON(!(x))
 #else
 #define IP_NF_ASSERT(x)
 #endif
 
-#if 0
-/* All the better to debug you with... */
-#define static
-#define inline
-#endif
-
 void *ipt_alloc_initial_table(const struct xt_table *info)
 {
 	return xt_alloc_initial_table(ipt, IPT);
@@ -85,52 +63,28 @@ ip_packet_match(const struct iphdr *ip,
 	if (FWINV((ip->saddr&ipinfo->smsk.s_addr) != ipinfo->src.s_addr,
 		  IPT_INV_SRCIP) ||
 	    FWINV((ip->daddr&ipinfo->dmsk.s_addr) != ipinfo->dst.s_addr,
-		  IPT_INV_DSTIP)) {
-		dprintf("Source or dest mismatch.\n");
-
-		dprintf("SRC: %pI4. Mask: %pI4. Target: %pI4.%s\n",
-			&ip->saddr, &ipinfo->smsk.s_addr, &ipinfo->src.s_addr,
-			ipinfo->invflags & IPT_INV_SRCIP ? " (INV)" : "");
-		dprintf("DST: %pI4 Mask: %pI4 Target: %pI4.%s\n",
-			&ip->daddr, &ipinfo->dmsk.s_addr, &ipinfo->dst.s_addr,
-			ipinfo->invflags & IPT_INV_DSTIP ? " (INV)" : "");
+		  IPT_INV_DSTIP))
 		return false;
-	}
 
 	ret = ifname_compare_aligned(indev, ipinfo->iniface, ipinfo->iniface_mask);
 
-	if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
-		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, ipinfo->iniface,
-			ipinfo->invflags & IPT_INV_VIA_IN ? " (INV)" : "");
+	if (FWINV(ret != 0, IPT_INV_VIA_IN))
 		return false;
-	}
 
 	ret = ifname_compare_aligned(outdev, ipinfo->outiface, ipinfo->outiface_mask);
 
-	if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
-		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, ipinfo->outiface,
-			ipinfo->invflags & IPT_INV_VIA_OUT ? " (INV)" : "");
+	if (FWINV(ret != 0, IPT_INV_VIA_OUT))
 		return false;
-	}
 
 	/* Check specific protocol */
 	if (ipinfo->proto &&
-	    FWINV(ip->protocol != ipinfo->proto, IPT_INV_PROTO)) {
-		dprintf("Packet protocol %hi does not match %hi.%s\n",
-			ip->protocol, ipinfo->proto,
-			ipinfo->invflags & IPT_INV_PROTO ? " (INV)" : "");
+	    FWINV(ip->protocol != ipinfo->proto, IPT_INV_PROTO))
 		return false;
-	}
 
 	/* If we have a fragment rule but the packet is not a fragment
 	 * then we return zero */
-	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG)) {
-		dprintf("Fragment rule but not fragment.%s\n",
-			ipinfo->invflags & IPT_INV_FRAG ? " (INV)" : "");
+	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG))
 		return false;
-	}
 
 	return true;
 }
@@ -138,16 +92,10 @@ ip_packet_match(const struct iphdr *ip,
 static bool
 ip_checkentry(const struct ipt_ip *ip)
 {
-	if (ip->flags & ~IPT_F_MASK) {
-		duprintf("Unknown flag bits set: %08X\n",
-			 ip->flags & ~IPT_F_MASK);
+	if (ip->flags & ~IPT_F_MASK)
 		return false;
-	}
-	if (ip->invflags & ~IPT_INV_MASK) {
-		duprintf("Unknown invflag bits set: %08X\n",
-			 ip->invflags & ~IPT_INV_MASK);
+	if (ip->invflags & ~IPT_INV_MASK)
 		return false;
-	}
 	return true;
 }
 
@@ -496,26 +444,13 @@ mark_source_chains(const struct xt_table_info *newinfo,
 
 				if ((strcmp(t->target.u.user.name,
 					    XT_STANDARD_TARGET) == 0) &&
-				    t->verdict < -NF_MAX_VERDICT - 1) {
-					duprintf("mark_source_chains: bad "
-						"negative verdict (%i)\n",
-								t->verdict);
+				    t->verdict < -NF_MAX_VERDICT - 1)
 					return 0;
-				}
 
 				/* Return: backtrack through the last
 				   big jump. */
 				do {
 					e->comefrom ^= (1<<NF_INET_NUMHOOKS);
-#ifdef DEBUG_IP_FIREWALL_USER
-					if (e->comefrom
-					    & (1 << NF_INET_NUMHOOKS)) {
-						duprintf("Back unset "
-							 "on hook %u "
-							 "rule %u\n",
-							 hook, pos);
-					}
-#endif
 					oldpos = pos;
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
@@ -543,8 +478,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
 					/* This a jump; chase it. */
-					duprintf("Jump rule %u -> %u\n",
-						 pos, newpos);
 					e = (struct ipt_entry *)
 						(entry0 + newpos);
 					if (!find_jump_target(newinfo, e))
@@ -561,8 +494,7 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				pos = newpos;
 			}
 		}
-next:
-		duprintf("Finished chain %u\n", hook);
+next:		;
 	}
 	return 1;
 }
@@ -584,18 +516,12 @@ static int
 check_match(struct xt_entry_match *m, struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
-	int ret;
 
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
 
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-	      ip->proto, ip->invflags & IPT_INV_PROTO);
-	if (ret < 0) {
-		duprintf("check failed for `%s'.\n", par->match->name);
-		return ret;
-	}
-	return 0;
+	return xt_check_match(par, m->u.match_size - sizeof(*m),
+			      ip->proto, ip->invflags & IPT_INV_PROTO);
 }
 
 static int
@@ -606,10 +532,8 @@ find_check_match(struct xt_entry_match *m, struct xt_mtchk_param *par)
 
 	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
 				      m->u.user.revision);
-	if (IS_ERR(match)) {
-		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
+	if (IS_ERR(match))
 		return PTR_ERR(match);
-	}
 	m->u.kernel.match = match;
 
 	ret = check_match(m, par);
@@ -634,16 +558,9 @@ static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 		.hook_mask = e->comefrom,
 		.family    = NFPROTO_IPV4,
 	};
-	int ret;
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
-	if (ret < 0) {
-		duprintf("check failed for `%s'.\n",
-			 t->u.kernel.target->name);
-		return ret;
-	}
-	return 0;
+	return xt_check_target(&par, t->u.target_size - sizeof(*t),
+			       e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
 }
 
 static int
@@ -680,7 +597,6 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	target = xt_request_find_target(NFPROTO_IPV4, t->u.user.name,
 					t->u.user.revision);
 	if (IS_ERR(target)) {
-		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
 		ret = PTR_ERR(target);
 		goto cleanup_matches;
 	}
@@ -734,17 +650,12 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 
 	if ((unsigned long)e % __alignof__(struct ipt_entry) != 0 ||
 	    (unsigned char *)e + sizeof(struct ipt_entry) >= limit ||
-	    (unsigned char *)e + e->next_offset > limit) {
-		duprintf("Bad offset %p\n", e);
+	    (unsigned char *)e + e->next_offset > limit)
 		return -EINVAL;
-	}
 
 	if (e->next_offset
-	    < sizeof(struct ipt_entry) + sizeof(struct xt_entry_target)) {
-		duprintf("checking: element %p size %u\n",
-			 e, e->next_offset);
+	    < sizeof(struct ipt_entry) + sizeof(struct xt_entry_target))
 		return -EINVAL;
-	}
 
 	if (!ip_checkentry(&e->ip))
 		return -EINVAL;
@@ -818,7 +729,6 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		newinfo->underflow[i] = 0xFFFFFFFF;
 	}
 
-	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
@@ -835,27 +745,18 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 			++newinfo->stacksize;
 	}
 
-	if (i != repl->num_entries) {
-		duprintf("translate_table: %u not %u entries\n",
-			 i, repl->num_entries);
+	if (i != repl->num_entries)
 		return -EINVAL;
-	}
 
 	/* Check hooks all assigned */
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
 		/* Only hooks which are valid */
 		if (!(repl->valid_hooks & (1 << i)))
 			continue;
-		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
-			duprintf("Invalid hook entry %u %u\n",
-				 i, repl->hook_entry[i]);
+		if (newinfo->hook_entry[i] == 0xFFFFFFFF)
 			return -EINVAL;
-		}
-		if (newinfo->underflow[i] == 0xFFFFFFFF) {
-			duprintf("Invalid underflow %u %u\n",
-				 i, repl->underflow[i]);
+		if (newinfo->underflow[i] == 0xFFFFFFFF)
 			return -EINVAL;
-		}
 	}
 
 	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
@@ -1083,11 +984,8 @@ static int get_info(struct net *net, void __user *user,
 	struct xt_table *t;
 	int ret;
 
-	if (*len != sizeof(struct ipt_getinfo)) {
-		duprintf("length %u != %zu\n", *len,
-			 sizeof(struct ipt_getinfo));
+	if (*len != sizeof(struct ipt_getinfo))
 		return -EINVAL;
-	}
 
 	if (copy_from_user(name, user, sizeof(name)) != 0)
 		return -EFAULT;
@@ -1145,31 +1043,23 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 	struct ipt_get_entries get;
 	struct xt_table *t;
 
-	if (*len < sizeof(get)) {
-		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
+	if (*len < sizeof(get))
 		return -EINVAL;
-	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
-	if (*len != sizeof(struct ipt_get_entries) + get.size) {
-		duprintf("get_entries: %u != %zu\n",
-			 *len, sizeof(get) + get.size);
+	if (*len != sizeof(struct ipt_get_entries) + get.size)
 		return -EINVAL;
-	}
 	get.name[sizeof(get.name) - 1] = '\0';
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR_OR_NULL(t)) {
 		const struct xt_table_info *private = t->private;
-		duprintf("t->private->number = %u\n", private->number);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
-		else {
-			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
+		else
 			ret = -EAGAIN;
-		}
+
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
@@ -1205,8 +1095,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 
 	/* You lied! */
 	if (valid_hooks != t->valid_hooks) {
-		duprintf("Valid hook crap: %08X vs %08X\n",
-			 valid_hooks, t->valid_hooks);
 		ret = -EINVAL;
 		goto put_module;
 	}
@@ -1216,8 +1104,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		goto put_module;
 
 	/* Update module usage count based on number of rules */
-	duprintf("do_replace: oldnum=%u, initnum=%u, newnum=%u\n",
-		oldinfo->number, oldinfo->initial_entries, newinfo->number);
 	if ((oldinfo->number > oldinfo->initial_entries) ||
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
@@ -1286,8 +1172,6 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	if (ret != 0)
 		goto free_newinfo;
 
-	duprintf("Translated table\n");
-
 	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
 			   tmp.num_counters, tmp.counters);
 	if (ret)
@@ -1413,11 +1297,9 @@ compat_find_calc_match(struct xt_entry_match *m,
 
 	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
 				      m->u.user.revision);
-	if (IS_ERR(match)) {
-		duprintf("compat_check_calc_match: `%s' not found\n",
-			 m->u.user.name);
+	if (IS_ERR(match))
 		return PTR_ERR(match);
-	}
+
 	m->u.kernel.match = match;
 	*size += xt_compat_match_offset(match);
 	return 0;
@@ -1449,20 +1331,14 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	unsigned int j;
 	int ret, off;
 
-	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ipt_entry) != 0 ||
 	    (unsigned char *)e + sizeof(struct compat_ipt_entry) >= limit ||
-	    (unsigned char *)e + e->next_offset > limit) {
-		duprintf("Bad offset %p, limit = %p\n", e, limit);
+	    (unsigned char *)e + e->next_offset > limit)
 		return -EINVAL;
-	}
 
 	if (e->next_offset < sizeof(struct compat_ipt_entry) +
-			     sizeof(struct compat_xt_entry_target)) {
-		duprintf("checking: element %p size %u\n",
-			 e, e->next_offset);
+			     sizeof(struct compat_xt_entry_target))
 		return -EINVAL;
-	}
 
 	if (!ip_checkentry(&e->ip))
 		return -EINVAL;
@@ -1486,8 +1362,6 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	target = xt_request_find_target(NFPROTO_IPV4, t->u.user.name,
 					t->u.user.revision);
 	if (IS_ERR(target)) {
-		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
-			 t->u.user.name);
 		ret = PTR_ERR(target);
 		goto release_matches;
 	}
@@ -1569,7 +1443,6 @@ translate_compat_table(struct net *net,
 	size = compatr->size;
 	info->number = compatr->num_entries;
 
-	duprintf("translate_compat_table: size %u\n", info->size);
 	j = 0;
 	xt_compat_lock(AF_INET);
 	xt_compat_init_offsets(AF_INET, compatr->num_entries);
@@ -1584,11 +1457,8 @@ translate_compat_table(struct net *net,
 	}
 
 	ret = -EINVAL;
-	if (j != compatr->num_entries) {
-		duprintf("translate_compat_table: %u not %u entries\n",
-			 j, compatr->num_entries);
+	if (j != compatr->num_entries)
 		goto out_unlock;
-	}
 
 	ret = -ENOMEM;
 	newinfo = xt_alloc_table_info(size);
@@ -1685,8 +1555,6 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	if (ret != 0)
 		goto free_newinfo;
 
-	duprintf("compat_do_replace: Translated table\n");
-
 	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
 			   tmp.num_counters, compat_ptr(tmp.counters));
 	if (ret)
@@ -1720,7 +1588,6 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 		break;
 
 	default:
-		duprintf("do_ipt_set_ctl:  unknown request %i\n", cmd);
 		ret = -EINVAL;
 	}
 
@@ -1770,19 +1637,15 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	struct compat_ipt_get_entries get;
 	struct xt_table *t;
 
-	if (*len < sizeof(get)) {
-		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
+	if (*len < sizeof(get))
 		return -EINVAL;
-	}
 
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
 
-	if (*len != sizeof(struct compat_ipt_get_entries) + get.size) {
-		duprintf("compat_get_entries: %u != %zu\n",
-			 *len, sizeof(get) + get.size);
+	if (*len != sizeof(struct compat_ipt_get_entries) + get.size)
 		return -EINVAL;
-	}
+
 	get.name[sizeof(get.name) - 1] = '\0';
 
 	xt_compat_lock(AF_INET);
@@ -1790,16 +1653,13 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	if (!IS_ERR_OR_NULL(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
-		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
-		if (!ret && get.size == info.size) {
+		if (!ret && get.size == info.size)
 			ret = compat_copy_entries_to_user(private->size,
 							  t, uptr->entrytable);
-		} else if (!ret) {
-			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
+		else if (!ret)
 			ret = -EAGAIN;
-		}
+
 		xt_compat_flush_offsets(AF_INET);
 		module_put(t->me);
 		xt_table_unlock(t);
@@ -1852,7 +1712,6 @@ do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 
 	default:
-		duprintf("do_ipt_set_ctl:  unknown request %i\n", cmd);
 		ret = -EINVAL;
 	}
 
@@ -1904,7 +1763,6 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	}
 
 	default:
-		duprintf("do_ipt_get_ctl: unknown request %i\n", cmd);
 		ret = -EINVAL;
 	}
 
@@ -2006,7 +1864,6 @@ icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		duprintf("Dropping evil ICMP tinygram.\n");
 		par->hotdrop = true;
 		return false;
 	}
-- 
2.1.4

