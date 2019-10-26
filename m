Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C462CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43C9A2070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfJZLNL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:13:11 -0400
Received: from correo.us.es ([193.147.175.20]:40712 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfJZLNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:13:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23D205E4781
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:13:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13AC2DA72F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:13:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 094BCDA840; Sat, 26 Oct 2019 13:13:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4D86A7E99
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:13:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:13:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A532742EE38E
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:13:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: add multidevice support for netdev chain
Date:   Sat, 26 Oct 2019 13:13:00 +0200
Message-Id: <20191026111300.4407-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to specify multiple netdevices to be bound to the
netdev basechain, eg.

 # nft add chain netdev x y { \
	type filter hook ingress devices = { eth0, eth1 } priority 0\; }

json codebase has been updated to support for one single device with the
existing representation, no support for multidevice is included in this
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix mnl_nft_flowtable_add() device array handling.

 include/rule.h     |  4 +++-
 src/json.c         | 17 +++++++++++++----
 src/mnl.c          | 38 +++++++++++++++++++++++++++++++-------
 src/netlink.c      | 20 +++++++++++++++++---
 src/parser_bison.y | 26 ++++++++++++++++++++------
 src/parser_json.c  | 18 +++++++++++++++---
 src/rule.c         | 22 +++++++++++++++++-----
 7 files changed, 116 insertions(+), 29 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 2708cbebc9f8..ba40db8806fc 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -208,7 +208,9 @@ struct chain {
 	struct prio_spec	priority;
 	struct expr		*policy;
 	const char		*type;
-	const char		*dev;
+	const char		**dev_array;
+	struct expr		*dev_expr;
+	int			dev_array_len;
 	struct scope		scope;
 	struct list_head	rules;
 };
diff --git a/src/json.c b/src/json.c
index 13a064249d90..56b20549bd73 100644
--- a/src/json.c
+++ b/src/json.c
@@ -222,9 +222,9 @@ static json_t *rule_print_json(struct output_ctx *octx,
 
 static json_t *chain_print_json(const struct chain *chain)
 {
+	int priority, policy, n = 0;
+	struct expr *dev, *expr;
 	json_t *root, *tmp;
-	int priority;
-	int policy;
 
 	root = json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
@@ -243,8 +243,17 @@ static json_t *chain_print_json(const struct chain *chain)
 						    chain->hooknum),
 				"prio", priority,
 				"policy", chain_policy2str(policy));
-		if (chain->dev)
-			json_object_set_new(tmp, "dev", json_string(chain->dev));
+		if (chain->dev_expr) {
+			list_for_each_entry(expr, &chain->dev_expr->expressions, list) {
+				dev = expr;
+				n++;
+			}
+		}
+
+		if (n == 1) {
+			json_object_set_new(tmp, "dev",
+					    json_string(dev->identifier));
+		}
 		json_object_update(root, tmp);
 		json_decref(tmp);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index 75ab07b045aa..27da5a284c05 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -526,10 +526,12 @@ err:
 int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		      unsigned int flags)
 {
+	int priority, policy, i = 0;
 	struct nftnl_chain *nlc;
+	const char **dev_array;
 	struct nlmsghdr *nlh;
-	int priority;
-	int policy;
+	struct expr *expr;
+	int dev_array_len;
 
 	nlc = nftnl_chain_alloc();
 	if (nlc == NULL)
@@ -555,9 +557,26 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 					BYTEORDER_HOST_ENDIAN, sizeof(int));
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY, policy);
 		}
