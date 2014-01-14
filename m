From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] scanner: add aliases to symbols for easier interaction with most shells
Date: Tue, 14 Jan 2014 15:55:14 +0100
Message-ID: <1389711314-9008-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaANOzb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:55:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These symbols need to be escaped in bash and if you use them without
escaping then, it can lead to confusion. This patch adds nominal
aliases, eg.

 nft add rule filter output meta mark and 0x3 eq 0x1

as an alternative to:

 nft add rule filter output meta mark \& 0x3 == 0x1

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/scanner.l b/src/scanner.l
index ee71492..50e24a4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -182,11 +182,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %%
 
 "=="			{ return EQ; }
+"eq"			{ return EQ; }
 "!="			{ return NEQ; }
+"ne"			{ return NEQ; }
 "<="			{ return LTE; }
+"le"			{ return LTE; }
 "<"			{ return LT; }
+"lt"			{ return LT; }
 ">="			{ return GTE; }
+"ge"			{ return GTE; }
 ">"			{ return GT; }
+"gt"			{ return GT; }
 ","			{ return COMMA; }
 "."			{ return DOT; }
 ":"			{ return COLON; }
@@ -198,11 +204,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "("			{ return '('; }
 ")"			{ return ')'; }
 "<<"			{ return LSHIFT; }
+"lshift"		{ return LSHIFT; }
 ">>"			{ return RSHIFT; }
+"rshift"		{ return RSHIFT; }
 "^"			{ return CARET; }
+"xor"			{ return CARET; }
 "&"			{ return AMPERSAND; }
+"and"			{ return AMPERSAND; }
 "|"			{ return '|'; }
+"or"			{ return '|'; }
 "!"			{ return NOT; }
+"not"			{ return NOT; }
 "/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
-- 
1.7.10.4

