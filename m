From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 nft] parser: Centralize commentary rule
Date: Mon, 30 May 2016 18:35:39 +0200
Message-ID: <1464626140-3449-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38497 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220AbcE3Qft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 12:35:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It make more sense if this rule can not be empty, so it can be used bot=
h as
mandatory as optional. The higher rule should choice use it in a way or=
 another.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/parser_bison.y | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ef10dee..6f51a49 100644
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
@@ -1273,11 +1273,7 @@ ruleid_spec		:	chain_spec	handle_spec	position_s=
pec
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
 				$$ =3D $2;
 			}
@@ -1295,12 +1291,21 @@ ruleset_spec		:	/* empty */
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
@@ -2029,9 +2034,9 @@ set_elem_option		:	TIMEOUT			time_spec
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
