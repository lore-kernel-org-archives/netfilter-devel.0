From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft PATCH] More extensive error checking on base chain
Date: Tue, 12 Aug 2014 17:37:24 +0800
Message-ID: <1407836244-30480-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39680 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaHLJec (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:34:32 -0400
Received: by mail-pd0-f175.google.com with SMTP id r10so12312038pdi.20
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2014 02:34:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The evaluation of base chain isn't extensive enough. It cannot
detect whether a chain type is supported or not in certain families.
It also cannot deletect whether a hook is supported or not in certain
chains. The evaluation is done by kernel, and the information is unclear.

nft> add chain arp arptable chain1 {type nat hook input priority 0 ;}
<cli>:1:1-64: Error: Could not add chain: No such file or directory
add chain arp arptable chain1 {type nat hook input priority 0 ;}
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
nft> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
<cli>:1:1-64: Error: Could not add chain: Operation not supported
add chain ip iptable chain1 {type nat hook forward priority 0 ;}
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This patch performs more extensive error checking, so the information
is more clear.

nft> add chain arp arptable chain1 {type nat hook input priority 0 ;}
<cli>:1:31-63: Error: invalid type name nat
add chain arp arptable chain1 {type nat hook input priority 0 ;}
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
nft> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
<cli>:1:29-63: Error: invalid hook name forward
add chain ip iptable chain1 {type nat hook forward priority 0 ;}
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 include/rule.h |   2 -
 src/evaluate.c | 196 +++++++++++++++++++++++++++++++++++++++++++++++----------
 src/parser.y   |  28 ++-------
 src/rule.c     |  40 ------------
 4 files changed, 168 insertions(+), 98 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index db91406..8caf088 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -121,8 +121,6 @@ struct chain {
 	struct list_head	rules;
 };
 
-extern const char *chain_type_name_lookup(const char *name);
-extern const char *chain_hookname_lookup(const char *name);
 extern struct chain *chain_alloc(const char *name);
 extern void chain_free(struct chain *chain);
 extern void chain_add_hash(struct chain *chain, struct table *table);
diff --git a/src/evaluate.c b/src/evaluate.c
index f66a8ea..d6129c7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -14,8 +14,10 @@
 #include <stdint.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <net/if.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <expression.h>
@@ -1309,36 +1311,156 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 	return 0;
 }
 
