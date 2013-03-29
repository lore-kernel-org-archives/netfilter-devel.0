From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] Fix a typo in src/expr/match
Date: Fri, 29 Mar 2013 16:34:27 +0100
Message-ID: <20130329153427.30122.66666.stgit@nfdev.cica.es>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44440 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755628Ab3C2Peb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:34:31 -0400
In-Reply-To: <20130329153155.30122.21803.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 src/expr/match.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

