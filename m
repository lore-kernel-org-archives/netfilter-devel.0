From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] parser_bison: keep snat/dnat existing syntax unchanged
Date: Mon, 22 Aug 2016 23:34:15 +0800
Message-ID: <1471880055-17832-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:33926 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755252AbcHVPez (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 11:34:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We should keep existing syntax unchanged, and this was emphasized
in the commit 850f0a56b6ad ("src: add 'to' for snat and dnat")'s
commit log: "Existing syntax is still preserved, but the listing
shows the one including 'to'."

This problem was found by running shell test:
  # ./run-tests.sh
  [ ... ]
  W: [FAILED]	./testcases/maps/anonymous_snat_map_0
  I: [OK]		./testcases/maps/map_with_flags_0
  W: [FAILED]	./testcases/maps/named_snat_map_0
  [ ... ]

Fixes: 850f0a56b6ad ("src: add 'to' for snat and dnat")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/parser_bison.y | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8025415..bf43608 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1649,15 +1649,28 @@ stmt_expr		:	map_stmt_expr
 			|	primary_rhs_expr
 			;
 
-nat_stmt_args		:	TO	stmt_expr
+nat_stmt_args		:	stmt_expr
+			{
+				$<stmt>0->nat.addr = $1;
+			}
+			|	TO	stmt_expr
 			{
 				$<stmt>0->nat.addr = $2;
 			}
+			|	stmt_expr	COLON	stmt_expr
+			{
+				$<stmt>0->nat.addr = $1;
+				$<stmt>0->nat.proto = $3;
+			}
 			|	TO	stmt_expr	COLON	stmt_expr
 			{
 				$<stmt>0->nat.addr = $2;
 				$<stmt>0->nat.proto = $4;
 			}
+			|	COLON		stmt_expr
+			{
+				$<stmt>0->nat.proto = $2;
+			}
 			|	TO	COLON		stmt_expr
 			{
 				$<stmt>0->nat.proto = $3;
-- 
2.5.5


