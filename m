From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: convert expr_rt byteorder when evaluating statment arg
Date: Mon, 28 Aug 2017 17:05:34 +0200
Message-ID: <20170828150534.12375-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51424 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751241AbdH1PFS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:05:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

expr_rt might write data in host byte order, so make sure to
convert if needed.

This makes 'tcp option maxseg size rt mtu' actually work, right now such rules
are no-ops because nft_exthdr never increases the mss.

While at it, extend the example to not bother testing non-syn packets.

Reported-by: Matteo Croce <technoboy85@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                | 4 ++--
 src/evaluate.c             | 2 ++
 tests/py/inet/rt.t.payload | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4e2730f698cb..cf9334891cee 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -4274,9 +4274,9 @@ ip forward ip dscp set 42
 				<example>
 					<title>change tcp mss</title>
 					<programlisting>
-tcp option maxseg size set 1360
+tcp flags syn tcp option maxseg size set 1360
 # set a size based on route information:
-tcp option maxseg size set rt mtu
+tcp flags syn tcp option maxseg size set rt mtu
 					</programlisting>
 				</example>
 			</para>
diff --git a/src/evaluate.c b/src/evaluate.c
index f21ac1a0ab85..9954d5c59622 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1799,6 +1799,8 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 		return stmt_binary_error(ctx, *expr, stmt,
 					 "you cannot reference a set here, "
 					 "unknown value to use");
+	case EXPR_RT:
+		return byteorder_conversion(ctx, expr, byteorder);
 	default:
 		break;
 	}
diff --git a/tests/py/inet/rt.t.payload b/tests/py/inet/rt.t.payload
index 2f6265ed640a..928e0095faf5 100644
--- a/tests/py/inet/rt.t.payload
+++ b/tests/py/inet/rt.t.payload
@@ -15,5 +15,6 @@ inet test-inet output
 # tcp option maxseg size set rt mtu
 inet test-inet output
   [ rt load tcpmss => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
   [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
 
-- 
2.13.0

