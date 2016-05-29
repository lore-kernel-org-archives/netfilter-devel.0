From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 1/3] datatype: fix parsing of tchandle type
Date: Sun, 29 May 2016 18:08:07 +0800
Message-ID: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:35966 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbcE2KJM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2016 06:09:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Properly detect tchandle strings in the lexer without quotation marks,
otherwise nft will complain the syntax error like this:

  # nft add rule filter test meta priority set 1:2
  <cmdline>:1:41-41: Error: syntax error, unexpected colon, expecting end of file or newline or semicolon
  add rule filter test meta priority set 1:2
                                          ^

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/scanner.l | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/scanner.l b/src/scanner.l
index b022114..9ca6d4d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -120,6 +120,8 @@ slash		\/
 
 timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?
 
+tchstring	([[:xdigit:]]{0,4}:[[:xdigit:]]{0,4})
+
 hex4		([[:xdigit:]]{1,4})
 v680		(({hex4}:){7}{hex4})
 v670		((:)((:{hex4}){7}))
@@ -479,6 +481,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{tchstring}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
 {decstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-- 
2.5.5


