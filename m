From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] parser_bison: fix typo in symbol redefinition error reporting
Date: Wed, 13 Jul 2016 16:59:41 +0200
Message-ID: <1468421982-2620-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60891 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbcGMPAE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2016 11:00:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 85E572519A8
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 78D019EBCB
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3DB1026674D
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:46 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"redefinition" instead of "redfinition".

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d946e0e..6a029d1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -635,7 +635,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 				struct scope *scope = current_scope(state);
 
 				if (symbol_lookup(scope, $2) != NULL) {
-					erec_queue(error(&@2, "redfinition of symbol '%s'", $2),
+					erec_queue(error(&@2, "redefinition of symbol '%s'", $2),
 						   state->msgs);
 					YYERROR;
 				}
-- 
2.1.4