-		if (cmd->chain->dev != NULL)
-			nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV,
-					    cmd->chain->dev);
+		if (cmd->chain->dev_expr) {
+			dev_array = xmalloc(sizeof(char *) * 8);
+			dev_array_len = 8;
+			list_for_each_entry(expr, &cmd->chain->dev_expr->expressions, list) {
+				dev_array[i++] = expr->identifier;
+				if (i == dev_array_len) {
+					dev_array_len *= 2;
+					dev_array = xrealloc(dev_array,
+							     dev_array_len);
+				}
+			}
+
+			dev_array[i] = NULL;
+			if (i == 1)
+				nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV, dev_array[0]);
+			else if (i > 1)
+				nftnl_chain_set(nlc, NFTNL_CHAIN_DEVICES, dev_array);
+
+			xfree(dev_array);
+		}
 	}
 	netlink_dump_chain(nlc, ctx);
 
@@ -1392,11 +1411,11 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			  unsigned int flags)
 {
 	struct nftnl_flowtable *flo;
-	const char *dev_array[8];
+	const char **dev_array;
 	struct nlmsghdr *nlh;
+	int i = 0, len = 1;
 	struct expr *expr;
 	int priority;
-	int i = 0;
 
 	flo = nftnl_flowtable_alloc();
 	if (!flo)
@@ -1415,10 +1434,15 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
 
 	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
+		len++;
+
+	dev_array = calloc(len, sizeof(char *));
+	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
 		dev_array[i++] = expr->identifier;
 
 	dev_array[i] = NULL;
 	nftnl_flowtable_set(flo, NFTNL_FLOWTABLE_DEVICES, dev_array);
+	free(dev_array);
 
 	netlink_dump_flowtable(flo, ctx);
 
diff --git a/src/netlink.c b/src/netlink.c
index 1e669e5dcaa1..c47771d3c801 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -378,9 +378,9 @@ void netlink_dump_chain(const struct nftnl_chain *nlc, struct netlink_ctx *ctx)
 struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					const struct nftnl_chain *nlc)
 {
+	int priority, policy, len = 0, i;
+	const char * const *dev_array;
 	struct chain *chain;
-	int priority;
-	int policy;
 
 	chain = chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	chain->handle.family =
@@ -415,8 +415,22 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 						    &policy);
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
 		if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_DEV)) {
-			chain->dev	=
+			chain->dev_array = xmalloc(sizeof(char *));
+			chain->dev_array_len = 1;
+			chain->dev_array[0] =
 				xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_DEV));
+			chain->dev_array[1] = NULL;
+		} else if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_DEVICES)) {
+			dev_array = nftnl_chain_get(nlc, NFTNL_CHAIN_DEVICES);
+			while (dev_array[len])
+				len++;
+
+			chain->dev_array = xmalloc(len * sizeof(char *));
+			for (i = 0; i < len; i++)
+				chain->dev_array[i] = xstrdup(dev_array[i]);
+
+			chain->dev_array[i] = NULL;
+			chain->dev_array_len = len;
 		}
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 11f0dc8b2153..7f9b1752f41d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -564,11 +564,11 @@ int nft_lex(void *, void *, void *);
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
-%type <string>			extended_prio_name
-%destructor { xfree($$); }	extended_prio_name
+%type <string>			extended_prio_name quota_unit
+%destructor { xfree($$); }	extended_prio_name quota_unit
 
-%type <string>			dev_spec quota_unit
-%destructor { xfree($$); }	dev_spec quota_unit
+%type <expr>			dev_spec
+%destructor { xfree($$); }	dev_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -1992,7 +1992,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
 				}
 				xfree($4);
 
-				$<chain>0->dev		= $5;
+				$<chain>0->dev_expr	= $5;
 				$<chain>0->priority	= $6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
@@ -2072,7 +2072,21 @@ int_num			:	NUM			{ $$ = $1; }
 			|	DASH	NUM		{ $$ = -$2; }
 			;
 
