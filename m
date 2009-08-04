From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 089/103] netfilter: ip6tables: remove remaining xt1 code
Date: Tue,  4 Aug 2009 09:26:13 +0200
Message-ID: <1249370787-17583-90-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbZHDH2J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:09 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv6/ip6_tables.h |   19 ---
 net/ipv6/netfilter/ip6_tables.c           |  223 -----------------------------
 2 files changed, 0 insertions(+), 242 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 63d5745..9f2f76a 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -304,15 +304,6 @@ ip6t_get_target(struct ip6t_entry *e)
 
 #ifdef __KERNEL__
 
-#include <linux/init.h>
-extern void ip6t_init(void) __init;
-
-extern unsigned int ip6t_do_table(struct sk_buff *skb,
-				  unsigned int hook,
-				  const struct net_device *in,
-				  const struct net_device *out,
-				  struct xt_table *table);
-
 extern struct xt2_table *ip6t2_register_table(struct net *,
 	const struct xt_table *, const struct ip6t_replace *);
 
@@ -326,8 +317,6 @@ extern int ip6_masked_addrcmp(const struct in6_addr *addr1,
 			      const struct in6_addr *mask,
 			      const struct in6_addr *addr2);
 
-#define IP6T_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -354,14 +343,6 @@ struct compat_ip6t_replace {
 	struct compat_ip6t_entry entries[0];
 };
 
-static inline struct ip6t_entry_target *
-compat_ip6t_get_target(struct compat_ip6t_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-
-#define COMPAT_IP6T_ALIGN(s)	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a1c684b..dd242ad 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -50,23 +50,6 @@ MODULE_DESCRIPTION("IPv6 packet filter");
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
 #define xtsub_entry           ip6t_entry
 #define xtsub_entry_nocompat  ip6t_entry
 #define xtsub_replace         ip6t_replace
@@ -244,55 +227,6 @@ static bool icmp6_checkentry(const struct xt_mtchk_param *par)
 	return !(icmpinfo->invflags & ~IP6T_ICMP_INV);
 }
 
