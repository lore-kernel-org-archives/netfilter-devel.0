From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: allow to use mark as datatype for maps and sets
Date: Tue, 16 Jun 2015 17:52:13 +0200
Message-ID: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, exa.exa@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56295 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848AbbFPPrA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:47:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update the grammar to accept a MARK token as datatype.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1012
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick: I think you prefer this update rather than renaming this to
packetmark. This comes in response to this patch proposal:
http://patchwork.ozlabs.org/patch/485058/

 src/parser_bison.y |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 89874e9..6f47745 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -398,12 +398,12 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token XML			"xml"
 %token JSON			"json"
 
-%type <string>			identifier string comment_spec
-%destructor { xfree($$); }	identifier string comment_spec
+%type <string>			identifier type_identifier string comment_spec
+%destructor { xfree($$); }	identifier type_identifier string comment_spec
 
 %type <val>			time_spec
 
-%type <val>			type_identifier
+%type <val>			type_identifier_list
 %type <datatype>		data_type
 
 %type <cmd>			line
@@ -1028,7 +1028,7 @@ set_policy_spec		:	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
 			|	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
 			;
 
-data_type		:	type_identifier
+data_type		:	type_identifier_list
 			{
 				if ($1 & ~TYPE_MASK)
 					$$ = concat_type_alloc($1);
@@ -1037,7 +1037,7 @@ data_type		:	type_identifier
 			}
 			;
 
-type_identifier		:	identifier
+type_identifier_list	:	type_identifier
 			{
 				const struct datatype *dtype = datatype_lookup_byname($1);
 				if (dtype == NULL) {
@@ -1047,7 +1047,7 @@ type_identifier		:	identifier
 				}
 				$$ = dtype->type;
 			}
-			|	type_identifier	DOT		identifier
+			|	type_identifier_list	DOT	type_identifier
 			{
 				const struct datatype *dtype = datatype_lookup_byname($3);
 				if (dtype == NULL) {
@@ -1059,6 +1059,10 @@ type_identifier		:	identifier
 			}
 			;
 
+type_identifier		:	STRING	{ $$ = $1; }
+			|	MARK	{ $$ = xstrdup("mark"); }
+			;
+
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
-- 
1.7.10.4

