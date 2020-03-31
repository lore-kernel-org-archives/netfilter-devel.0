Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F06C2D0EE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 12:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFDC820848
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 12:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgCaMqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 08:46:01 -0400
Received: from correo.us.es ([193.147.175.20]:41214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730642AbgCaMqB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 08:46:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DDEF4FFE00
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E8D212395B
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03EE7123960; Tue, 31 Mar 2020 14:45:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D635112395B
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 14:45:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C08F54301DE1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] rule: add hook_spec
Date:   Tue, 31 Mar 2020 14:45:49 +0200
Message-Id: <20200331124551.403893-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store location of chain hook definition.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 12 ++++++++----
 src/evaluate.c     | 18 +++++++++---------
 src/json.c         |  4 ++--
 src/mnl.c          |  4 ++--
 src/netlink.c      |  8 ++++----
 src/parser_bison.y | 10 ++++++----
 src/parser_json.c  |  6 +++---
 src/rule.c         | 12 ++++++------
 8 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index db11b1d60658..06fefef8a5d8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -189,6 +189,12 @@ struct prio_spec {
 	struct expr	*expr;
 };
 
+struct hook_spec {
+	struct location	loc;
+	const char	*name;
+	unsigned int	num;
+};
+
 /**
  * struct chain - nftables chain
  *
@@ -211,9 +217,8 @@ struct chain {
 	struct location		location;
 	unsigned int		refcnt;
 	uint32_t		flags;
-	const char		*hookstr;
-	unsigned int		hooknum;
 	struct prio_spec	priority;
+	struct hook_spec	hook;
 	struct expr		*policy;
 	const char		*type;
 	const char		**dev_array;
@@ -485,8 +490,7 @@ struct flowtable {
 	struct handle		handle;
 	struct scope		scope;
 	struct location		location;
-	const char *		hookstr;
-	unsigned int		hooknum;
+	struct hook_spec	hook;
 	struct prio_spec	priority;
 	const char		**dev_array;
 	struct expr		*dev_expr;
diff --git a/src/evaluate.c b/src/evaluate.c
index 8b03e1f3cfb8..759cdaafb0ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3568,11 +3568,11 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	ft->hooknum = str2hooknum(NFPROTO_NETDEV, ft->hookstr);
-	if (ft->hooknum == NF_INET_NUMHOOKS)
-		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
+	ft->hook.num = str2hooknum(NFPROTO_NETDEV, ft->hook.name);
+	if (ft->hook.num == NF_INET_NUMHOOKS)
+		return chain_error(ctx, ft, "invalid hook %s", ft->hook.name);
 
-	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hooknum))
+	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hook.num))
 		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
 					   "invalid priority expression %s.",
 					   expr_name(ft->priority.expr));
@@ -3783,14 +3783,14 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	}
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		chain->hooknum = str2hooknum(chain->handle.family,
-					     chain->hookstr);
-		if (chain->hooknum == NF_INET_NUMHOOKS)
+		chain->hook.num = str2hooknum(chain->handle.family,
+					      chain->hook.name);
+		if (chain->hook.num == NF_INET_NUMHOOKS)
 			return chain_error(ctx, chain, "invalid hook %s",
-					   chain->hookstr);
+					   chain->hook.name);
 
 		if (!evaluate_priority(ctx, &chain->priority,
-				       chain->handle.family, chain->hooknum))
+				       chain->handle.family, chain->hook.num))
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
 						   "invalid priority expression %s in this context.",
 						   expr_name(chain->priority.expr));
diff --git a/src/json.c b/src/json.c
index 86028959b8a3..ed7131816d7d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -240,7 +240,7 @@ static json_t *chain_print_json(const struct chain *chain)
 		tmp = json_pack("{s:s, s:s, s:i, s:s}",
 				"type", chain->type,
 				"hook", hooknum2str(chain->handle.family,
-						    chain->hooknum),
+						    chain->hook.num),
 				"prio", priority,
 				"policy", chain_policy2str(policy));
 		if (chain->dev_expr) {
@@ -415,7 +415,7 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 			"name", ftable->handle.flowtable.name,
 			"table", ftable->handle.table.name,
 			"handle", ftable->handle.handle.id,
-			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hooknum),
+			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hook.num),
 			"prio", priority);
 
 	for (i = 0; i < ftable->dev_array_len; i++) {
diff --git a/src/mnl.c b/src/mnl.c
index 2eea85e838fc..3c009fab6dcf 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -630,7 +630,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		}
 		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
-					    cmd->chain->hooknum);
+					    cmd->chain->hook.num);
 			mpz_export_data(&priority,
 					cmd->chain->priority.expr->value,
 					BYTEORDER_HOST_ENDIAN, sizeof(int));
@@ -1601,7 +1601,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
-				cmd->flowtable->hooknum);
+				cmd->flowtable->hook.num);
 	mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
 			BYTEORDER_HOST_ENDIAN, sizeof(int));
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
diff --git a/src/netlink.c b/src/netlink.c
index ab1afd42f60b..24d746ca636b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -445,10 +445,10 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 	    nftnl_chain_is_set(nlc, NFTNL_CHAIN_PRIO) &&
 	    nftnl_chain_is_set(nlc, NFTNL_CHAIN_TYPE) &&
 	    nftnl_chain_is_set(nlc, NFTNL_CHAIN_POLICY)) {
-		chain->hooknum       =
+		chain->hook.num =
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_HOOKNUM);
-		chain->hookstr       =
-			hooknum2str(chain->handle.family, chain->hooknum);
+		chain->hook.name =
+			hooknum2str(chain->handle.family, chain->hook.num);
 		priority = nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
 		chain->priority.expr =
 				constant_expr_alloc(&netlink_location,
@@ -1340,7 +1340,7 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 						    sizeof(int) *
 						    BITS_PER_BYTE,
 						    &priority);
-	flowtable->hooknum =
+	flowtable->hook.num =
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
 	flowtable->flags =
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FLAGS);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9976bcafb2c4..ebaef17c904c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1877,8 +1877,9 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			|	flowtable_block	stmt_separator
 			|	flowtable_block	HOOK		STRING	prio_spec	stmt_separator
 			{
-				$$->hookstr	= chain_hookname_lookup($3);
-				if ($$->hookstr == NULL) {
+				$$->hook.loc = @3;
+				$$->hook.name = chain_hookname_lookup($3);
+				if ($$->hook.name == NULL) {
 					erec_queue(error(&@3, "unknown chain hook %s", $3),
 						   state->msgs);
 					xfree($3);
@@ -2056,8 +2057,9 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
 				$<chain>0->type		= xstrdup(chain_type);
 				xfree($2);
 
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
+				$<chain>0->hook.loc = @4;
+				$<chain>0->hook.name = chain_hookname_lookup($4);
+				if ($<chain>0->hook.name == NULL) {
 					erec_queue(error(&@4, "unknown chain hook %s", $4),
 						   state->msgs);
 					xfree($4);
diff --git a/src/parser_json.c b/src/parser_json.c
index d158db786b8d..a1765027fdf3 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2628,8 +2628,8 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 						   BYTEORDER_HOST_ENDIAN,
 						   sizeof(int) * BITS_PER_BYTE,
 						   &prio);
-	chain->hookstr = chain_hookname_lookup(hookstr);
-	if (!chain->hookstr) {
+	chain->hook.name = chain_hookname_lookup(hookstr);
+	if (!chain->hook.name) {
 		json_error(ctx, "Invalid chain hook '%s'.", hookstr);
 		chain_free(chain);
 		return NULL;
@@ -3017,7 +3017,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	}
 
 	flowtable = flowtable_alloc(int_loc);
-	flowtable->hookstr = hookstr;
+	flowtable->hook.name = hookstr;
 	flowtable->priority.expr =
 		constant_expr_alloc(int_loc, &integer_type,
 				    BYTEORDER_HOST_ENDIAN,
diff --git a/src/rule.c b/src/rule.c
index 92fa129be077..a312693f4edc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1165,7 +1165,7 @@ static void chain_print_declaration(const struct chain *chain,
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		nft_print(octx, "\t\ttype %s hook %s", chain->type,
-			  hooknum2str(chain->handle.family, chain->hooknum));
+			  hooknum2str(chain->handle.family, chain->hook.num));
 		if (chain->dev_array_len == 1) {
 			nft_print(octx, " device \"%s\"", chain->dev_array[0]);
 		} else if (chain->dev_array_len > 1) {
@@ -1179,7 +1179,7 @@ static void chain_print_declaration(const struct chain *chain,
 		}
 		nft_print(octx, " priority %s;",
 			  prio2str(octx, priobuf, sizeof(priobuf),
-				   chain->handle.family, chain->hooknum,
+				   chain->handle.family, chain->hook.num,
 				   chain->priority.expr));
 		if (chain->policy) {
 			mpz_export_data(&policy, chain->policy->value,
@@ -1220,9 +1220,9 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 		mpz_export_data(&policy, chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		nft_print(octx, " { type %s hook %s priority %s; policy %s; }",
-			  chain->type, chain->hookstr,
+			  chain->type, chain->hook.name,
 			  prio2str(octx, priobuf, sizeof(priobuf),
-				   chain->handle.family, chain->hooknum,
+				   chain->handle.family, chain->hook.num,
 				   chain->priority.expr),
 			  chain_policy2str(policy));
 	}
@@ -2235,9 +2235,9 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 	nft_print(octx, "%s", opts->nl);
 	nft_print(octx, "%s%shook %s priority %s%s",
 		  opts->tab, opts->tab,
-		  hooknum2str(NFPROTO_NETDEV, flowtable->hooknum),
+		  hooknum2str(NFPROTO_NETDEV, flowtable->hook.num),
 		  prio2str(octx, priobuf, sizeof(priobuf), NFPROTO_NETDEV,
-			   flowtable->hooknum, flowtable->priority.expr),
+			   flowtable->hook.num, flowtable->priority.expr),
 		  opts->stmt_separator);
 
 	nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
-- 
2.11.0