-#ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(AF_INET6, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(AF_INET6, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-#endif
-
-static unsigned int
-ip6t_error(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	if (net_ratelimit())
-		printk("ip6_tables: error: `%s'\n",
-		       (const char *)par->targinfo);
-
-	return NF_DROP;
-}
-
-static struct xt_target ip6t_builtin_tg[] __read_mostly = {
-	{
-		.name             = IP6T_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_IPV6,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = IP6T_ERROR_TARGET,
-		.target           = ip6t_error,
-		.targetsize       = IP6T_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_IPV6,
-	},
-};
-
 static struct xt_match ip6t_builtin_mt[] __read_mostly = {
 	{
 		.name       = "ipv6",
@@ -312,156 +246,6 @@ static struct xt_match ip6t_builtin_mt[] __read_mostly = {
 	},
 };
 
-static inline struct ip6t_entry *
-get_entry(const void *base, unsigned int offset)
-{
-	return (struct ip6t_entry *)(base + offset);
-}
-
-/* All zeroes == unconditional rule. */
-/* Mildly perf critical (only if packet tracing is on) */
-static inline bool unconditional(const struct ip6t_ip6 *ipv6)
-{
-	static const struct ip6t_ip6 uncond;
-
-	return memcmp(ipv6, &uncond, sizeof(uncond)) == 0;
-}
-
-static inline const struct ip6t_entry_target *
-ip6t_get_target_c(const struct ip6t_entry *e)
-{
-	return ip6t_get_target((struct ip6t_entry *)e);
-}
-
-static inline __pure struct ip6t_entry *
-ip6t_next_entry(const struct ip6t_entry *entry)
-{
-	return (void *)entry + entry->next_offset;
-}
-
-/* Returns one of the generic firewall policies, like NF_ACCEPT. */
-unsigned int
-ip6t_do_table(struct sk_buff *skb,
-	      unsigned int hook,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      struct xt_table *table)
-{
-	/* Initializing verdict to NF_DROP keeps gcc happy. */
-	unsigned int verdict = NF_DROP;
-	const void *table_base;
-	struct ip6t_entry *e, **jumpstack;
-	unsigned int *stackptr, origptr, cpu;
-	const struct xt_table_info *private;
-	struct xt_action_param acpar;
-
-	/* We handle fragments by dealing with the first fragment as
-	 * if it was a normal packet.  All other fragments are treated
-	 * normally, except that they will NEVER match rules that ask
-	 * things we don't know, ie. tcp syn flag or ports).  If the
-	 * rule is also a fragment-specific rule, non-fragments won't
-	 * match it. */
-	acpar.hotdrop = false;
-	acpar.in      = in;
-	acpar.out     = out;
-	acpar.family  = NFPROTO_IPV6;
-	acpar.hooknum = hook;
-
-	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-
-	xt_info_rdlock_bh();
-	private = table->private;
-	cpu        = smp_processor_id();
-	table_base = private->entries[cpu];
-	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
-	stackptr   = &private->stackptr[cpu];
-	origptr    = *stackptr;
-
-	e = get_entry(table_base, private->hook_entry[hook]);
-
-	do {
-		const struct ip6t_entry_target *t;
-		const struct xt_entry_match *ematch;
-
-		IP_NF_ASSERT(e);
-		acpar.match     = &ip6t_builtin_mt[0];
-		acpar.matchinfo = &e->ipv6;
-		if (!ip6_packet_match(skb, &acpar)) {
- no_match:
-			e = ip6t_next_entry(e);
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
-		ADD_COUNTER(e->counters,
-			    ntohs(ipv6_hdr(skb)->payload_len) +
-			    sizeof(struct ipv6hdr), 1);
-
-		t = ip6t_get_target_c(e);
-		IP_NF_ASSERT(t->u.kernel.target);
-
-		/* Standard target? */
-		if (!t->u.kernel.target->target) {
-			int v;
-
-			v = ((struct ip6t_standard_target *)t)->verdict;
-			if (v < 0) {
-				/* Pop from stack? */
-				if (v != IP6T_RETURN) {
-					verdict = (unsigned)(-v) - 1;
-					break;
-				}
-				if (*stackptr == 0)
-					e = get_entry(table_base,
-					    private->underflow[hook]);
-				else
-					e = ip6t_next_entry(jumpstack[--*stackptr]);
-				continue;
-			}
-			if (table_base + v != ip6t_next_entry(e)
-			    && !(e->ipv6.flags & IP6T_F_GOTO)) {
-				if (*stackptr >= private->stacksize) {
-					verdict = NF_DROP;
-					break;
-				}
-				jumpstack[(*stackptr)++] = e;
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
-		if (verdict == IP6T_CONTINUE)
-			e = ip6t_next_entry(e);
-		else
-			/* Verdict */
-			break;
-	} while (!acpar.hotdrop);
-
-	xt_info_rdunlock_bh();
-	*stackptr = origptr;
-
-#ifdef DEBUG_ALLOW_ALL
-	return NF_ACCEPT;
-#else
-	if (acpar.hotdrop)
-		return NF_DROP;
-	else return verdict;
-#endif
-}
-
 static const struct xt1_xlat_info ip6t_compat_xlat_info = {
 #ifdef CONFIG_COMPAT
 	.marker_size     = COMPAT_XT_ALIGN(sizeof(struct ip6t_error_target)),
@@ -812,9 +596,6 @@ static int __init ip6_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
-	if (ret < 0)
-		goto err2;
 	ret = xt_register_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 	if (ret < 0)
 		goto err4;
@@ -830,8 +611,6 @@ static int __init ip6_tables_init(void)
 err5:
 	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 err4:
-	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
-err2:
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 err1:
 	return ret;
@@ -842,7 +621,6 @@ static void __exit ip6_tables_fini(void)
 	nf_unregister_sockopt(&ip6t_sockopts);
 
 	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
-	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 }
 
@@ -936,7 +714,6 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 	return nexthdr;
 }
 
-EXPORT_SYMBOL(ip6t_do_table);
 EXPORT_SYMBOL(ip6t_ext_hdr);
 EXPORT_SYMBOL(ipv6_find_hdr);
 
-- 
1.6.3.3

