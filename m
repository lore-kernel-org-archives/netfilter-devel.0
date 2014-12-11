From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] stmt: rename nat "random-fully" option to "fully-random"
Date: Thu, 11 Dec 2014 22:07:21 +0000
Message-ID: <1418335641-24383-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbaLKWHo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:07:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use proper english for full randomization option.

Signed-off-by: Patrick McHardy
---
 src/parser_bison.y | 4 ++--
 src/scanner.l      | 2 +-
 src/statement.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6c7a036..515a11a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -378,7 +378,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MASQUERADE		"masquerade"
 %token REDIRECT			"redirect"
 %token RANDOM			"random"
-%token RANDOM_FULLY		"random-fully"
+%token FULLY_RANDOM		"fully-random"
 %token PERSISTENT		"persistent"
 
 %token QUEUE			"queue"
@@ -1462,7 +1462,7 @@ nf_nat_flags		:	nf_nat_flag
 			;
 
 nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
-			|	RANDOM_FULLY	{ $$ = NF_NAT_RANGE_PROTO_RANDOM_FULLY; }
+			|	FULLY_RANDOM	{ $$ = NF_NAT_RANGE_PROTO_RANDOM_FULLY; }
 			|	PERSISTENT 	{ $$ = NF_NAT_RANGE_PERSISTENT; }
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 72b5447..1723159 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -321,7 +321,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "masquerade"		{ return MASQUERADE; }
 "redirect"		{ return REDIRECT; }
 "random"		{ return RANDOM; }
-"random-fully"		{ return RANDOM_FULLY; }
+"fully-random"		{ return FULLY_RANDOM; }
 "persistent"		{ return PERSISTENT; }
 
 "ll"			{ return LL_HDR; }
diff --git a/src/statement.c b/src/statement.c
index 2587d27..83abfea 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -287,7 +287,7 @@ static void print_nf_nat_flags(uint32_t flags)
 	}
 
 	if (flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		printf("%srandom-fully", delim);
+		printf("%sfully-random", delim);
 		delim = ",";
 	}
 
-- 
2.1.0

