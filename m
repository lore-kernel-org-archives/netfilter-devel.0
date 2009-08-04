From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 093/103] netfilter: iptables: remove xt1/ipv4 registration functions
Date: Tue,  4 Aug 2009 09:26:17 +0200
Message-ID: <1249370787-17583-94-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbZHDH2N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:13 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv4/ip_tables.h |    5 -
 net/ipv4/netfilter/ip_tables.c           |  491 ------------------------------
 2 files changed, 0 insertions(+), 496 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index ab81dbe..73a8f55 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -246,11 +246,6 @@ ipt_get_target(struct ipt_entry *e)
 #include <linux/init.h>
 extern void ipt_init(void) __init;
 
-extern struct xt_table *ipt_register_table(struct net *net,
-					   const struct xt_table *table,
-					   const struct ipt_replace *repl);
-extern void ipt_unregister_table(struct xt_table *table);
-
 extern struct xt2_table *ipt2_register_table(struct net *,
 	const struct xt_table *, const struct ipt_replace *);
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3c98c7d..ed3056b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -567,439 +567,6 @@ ipt_do_table(struct sk_buff *skb,
 #endif
 }
 
-/* Figures out from what hook each rule can be called: returns 0 if
-   there are loops.  Puts hook bitmask in comefrom. */
-static int
-mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
-{
-	unsigned int hook;
-
-	/* No recursion; use packet counter to save back ptrs (reset
-	   to 0 as we leave), and comefrom to save source hook bitmask */
-	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
-		unsigned int pos = newinfo->hook_entry[hook];
-		struct ipt_entry *e = (struct ipt_entry *)(entry0 + pos);
-
-		if (!(valid_hooks & (1 << hook)))
-			continue;
-
-		/* Set initial back pointer. */
-		e->counters.pcnt = pos;
-
-		for (;;) {
-			const struct ipt_standard_target *t
-				= (void *)ipt_get_target_c(e);
-			int visited = e->comefrom & (1 << hook);
-
-			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
-				       hook, pos, e->comefrom);
-				return 0;
-			}
-			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
-
-			/* Unconditional return/END. */
-			if ((e->target_offset == sizeof(struct ipt_entry)
-			    && (strcmp(t->target.u.user.name,
-				       IPT_STANDARD_TARGET) == 0)
-			    && t->verdict < 0
-			    && unconditional(&e->ip)) || visited) {
-				unsigned int oldpos, size;
-
-				if ((strcmp(t->target.u.user.name,
-			    		    IPT_STANDARD_TARGET) == 0) &&
-				    t->verdict < -NF_MAX_VERDICT - 1) {
-					duprintf("mark_source_chains: bad "
-						"negative verdict (%i)\n",
-								t->verdict);
-					return 0;
-				}
-
-				/* Return: backtrack through the last
-				   big jump. */
-				do {
-					e->comefrom ^= (1<<NF_INET_NUMHOOKS);
-#ifdef DEBUG_IP_FIREWALL_USER
-					if (e->comefrom
-					    & (1 << NF_INET_NUMHOOKS)) {
-						duprintf("Back unset "
-							 "on hook %u "
-							 "rule %u\n",
-							 hook, pos);
-					}
-#endif
-					oldpos = pos;
-					pos = e->counters.pcnt;
-					e->counters.pcnt = 0;
-
-					/* We're at the start. */
-					if (pos == oldpos)
-						goto next;
-
-					e = (struct ipt_entry *)
-						(entry0 + pos);
-				} while (oldpos == pos + e->next_offset);
-
-				/* Move along one */
-				size = e->next_offset;
-				e = (struct ipt_entry *)
-					(entry0 + pos + size);
-				e->counters.pcnt = pos;
-				pos += size;
-			} else {
-				int newpos = t->verdict;
-
-				if (strcmp(t->target.u.user.name,
-					   IPT_STANDARD_TARGET) == 0
-				    && newpos >= 0) {
-					if (newpos > newinfo->size -
-						sizeof(struct ipt_entry)) {
-						duprintf("mark_source_chains: "
-							"bad verdict (%i)\n",
-								newpos);
-						return 0;
-					}
-					/* This a jump; chase it. */
-					duprintf("Jump rule %u -> %u\n",
-						 pos, newpos);
-				} else {
-					/* ... this is a fallthru */
-					newpos = pos + e->next_offset;
-				}
-				e = (struct ipt_entry *)
-					(entry0 + newpos);
-				e->counters.pcnt = pos;
-				pos = newpos;
-			}
-		}
-		next:
-		duprintf("Finished chain %u\n", hook);
-	}
-	return 1;
-}
-
-static void cleanup_match(struct ipt_entry_match *m)
-{
-	struct xt_mtdtor_param par;
-
-	par.match     = m->u.kernel.match;
-	par.matchinfo = m->data;
-	par.family    = NFPROTO_IPV4;
-	if (par.match->destroy != NULL)
-		par.match->destroy(&par);
-	module_put(par.match->me);
-}
-
-static int
-check_entry(struct ipt_entry *e, struct xt_mtchk_param *par)
-{
-	const struct ipt_entry_target *t;
-
-	par->match     = &ipt_builtin_mt[0]; /* ipv4 */
-	par->matchinfo = &e->ip;
-	if (!ip_checkentry(par)) {
-		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
-		return -EINVAL;
-	}
-
-	if (e->target_offset + sizeof(struct ipt_entry_target) >
-	    e->next_offset)
-		return -EINVAL;
-
-	t = ipt_get_target_c(e);
-	if (e->target_offset + t->u.target_size > e->next_offset)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int
-check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
-{
-	const struct ipt_ip *ip = par->entryinfo;
-	int ret;
-
-	par->match     = m->u.kernel.match;
-	par->matchinfo = m->data;
-
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-	      ip->proto, ip->invflags & IPT_INV_PROTO, true);
-	if (ret < 0) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 par.match->name);
-		return ret;
-	}
-	return 0;
-}
-
-static int
-find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
-{
-	struct xt_match *match;
-	int ret;
-
-	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
-	        m->u.user.revision);
-	if (IS_ERR(match)) {
-		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
-		return PTR_ERR(match);
-	}
-	m->u.kernel.match = match;
-
-	ret = check_match(m, par);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	module_put(m->u.kernel.match->me);
-	return ret;
-}
-
-static int check_target(struct ipt_entry *e, const char *name)
-{
-	struct ipt_entry_target *t = ipt_get_target(e);
-	struct xt_tgchk_param par = {
-		.table     = name,
-		.entryinfo = e,
-		.nfproto_info = &e->ip,
-		.target    = t->u.kernel.target,
-		.targinfo  = t->data,
-		.hook_mask = e->comefrom,
-		.family    = NFPROTO_IPV4,
-	};
-	int ret;
-
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO, true);
-	if (ret < 0) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
-		return ret;
-	}
-	return 0;
-}
-
-static int
-find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
-{
-	struct ipt_entry_target *t;
-	struct xt_target *target;
-	int ret;
-	unsigned int j;
-	struct xt_mtchk_param mtpar;
-	struct xt_entry_match *ematch;
-
-	mtpar.table     = name;
-	mtpar.entryinfo = &e->ip;
-	mtpar.hook_mask = e->comefrom;
-	mtpar.family    = NFPROTO_IPV4;
-	ret = check_entry(e, &mtpar);
-	if (ret)
-		return ret;
-	j = 0;
-	xt_ematch_foreach(ematch, e) {
-		ret = find_check_match(ematch, &mtpar);
-		if (ret != 0)
-			goto cleanup_matches;
-		++j;
-	}
-
-	t = ipt_get_target(e);
-	target = xt_request_find_target(NFPROTO_IPV4, t->u.user.name,
-	         t->u.user.revision);
-	if (IS_ERR(target)) {
-		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = PTR_ERR(target);
-		goto cleanup_matches;
-	}
-	t->u.kernel.target = target;
-
-	ret = check_target(e, name);
-	if (ret)
-		goto err;
-	return 0;
- err:
-	module_put(t->u.kernel.target->me);
- cleanup_matches:
-	xt_ematch_foreach(ematch, e) {
-		if (j-- == 0)
-			break;
-		cleanup_match(ematch);
-	}
-	return ret;
-}
-
-static bool check_underflow(const struct ipt_entry *e)
-{
-	const struct ipt_entry_target *t;
-	unsigned int verdict;
-
-	if (!unconditional(&e->ip))
-		return false;
-	t = ipt_get_target_c(e);
-	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
-		return false;
-	verdict = ((struct ipt_standard_target *)t)->verdict;
-	verdict = -verdict - 1;
-	return verdict == NF_DROP || verdict == NF_ACCEPT;
-}
-
-static int
-check_entry_size_and_hooks(struct ipt_entry *e,
-			   struct xt_table_info *newinfo,
-			   const unsigned char *base,
-			   const unsigned char *limit,
-			   const unsigned int *hook_entries,
-			   const unsigned int *underflows,
-			   unsigned int valid_hooks)
-{
-	unsigned int h;
-
-	if ((unsigned long)e % __alignof__(struct ipt_entry) != 0
-	    || (unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
-		duprintf("Bad offset %p\n", e);
-		return -EINVAL;
-	}
-
-	if (e->next_offset
-	    < sizeof(struct ipt_entry) + sizeof(struct ipt_entry_target)) {
-		duprintf("checking: element %p size %u\n",
-			 e, e->next_offset);
-		return -EINVAL;
-	}
-
-	/* Check hooks & underflows */
-	for (h = 0; h < NF_INET_NUMHOOKS; h++) {
-		if (!(valid_hooks & (1 << h)))
-			continue;
-		if ((unsigned char *)e - base == hook_entries[h])
-			newinfo->hook_entry[h] = hook_entries[h];
-		if ((unsigned char *)e - base == underflows[h]) {
-			if (!check_underflow(e)) {
-				pr_err("Underflows must be unconditional and "
-				       "use the STANDARD target with "
-				       "ACCEPT/DROP\n");
-				return -EINVAL;
-			}
-			newinfo->underflow[h] = underflows[h];
-		}
-	}
-
-	/* Clear counters and comefrom */
-	e->counters = ((struct xt_counters) { 0, 0 });
-	e->comefrom = 0;
-	return 0;
-}
-
-static void
-cleanup_entry(struct ipt_entry *e)
-{
-	struct xt_tgdtor_param par;
-	struct ipt_entry_target *t;
-	struct xt_entry_match *ematch;
-
-	/* Cleanup all matches */
-	xt_ematch_foreach(ematch, e)
-		cleanup_match(ematch);
-	t = ipt_get_target(e);
-
-	par.target   = t->u.kernel.target;
-	par.targinfo = t->data;
-	par.family   = NFPROTO_IPV4;
-	if (par.target->destroy != NULL)
-		par.target->destroy(&par);
-	module_put(par.target->me);
-}
-
-/* Checks and translates the user-supplied table segment (held in
-   newinfo) */
-static int
-translate_table(struct xt_table_info *newinfo, void *entry0,
-                const struct ipt_replace *repl)
-{
-	struct ipt_entry *iter;
-	unsigned int i;
-	int ret = 0;
-
-	newinfo->size = repl->size;
-	newinfo->number = repl->num_entries;
-
-	/* Init all hooks to impossible value. */
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		newinfo->hook_entry[i] = 0xFFFFFFFF;
-		newinfo->underflow[i] = 0xFFFFFFFF;
-	}
-
-	duprintf("translate_table: size %u\n", newinfo->size);
-	i = 0;
-	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + repl->size, repl->hook_entry, repl->underflow,
-		      repl->valid_hooks);
-		if (ret != 0)
-			return ret;
-		++i;
-		if (strcmp(ipt_get_target(iter)->u.user.name,
-		    XT_ERROR_TARGET) == 0)
-			++newinfo->stacksize;
-	}
-
-	if (i != repl->num_entries) {
-		duprintf("translate_table: %u not %u entries\n",
-			 i, repl->num_entries);
-		return -EINVAL;
-	}
-
-	/* Check hooks all assigned */
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		/* Only hooks which are valid */
-		if (!(repl->valid_hooks & (1 << i)))
-			continue;
-		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
-			duprintf("Invalid hook entry %u %u\n",
-				 i, repl->hook_entry[i]);
-			return -EINVAL;
-		}
-		if (newinfo->underflow[i] == 0xFFFFFFFF) {
-			duprintf("Invalid underflow %u %u\n",
-				 i, repl->underflow[i]);
-			return -EINVAL;
-		}
-	}
-
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
-		return -ELOOP;
-
-	/* Finally, each sanity check must pass */
-	i = 0;
-	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, repl->name, repl->size);
-		if (ret != 0)
-			break;
-		++i;
-	}
-
-	if (ret != 0) {
-		xt_entry_foreach(iter, entry0, newinfo->size) {
-			if (i-- == 0)
-				break;
-			cleanup_entry(iter);
-		}
-		return ret;
-	}
-
-	/* And one copy for every other CPU */
-	for_each_possible_cpu(i) {
-		if (newinfo->entries[i] && newinfo->entries[i] != entry0)
-			memcpy(newinfo->entries[i], entry0, newinfo->size);
-	}
-
-	return ret;
-}
-
 static const struct xt1_xlat_info ipt_compat_xlat_info = {
 #ifdef CONFIG_COMPAT
 	.marker_size     = XT_ALIGN(sizeof(struct ipt_error_target)),
@@ -1311,62 +878,6 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ipt_register_table(struct net *net,
-				    const struct xt_table *table,
-				    const struct ipt_replace *repl)
-{
-	int ret;
-	struct xt_table_info *newinfo;
-	struct xt_table_info bootstrap = {};
-	void *loc_cpu_entry;
-	struct xt_table *new_table;
-
-	newinfo = xt_alloc_table_info(repl->size);
-	if (!newinfo) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* choose the copy on our node/cpu, but dont care about preemption */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
-	memcpy(loc_cpu_entry, repl->entries, repl->size);
-
-	ret = translate_table(newinfo, loc_cpu_entry, repl);
-	if (ret != 0)
-		goto out_free;
-
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
-	if (IS_ERR(new_table)) {
-		ret = PTR_ERR(new_table);
-		goto out_free;
-	}
-
-	return new_table;
-
-out_free:
-	xt_free_table_info(newinfo);
-out:
-	return ERR_PTR(ret);
-}
-
-void ipt_unregister_table(struct xt_table *table)
-{
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
-	struct module *table_owner = table->me;
-	struct ipt_entry *iter;
-
-	private = xt_unregister_table(table);
-
-	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter);
-	if (private->number > private->initial_entries)
-		module_put(table_owner);
-	xt_free_table_info(private);
-}
-
 static struct nf_sockopt_ops ipt_sockopts = {
 	.pf		= PF_INET,
 	.set_optmin	= IPT_BASE_CTL,
@@ -1442,8 +953,6 @@ static void __exit ip_tables_fini(void)
 	unregister_pernet_subsys(&ip_tables_net_ops);
 }
 
-EXPORT_SYMBOL(ipt_register_table);
-EXPORT_SYMBOL(ipt_unregister_table);
 EXPORT_SYMBOL(ipt_do_table);
 module_init(ip_tables_init);
 module_exit(ip_tables_fini);
-- 
1.6.3.3