-static uint32_t str2hooknum(uint32_t family, const char *hook)
+static const char *inet_hooks_str_array[NF_INET_NUMHOOKS] = {
+	[NF_INET_PRE_ROUTING]	= "prerouting",
+	[NF_INET_LOCAL_IN]	= "input",
+	[NF_INET_FORWARD]	= "forward",
+	[NF_INET_LOCAL_OUT]	= "output",
+	[NF_INET_POST_ROUTING]	= "postrouting",
+};
+
+static const char *bridge_hooks_str_array[NF_BR_NUMHOOKS] = {
+	[NF_BR_PRE_ROUTING]	= "prerouting",
+	[NF_BR_LOCAL_IN]	= "input",
+	[NF_BR_FORWARD]		= "forward",
+	[NF_BR_LOCAL_OUT]	= "output",
+	[NF_BR_POST_ROUTING]	= "postrouting",
+	[NF_BR_BROUTING]	= NULL,
+};
+
+static const char *arp_hooks_str_array[NF_ARP_NUMHOOKS] = {
+	[NF_ARP_IN]		= "input",
+	[NF_ARP_OUT]		= "output",
+	[NF_ARP_FORWARD]	= "forward",
+};
+
+struct chain_type {
+	struct list_head	list;
+	uint32_t		family;
+	const char		*type;
+	unsigned int		num;
+	const	char		*hooks[0];
+};
+
+static struct list_head chain_types;
+
+static struct chain_type *chain_type_name_lookup(uint32_t family,
+			const char *name)
 {
-	switch (family) {
-	case NFPROTO_IPV4:
-	case NFPROTO_BRIDGE:
-	case NFPROTO_IPV6:
-	case NFPROTO_INET:
-		/* These families have overlapping values for each hook */
-		if (!strcmp(hook, "prerouting"))
-			return NF_INET_PRE_ROUTING;
-		else if (!strcmp(hook, "input"))
-			return NF_INET_LOCAL_IN;
-		else if (!strcmp(hook, "forward"))
-			return NF_INET_FORWARD;
-		else if (!strcmp(hook, "postrouting"))
-			return NF_INET_POST_ROUTING;
-		else if (!strcmp(hook, "output"))
-			return NF_INET_LOCAL_OUT;
-	case NFPROTO_ARP:
-		if (!strcmp(hook, "input"))
-			return NF_ARP_IN;
-		else if (!strcmp(hook, "forward"))
-			return NF_ARP_FORWARD;
-		else if (!strcmp(hook, "output"))
-			return NF_ARP_OUT;
-	default:
-		break;
+	struct chain_type *type;
+
+	list_for_each_entry(type, &chain_types, list) {
+		if (type->family == family && !strcmp(type->type, name))
+			return type;
+		}
+	return NULL;
+}
+
+static int chain_hook_name_lookup(struct chain_type *type, const char *name)
+{
+	unsigned int	num;
+	const char	**hookstr;
+
+	if (!type)
+		return -1;
+	hookstr = type->hooks;
+	for (num = 0; num < type->num; num++) {
+		if (hookstr[num] && !(strcmp(hookstr[num], name)))
+			return num;
+	}
+	return -1;
+}
+
+static void chain_type_register(uint32_t family, const char *type,
+			unsigned int max, unsigned int hook_mask)
+{
+	unsigned int	num;
+	const char	**hookstr;
+	struct chain_type	*chain_type;
+
+	chain_type = xmalloc(sizeof(struct chain_type) +
+				max * sizeof(char *));
+	init_list_head(&chain_type->list);
+	chain_type->family = family;
+	chain_type->type = type;
+	chain_type->num = max;
+
+	hookstr = chain_type->hooks;
+	for (num = 0; num < max; num++) {
+		if (hook_mask & (1 << num)) {
+			switch (family) {
+			case NFPROTO_IPV4:
+			case NFPROTO_IPV6:
+			case NFPROTO_INET:
+				hookstr[num] = inet_hooks_str_array[num];
+				break;
+			case NFPROTO_ARP:
+				hookstr[num] = arp_hooks_str_array[num];
+				break;
+			case NFPROTO_BRIDGE:
+				hookstr[num] = bridge_hooks_str_array[num];
+				break;
+			default:
+				BUG("invalid family %u\n", family);
+			}
+		} else
+			hookstr[num] = NULL;
 	}
+	list_add_tail(&chain_type->list, &chain_types);
+}
 
-	return NF_INET_NUMHOOKS;
+static void __init chain_type_init(void)
+{
+	init_list_head(&chain_types);
+
+	chain_type_register(NFPROTO_IPV4, "filter", NF_INET_NUMHOOKS,
+				(1 << NF_INET_PRE_ROUTING) |
+				(1 << NF_INET_LOCAL_IN) |
+				(1 << NF_INET_FORWARD) |
+				(1 << NF_INET_LOCAL_OUT) |
+				(1 << NF_INET_POST_ROUTING));
+
+	chain_type_register(NFPROTO_IPV4, "nat", NF_INET_NUMHOOKS,
+				(1 << NF_INET_PRE_ROUTING) |
+				(1 << NF_INET_LOCAL_IN) |
+				(1 << NF_INET_LOCAL_OUT) |
+				(1 << NF_INET_POST_ROUTING));
+
+	chain_type_register(NFPROTO_IPV4, "route", NF_INET_NUMHOOKS,
+				(1 << NF_INET_LOCAL_OUT));
+
+	chain_type_register(NFPROTO_IPV6, "filter", NF_INET_NUMHOOKS,
+				(1 << NF_INET_PRE_ROUTING) |
+				(1 << NF_INET_LOCAL_IN) |
+				(1 << NF_INET_FORWARD) |
+				(1 << NF_INET_LOCAL_OUT) |
+				(1 << NF_INET_POST_ROUTING));
+
+	chain_type_register(NFPROTO_IPV6, "nat", NF_INET_NUMHOOKS,
+				(1 << NF_INET_PRE_ROUTING) |
+				(1 << NF_INET_LOCAL_IN) |
+				(1 << NF_INET_LOCAL_OUT) |
+				(1 << NF_INET_POST_ROUTING));
+
+	chain_type_register(NFPROTO_IPV6, "route", NF_INET_NUMHOOKS,
+				(1 << NF_INET_LOCAL_OUT));
+
+	chain_type_register(NFPROTO_INET, "filter", NF_INET_NUMHOOKS,
+				(1 << NF_INET_PRE_ROUTING) |
+				(1 << NF_INET_LOCAL_IN) |
+				(1 << NF_INET_FORWARD) |
+				(1 << NF_INET_LOCAL_OUT) |
+				(1 << NF_INET_POST_ROUTING));
+
+	chain_type_register(NFPROTO_ARP, "filter", NF_ARP_NUMHOOKS,
+				(1 << NF_ARP_IN) |
+				(1 << NF_ARP_OUT) |
+				(1 << NF_ARP_FORWARD));
+
+	chain_type_register(NFPROTO_BRIDGE, "filter", NF_BR_NUMHOOKS,
+				(1 << NF_BR_LOCAL_IN) |
+				(1 << NF_BR_FORWARD) |
+				(1 << NF_BR_LOCAL_OUT));
 }
 
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
@@ -1346,11 +1468,21 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	struct rule *rule;
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		chain->hooknum = str2hooknum(chain->handle.family,
-					     chain->hookstr);
-		if (chain->hooknum == NF_INET_NUMHOOKS)
-			return chain_error(ctx, chain, "invalid hook %s",
-					   chain->hookstr);
+		int	hooknum;
+		struct chain_type *chain_type;
+
+		chain_type = chain_type_name_lookup(chain->handle.family,
+					chain->type);
+		if (!chain_type)
+			return chain_error(ctx, chain, "invalid type name %s",
+						chain->type);
+		hooknum = chain_hook_name_lookup(chain_type, chain->hookstr);
+		if (hooknum == -1)
+			return chain_error(ctx, chain, "invalid hook name %s",
+						chain->hookstr);
+		xfree(chain->type);
+		chain->type = chain_type->type;
+		chain->hooknum = (unsigned int)hooknum;
 	}
 
 	list_for_each_entry(rule, &chain->rules, list) {
diff --git a/src/parser.y b/src/parser.y
index 26d2879..2a816be 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1119,35 +1119,15 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown chain type %s", $2),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown chain type %s", $4),
-						   state->msgs);
-					YYERROR;
-				}
+				$<chain>0->type		= $2;
+				$<chain>0->hookstr	= $4;
 				$<chain>0->priority	= $6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
 			|	TYPE		STRING		HOOK		STRING		PRIORITY	DASH	NUM
 			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown type name %s", $2),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown hook name %s", $4),
