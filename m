From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool v2 PATCH 1/4] src: Wrap netfilter hooks around human readable strings
Date: Wed,  4 Sep 2013 12:50:19 +0300
Message-ID: <1378288222-13182-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934527Ab3IDJuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:50:39 -0400
In-Reply-To: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to use unique, human readable, hook names for the command
line and let the user being unaware of the complex netfilter's hook
names and there difference depending on the netfilter family.

So:
add chain foo bar { type route hook NF_INET_LOCAL_IN 0; }

becomes:
add chain foo bar { type route hook input 0; }

It also fixes then the difference in hook values between families.
I.e. ARP family has different values for input, forward and output
compared to IPv4, IPv6 or BRIDGE.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/rule.h |  3 +++
 src/evaluate.c | 44 ++++++++++++++++++++++++++++++++++
 src/parser.y   | 21 +++++++++++++----
 src/rule.c     | 74 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 src/scanner.l  |  6 -----
 5 files changed, 123 insertions(+), 25 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 4f68431..14a3958 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -98,6 +98,7 @@ enum chain_flags {
  * @handle:	chain handle
  * @location:	location the chain was defined at
  * @flags:	chain flags
+ * @hookstr:	unified and human readable hook name (base chains)
  * @hooknum:	hook number (base chains)
  * @priority:	hook priority (base chains)
  * @type:	chain type
@@ -108,6 +109,7 @@ struct chain {
 	struct handle		handle;
 	struct location		location;
 	uint32_t		flags;
+	const char		*hookstr;
 	unsigned int		hooknum;
 	unsigned int		priority;
 	const char		*type;
@@ -115,6 +117,7 @@ struct chain {
 	struct list_head	rules;
 };
 
+extern const char *chain_hook_name_lookup(const char *name);
 extern struct chain *chain_alloc(const char *name);
 extern void chain_free(struct chain *chain);
 extern void chain_add_hash(struct chain *chain, struct table *table);
diff --git a/src/evaluate.c b/src/evaluate.c
index 85c647e..470e141 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -14,6 +14,8 @@
 #include <stdint.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <expression.h>
@@ -54,6 +56,8 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define stmt_binary_error(ctx, s1, s2, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
+#define chain_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -1247,10 +1251,50 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 	return 0;
 }
 
+static uint32_t hookname2nfhook(uint32_t family, const char *hook)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_BRIDGE:
+	case NFPROTO_IPV6:
+		/* All these 3 families share actually
+		 * the same values for each hook */
+		if (!strcmp(hook, "prerouting"))
+			return NF_INET_PRE_ROUTING;
+		else if (!strcmp(hook, "in"))
+			return NF_INET_LOCAL_IN;
+		else if (!strcmp(hook, "forward"))
+			return NF_INET_FORWARD;
+		else if (!strcmp(hook, "postrouting"))
+			return NF_INET_POST_ROUTING;
+		return NF_INET_LOCAL_OUT;
+	case NFPROTO_ARP:
+		if (!strcmp(hook, "in"))
+			return NF_ARP_IN;
+		else if (!strcmp(hook, "forward"))
+			return NF_ARP_FORWARD;
+		else if (!strcmp(hook, "out"))
+			return NF_ARP_OUT;
+	default:
+		break;
+	}
+
+	return NF_INET_NUMHOOKS;
+}
+
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct rule *rule;
 
+	if (chain->flags & CHAIN_F_BASECHAIN) {
+		chain->hooknum = hookname2nfhook(chain->handle.family,
+						 chain->hookstr);
+		if (chain->hooknum == NF_INET_NUMHOOKS)
+			return chain_error(ctx, chain,
+					   "Chain cannot use hook %s",
+					   chain->hookstr);
+	}
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		handle_merge(&rule->handle, &chain->handle);
 		if (rule_evaluate(ctx, rule) < 0)
diff --git a/src/parser.y b/src/parser.y
index f0eb8e3..771b194 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -155,7 +155,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DEFINE			"define"
 
 %token HOOK			"hook"
-%token <val> HOOKNUM		"hooknum"
 %token TABLE			"table"
 %token TABLES			"tables"
 %token CHAIN			"chain"
@@ -550,6 +549,7 @@ add_cmd			:	TABLE		table_spec
 			|	CHAIN		chain_spec	chain_block_alloc
 						'{'	chain_block	'}'
 			{
+				$5->location = @5;
 				handle_merge(&$3->handle, &$2);
 				close_scope(state);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &$2, &@$, $5);
