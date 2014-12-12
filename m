From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/6] parser: alloc specifying concat types in set declarations
Date: Fri, 12 Dec 2014 00:22:36 +0000
Message-ID: <1418343756-2886-7-git-send-email-kaber@trash.net>
References: <1418343756-2886-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57283 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbaLLAWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:22:46 -0500
In-Reply-To: <1418343756-2886-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support specification of concat types in set declarations:

add set filter test {
	type ipv4_addr . inet_service
}

Netlink delinearization is changed to reconstruct the type from the id.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c      |  2 ++
 src/parser_bison.y | 63 +++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index e59e297..feaea19 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -986,6 +986,8 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	case NFT_DATA_VERDICT:
 		return &verdict_type;
 	default:
+		if (type & ~TYPE_MASK)
+			return concat_type_alloc(type);
 		return datatype_lookup(type);
 	}
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 515a11a..c6d9104 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -132,6 +132,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct stmt		*stmt;
 	struct expr		*expr;
 	struct set		*set;
+	const struct datatype	*datatype;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -395,6 +396,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <string>			identifier string comment_spec
 %destructor { xfree($$); }	identifier string comment_spec
 
+%type <val>			type_identifier
+%type <datatype>		data_type
+
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
@@ -914,14 +918,9 @@ set_block_alloc		:	/* empty */
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
 			|	set_block	stmt_seperator
-			|	set_block	TYPE		identifier	stmt_seperator
+			|	set_block	TYPE		data_type	stmt_seperator
 			{
-				$1->keytype = datatype_lookup_byname($3);
-				if ($1->keytype == NULL) {
-					erec_queue(error(&@3, "unknown datatype %s", $3),
-						   state->msgs);
-					YYERROR;
-				}
+				$1->keytype = $3;
 				$$ = $1;
 			}
 			|	set_block	FLAGS		set_flag_list	stmt_seperator
@@ -959,23 +958,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_seperator
 			|	map_block	TYPE
-						identifier	COLON	identifier
+						data_type	COLON	data_type
 						stmt_seperator
 			{
-				$1->keytype = datatype_lookup_byname($3);
-				if ($1->keytype == NULL) {
-					erec_queue(error(&@3, "unknown datatype %s", $3),
-						   state->msgs);
-					YYERROR;
-				}
-
-				$1->datatype = datatype_lookup_byname($5);
-				if ($1->datatype == NULL) {
-					erec_queue(error(&@5, "unknown datatype %s", $5),
-						   state->msgs);
-					YYERROR;
-				}
-
+				$1->keytype  = $3;
+				$1->datatype = $5;
 				$$ = $1;
 			}
 			|	map_block	FLAGS		set_flag_list	stmt_seperator
@@ -1005,6 +992,38 @@ set_policy_spec		:	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
 			|	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
 			;
 
+data_type		:	type_identifier
+			{
+				if ($1 & ~TYPE_MASK)
+					$$ = concat_type_alloc($1);
+				else
+					$$ = datatype_lookup($1);
+			}
+			;
+
+type_identifier		:	identifier
+			{
+				const struct datatype *dtype = datatype_lookup_byname($1);
+				if (dtype == NULL) {
+					erec_queue(error(&@1, "unknown datatype %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+				$$ = dtype->type;
+			}
+			|	type_identifier	DOT		identifier
+			{
+				const struct datatype *dtype = datatype_lookup_byname($3);
+				if (dtype == NULL) {
+					erec_queue(error(&@3, "unknown datatype %s", $3),
+						   state->msgs);
+					YYERROR;
+				}
+				$$ <<= TYPE_BITS;
+				$$ |= dtype->type;
+			}
+			;
+
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
-- 
2.1.0

