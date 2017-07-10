From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 3/7] parser: fix bison warnings
Date: Tue, 11 Jul 2017 00:32:51 +0200
Message-ID: <20170710223255.29885-4-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41138 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754106AbdGJWdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:16 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We had the following warnings

parser_bison.y:1089:10: warning: variable 'cmd' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                                        if (erec != NULL) {
                                            ^~~~~~~~~~~~
parser_bison.y:1095:39: note: uninitialized use occurs here
                                (yyval.cmd) = cmd_alloc(CMD_LIST, cmd, &(yyvsp[0].handle), &(yyloc), NULL);
                                                                  ^~~
parser_bison.y:1089:6: note: remove the 'if' if its condition is always true
                                        if (erec != NULL) {
                                        ^~~~~~~~~~~~~~~~~~
parser_bison.y:1080:12: note: initialize the variable 'cmd' to silence this warning
                                int cmd;
                                       ^
                                        = 0

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/parser_bison.y | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c505a04..b898e1c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1089,7 +1089,8 @@ list_cmd		:	TABLE		table_spec
 					if (erec != NULL) {
 						erec_queue(erec, state->msgs);
 						YYERROR;
-					}
+					} else
+						YYERROR;
 				}
 
 				$$ = cmd_alloc(CMD_LIST, cmd, &$4, &@$, NULL);
-- 
2.13.2

