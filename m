From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: keep map flag around when flags are specified
Date: Wed, 27 Jul 2016 13:48:54 +0200
Message-ID: <1469620134-7854-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33205 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbcG0LtG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2016 07:49:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C92221EC2C3
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:49:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B4695FF154
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:49:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 71CADFF2FD
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:48:59 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you add a map with timeouts, eg.

  # nft add table x
  # nft add map x y { type ipv4_addr : ipv4_addr\; flags timeout\; }

The listing shows a set instead of a map:

  # nft list ruleset
  table ip x {
          set y {
                  type ipv4_addr
                  flags timeout
          }
  }

This patch fixes the parser to keep the map flag around when timeout
flag (or any other flags) are specified.

This patch also comes with a regression test.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                          |  2 +-
 tests/shell/testcases/maps/map_with_flags_0 | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/maps/map_with_flags_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e259fdc..a4f021a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1071,7 +1071,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	FLAGS		set_flag_list	stmt_seperator
 			{
-				$1->flags = $3;
+				$1->flags |= $3;
 				$$ = $1;
 			}
 			|	map_block	ELEMENTS	'='		set_expr
diff --git a/tests/shell/testcases/maps/map_with_flags_0 b/tests/shell/testcases/maps/map_with_flags_0
new file mode 100755
index 0000000..8774eb5
--- /dev/null
+++ b/tests/shell/testcases/maps/map_with_flags_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : ipv4_addr\; flags timeout\; }
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		flags timeout
+	}
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.1.4

