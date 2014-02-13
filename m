From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 12:41:12 +0100
Message-ID: <1392291672-7885-2-git-send-email-pablo@netfilter.org>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbaBMLlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:41:24 -0500
In-Reply-To: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hexstring:hexstring
hexstring:
:hexstring
---
The spaces to separate the key and the action in dictionaries is very
important, otherwise (with this patch) the scanner misinterprets this.

 # nft add filter input tcp dport vmap { 25:drop }
 <cmdline>:1:41-43: Error: syntax error, unexpected string, expecting comma or '}'
 add rule filter input tcp dport vmap { 25:drop }
                                        ^^^
I think we can just document this, I don't see any better solution for this
at this moment.

 src/scanner.l |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index e4cb398..ea61fa0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -109,7 +109,7 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
-range		({decstring}?:{decstring}?)
+priostring	{hexdigit}{0,4}:{hexdigit}{0,4}
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
@@ -447,6 +447,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{priostring}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
-- 
1.7.10.4

