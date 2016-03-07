From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] parser: remove 'reset' as reserve keyword
Date: Mon,  7 Mar 2016 13:37:47 +0100
Message-ID: <1457354268-11240-1-git-send-email-pablo@netfilter.org>
Cc: shivanib134@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53731 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbcCGMiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 07:38:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 13EB54B0FB
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04808DA390
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C86528D221
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 13:38:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The 'reset' keyword can be used as dccp type, so don't qualify it as
reserve keyword to avoid a conflict with this.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1055
Reported-by: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 11 ++++++++---
 src/scanner.l      |  1 -
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d41fc0a..3f22639 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -380,7 +380,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
-%token RESET			"reset"
 %token WITH			"with"
 %token ICMPX			"icmpx"
 
@@ -1573,9 +1572,15 @@ reject_opts		:       /* empty */
 							  $4);
 				$<stmt>0->reject.expr->dtype = &icmpx_code_type;
 			}
-			|	WITH	TCP	RESET
+			|	WITH	TCP	STRING
 			{
-				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
+				if (strcmp($3, "reset") == 0) {
+					$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
+				} else {
+					erec_queue(error(&@2, "unsupported reject type", $3),
+						   state->msgs);
+					YYERROR;
+				}
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index a0dee47..60b61a5 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -326,7 +326,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "reject"		{ return _REJECT; }
 "with"			{ return WITH; }
-"reset"			{ return RESET; }
 "icmpx"			{ return ICMPX; }
 
 "snat"			{ return SNAT; }
-- 
2.1.4