@@ -667,6 +667,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 					chain_block_alloc	'{' 	chain_block	'}'
 					stmt_seperator
 			{
+				$4->location = @3;
 				handle_merge(&$4->handle, &$3);
 				handle_free(&$3);
 				close_scope(state);
@@ -766,17 +767,27 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		HOOKNUM		NUM
+hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 			{
 				$<chain>0->type		= $2;
-				$<chain>0->hooknum	= $4;
+				$<chain>0->hookstr	= chain_hook_name_lookup($4);
+				if ($<chain>0->hookstr == NULL) {
+					erec_queue(error(&@4, "unknown hook name %s", $4),
+						   state->msgs);
+					YYERROR;
+				}
 				$<chain>0->priority	= $5;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
-			|	TYPE		STRING		HOOK		HOOKNUM		DASH	NUM
+			|	TYPE		STRING		HOOK		STRING		DASH	NUM
 			{
 				$<chain>0->type		= $2;
-				$<chain>0->hooknum	= $4;
+				$<chain>0->hookstr	= chain_hook_name_lookup($4);
+				if ($<chain>0->hookstr == NULL) {
+					erec_queue(error(&@4, "unknown hook name %s", $4),
+						   state->msgs);
+					YYERROR;
+				}
 				$<chain>0->priority	= -$6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
diff --git a/src/rule.c b/src/rule.c
index 73054ba..1b1e5d4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -21,6 +21,7 @@
 
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
 
 void handle_free(struct handle *h)
 {
@@ -189,6 +190,27 @@ struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 	return NULL;
 }
 
+static const char *chain_hook_name_str_array[] = {
+	"prerouting",
+	"in",
+	"forward",
+	"postrouting",
+	"out",
+	NULL,
+};
+
+const char *chain_hook_name_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; chain_hook_name_str_array[i]; i++) {
+		if (!strcmp(name, chain_hook_name_str_array[i]))
+			return chain_hook_name_str_array[i];
+	}
+
+	return NULL;
+}
+
 struct chain *chain_alloc(const char *name)
 {
 	struct chain *chain;
@@ -228,20 +250,43 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
-static const char *hooknum2str_array[NF_INET_NUMHOOKS] = {
-	[NF_INET_PRE_ROUTING]	= "NF_INET_PRE_ROUTING",
-	[NF_INET_LOCAL_IN]	= "NF_INET_LOCAL_IN",
-	[NF_INET_FORWARD]	= "NF_INET_FORWARD",
-	[NF_INET_LOCAL_OUT]	= "NF_INET_LOCAL_OUT",
-	[NF_INET_POST_ROUTING]	= "NF_INET_POST_ROUTING",
-};
-
-static const char *hooknum2str(unsigned int hooknum)
-{
-	if (hooknum >= NF_INET_NUMHOOKS)
-		return "UNKNOWN";
+static const char *hooknum2str(unsigned int family, unsigned int hooknum)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_BRIDGE:
+	case NFPROTO_IPV6:
+		switch (hooknum) {
+		case NF_INET_PRE_ROUTING:
+			return "prerouting";
+		case NF_INET_LOCAL_IN:
+			return "in";
+		case NF_INET_FORWARD:
+			return "forward";
+		case NF_INET_POST_ROUTING:
+			return "postrouting";
+		case NF_INET_LOCAL_OUT:
+			return "out";
+		default:
+			break;
+		};
+		break;
+	case NFPROTO_ARP:
+		switch (hooknum) {
+		case NF_ARP_IN:
+			return "in";
+		case NF_ARP_FORWARD:
+			return "forward";
+		case NF_ARP_OUT:
+			return "out";
+		default:
+			break;
+		}
+	default:
+		break;
+	};
 
-	return hooknum2str_array[hooknum];
+	return "UNKNOWN";
 }
 
 static void chain_print(const struct chain *chain)
@@ -251,7 +296,8 @@ static void chain_print(const struct chain *chain)
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		printf("\t\t type %s hook %s %u;\n", chain->type,
-		       hooknum2str(chain->hooknum), chain->priority);
+		       hooknum2str(chain->handle.family, chain->hooknum),
+		       chain->priority);
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
diff --git a/src/scanner.l b/src/scanner.l
index 59e0aac..cee6aa6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -212,12 +212,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "=>"			{ return ARROW; }
 "vmap"			{ return VMAP; }
 
-"NF_INET_PRE_ROUTING"	{ yylval->val = NF_INET_PRE_ROUTING;	return HOOKNUM; }
-"NF_INET_LOCAL_IN"	{ yylval->val = NF_INET_LOCAL_IN;	return HOOKNUM; }
-"NF_INET_FORWARD"	{ yylval->val = NF_INET_FORWARD;	return HOOKNUM; }
-"NF_INET_LOCAL_OUT"	{ yylval->val = NF_INET_LOCAL_OUT;	return HOOKNUM; }
-"NF_INET_POST_ROUTING"	{ yylval->val = NF_INET_POST_ROUTING;	return HOOKNUM; }
-
 "include"		{ return INCLUDE; }
 "define"		{ return DEFINE; }
 
-- 
1.8.3.2

