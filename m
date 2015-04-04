From: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sat,  4 Apr 2015 13:13:06 +0200
Message-ID: <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
References: <551FC211.6000907@ahsoftware.de>
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>,
	Alexander Holler <holler@ahsoftware.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:52107 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbDDLNY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2015 07:13:24 -0400
Received: from wandq.ahsoftware (p4FC37AA6.dip0.t-ipconnect.de [79.195.122.166])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 24B8A2C9C1CA
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2015 13:13:22 +0200 (CEST)
In-Reply-To: <551FC211.6000907@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Context sensitive handling of "param-problem" and "redirect" is necessary
to allow usage of them as token or as string for icmp types.

Without this patch, e.g. the following fails:

nft add rule filter input icmp type redirect accept
nft add rule filter input icmpv6 type param-problem accept

And, worse, saving and restoring rules might fail. E.g. if the following
was used:

nft add rule filter input icmp type 5 accept

'nft list table filter' would show it using the type name "redirect" instead
of the the number, which means you could not use the output of 'nft list' to
restore the rules.

I've tested the patch using the following script:

---------------------
flush ruleset

table filter {
	chain input {
		type filter hook input priority 0;
		icmp type redirect accept
		tcp dport 22223 reject with icmp type host-prohibited
	}
}
table ip6 filter {
	chain input {
		type filter hook input priority 0;
		icmpv6 type param-problem accept
		tcp dport 22224 reject with icmpv6 type admin-prohibited
		icmpv6 param-problem 2 drop
	}
}
table nat {
	chain prerouting {
		type nat hook prerouting priority 0;
		tcp dport 22222 redirect to 22
	}
	chain postrouting {
		type nat hook postrouting priority 0;
	}
}
---------------------

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 src/parser_bison.y |  8 +++++---
 src/scanner.l      | 30 ++++++++++++++++++++++++------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b86381d..af40195 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -34,6 +34,8 @@
 
 #include "parser_bison.h"
 
+int icmp_flag;
+
 void parser_init(struct parser_state *state, struct list_head *msgs)
 {
 	memset(state, 0, sizeof(*state));
@@ -445,7 +447,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	limit_stmt
 %type <val>			time_unit
 %type <stmt>			reject_stmt reject_stmt_alloc
-%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
+%destructor { stmt_free($$); icmp_flag = 0; }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %type <val>			nf_nat_flags nf_nat_flag
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
index 73c4f8b..3a058ad 100644
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
@@ -334,8 +342,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ether"			{ return ETHER; }
 "saddr"			{ return SADDR; }
 "daddr"			{ return DADDR; }
-"type"			{ return TYPE; }
-
+"type"			{
+				if (icmp_flag)
+					++icmp_flag;
+				return TYPE;
+			}
 "vlan"			{ return VLAN; }
 "id"			{ return ID; }
 "cfi"			{ return CFI; }
@@ -358,7 +369,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
-"icmp"			{ return ICMP; }
+"icmp"			{ icmp_flag = 3; return ICMP; }
 "code"			{ return CODE; }
 "sequence"		{ return SEQUENCE; }
 "gateway"		{ return GATEWAY; }
@@ -369,9 +380,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flowlabel"		{ return FLOWLABEL; }
 "nexthdr"		{ return NEXTHDR; }
 "hoplimit"		{ return HOPLIMIT; }
+"icmpv6"		{ icmp_flag = 5; return ICMP6; }
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

