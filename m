From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 04/10] parser: add a time_spec rule
Date: Sun, 12 Apr 2015 13:16:12 +0100
Message-ID: <1428840978-27226-5-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58911 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbDLMQY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:24 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser_bison.y | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b86381d..cd4e096 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -396,6 +396,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <string>			identifier string comment_spec
 %destructor { xfree($$); }	identifier string comment_spec
 
+%type <val>			time_spec
+
 %type <val>			type_identifier
 %type <datatype>		data_type
 
@@ -1093,6 +1095,20 @@ string			:	STRING
 			|	QUOTED_STRING
 			;
 
+time_spec		:	STRING
+			{
+				struct error_record *erec;
+				uint64_t res;
+
+				erec = time_parse(&@1, $1, &res);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = res;
+			}
+			;
+
 family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 			|	family_spec_explicit
 			;
-- 
2.1.0

