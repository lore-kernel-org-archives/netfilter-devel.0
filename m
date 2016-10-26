From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] meta: allow resolving meta keys at run time
Date: Thu, 27 Oct 2016 00:36:08 +0200
Message-ID: <1477521368-12696-4-git-send-email-fw@strlen.de>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58160 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754604AbcJZWgC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 18:36:02 -0400
In-Reply-To: <1477521368-12696-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use the meta template to translate the textual token to the enum value.
This allows to remove two keywords from the scanner and also means we do
not need to introduce new keywords when more meta keys get added.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/meta.h     |  4 ++++
 src/meta.c         | 36 ++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 31 ++++++++++++++++++++++++++-----
 src/scanner.l      |  2 --
 4 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/include/meta.h b/include/meta.h
index f25b147a624f..c63787a7d1f0 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -30,4 +30,8 @@ struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type);
 
 const struct datatype ifindex_type;
 
+struct error_record *meta_type_get(const struct location *loc,
+				   const char *name,
+				   unsigned int *value);
+
 #endif /* NFTABLES_META_H */
diff --git a/src/meta.c b/src/meta.c
index 34f9ee8e36e2..972a84cf6978 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -638,3 +638,39 @@ struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type)
 	dep = relational_expr_alloc(loc, OP_EQ, left, right);
 	return expr_stmt_alloc(&dep->location, dep);
 }
+
+struct error_record *meta_type_get(const struct location *loc,
+                                   const char *str,
+                                   unsigned int *value)
+{
+	int ret, len, offset = 0;
+	const char *sep = "";
+	unsigned int i;
+	char buf[1024];
+	size_t size;
+
+	for (i = 0; i < array_size(meta_templates); i++) {
+		if (!meta_templates[i].token || strcmp(meta_templates[i].token, str))
+			continue;
+
+		*value = i;
+		return NULL;
+	}
+
+	len = (int)sizeof(buf);
+	size = sizeof(buf);
+
+	for (i = 0; i < array_size(meta_templates); i++) {
+		if (!meta_templates[i].token)
+			continue;
+
+		if (offset)
+			sep = ", ";
+
+		ret = snprintf(buf+offset, len, "%s%s", sep, meta_templates[i].token);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		assert(offset < (int)sizeof(buf));
+	}
+
+	return error(loc, "Could not parse %s, known meta keys are: %s", str, buf);
+}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 03cf590272e8..23982c132f8b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -319,8 +319,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MH			"mh"
 
 %token META			"meta"
-%token NFPROTO			"nfproto"
-%token L4PROTO			"l4proto"
 %token MARK			"mark"
 %token IIF			"iif"
 %token IIFNAME			"iifname"
@@ -2426,15 +2424,25 @@ meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $1);
 			}
-			;
+			|	META	STRING
+			{
+				struct error_record *erec;
+				unsigned int key;
+
+				erec = meta_type_get(&@$, $2, &key);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = meta_expr_alloc(&@$, key);
+			}
 
 meta_key		:	meta_key_qualified
 			|	meta_key_unqualified
 			;
 
 meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
-			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
-			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
 			|	RANDOM		{ $$ = NFT_META_PRANDOM; }
@@ -2468,6 +2476,19 @@ meta_stmt		:	META	meta_key	SET	expr
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
+			|	META	STRING	SET	expr
+			{
+				struct error_record *erec;
+				unsigned int key;
+
+				erec = meta_type_get(&@$, $2, &key);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = meta_stmt_alloc(&@$, key, $4);
+			}
 			;
 
 numgen_type		:	INC		{ $$ = NFT_NG_INCREMENTAL; }
diff --git a/src/scanner.l b/src/scanner.l
index f11f06506f6c..4dd7d0c9820a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -435,8 +435,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "mh"			{ return MH; }
 
 "meta"			{ return META; }
-"nfproto"		{ return NFPROTO; }
-"l4proto"		{ return L4PROTO; }
 "mark"			{ return MARK; }
 "iif"			{ return IIF; }
 "iifname"		{ return IIFNAME; }
-- 
2.7.3

