From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/2] counter: fix restoration
Date: Sun,  9 Jun 2013 01:08:47 +0200
Message-ID: <1370732927-23322-3-git-send-email-eric@regit.org>
References: <1370732927-23322-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56763 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3FHXJC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:09:02 -0400
In-Reply-To: <1370732927-23322-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was not possible to restore a ruleset countaining counter. The
packets and bytes fields were not known from the parser but they
were in the output of the list command.
This patch fixes the issue by restoring correctly the counters if
they are present in the command.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink_linearize.c |    4 ++++
 src/parser.y            |   28 +++++++++++++++++++++++++---
 src/scanner.l           |    2 ++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index cfd6691..accab9c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -440,6 +440,10 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 	struct nfnl_nft_expr *nle;
 
 	nle = alloc_nft_expr(nfnl_nft_counter_init);
+	if (stmt->counter.packets)
+		nfnl_nft_counter_set_packets(nle, stmt->counter.packets);
+	if (stmt->counter.bytes)
+		nfnl_nft_counter_set_bytes(nle, stmt->counter.bytes);
 	nfnl_nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 1232220..2923b59 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -300,6 +300,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PROTO_DST		"proto-dst"
 
 %token COUNTER			"counter"
+%token PACKETS			"packets"
+%token BYTES			"bytes"
 
 %token LOG			"log"
 %token PREFIX			"prefix"
@@ -356,8 +358,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_list_free($$); xfree($$); } stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
-%type <stmt>			counter_stmt
-%destructor { stmt_free($$); }	counter_stmt
+%type <stmt>			counter_stmt counter_stmt_alloc
+%destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc
 %type <stmt>			meta_stmt
 %destructor { stmt_free($$); }	meta_stmt
 %type <stmt>			log_stmt log_stmt_alloc
@@ -892,12 +894,32 @@ verdict_stmt		:	verdict_expr
 			}
 			;
 
-counter_stmt		:	COUNTER
+counter_stmt		:	counter_stmt_alloc
+			|	counter_stmt_alloc	counter_args
+
+counter_stmt_alloc	:	COUNTER
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
 			;
 
+counter_args		:	counter_arg
+			{
+				$<stmt>$	= $<stmt>0;
+			}
+			|	counter_args	counter_arg
+			;
+
+counter_arg		:	PACKETS			NUM
+			{
+				$<stmt>0->counter.packets = $2;
+			}
+			|	BYTES			NUM
+			{
+				$<stmt>0->counter.bytes	 = $2;
+			}
+			;
+
 log_stmt		:	log_stmt_alloc
 			|	log_stmt_alloc		log_args
 			;
diff --git a/src/scanner.l b/src/scanner.l
index edecf7b..fe7b86c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -250,6 +250,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rename"		{ return RENAME; }
 
 "counter"		{ return COUNTER; }
+"packets"		{ return PACKETS; }
+"bytes"			{ return BYTES; }
 
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
-- 
1.7.10.4

