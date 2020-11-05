Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEAEC4741F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691BE206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgKEOMB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOMA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:12:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80048C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:12:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzb-0006GW-5H; Thu, 05 Nov 2020 15:11:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/7] tcpopts: clean up parser -> tcpopt.c plumbing
Date:   Thu,  5 Nov 2020 15:11:39 +0100
Message-Id: <20201105141144.31430-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tcpopt template mapping is asymmetric:
one mapping is to match dumped netlink exthdr expression to the original
tcp option template.

This struct is indexed by the raw, on-write kind/type number.

The other mapping maps parsed options to the tcp option template.
Remove the latter.  The parser is changed to translate the textual
option name, e.g. "maxseg" to the on-wire number.

This avoids the second mapping, it will also allow to more easily
support raw option matching in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt |  4 +-
 include/tcpopt.h           | 35 ++++++++-------
 src/parser_bison.y         | 28 ++++++------
 src/parser_json.c          | 10 ++---
 src/scanner.l              |  3 +-
 src/tcpopt.c               | 92 +++++++++++++++-----------------------
 6 files changed, 76 insertions(+), 96 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 9df20a18ae8a..2fa394ea966f 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -525,13 +525,13 @@ nftables currently supports matching (finding) a given ipv6 extension header, TC
 *dst* {*nexthdr* | *hdrlength*}
 *mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
 *srh* {*flags* | *tag* | *sid* | *seg-left*}
-*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
+*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
 *ip option* { lsrr | ra | rr | ssrr } 'ip_option_field'
 
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
-*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
+*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
 *ip option* { lsrr | ra | rr | ssrr }
 
 .IPv6 extension headers
diff --git a/include/tcpopt.h b/include/tcpopt.h
index ffdbcb028125..7f3fbb8b0c7d 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -6,7 +6,7 @@
 #include <statement.h>
 
 extern struct expr *tcpopt_expr_alloc(const struct location *loc,
-				      uint8_t type, uint8_t field);
+				      unsigned int kind, unsigned int field);
 
 extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len,
@@ -15,21 +15,22 @@ extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
 
