From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 03/17] parser: use scanner tokens again for ct key handling
Date: Wed, 28 Jun 2017 12:06:45 +0200
Message-ID: <20170628100659.26976-4-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33348 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KGv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:51 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This partially reverts commit
c992153402c78d91e8beba791171bced21c62d3f
("ct: allow resolving ct keys at run time").

It was a bad idea; problem is that if we want to support
a syntax like

ct origin ip saddr @foo

(to indicate that we want to match ip addresses, not ipv6), then we get
a failure here because "ip" is a token and not a string.

We could work around this by convertig ip to a string in that case
but thats worse than using tokens again.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ct.h       |  2 --
 src/ct.c           | 35 -----------------------------------
 src/parser_bison.y | 54 ++++++++++++++++++++++--------------------------------
 src/scanner.l      |  6 ++++++
 4 files changed, 28 insertions(+), 69 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index ae900ee4fb61..69ccc913dd74 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -29,8 +29,6 @@ extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct error_record *ct_dir_parse(const struct location *loc,
 					 const char *str, int8_t *dir);
-extern struct error_record *ct_key_parse(const struct location *loc, const char *str,
-					 unsigned int *key);
 extern struct error_record *ct_objtype_parse(const struct location *loc, const char *str, int *type);
 
 extern struct stmt *notrack_stmt_alloc(const struct location *loc);
diff --git a/src/ct.c b/src/ct.c
index 87fe08bc62f8..f76f7867a77d 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -349,41 +349,6 @@ struct error_record *ct_dir_parse(const struct location *loc, const char *str,
 	return error(loc, "Could not parse direction %s", str);
 }
 
-struct error_record *ct_key_parse(const struct location *loc, const char *str,
-				  unsigned int *key)
-{
-	int ret, len, offset = 0;
-	const char *sep = "";
-	unsigned int i;
-	char buf[1024];
-	size_t size;
-
-	for (i = 0; i < array_size(ct_templates); i++) {
-		if (!ct_templates[i].token || strcmp(ct_templates[i].token, str))
-			continue;
-
-		*key = i;
-		return NULL;
-	}
-
-	len = (int)sizeof(buf);
-	size = sizeof(buf);
-
-	for (i = 0; i < array_size(ct_templates); i++) {
-		if (!ct_templates[i].token)
-			continue;
-
-		if (offset)
-			sep = ", ";
-
-		ret = snprintf(buf+offset, len, "%s%s", sep, ct_templates[i].token);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		assert(offset < (int)sizeof(buf));
-	}
-
-	return error(loc, "syntax error, unexpected %s, known keys are %s", str, buf);
-}
-
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			   int8_t direction)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 79918399368e..86f0464295eb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -379,6 +379,12 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
 %token ZONE			"zone"
+%token DIRECTION		"direction"
+%token STATE			"state"
+%token STATUS			"status"
+%token EXPIRATION		"expiration"
+%token LABEL			"label"
+%token EVENT			"event"
 
 %token COUNTER			"counter"
 %token NAME			"name"
@@ -3082,19 +3088,6 @@ ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
-			| 	CT	STRING
-			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = ct_key_parse(&@$, $2, &key);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = ct_expr_alloc(&@$, key, -1);
-			}
 			|	CT	STRING	ct_key_dir
 			{
 				struct error_record *erec;
@@ -3110,18 +3103,25 @@ ct_expr			: 	CT	ct_key
 			}
 			;
 
-ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
-			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
+ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
+			|	DIRECTION	{ $$ = NFT_CT_DIRECTION; }
+			|	STATUS		{ $$ = NFT_CT_STATUS; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
+			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
+			|	LABEL		{ $$ = NFT_CT_LABELS; }
+			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
+			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
+			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
 			|	ct_key_dir_optional
 			;
-ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
-			|	DADDR		{ $$ = NFT_CT_DST; }
-			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
+
+ct_key_dir		:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
+			|	SADDR		{ $$ = NFT_CT_SRC; }
+			|	DADDR		{ $$ = NFT_CT_DST; }
 			|	ct_key_dir_optional
 			;
 
@@ -3149,9 +3149,11 @@ ct_stmt_expr		:	expr
 			|	list_stmt_expr
 			;
 
-ct_stmt			:	CT	ct_key		SET	expr
+ct_stmt			:	CT	ct_key		SET	ct_stmt_expr
 			{
-				switch ($2) {
+				unsigned int key = $2;
+
+				switch (key) {
 				case NFT_CT_HELPER:
 					$$ = objref_stmt_alloc(&@$);
 					$$->objref.type = NFT_OBJECT_CT_HELPER;
@@ -3162,18 +3164,6 @@ ct_stmt			:	CT	ct_key		SET	expr
 					break;
 				}
 			}
-			|	CT	STRING		SET	ct_stmt_expr
-			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = ct_key_parse(&@$, $2, &key);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-				$$ = ct_stmt_alloc(&@$, key, -1, $4);
-			}
 			|	CT	STRING	ct_key_dir_optional SET	expr
 			{
 				struct error_record *erec;
diff --git a/src/scanner.l b/src/scanner.l
index c0c48a0dea29..f7717eb92f33 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -483,6 +483,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
 "zone"			{ return ZONE; }
+"direction"		{ return DIRECTION; }
+"state"			{ return STATE; }
+"status"		{ return STATUS; }
+"expiration"		{ return EXPIRATION; }
+"event"			{ return EVENT; }
+"label"			{ return LABEL; }
 
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
-- 
2.13.0

