From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH nft] parser: Check commentaries length
Date: Mon, 30 May 2016 17:41:00 +0200
Message-ID: <1464622860-31287-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50194 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220AbcE3PlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 11:41:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Checks the commentary maximum length and reports to user in case of err=
or.

The commentary rule of the parser was simplified in order to centralize=
 the
length checking.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/parser.h   |  6 ++++++
 src/parser_bison.y | 31 ++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 92beab2..f48fcfd 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -13,6 +13,12 @@
=20
 #define SCOPE_NEST_MAX			3
=20
+/*
+ * This maximum is set to 32 bytes in order to keep the coherence with=
 others
+ * string length in nft objects
+ */
+#define MAX_COMM_LEN			32
+
 struct parser_state {
 	struct input_descriptor		*indesc;
 	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0452b8f..c159684 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -440,7 +440,7 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
 %type <chain>			chain_block_alloc chain_block
 %destructor { close_scope(state); chain_free($$); }	chain_block_alloc
-%type <rule>			rule
+%type <rule>			rule rule_alloc
 %destructor { rule_free($$); }	rule
=20
 %type <val>			set_flag_list	set_flag
@@ -1271,12 +1271,13 @@ ruleid_spec		:	chain_spec	handle_spec	position_=
spec
 			}
 			;
=20
-comment_spec		:	/* empty */
-			{
-				$$ =3D NULL;
-			}
-			|	COMMENT		string
+comment_spec		:	COMMENT		string
 			{
+				if (strlen($2) > MAX_COMM_LEN) {
+					erec_queue(error(&@2, "Comment too long.  %d character maximun al=
lowed", MAX_COMM_LEN),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ =3D $2;
 			}
 			;
@@ -1293,18 +1294,26 @@ ruleset_spec		:	/* empty */
 			}
 			;
=20
-rule			:	stmt_list	comment_spec
+rule			:	rule_alloc
+			{
+				$$->comment =3D NULL;
+			}
+			|	rule_alloc	comment_spec
+			{
+				$$->comment =3D $2;
+			}
+			;
+
+rule_alloc		:	stmt_list
 			{
 				struct stmt *i;
=20
 				$$ =3D rule_alloc(&@$, NULL);
-				$$->comment =3D $2;
 				list_for_each_entry(i, $1, list)
 					$$->num_stmts++;
 				list_splice_tail($1, &$$->stmts);
 				xfree($1);
 			}
-			;
=20
 stmt_list		:	stmt
 			{
@@ -2027,9 +2036,9 @@ set_elem_option		:	TIMEOUT			time_spec
 			{
 				$<expr>0->timeout =3D $2 * 1000;
 			}
-			|	COMMENT			string
+			|	comment_spec
 			{
-				$<expr>0->comment =3D $2;
+				$<expr>0->comment =3D $1;
 			}
 			;
=20
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