-enum tcpopt_hdr_types {
-	TCPOPTHDR_INVALID,
-	TCPOPTHDR_EOL,
-	TCPOPTHDR_NOOP,
-	TCPOPTHDR_MAXSEG,
-	TCPOPTHDR_WINDOW,
-	TCPOPTHDR_SACK_PERMITTED,
-	TCPOPTHDR_SACK0,
-	TCPOPTHDR_SACK1,
-	TCPOPTHDR_SACK2,
-	TCPOPTHDR_SACK3,
-	TCPOPTHDR_TIMESTAMP,
-	TCPOPTHDR_ECHO,
-	TCPOPTHDR_ECHO_REPLY,
-	__TCPOPTHDR_MAX
+/* TCP option numbers used on wire */
+enum tcpopt_kind {
+	TCPOPT_KIND_EOL = 0,
+	TCPOPT_KIND_NOP = 1,
+	TCPOPT_KIND_MAXSEG = 2,
+	TCPOPT_KIND_WINDOW = 3,
+	TCPOPT_KIND_SACK_PERMITTED = 4,
+	TCPOPT_KIND_SACK = 5,
+	TCPOPT_KIND_TIMESTAMP = 8,
+	TCPOPT_KIND_ECHO = 8,
+	__TCPOPT_KIND_MAX,
+
+	/* extra oob info, internal to nft */
+	TCPOPT_KIND_SACK1 = 256,
+	TCPOPT_KIND_SACK2 = 257,
+	TCPOPT_KIND_SACK3 = 258,
 };
 
 enum tcpopt_hdr_fields {
@@ -44,6 +45,6 @@ enum tcpopt_hdr_fields {
 	TCPOPTHDR_FIELD_TSECR,
 };
 
-extern const struct exthdr_desc *tcpopthdr_protocols[__TCPOPTHDR_MAX];
+extern const struct exthdr_desc *tcpopt_protocols[__TCPOPT_KIND_MAX];
 
 #endif /* NFTABLES_TCPOPT_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8c37f895167e..379a6acd18e6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -399,7 +399,7 @@ int nft_lex(void *, void *, void *);
 %token OPTION			"option"
 %token ECHO			"echo"
 %token EOL			"eol"
-%token NOOP			"noop"
+%token NOP			"nop"
 %token SACK			"sack"
 %token SACK0			"sack0"
 %token SACK1			"sack1"
@@ -5212,19 +5212,19 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 			|	URGPTR		{ $$ = TCPHDR_URGPTR; }
 			;
 
-tcp_hdr_option_type	:	EOL		{ $$ = TCPOPTHDR_EOL; }
-			|	NOOP		{ $$ = TCPOPTHDR_NOOP; }
-			|	MSS  	  	{ $$ = TCPOPTHDR_MAXSEG; }
-			|	SACK_PERM	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
-			|	WINDOW		{ $$ = TCPOPTHDR_WINDOW; }
-			|	WSCALE		{ $$ = TCPOPTHDR_WINDOW; }
-			|	SACK		{ $$ = TCPOPTHDR_SACK0; }
-			|	SACK0		{ $$ = TCPOPTHDR_SACK0; }
-			|	SACK1		{ $$ = TCPOPTHDR_SACK1; }
-			|	SACK2		{ $$ = TCPOPTHDR_SACK2; }
-			|	SACK3		{ $$ = TCPOPTHDR_SACK3; }
-			|	ECHO		{ $$ = TCPOPTHDR_ECHO; }
-			|	TIMESTAMP	{ $$ = TCPOPTHDR_TIMESTAMP; }
+tcp_hdr_option_type	:	EOL		{ $$ = TCPOPT_KIND_EOL; }
+			|	NOP		{ $$ = TCPOPT_KIND_NOP; }
+			|	MSS  	  	{ $$ = TCPOPT_KIND_MAXSEG; }
+			|	SACK_PERM	{ $$ = TCPOPT_KIND_SACK_PERMITTED; }
+			|	WINDOW		{ $$ = TCPOPT_KIND_WINDOW; }
+			|	WSCALE		{ $$ = TCPOPT_KIND_WINDOW; }
+			|	SACK		{ $$ = TCPOPT_KIND_SACK; }
+			|	SACK0		{ $$ = TCPOPT_KIND_SACK; }
+			|	SACK1		{ $$ = TCPOPT_KIND_SACK1; }
+			|	SACK2		{ $$ = TCPOPT_KIND_SACK2; }
+			|	SACK3		{ $$ = TCPOPT_KIND_SACK3; }
+			|	ECHO		{ $$ = TCPOPT_KIND_ECHO; }
+			|	TIMESTAMP	{ $$ = TCPOPT_KIND_TIMESTAMP; }
 			;
 
 tcp_hdr_option_field	:	KIND		{ $$ = TCPOPTHDR_FIELD_KIND; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 136239121427..c68b64d9f636 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -458,9 +458,9 @@ static int json_parse_tcp_option_type(const char *name, int *val)
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(tcpopthdr_protocols); i++) {
-		if (tcpopthdr_protocols[i] &&
-		    !strcmp(tcpopthdr_protocols[i]->name, name)) {
+	for (i = 0; i < array_size(tcpopt_protocols); i++) {
+		if (tcpopt_protocols[i] &&
+		    !strcmp(tcpopt_protocols[i]->name, name)) {
 			if (val)
 				*val = i;
 			return 0;
@@ -469,7 +469,7 @@ static int json_parse_tcp_option_type(const char *name, int *val)
 	/* special case for sack0 - sack3 */
 	if (sscanf(name, "sack%u", &i) == 1 && i < 4) {
 		if (val)
-			*val = TCPOPTHDR_SACK0 + i;
+			*val = TCPOPT_KIND_SACK + i;
 		return 0;
 	}
 	return 1;
@@ -478,7 +478,7 @@ static int json_parse_tcp_option_type(const char *name, int *val)
 static int json_parse_tcp_option_field(int type, const char *name, int *val)
 {
 	unsigned int i;
-	const struct exthdr_desc *desc = tcpopthdr_protocols[type];
+	const struct exthdr_desc *desc = tcpopt_protocols[type];
 
 	for (i = 0; i < array_size(desc->templates); i++) {
 		if (desc->templates[i].token &&
diff --git a/src/scanner.l b/src/scanner.l
index 516c648f1c1f..8bde1fbe912d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -423,7 +423,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "eol"			{ return EOL; }
 "maxseg"		{ return MSS; }
 "mss"			{ return MSS; }
-"noop"			{ return NOOP; }
+"nop"			{ return NOP; }
+"noop"			{ return NOP; }
 "sack"			{ return SACK; }
 "sack0"			{ return SACK0; }
 "sack1"			{ return SACK1; }
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 6dbaa9e6dd17..8d5bdec5399e 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -20,7 +20,7 @@ static const struct proto_hdr_template tcpopt_unknown_template =
 			   __offset, __len)
 static const struct exthdr_desc tcpopt_eol = {
 	.name		= "eol",
-	.type		= TCPOPT_EOL,
+	.type		= TCPOPT_KIND_EOL,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",  0,    8),
 	},
@@ -28,7 +28,7 @@ static const struct exthdr_desc tcpopt_eol = {
 
 static const struct exthdr_desc tcpopt_nop = {
 	.name		= "noop",
-	.type		= TCPOPT_NOP,
+	.type		= TCPOPT_KIND_NOP,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
 	},
@@ -36,7 +36,7 @@ static const struct exthdr_desc tcpopt_nop = {
 
 static const struct exthdr_desc tcptopt_maxseg = {
 	.name		= "maxseg",
-	.type		= TCPOPT_MAXSEG,
+	.type		= TCPOPT_KIND_MAXSEG,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
 		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
@@ -46,7 +46,7 @@ static const struct exthdr_desc tcptopt_maxseg = {
 
 static const struct exthdr_desc tcpopt_window = {
 	.name		= "window",
-	.type		= TCPOPT_WINDOW,
+	.type		= TCPOPT_KIND_WINDOW,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
 		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
@@ -56,7 +56,7 @@ static const struct exthdr_desc tcpopt_window = {
 
 static const struct exthdr_desc tcpopt_sack_permitted = {
 	.name		= "sack-perm",
-	.type		= TCPOPT_SACK_PERMITTED,
+	.type		= TCPOPT_KIND_SACK_PERMITTED,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0, 8),
 		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8, 8),
@@ -65,7 +65,7 @@ static const struct exthdr_desc tcpopt_sack_permitted = {
 
 static const struct exthdr_desc tcpopt_sack = {
 	.name		= "sack",
-	.type		= TCPOPT_SACK,
+	.type		= TCPOPT_KIND_SACK,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
 		[TCPOPTHDR_FIELD_LENGTH]		= PHT("length", 8,   8),
@@ -76,7 +76,7 @@ static const struct exthdr_desc tcpopt_sack = {
 
 static const struct exthdr_desc tcpopt_timestamp = {
 	.name		= "timestamp",
-	.type		= TCPOPT_TIMESTAMP,
+	.type		= TCPOPT_KIND_TIMESTAMP,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
 		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
@@ -86,19 +86,14 @@ static const struct exthdr_desc tcpopt_timestamp = {
 };
 #undef PHT
 
-#define TCPOPT_OBSOLETE ((struct exthdr_desc *)NULL)
-#define TCPOPT_ECHO 6
-#define TCPOPT_ECHO_REPLY 7
-static const struct exthdr_desc *tcpopt_protocols[] = {
-	[TCPOPT_EOL]		= &tcpopt_eol,
-	[TCPOPT_NOP]		= &tcpopt_nop,
-	[TCPOPT_MAXSEG]		= &tcptopt_maxseg,
-	[TCPOPT_WINDOW]		= &tcpopt_window,
-	[TCPOPT_SACK_PERMITTED]	= &tcpopt_sack_permitted,
-	[TCPOPT_SACK]		= &tcpopt_sack,
-	[TCPOPT_ECHO]		= TCPOPT_OBSOLETE,
-	[TCPOPT_ECHO_REPLY]	= TCPOPT_OBSOLETE,
-	[TCPOPT_TIMESTAMP]	= &tcpopt_timestamp,
+const struct exthdr_desc *tcpopt_protocols[] = {
+	[TCPOPT_KIND_EOL]		= &tcpopt_eol,
+	[TCPOPT_KIND_NOP]		= &tcpopt_nop,
+	[TCPOPT_KIND_MAXSEG]		= &tcptopt_maxseg,
+	[TCPOPT_KIND_WINDOW]		= &tcpopt_window,
+	[TCPOPT_KIND_SACK_PERMITTED]	= &tcpopt_sack_permitted,
+	[TCPOPT_KIND_SACK]		= &tcpopt_sack,
+	[TCPOPT_KIND_TIMESTAMP]		= &tcpopt_timestamp,
 };
 
 static unsigned int calc_offset(const struct exthdr_desc *desc,
@@ -136,51 +131,34 @@ static unsigned int calc_offset_reverse(const struct exthdr_desc *desc,
 	}
 }
 
-const struct exthdr_desc *tcpopthdr_protocols[__TCPOPTHDR_MAX] = {
-	[TCPOPTHDR_EOL]			= &tcpopt_eol,
-	[TCPOPTHDR_NOOP]		= &tcpopt_nop,
-	[TCPOPTHDR_MAXSEG]		= &tcptopt_maxseg,
-	[TCPOPTHDR_WINDOW]		= &tcpopt_window,
-	[TCPOPTHDR_SACK_PERMITTED]	= &tcpopt_sack_permitted,
-	[TCPOPTHDR_SACK0]		= &tcpopt_sack,
-	[TCPOPTHDR_SACK1]		= &tcpopt_sack,
-	[TCPOPTHDR_SACK2]		= &tcpopt_sack,
-	[TCPOPTHDR_SACK3]		= &tcpopt_sack,
-	[TCPOPTHDR_ECHO]		= TCPOPT_OBSOLETE,
-	[TCPOPTHDR_ECHO_REPLY]		= TCPOPT_OBSOLETE,
-	[TCPOPTHDR_TIMESTAMP]		= &tcpopt_timestamp,
-};
-
-static uint8_t tcpopt_optnum[] = {
-	[TCPOPTHDR_SACK0]	= 0,
-	[TCPOPTHDR_SACK1]	= 1,
-	[TCPOPTHDR_SACK2]	= 2,
-	[TCPOPTHDR_SACK3]	= 3,
-};
-
-static uint8_t tcpopt_find_optnum(uint8_t optnum)
-{
-	if (optnum > TCPOPTHDR_SACK3)
-		return 0;
-
-	return tcpopt_optnum[optnum];
-}
-
-struct expr *tcpopt_expr_alloc(const struct location *loc, uint8_t type,
-			       uint8_t field)
+struct expr *tcpopt_expr_alloc(const struct location *loc,
+			       unsigned int kind,
+			       unsigned int field)
 {
 	const struct proto_hdr_template *tmpl;
 	const struct exthdr_desc *desc;
+	uint8_t optnum = 0;
 	struct expr *expr;
-	uint8_t optnum;
 
-	desc = tcpopthdr_protocols[type];
+	switch (kind) {
+	case TCPOPT_KIND_SACK1:
+		kind = TCPOPT_KIND_SACK;
+		optnum = 1;
+		break;
+	case TCPOPT_KIND_SACK2:
+		kind = TCPOPT_KIND_SACK;
+		optnum = 2;
+		break;
+	case TCPOPT_KIND_SACK3:
+		kind = TCPOPT_KIND_SACK;
+		optnum = 3;
+	}
+
+	desc = tcpopt_protocols[kind];
 	tmpl = &desc->templates[field];
 	if (!tmpl)
 		return NULL;
 
-	optnum = tcpopt_find_optnum(type);
-
 	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
 			  BYTEORDER_BIG_ENDIAN, tmpl->len);
 	expr->exthdr.desc   = desc;
@@ -206,7 +184,7 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 	assert(type < array_size(tcpopt_protocols));
 	expr->exthdr.desc = tcpopt_protocols[type];
 	expr->exthdr.flags = flags;
-	assert(expr->exthdr.desc != TCPOPT_OBSOLETE);
+	assert(expr->exthdr.desc != NULL);
 
 	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
 		tmpl = &expr->exthdr.desc->templates[i];
-- 
2.26.2

