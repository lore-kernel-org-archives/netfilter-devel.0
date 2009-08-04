From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 094/103] netfilter: iptables: remove remaining xt1 code
Date: Tue,  4 Aug 2009 09:26:18 +0200
Message-ID: <1249370787-17583-95-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56961 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbZHDH2O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:14 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv4/ip_tables.h |   17 --
 net/ipv4/netfilter/ip_tables.c           |  344 ------------------------------
 2 files changed, 0 insertions(+), 361 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 73a8f55..fdc7e4e 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -290,14 +290,6 @@ struct ipt_error
 	.target.errorname = "ERROR",					       \
 }
 
-extern unsigned int ipt_do_table(struct sk_buff *skb,
-				 unsigned int hook,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 struct xt_table *table);
-
-#define IPT_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -324,15 +316,6 @@ struct compat_ipt_replace {
 	struct compat_ipt_entry	entries[0];
 };
 
-/* Helper functions */
-static inline struct ipt_entry_target *
-compat_ipt_get_target(struct compat_ipt_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-
-#define COMPAT_IPT_ALIGN(s) 	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index ed3056b..c58b5a1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -49,23 +49,6 @@ MODULE_DESCRIPTION("IPv4 packet filter");
 #define duprintf(format, args...)
 #endif
 
-#ifdef CONFIG_NETFILTER_DEBUG
-#define IP_NF_ASSERT(x)						\
-do {								\
-	if (!(x))						\
-		printk("IP_NF_ASSERT: %s:%s:%u\n",		\
-		       __func__, __FILE__, __LINE__);	\
-} while(0)
-#else
-#define IP_NF_ASSERT(x)
-#endif
-
-#if 0
-/* All the better to debug you with... */
-#define static
-#define inline
-#endif
-
 #define xtsub_entry           ipt_entry
 #define xtsub_entry_nocompat  ipt_entry
 #define xtsub_replace         ipt_replace
@@ -228,55 +211,6 @@ static bool icmp_checkentry(const struct xt_mtchk_param *par)
 	return !(icmpinfo->invflags & ~IPT_ICMP_INV);
 }
 
