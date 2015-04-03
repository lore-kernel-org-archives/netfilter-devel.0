From: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] parser: add kludges for "param-problem" and "redirect"
Date: Fri,  3 Apr 2015 19:50:29 +0200
Message-ID: <1428083429-7042-1-git-send-email-holler@ahsoftware.de>
References: <551BEF7F.3050908@ahsoftware.de>
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>,
	Alexander Holler <holler@ahsoftware.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:54115 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbDCRvy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2015 13:51:54 -0400
Received: from wandq.ahsoftware (p4FC37D76.dip0.t-ipconnect.de [79.195.125.118])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id A8FF82C9C1C6
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2015 19:51:51 +0200 (CEST)
In-Reply-To: <551BEF7F.3050908@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Context sensitive handling of "param-problem" and "redirect" is necessary
to allow usage of them as token or as string for icmp types.

Without this patch, e.g. the following fails:

nft add rule filter input icmp type redirect accept
nft add rule filter input icmpv6 type param-problem accept

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 src/parser_bison.y |  6 ++++--
 src/scanner.l      | 23 +++++++++++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b86381d..36a71d0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -34,6 +34,8 @@
 
 #include "parser_bison.h"
 
+int icmp_flag;
+
 void parser_init(struct parser_state *state, struct list_head *msgs)
 {
 	memset(state, 0, sizeof(*state));
@@ -500,10 +502,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	arp_hdr_expr
 %type <val>			arp_hdr_field
 %type <expr>			ip_hdr_expr	icmp_hdr_expr
-%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr
+%destructor { expr_free($$); icmp_flag = 0; }	ip_hdr_expr	icmp_hdr_expr
 %type <val>			ip_hdr_field	icmp_hdr_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
-%destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
+%destructor { expr_free($$); icmp_flag = 0; }	ip6_hdr_expr	icmp6_hdr_expr
 %type <val>			ip6_hdr_field   icmp6_hdr_field
 %type <expr>			auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
 %destructor { expr_free($$); }	auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..3468276 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -100,6 +100,7 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 /* avoid warnings with -Wmissing-prototypes */
 extern int	yyget_column(yyscan_t);
 extern void	yyset_column(int, yyscan_t);
+extern int icmp_flag;
 
 %}
 
@@ -320,7 +321,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
 "masquerade"		{ return MASQUERADE; }
-"redirect"		{ return REDIRECT; }
+"redirect"		{
+				if (icmp_flag == 4) {
+					yylval->string = xstrdup(yytext);
+					return STRING;
+				} else
+					return REDIRECT;
+			}
+
 "random"		{ return RANDOM; }
 "fully-random"		{ return FULLY_RANDOM; }
 "persistent"		{ return PERSISTENT; }
@@ -358,7 +366,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
-"icmp"			{ return ICMP; }
+"icmp"			{ icmp_flag = 4; return ICMP; }
 "code"			{ return CODE; }
 "sequence"		{ return SEQUENCE; }
 "gateway"		{ return GATEWAY; }
@@ -369,9 +377,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flowlabel"		{ return FLOWLABEL; }
 "nexthdr"		{ return NEXTHDR; }
 "hoplimit"		{ return HOPLIMIT; }
+"icmpv6"		{ icmp_flag = 6; return ICMP6; }
+"param-problem"		{
+				if (icmp_flag == 6) {
+					yylval->string = xstrdup(yytext);
+					return STRING;
+				} else
+					return PPTR;
+			}
+
 
-"icmpv6"		{ return ICMP6; }
-"param-problem"		{ return PPTR; }
 "max-delay"		{ return MAXDELAY; }
 
 "ah"			{ return AH; }
-- 
2.1.0

