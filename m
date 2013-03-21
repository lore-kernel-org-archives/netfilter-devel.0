From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [PATCH] expr: match: fix typo in function name
Date: Thu, 21 Mar 2013 18:56:38 +0100
Message-ID: <20130321175637.5783.35022.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MIMEBOUNDARY
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52836 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751629Ab3CUSsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:48:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a MIME message.

--MIMEBOUNDARY
Content-Disposition: inline
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


---
 src/expr/match.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--MIMEBOUNDARY
Content-Disposition: attachment; filename=rule-expr-match-fix-typo-in-fu.patch
MIME-Version: 1.0
Content-Type: text/plain; name=rule-expr-match-fix-typo-in-fu.patch;
	charset="utf-8"
Content-Transfer-Encoding: 7bit

diff --git a/src/expr/match.c b/src/expr/match.c
index 9ae849b..f83a8ea 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -185,7 +185,7 @@ static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *att
 }
 
 static
-int nft_rule_exp_match_snprintf_xml(char *buf, size_t len,
+int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 				struct nft_expr_match *mt)
 {
 	int ret, size=len;
@@ -217,7 +217,7 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_exp_match_snprintf_xml(buf, len, match);
+		return nft_rule_expr_match_snprintf_xml(buf, len, match);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "name=%s rev=%u ",
 				match->name, match->rev);

--MIMEBOUNDARY--
