From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 100/103] netfilter: arptables: remove remaining xt1 code
Date: Tue,  4 Aug 2009 09:26:24 +0200
Message-ID: <1249370787-17583-101-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56966 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbZHDH2V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:21 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_arp/arp_tables.h |   16 ---
 net/ipv4/netfilter/arp_tables.c          |  191 ------------------------------
 2 files changed, 0 insertions(+), 207 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index b480fa6..6d896ff 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -266,17 +266,9 @@ struct arpt_error
 	.target.errorname = "ERROR",					       \
 }
 
-extern unsigned int arpt_do_table(struct sk_buff *skb,
-				  unsigned int hook,
-				  const struct net_device *in,
-				  const struct net_device *out,
-				  struct xt_table *table);
-
 extern struct xt2_table *arpt2_register_table(struct net *,
 	const struct xt_table *, const struct arpt_replace *);
 
-#define ARPT_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -302,14 +294,6 @@ struct compat_arpt_replace {
 	struct compat_arpt_entry	entries[0];
 };
 
-static inline struct arpt_entry_target *
-compat_arpt_get_target(struct compat_arpt_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-
-#define COMPAT_ARPT_ALIGN(s)	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b82a831..200dcb6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -47,17 +47,6 @@ MODULE_DESCRIPTION("arptables core");
 #define duprintf(format, args...)
 #endif
 
-#ifdef CONFIG_NETFILTER_DEBUG
-#define ARP_NF_ASSERT(x)					\
-do {								\
-	if (!(x))						\
-		printk("ARP_NF_ASSERT: %s:%s:%u\n",		\
-		       __func__, __FILE__, __LINE__);	\
-} while(0)
-#else
-#define ARP_NF_ASSERT(x)
-#endif
-
 #define xtsub_entry           arpt_entry
 #define xtsub_entry_nocompat  arpt_entry
 #define xtsub_replace         arpt_replace
@@ -241,55 +230,6 @@ static bool arp_checkentry(const struct xt_mtchk_param *par)
 	return true;
 }
 
-#ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(NFPROTO_ARP, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(NFPROTO_ARP, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-#endif
-
-static unsigned int
-arpt_error(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	if (net_ratelimit())
-		printk("arp_tables: error: '%s'\n",
-		       (const char *)par->targinfo);
-
-	return NF_DROP;
-}
-
-static struct xt_target arpt_builtin_tg[] __read_mostly = {
-	{
-		.name             = ARPT_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_ARP,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = ARPT_ERROR_TARGET,
-		.target           = arpt_error,
-		.targetsize       = ARPT_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_ARP,
-	},
-};
-
 static struct xt_match arpt_builtin_mt __read_mostly = {
 	.name       = "arp",
 	.revision   = 0,
@@ -299,129 +239,6 @@ static struct xt_match arpt_builtin_mt __read_mostly = {
 	.checkentry = arp_checkentry,
 };
 
-static inline const struct arpt_entry_target *
-arpt_get_target_c(const struct arpt_entry *e)
-{
-	return arpt_get_target((struct arpt_entry *)e);
-}
-
-static inline struct arpt_entry *
-get_entry(const void *base, unsigned int offset)
-{
-	return (struct arpt_entry *)(base + offset);
-}
-
-static inline __pure
-struct arpt_entry *arpt_next_entry(const struct arpt_entry *entry)
-{
-	return (void *)entry + entry->next_offset;
-}
-
-unsigned int arpt_do_table(struct sk_buff *skb,
-			   unsigned int hook,
-			   const struct net_device *in,
-			   const struct net_device *out,
-			   struct xt_table *table)
-{
-	unsigned int verdict = NF_DROP;
-	const struct arphdr *arp;
-	struct arpt_entry *e, *back;
-	void *table_base;
-	const struct xt_table_info *private;
-	struct xt_action_param acpar;
-
-	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
-		return NF_DROP;
-
-	xt_info_rdlock_bh();
-	private = table->private;
-	table_base = private->entries[smp_processor_id()];
-
-	e = get_entry(table_base, private->hook_entry[hook]);
-	back = get_entry(table_base, private->underflow[hook]);
-
-	acpar.in      = in;
-	acpar.out     = out;
-	acpar.hooknum = hook;
-	acpar.family  = NFPROTO_ARP;
-	acpar.hotdrop = false;
-
-	/*
-	 * For arptables, do these two outside the loop because arp_tables
-	 * does not support other matches anyway.
-	 */
-	acpar.match     = &arpt_builtin_mt;
-	acpar.matchinfo = &e->arp;
-
-	arp = arp_hdr(skb);
-	do {
-		const struct arpt_entry_target *t;
-		int hdr_len;
-
-		if (!arp_packet_match(skb, &acpar)) {
-			e = arpt_next_entry(e);
-			continue;
-		}
-
-		hdr_len = sizeof(*arp) + (2 * sizeof(struct in_addr)) +
-			(2 * skb->dev->addr_len);
-		ADD_COUNTER(e->counters, hdr_len, 1);
-
-		t = arpt_get_target_c(e);
-
-		/* Standard target? */
-		if (!t->u.kernel.target->target) {
-			int v;
-
-			v = ((struct arpt_standard_target *)t)->verdict;
-			if (v < 0) {
-				/* Pop from stack? */
-				if (v != ARPT_RETURN) {
-					verdict = (unsigned)(-v) - 1;
-					break;
-				}
-				e = back;
-				back = get_entry(table_base, back->comefrom);
-				continue;
-			}
-			if (table_base + v
-			    != arpt_next_entry(e)) {
-				/* Save old back ptr in next entry */
-				struct arpt_entry *next = arpt_next_entry(e);
-				next->comefrom = (void *)back - table_base;
-
-				/* set back pointer to next entry */
-				back = next;
-			}
-
-			e = get_entry(table_base, v);
-			continue;
-		}
-
-		/* Targets which reenter must return
-		 * abs. verdicts
-		 */
-		acpar.target   = t->u.kernel.target;
-		acpar.targinfo = t->data;
-		verdict = t->u.kernel.target->target(skb, &acpar);
-
-		/* Target might have changed stuff. */
-		arp = arp_hdr(skb);
-
-		if (verdict == ARPT_CONTINUE)
-			e = arpt_next_entry(e);
-		else
-			/* Verdict */
-			break;
-	} while (!acpar.hotdrop);
-	xt_info_rdunlock_bh();
-
-	if (acpar.hotdrop)
-		return NF_DROP;
-	else
-		return verdict;
-}
-
 static const struct xt1_xlat_info arpt_compat_xlat_info = {
 #ifdef CONFIG_COMPAT
 	.marker_size     = XT_ALIGN(sizeof(struct arpt_error_target)),
@@ -757,9 +574,6 @@ static int __init arp_tables_init(void)
 		goto err1;
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	ret = xt_register_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
-	if (ret < 0)
-		goto err2;
 	ret = xt_register_match(&arpt_builtin_mt);
 	if (ret < 0)
 		goto err3;
@@ -775,8 +589,6 @@ static int __init arp_tables_init(void)
 err4:
 	xt_unregister_match(&arpt_builtin_mt);
 err3:
-	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
-err2:
 	unregister_pernet_subsys(&arp_tables_net_ops);
 err1:
 	return ret;
@@ -786,11 +598,8 @@ static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
 	xt_unregister_match(&arpt_builtin_mt);
-	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	unregister_pernet_subsys(&arp_tables_net_ops);
 }
 
-EXPORT_SYMBOL(arpt_do_table);
-
 module_init(arp_tables_init);
 module_exit(arp_tables_fini);
-- 
1.6.3.3