-dev_spec		:	DEVICE	string		{ $$ = $2; }
+dev_spec		:	DEVICE	string
+			{
+				struct expr *expr;
+
+				expr = constant_expr_alloc(&@$, &string_type,
+							   BYTEORDER_HOST_ENDIAN,
+							   strlen($2) * BITS_PER_BYTE, $2);
+				$$ = compound_expr_alloc(&@$, EXPR_LIST);
+				compound_expr_add($$, expr);
+
+			}
+			|	DEVICES		'='	flowtable_expr
+			{
+				$$ = $3;
+			}
 			|	/* empty */		{ $$ = NULL; }
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index fe0c5df98f5d..a9bcb84faf44 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -17,6 +17,7 @@
 #include <netinet/icmp6.h>
 #include <netinet/ip.h>
 #include <netinet/ip_icmp.h>
+#include <net/if.h>
 #include <linux/xfrm.h>
 
 #include <linux/netfilter.h>
@@ -2581,8 +2582,9 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		.table.location = *int_loc,
 	};
 	const char *family = "", *policy = "", *type, *hookstr;
-	int prio;
+	const char name[IFNAMSIZ];
 	struct chain *chain;
+	int prio;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -2626,8 +2628,18 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
-	if (!json_unpack(root, "{s:s}", "dev", &chain->dev))
-		chain->dev = xstrdup(chain->dev);
+	if (!json_unpack(root, "{s:s}", "dev", &name)) {
+		struct expr *dev_expr, *expr;
+
+		dev_expr = compound_expr_alloc(int_loc, EXPR_LIST);
+		expr = constant_expr_alloc(int_loc, &integer_type,
+					   BYTEORDER_HOST_ENDIAN,
+					   strlen(name) * BITS_PER_BYTE,
+					   name);
+		compound_expr_add(dev_expr, expr);
+		chain->dev_expr = dev_expr;
+	}
+
 	if (!json_unpack(root, "{s:s}", "policy", &policy)) {
 		chain->policy = parse_policy(policy);
 		if (!chain->policy) {
diff --git a/src/rule.c b/src/rule.c
index 64756bcee6b8..c258f12e5c77 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -814,6 +814,7 @@ struct chain *chain_get(struct chain *chain)
 void chain_free(struct chain *chain)
 {
 	struct rule *rule, *next;
+	int i;
 
 	if (--chain->refcnt > 0)
 		return;
@@ -822,8 +823,10 @@ void chain_free(struct chain *chain)
 	handle_free(&chain->handle);
 	scope_release(&chain->scope);
 	xfree(chain->type);
-	if (chain->dev != NULL)
-		xfree(chain->dev);
+	expr_free(chain->dev_expr);
+	for (i = 0; i < chain->dev_array_len; i++)
+		xfree(chain->dev_array[i]);
+	xfree(chain->dev_array);
 	expr_free(chain->priority.expr);
 	expr_free(chain->policy);
 	xfree(chain);
@@ -1102,7 +1105,7 @@ static void chain_print_declaration(const struct chain *chain,
 				    struct output_ctx *octx)
 {
 	char priobuf[STD_PRIO_BUFSIZE];
-	int policy;
+	int policy, i;
 
 	nft_print(octx, "\tchain %s {", chain->handle.chain.name);
 	if (nft_output_handle(octx))
@@ -1111,8 +1114,17 @@ static void chain_print_declaration(const struct chain *chain,
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		nft_print(octx, "\t\ttype %s hook %s", chain->type,
 			  hooknum2str(chain->handle.family, chain->hooknum));
-		if (chain->dev != NULL)
-			nft_print(octx, " device \"%s\"", chain->dev);
+		if (chain->dev_array_len == 1) {
+			nft_print(octx, " device \"%s\"", chain->dev_array[0]);
+		} else if (chain->dev_array_len > 1) {
+			nft_print(octx, " devices = { ");
+			for (i = 0; i < chain->dev_array_len; i++) {
+				nft_print(octx, "%s", chain->dev_array[i]);
+					if (i + 1 != chain->dev_array_len)
+						nft_print(octx, ", ");
+			}
+			nft_print(octx, " }");
+		}
 		nft_print(octx, " priority %s;",
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
-- 
2.11.0

