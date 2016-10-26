From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] ct: allow resolving ct keys at run time
Date: Thu, 27 Oct 2016 00:36:07 +0200
Message-ID: <1477521368-12696-3-git-send-email-fw@strlen.de>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58158 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754395AbcJZWf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 18:35:59 -0400
In-Reply-To: <1477521368-12696-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... and remove those keywords we no longer need.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ct.h       |  2 ++
 src/ct.c           | 35 +++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 36 +++++++++++++++++++++++++++---------
 src/scanner.l      |  6 ------
 tests/py/any/ct.t  |  5 +++++
 5 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 945fcc4d829d..0aeeed60bfaa 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -29,4 +29,6 @@ extern void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr);
 
 extern struct error_record *ct_dir_parse(const struct location *loc,
 					 const char *str, int8_t *dir);
+extern struct error_record *ct_key_parse(const struct location *loc, const char *str,
+					 unsigned int *key);
 #endif /* NFTABLES_CT_H */
diff --git a/src/ct.c b/src/ct.c
index a68293896ed6..d50c92616afa 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -306,6 +306,41 @@ struct error_record *ct_dir_parse(const struct location *loc, const char *str,
 	return error(loc, "Could not parse direction %s", str);
 }
 
+struct error_record *ct_key_parse(const struct location *loc, const char *str,
+				  unsigned int *key)
+{
+	int ret, len, offset = 0;
+	const char *sep = "";
+	unsigned int i;
+	char buf[1024];
+	size_t size;
+
+	for (i = 0; i < array_size(ct_templates); i++) {
+		if (!ct_templates[i].token || strcmp(ct_templates[i].token, str))
+			continue;
+
+		*key = i;
+		return NULL;
+	}
+
+	len = (int)sizeof(buf);
+	size = sizeof(buf);
+
+	for (i = 0; i < array_size(ct_templates); i++) {
+		if (!ct_templates[i].token)
+			continue;
+
+		if (offset)
+			sep = ", ";
+
+		ret = snprintf(buf+offset, len, "%s%s", sep, ct_templates[i].token);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		assert(offset < (int)sizeof(buf));
+	}
+
+	return error(loc, "Could not parse %s, known ct keys are: %s", str, buf);
+}
+
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			   int8_t direction)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index baf0a539efa0..03cf590272e8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2491,6 +2491,19 @@ ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
+			| 	CT	STRING
+			{
+				struct error_record *erec;
+				unsigned int key;
+
+				erec = ct_key_parse(&@$, $2, &key);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = ct_expr_alloc(&@$, key, -1);
+			}
 			|	CT	STRING	ct_key_dir
 			{
 				struct error_record *erec;
@@ -2506,15 +2519,7 @@ ct_expr			: 	CT	ct_key
 			}
 			;
 
-ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
-			|	DIRECTION	{ $$ = NFT_CT_DIRECTION; }
-			|	STATUS		{ $$ = NFT_CT_STATUS; }
-			|	MARK		{ $$ = NFT_CT_MARK; }
-			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
-			|	HELPER		{ $$ = NFT_CT_HELPER; }
-			|	LABEL		{ $$ = NFT_CT_LABELS; }
-			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
-			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
+ct_key			:	MARK		{ $$ = NFT_CT_MARK; }
 			|	ct_key_counters
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
@@ -2534,6 +2539,19 @@ ct_stmt			:	CT	ct_key		SET	expr
 			{
 				$$ = ct_stmt_alloc(&@$, $2, $4);
 			}
+			|	CT	STRING		SET	expr
+			{
+				struct error_record *erec;
+				unsigned int key;
+
+				erec = ct_key_parse(&@$, $2, &key);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = ct_stmt_alloc(&@$, key, $4);
+			}
 			;
 
 payload_stmt		:	payload_expr		SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383bd095..f11f06506f6c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -457,15 +457,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "cgroup"		{ return CGROUP; }
 
 "ct"			{ return CT; }
-"direction"		{ return DIRECTION; }
-"state"			{ return STATE; }
-"status"		{ return STATUS; }
-"expiration"		{ return EXPIRATION; }
-"helper"		{ return HELPER; }
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
-"label"			{ return LABEL; }
 
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 7fd4f2cbdc9a..cc4f8e19c619 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -96,3 +96,8 @@ ct mark original;fail
 ct label 127;ok
 ct label set 127;ok
 ct label 128;fail
+
+ct invalid;fail
+ct invalid original;fail
+ct set invalid original 42;fail
+ct set invalid 42;fail
-- 
2.7.3

