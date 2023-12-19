Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA18A1CAA2
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2023 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFbvd-0008UJ-Rj; Tue, 19 Dec 2023 16:22:41 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: error out on duplicated type/typeof/element keywords
Date: Tue, 19 Dec 2023 16:22:32 +0100
Message-ID: <20231219152235.13511-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise nft will leak the previous definition (expressions).
Also remove the nonsensical

   datatype_set($1->key, $3->dtype);

This is a no-op, at this point: $1->key and $3 are identical.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8f4182c9b296..86fb9f077db8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2174,11 +2174,20 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	stmt_separator
 			|	set_block	TYPE		data_type_expr	stmt_separator	close_scope_type
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					YYERROR;
+				}
+
 				$1->key = $3;
 				$$ = $1;
 			}
 			|	set_block	TYPEOF		typeof_expr	stmt_separator
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					YYERROR;
+				}
 				$1->key = $3;
 				datatype_set($1->key, $3->dtype);
 				$$ = $1;
@@ -2206,6 +2215,10 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	set_block	ELEMENTS	'='		set_block_expr
 			{
+				if (already_set($1->init, &@2, state)) {
+					expr_free($4);
+					YYERROR;
+				}
 				$1->init = $4;
 				$$ = $1;
 			}
@@ -2277,6 +2290,12 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 						data_type_expr	COLON	map_block_data_interval data_type_expr
 						stmt_separator	close_scope_type
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					expr_free($6);
+					YYERROR;
+				}
+
 				$1->key = $3;
 				$1->data = $6;
 				$1->data->flags |= $5;
@@ -2288,8 +2307,13 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 						typeof_expr	COLON	typeof_data_expr
 						stmt_separator
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					expr_free($5);
+					YYERROR;
+				}
+
 				$1->key = $3;
-				datatype_set($1->key, $3->dtype);
 				$1->data = $5;
 
 				$1->flags |= NFT_SET_MAP;
@@ -2299,8 +2323,13 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 						typeof_expr	COLON	INTERVAL	typeof_expr
 						stmt_separator
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					expr_free($6);
+					YYERROR;
+				}
+
 				$1->key = $3;
-				datatype_set($1->key, $3->dtype);
 				$1->data = $6;
 				$1->data->flags |= EXPR_F_INTERVAL;
 
@@ -2311,6 +2340,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 						data_type_expr	COLON	map_block_obj_type
 						stmt_separator	close_scope_type
 			{
+				if (already_set($1->key, &@2, state)) {
+					expr_free($3);
+					YYERROR;
+				}
+
 				$1->key = $3;
 				$1->objtype = $5;
 				$1->flags  |= NFT_SET_OBJECT;
-- 
2.41.0