-						   state->msgs);
-					YYERROR;
-				}
+				$<chain>0->type		= $2;
+				$<chain>0->hookstr	= $4;
 				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
diff --git a/src/rule.c b/src/rule.c
index 1e54526..c360bc7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -275,46 +275,6 @@ struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 	return NULL;
 }
 
-static const char *chain_type_str_array[] = {
-	"filter",
-	"nat",
-	"route",
-	NULL,
-};
-
-const char *chain_type_name_lookup(const char *name)
-{
-	int i;
-
-	for (i = 0; chain_type_str_array[i]; i++) {
-		if (!strcmp(name, chain_type_str_array[i]))
-			return chain_type_str_array[i];
-	}
-
-	return NULL;
-}
-
-static const char *chain_hookname_str_array[] = {
-	"prerouting",
-	"input",
-	"forward",
-	"postrouting",
-	"output",
-	NULL,
-};
-
-const char *chain_hookname_lookup(const char *name)
-{
-	int i;
-
-	for (i = 0; chain_hookname_str_array[i]; i++) {
-		if (!strcmp(name, chain_hookname_str_array[i]))
-			return chain_hookname_str_array[i];
-	}
-
-	return NULL;
-}
-
 struct chain *chain_alloc(const char *name)
 {
 	struct chain *chain;
-- 
1.9.3

