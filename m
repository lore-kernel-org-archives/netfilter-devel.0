From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 081/103] netfilter: ip6tables: remove obsolete packet tracing
Date: Tue,  4 Aug 2009 09:26:05 +0200
Message-ID: <1249370787-17583-82-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbZHDH2A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:00 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Packet tracking is now done by xt2_trace_packet.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |  103 ---------------------------------------
 1 files changed, 0 insertions(+), 103 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 53186a2..67f676f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -333,102 +333,6 @@ ip6t_get_target_c(const struct ip6t_entry *e)
 	return ip6t_get_target((struct ip6t_entry *)e);
 }
 
-#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
-    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
-/* This cries for unification! */
-static const char *const hooknames[] = {
-	[NF_INET_PRE_ROUTING]		= "PREROUTING",
-	[NF_INET_LOCAL_IN]		= "INPUT",
-	[NF_INET_FORWARD]		= "FORWARD",
-	[NF_INET_LOCAL_OUT]		= "OUTPUT",
-	[NF_INET_POST_ROUTING]		= "POSTROUTING",
-};
-
-enum nf_ip_trace_comments {
-	NF_IP6_TRACE_COMMENT_RULE,
-	NF_IP6_TRACE_COMMENT_RETURN,
-	NF_IP6_TRACE_COMMENT_POLICY,
-};
-
-static const char *const comments[] = {
-	[NF_IP6_TRACE_COMMENT_RULE]	= "rule",
-	[NF_IP6_TRACE_COMMENT_RETURN]	= "return",
-	[NF_IP6_TRACE_COMMENT_POLICY]	= "policy",
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
-get_chainname_rulenum(const struct ip6t_entry *s, const struct ip6t_entry *e,
-		      const char *hookname, const char **chainname,
-		      const char **comment, unsigned int *rulenum)
-{
-	const struct ip6t_standard_target *t = (void *)ip6t_get_target_c(s);
-
-	if (strcmp(t->target.u.kernel.target->name, IP6T_ERROR_TARGET) == 0) {
-		/* Head of user chain: ERROR target with chainname */
-		*chainname = t->target.data;
-		(*rulenum) = 0;
-	} else if (s == e) {
-		(*rulenum)++;
-
-		if (s->target_offset == sizeof(struct ip6t_entry)
-		   && strcmp(t->target.u.kernel.target->name,
-			     IP6T_STANDARD_TARGET) == 0
-		   && t->verdict < 0
-		   && unconditional(&s->ipv6)) {
-			/* Tail of chains: STANDARD target (return/policy) */
-			*comment = *chainname == hookname
-				? comments[NF_IP6_TRACE_COMMENT_POLICY]
-				: comments[NF_IP6_TRACE_COMMENT_RETURN];
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
-			 const struct ip6t_entry *e)
-{
-	const void *table_base;
-	const struct ip6t_entry *root;
-	const char *hookname, *chainname, *comment;
-	const struct ip6t_entry *iter;
-	unsigned int rulenum = 0;
-
-	table_base = private->entries[smp_processor_id()];
-	root = get_entry(table_base, private->hook_entry[hook]);
-
-	hookname = chainname = hooknames[hook];
-	comment = comments[NF_IP6_TRACE_COMMENT_RULE];
-
-	xt_entry_foreach(iter, root, private->size - private->hook_entry[hook])
-		if (get_chainname_rulenum(iter, e, hookname,
-		    &chainname, &comment, &rulenum) != 0)
-			break;
-
-	nf_log_packet(AF_INET6, hook, skb, in, out, &trace_loginfo,
-		      "TRACE: %s:%s:%s:%u ",
-		      tablename, chainname, comment, rulenum);
-}
-#endif
-
 static inline __pure struct ip6t_entry *
 ip6t_next_entry(const struct ip6t_entry *entry)
 {
@@ -502,13 +406,6 @@ ip6t_do_table(struct sk_buff *skb,
 		t = ip6t_get_target_c(e);
 		IP_NF_ASSERT(t->u.kernel.target);
 
-#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
-    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
-		/* The packet is traced: log it */
-		if (unlikely(skb->nf_trace))
-			trace_packet(skb, hook, in, out,
-				     table->name, private, e);
-#endif
 		/* Standard target? */
 		if (!t->u.kernel.target->target) {
 			int v;
-- 
1.6.3.3

