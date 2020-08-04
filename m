Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96539C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 14:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805AA208A9
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 14:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHDOYt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:24:49 -0400
Received: from correo.us.es ([193.147.175.20]:43062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgHDOYs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 10:24:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1814AFB366
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:24:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AD36DA78C
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 16:24:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 00735DA78A; Tue,  4 Aug 2020 16:24:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFBBADA73F;
        Tue,  4 Aug 2020 16:24:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 16:24:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.49.65])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5449A4265A2F;
        Tue,  4 Aug 2020 16:24:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, erig@erig.me
Subject: [PATCH nft] src: add cookie support for rules
Date:   Tue,  4 Aug 2020 16:24:12 +0200
Message-Id: <20200804142412.7409-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows users to specify a unsigned 64-bit cookie for rules.
The userspace application assigns the cookie number for tracking the rule.
The cookie needs to be non-zero. This cookie value is only relevant to
userspace since this resides in the user data area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Phil, you suggested a cookie to track rules, here it is. A few notes:

- This patch is missing json support.
- No need for kernel update since the cookie is stored in the user data area.

 include/rule.h            |  3 ++-
 src/netlink_delinearize.c | 22 +++++++++++++++-------
 src/netlink_linearize.c   | 16 ++++++++++++----
 src/parser_bison.y        | 18 +++++++++++++++++-
 src/rule.c                |  2 ++
 src/scanner.l             |  1 +
 6 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 60eadfa3c9a2..0dd29625e613 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -275,8 +275,9 @@ struct rule {
 	struct location		location;
 	struct list_head	stmts;
 	unsigned int		num_stmts;
-	const char		*comment;
 	unsigned int		refcnt;
+	const char		*comment;
+	uint64_t		cookie;
 };
 
 extern struct rule *rule_alloc(const struct location *loc,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9e3ed53d09f1..7a25f5b0ddf4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2816,6 +2816,10 @@ static int parse_rule_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (value[len - 1] != '\0')
 			return -1;
 		break;
+	case NFTNL_UDATA_RULE_COOKIE:
+		if (len != sizeof(uint64_t))
+			return -1;
+		break;
 	default:
 		return 0;
 	}
@@ -2823,24 +2827,28 @@ static int parse_rule_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
-static char *nftnl_rule_get_comment(const struct nftnl_rule *nlr)
+static int nftnl_rule_get_userdata(const struct nftnl_rule *nlr, struct rule *rule)
 {
 	const struct nftnl_udata *tb[NFTNL_UDATA_RULE_MAX + 1] = {};
 	const void *data;
 	uint32_t len;
 
 	if (!nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA))
-		return NULL;
+		return 0;
 
 	data = nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
 
 	if (nftnl_udata_parse(data, len, parse_rule_udata_cb, tb) < 0)
-		return NULL;
+		return -1;
 
-	if (!tb[NFTNL_UDATA_RULE_COMMENT])
-		return NULL;
+	if (tb[NFTNL_UDATA_RULE_COMMENT]) {
+		rule->comment =
+			xstrdup(nftnl_udata_get(tb[NFTNL_UDATA_RULE_COMMENT]));
+	}
+	if (tb[NFTNL_UDATA_RULE_COOKIE])
+		rule->cookie = nftnl_udata_get_u64(tb[NFTNL_UDATA_RULE_COOKIE]);
 
-	return xstrdup(nftnl_udata_get(tb[NFTNL_UDATA_RULE_COMMENT]));
+	return 0;
 }
 
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
@@ -2866,7 +2874,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	pctx->table = table_lookup(&h, &ctx->nft->cache);
 	assert(pctx->table != NULL);
 
-	pctx->rule->comment = nftnl_rule_get_comment(nlr);
+	nftnl_rule_get_userdata(nlr, pctx->rule);
 
 	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 846df46b75fd..a5d86449d7f2 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1516,6 +1516,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 			    const struct rule *rule)
 {
+	struct nftnl_udata_buf *udata = NULL;
 	struct netlink_linearize_ctx lctx;
 	const struct stmt *stmt;
 
@@ -1526,20 +1527,27 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 	list_for_each_entry(stmt, &rule->stmts, list)
 		netlink_gen_stmt(&lctx, stmt);
 
-	if (rule->comment) {
-		struct nftnl_udata_buf *udata;
-
+	if (rule->comment || rule->cookie) {
 		udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udata)
 			memory_allocation_error();
+	}
 
+	if (rule->comment) {
 		if (!nftnl_udata_put_strz(udata, NFTNL_UDATA_RULE_COMMENT,
 					  rule->comment))
 			memory_allocation_error();
+	}
+	if (rule->cookie) {
+		if (!nftnl_udata_put_u64(udata, NFTNL_UDATA_RULE_COOKIE,
+					 rule->cookie))
+			memory_allocation_error();
+	}
+
+	if (udata) {
 		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
 				    nftnl_udata_buf_data(udata),
 				    nftnl_udata_buf_len(udata));
-
 		nftnl_udata_buf_free(udata);
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 167c315810ed..9d982900eb94 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -543,6 +543,7 @@ int nft_lex(void *, void *, void *);
 %token POSITION			"position"
 %token INDEX			"index"
 %token COMMENT			"comment"
+%token COOKIE			"cookie"
 
 %token XML			"xml"
 %token JSON			"json"
@@ -568,7 +569,7 @@ int nft_lex(void *, void *, void *);
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec quota_used
+%type <val>			time_spec quota_used cookie_spec
 
 %type <expr>			data_type_expr data_type_atom_expr
 %destructor { expr_free($$); }  data_type_expr data_type_atom_expr
@@ -2482,6 +2483,12 @@ comment_spec		:	COMMENT		string
 			}
 			;
 
+cookie_spec		:	COOKIE		NUM
+			{
+				$$ = $2;
+			}
+			;
+
 ruleset_spec		:	/* empty */
 			{
 				memset(&$$, 0, sizeof($$));
@@ -2502,6 +2509,15 @@ rule			:	rule_alloc
 			{
 				$$->comment = $2;
 			}
+			|	rule_alloc	cookie_spec
+			{
+				$$->cookie = $2;
+			}
+			|	rule_alloc	cookie_spec comment_spec
+			{
+				$$->cookie = $2;
+				$$->comment = $3;
+			}
 			;
 
 rule_alloc		:	stmt_list
diff --git a/src/rule.c b/src/rule.c
index 6335aa2189ad..551a7dc01ce2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -664,6 +664,8 @@ void rule_print(const struct rule *rule, struct output_ctx *octx)
 			nft_print(octx, " ");
 	}
 
+	if (rule->cookie)
+		nft_print(octx, " cookie %"PRIu64"", rule->cookie);
 	if (rule->comment)
 		nft_print(octx, " comment \"%s\"", rule->comment);
 
diff --git a/src/scanner.l b/src/scanner.l
index 45699c85d7d0..7117ebb918fc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -300,6 +300,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "position"		{ return POSITION; }
 "index"			{ return INDEX; }
 "comment"		{ return COMMENT; }
+"cookie"		{ return COOKIE; }
 
 "constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
-- 
2.20.1

