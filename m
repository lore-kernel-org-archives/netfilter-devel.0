From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/11] netfilter: xtables: fix const inconsistency
Date: Fri,  8 May 2009 11:26:35 +0200
Message-ID: <1241774801-2315-6-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53356 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZEHJ0o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:44 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |   14 +++++++-------
 net/ipv6/netfilter/ip6_tables.c |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7fcbc16..16b7c09 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -238,8 +238,8 @@ static struct nf_loginfo trace_loginfo = {
 /* Mildly perf critical (only if packet tracing is on) */
 static inline int
 get_chainname_rulenum(struct ipt_entry *s, struct ipt_entry *e,
-		      char *hookname, char **chainname,
-		      char **comment, unsigned int *rulenum)
+		      const char *hookname, const char **chainname,
+		      const char **comment, unsigned int *rulenum)
 {
 	struct ipt_standard_target *t = (void *)ipt_get_target(s);
 
@@ -257,8 +257,8 @@ get_chainname_rulenum(struct ipt_entry *s, struct ipt_entry *e,
 		   && unconditional(&s->ip)) {
 			/* Tail of chains: STANDARD target (return/policy) */
 			*comment = *chainname == hookname
-				? (char *)comments[NF_IP_TRACE_COMMENT_POLICY]
-				: (char *)comments[NF_IP_TRACE_COMMENT_RETURN];
+				? comments[NF_IP_TRACE_COMMENT_POLICY]
+				: comments[NF_IP_TRACE_COMMENT_RETURN];
 		}
 		return 1;
 	} else
@@ -277,14 +277,14 @@ static void trace_packet(struct sk_buff *skb,
 {
 	void *table_base;
 	const struct ipt_entry *root;
-	char *hookname, *chainname, *comment;
+	const char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
 	table_base = private->entries[smp_processor_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
-	hookname = chainname = (char *)hooknames[hook];
-	comment = (char *)comments[NF_IP_TRACE_COMMENT_RULE];
+	hookname = chainname = hooknames[hook];
+	comment = comments[NF_IP_TRACE_COMMENT_RULE];
 
 	IPT_ENTRY_ITERATE(root,
 			  private->size - private->hook_entry[hook],
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2b52fac..4853a3d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -270,8 +270,8 @@ static struct nf_loginfo trace_loginfo = {
 /* Mildly perf critical (only if packet tracing is on) */
 static inline int
 get_chainname_rulenum(struct ip6t_entry *s, struct ip6t_entry *e,
-		      char *hookname, char **chainname,
-		      char **comment, unsigned int *rulenum)
+		      const char *hookname, const char **chainname,
+		      const char **comment, unsigned int *rulenum)
 {
 	struct ip6t_standard_target *t = (void *)ip6t_get_target(s);
 
@@ -289,8 +289,8 @@ get_chainname_rulenum(struct ip6t_entry *s, struct ip6t_entry *e,
 		   && unconditional(&s->ipv6)) {
 			/* Tail of chains: STANDARD target (return/policy) */
 			*comment = *chainname == hookname
-				? (char *)comments[NF_IP6_TRACE_COMMENT_POLICY]
-				: (char *)comments[NF_IP6_TRACE_COMMENT_RETURN];
+				? comments[NF_IP6_TRACE_COMMENT_POLICY]
+				: comments[NF_IP6_TRACE_COMMENT_RETURN];
 		}
 		return 1;
 	} else
@@ -309,14 +309,14 @@ static void trace_packet(struct sk_buff *skb,
 {
 	void *table_base;
 	const struct ip6t_entry *root;
-	char *hookname, *chainname, *comment;
+	const char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
 	table_base = private->entries[smp_processor_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
-	hookname = chainname = (char *)hooknames[hook];
-	comment = (char *)comments[NF_IP6_TRACE_COMMENT_RULE];
+	hookname = chainname = hooknames[hook];
+	comment = comments[NF_IP6_TRACE_COMMENT_RULE];
 
 	IP6T_ENTRY_ITERATE(root,
 			   private->size - private->hook_entry[hook],
-- 
1.6.2.2