-#ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(AF_INET, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(AF_INET, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-#endif
-
-static unsigned int
-ipt_error(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	if (net_ratelimit())
-		printk("ip_tables: error: `%s'\n",
-		       (const char *)par->targinfo);
-
-	return NF_DROP;
-}
-
-static struct xt_target ipt_builtin_tg[] __read_mostly = {
-	{
-		.name             = IPT_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_IPV4,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = IPT_ERROR_TARGET,
-		.target           = ipt_error,
-		.targetsize       = IPT_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_IPV4,
-	},
-};
-
 static struct xt_match ipt_builtin_mt[] __read_mostly = {
 	{
 		.name       = "ipv4",
@@ -296,277 +230,6 @@ static struct xt_match ipt_builtin_mt[] __read_mostly = {
 	},
 };
 
-/* Performance critical */
-static inline struct ipt_entry *
-get_entry(const void *base, unsigned int offset)
-{
-	return (struct ipt_entry *)(base + offset);
-}
-
-/* All zeroes == unconditional rule. */
-/* Mildly perf critical (only if packet tracing is on) */
-static inline bool unconditional(const struct ipt_ip *ip)
-{
-	static const struct ipt_ip uncond;
-
-	return memcmp(ip, &uncond, sizeof(uncond)) == 0;
-#undef FWINV
-}
-
-/* for const-correctness */
-static inline const struct ipt_entry_target *
-ipt_get_target_c(const struct ipt_entry *e)
-{
-	return ipt_get_target((struct ipt_entry *)e);
-}
-
-#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
-    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
-static const char *const hooknames[] = {
-	[NF_INET_PRE_ROUTING]		= "PREROUTING",
-	[NF_INET_LOCAL_IN]		= "INPUT",
-	[NF_INET_FORWARD]		= "FORWARD",
-	[NF_INET_LOCAL_OUT]		= "OUTPUT",
-	[NF_INET_POST_ROUTING]		= "POSTROUTING",
-};
-
-enum nf_ip_trace_comments {
-	NF_IP_TRACE_COMMENT_RULE,
-	NF_IP_TRACE_COMMENT_RETURN,
-	NF_IP_TRACE_COMMENT_POLICY,
-};
-
-static const char *const comments[] = {
-	[NF_IP_TRACE_COMMENT_RULE]	= "rule",
-	[NF_IP_TRACE_COMMENT_RETURN]	= "return",
-	[NF_IP_TRACE_COMMENT_POLICY]	= "policy",
-};
-
-static struct nf_loginfo trace_loginfo = {
-	.type = NF_LOG_TYPE_LOG,
-	.u = {
-		.log = {
-			.level = 4,
-			.logflags = NF_LOG_MASK,
-		},
-	},
-};
-
-/* Mildly perf critical (only if packet tracing is on) */
-static inline int
-get_chainname_rulenum(const struct ipt_entry *s, const struct ipt_entry *e,
-		      const char *hookname, const char **chainname,
-		      const char **comment, unsigned int *rulenum)
-{
-	const struct ipt_standard_target *t = (void *)ipt_get_target_c(s);
-
-	if (strcmp(t->target.u.kernel.target->name, IPT_ERROR_TARGET) == 0) {
-		/* Head of user chain: ERROR target with chainname */
-		*chainname = t->target.data;
-		(*rulenum) = 0;
-	} else if (s == e) {
-		(*rulenum)++;
-
-		if (s->target_offset == sizeof(struct ipt_entry)
-		   && strcmp(t->target.u.kernel.target->name,
-			     IPT_STANDARD_TARGET) == 0
-		   && t->verdict < 0
-		   && unconditional(&s->ip)) {
-			/* Tail of chains: STANDARD target (return/policy) */
-			*comment = *chainname == hookname
-				? comments[NF_IP_TRACE_COMMENT_POLICY]
-				: comments[NF_IP_TRACE_COMMENT_RETURN];
-		}
-		return 1;
-	} else
-		(*rulenum)++;
-
-	return 0;
-}
-
-static void trace_packet(const struct sk_buff *skb,
-			 unsigned int hook,
-			 const struct net_device *in,
-			 const struct net_device *out,
-			 const char *tablename,
-			 const struct xt_table_info *private,
-			 const struct ipt_entry *e)
-{
-	const void *table_base;
-	const struct ipt_entry *root;
-	const char *hookname, *chainname, *comment;
-	const struct ipt_entry *iter;
-	unsigned int rulenum = 0;
-
-	table_base = private->entries[smp_processor_id()];
-	root = get_entry(table_base, private->hook_entry[hook]);
-
-	hookname = chainname = hooknames[hook];
-	comment = comments[NF_IP_TRACE_COMMENT_RULE];
-
-	xt_entry_foreach(iter, root, private->size - private->hook_entry[hook])
-		if (get_chainname_rulenum(iter, e, hookname,
-		    &chainname, &comment, &rulenum) != 0)
-			break;
-
-	nf_log_packet(AF_INET, hook, skb, in, out, &trace_loginfo,
-		      "TRACE: %s:%s:%s:%u ",
-		      tablename, chainname, comment, rulenum);
-}
-#endif
-
-static inline __pure
-struct ipt_entry *ipt_next_entry(const struct ipt_entry *entry)
-{
-	return (void *)entry + entry->next_offset;
-}
-
-/* Returns one of the generic firewall policies, like NF_ACCEPT. */
-unsigned int
-ipt_do_table(struct sk_buff *skb,
-	     unsigned int hook,
-	     const struct net_device *in,
-	     const struct net_device *out,
-	     struct xt_table *table)
-{
-	const struct iphdr *ip;
-	/* Initializing verdict to NF_DROP keeps gcc happy. */
-	unsigned int verdict = NF_DROP;
-	const void *table_base;
-	struct ipt_entry *e, **jumpstack;
-	unsigned int *stackptr, origptr, cpu;
-	const struct xt_table_info *private;
-	struct xt_action_param acpar;
-
-	/* Initialization */
-	ip = ip_hdr(skb);
-	/* We handle fragments by dealing with the first fragment as
-	 * if it was a normal packet.  All other fragments are treated
-	 * normally, except that they will NEVER match rules that ask
-	 * things we don't know, ie. tcp syn flag or ports).  If the
-	 * rule is also a fragment-specific rule, non-fragments won't
-	 * match it. */
-	acpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
-	acpar.thoff   = ip_hdrlen(skb);
-	acpar.hotdrop = false;
-	acpar.in      = in;
-	acpar.out     = out;
-	acpar.family  = NFPROTO_IPV4;
-	acpar.hooknum = hook;
-
-	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	xt_info_rdlock_bh();
-	private = table->private;
-	cpu        = smp_processor_id();
-	table_base = private->entries[cpu];
-	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
-	stackptr   = &private->stackptr[cpu];
-	origptr    = *stackptr;
-
-	e = get_entry(table_base, private->hook_entry[hook]);
-
-	pr_devel("Entering %s(hook %u); sp at %u (UF %p)\n", table->name,
-	         hook, origptr,
-	         get_entry(table_base, private->underflow[hook]));
-
-	do {
-		const struct ipt_entry_target *t;
-		const struct xt_entry_match *ematch;
-
-		IP_NF_ASSERT(e);
-		acpar.match     = &ipt_builtin_mt[0]; /* "ipv4" itself */
-		acpar.matchinfo = &e->ip;
-		if (!ip_packet_match(skb, &acpar)) {
- no_match:
-			e = ipt_next_entry(e);
-			continue;
-		}
-
-		xt_ematch_foreach(ematch, e) {
-			acpar.match     = ematch->u.kernel.match;
-			acpar.matchinfo = ematch->data;
-			if (!acpar.match->match(skb, &acpar))
-				goto no_match;
-		}
-
-		ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
-
-		t = ipt_get_target(e);
-		IP_NF_ASSERT(t->u.kernel.target);
-
-#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
-    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
-		/* The packet is traced: log it */
-		if (unlikely(skb->nf_trace))
-			trace_packet(skb, hook, in, out,
-				     table->name, private, e);
-#endif
-		/* Standard target? */
-		if (!t->u.kernel.target->target) {
-			int v;
-
-			v = ((struct ipt_standard_target *)t)->verdict;
-			if (v < 0) {
-				/* Pop from stack? */
-				if (v != IPT_RETURN) {
-					verdict = (unsigned)(-v) - 1;
-					break;
-				}
-				if (*stackptr == 0) {
-					e = get_entry(table_base,
-					    private->underflow[hook]);
-					pr_devel("Underflow (this is normal) "
-					         "to %p\n", e);
-				} else {
-					e = jumpstack[--*stackptr];
-					pr_devel("Pulled %p out from pos %u\n",
-					         e, *stackptr);
-					e = ipt_next_entry(e);
-				}
-				continue;
-			}
-			if (table_base + v != ipt_next_entry(e)
-			    && !(e->ip.flags & IPT_F_GOTO)) {
-				if (*stackptr >= private->stacksize) {
-					verdict = NF_DROP;
-					break;
-				}
-				jumpstack[(*stackptr)++] = e;
-				pr_devel("Pushed %p into pos %u\n",
-				         e, *stackptr - 1);
-			}
-
-			e = get_entry(table_base, v);
-			continue;
-		}
-
-		/* Targets which reenter must return
-		   abs. verdicts */
-		acpar.target   = t->u.kernel.target;
-		acpar.targinfo = t->data;
-
-		verdict = t->u.kernel.target->target(skb, &acpar);
-		/* Target might have changed stuff. */
-		ip = ip_hdr(skb);
-		if (verdict == IPT_CONTINUE)
-			e = ipt_next_entry(e);
-		else
-			/* Verdict */
-			break;
-	} while (!acpar.hotdrop);
-	xt_info_rdunlock_bh();
-	pr_devel("Exiting %s; resetting sp from %u to %u\n",
-	         __func__, *stackptr, origptr);
-	*stackptr = origptr;
-#ifdef DEBUG_ALLOW_ALL
-	return NF_ACCEPT;
-#else
-	if (acpar.hotdrop)
-		return NF_DROP;
-	else return verdict;
-#endif
-}
-
 static const struct xt1_xlat_info ipt_compat_xlat_info = {
 #ifdef CONFIG_COMPAT
 	.marker_size     = XT_ALIGN(sizeof(struct ipt_error_target)),
@@ -919,9 +582,6 @@ static int __init ip_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
-	if (ret < 0)
-		goto err2;
 	ret = xt_register_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 	if (ret < 0)
 		goto err4;
@@ -937,8 +597,6 @@ static int __init ip_tables_init(void)
 err5:
 	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 err4:
-	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
-err2:
 	unregister_pernet_subsys(&ip_tables_net_ops);
 err1:
 	return ret;
@@ -949,10 +607,8 @@ static void __exit ip_tables_fini(void)
 	nf_unregister_sockopt(&ipt_sockopts);
 
 	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
-	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 	unregister_pernet_subsys(&ip_tables_net_ops);
 }
 
-EXPORT_SYMBOL(ipt_do_table);
 module_init(ip_tables_init);
 module_exit(ip_tables_fini);
-- 
1.6.3.3

