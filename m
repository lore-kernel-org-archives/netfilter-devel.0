From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 03/10] src: support for RFC2732 IPv6 address format with brackets
Date: Wed, 17 Aug 2016 15:29:54 +0200
Message-ID: <1471440601-5327-4-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44016 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbcHQNaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9931DE9778
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 84B9CFC619
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4F575FC61B
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:08 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The statement:

	dnat to 2001:838:35f:1:::80

is very confusing as it is not so easy to identify where address ends
and the port starts. This even harder to read with ranges.

So this patch adds squared brackets as RFC2732 to enclose the IPv6
address.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l                   |  7 +++++++
 src/statement.c                 | 22 ++++++++++++++++++++--
 tests/py/ip6/dnat.t             |  5 +++--
 tests/py/ip6/dnat.t.payload.ip6 | 14 ++++++++++++--
 tests/py/ip6/snat.t             |  4 ++--
 tests/py/ip6/snat.t.payload.ip6 |  4 ++--
 6 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 613c3c9..3ad4dd9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -169,6 +169,7 @@ v60		(::)
 macaddr		(([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2})
 ip4addr		(([[:digit:]]{1,3}"."){3}([[:digit:]]{1,3}))
 ip6addr		({v680}|{v67}|{v66}|{v65}|{v64}|{v63}|{v62}|{v61}|{v60})
+ip6addr_rfc2732	(\[{ip6addr}\])
 
 addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
@@ -475,6 +476,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{ip6addr_rfc2732}	{
+				yytext[yyleng - 1] = '\0';
+				yylval->string = xstrdup(yytext + 1);
+				return STRING;
+			}
+
 {timestring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/src/statement.c b/src/statement.c
index ccc16bb..fbe74a6 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -397,8 +397,26 @@ static void nat_stmt_print(const struct stmt *stmt)
 	};
 
 	printf("%s to ", nat_types[stmt->nat.type]);
-	if (stmt->nat.addr)
-		expr_print(stmt->nat.addr);
+	if (stmt->nat.addr) {
+		if (stmt->nat.proto) {
+			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
+			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
+				printf("[");
+				expr_print(stmt->nat.addr);
+				printf("]");
+			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
+				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
+				printf("[");
+				expr_print(stmt->nat.addr->left);
+				printf("]-[");
+				expr_print(stmt->nat.addr->right);
+				printf("]");
+			}
+		} else {
+			expr_print(stmt->nat.addr);
+		}
+	}
+
 	if (stmt->nat.proto) {
 		printf(":");
 		expr_print(stmt->nat.proto);
diff --git a/tests/py/ip6/dnat.t b/tests/py/ip6/dnat.t
index b256e01..78d6d0a 100644
--- a/tests/py/ip6/dnat.t
+++ b/tests/py/ip6/dnat.t
@@ -2,5 +2,6 @@
 
 *ip6;test-ip6;prerouting
 
-tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::80-100;ok
-tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:: :100;ok;tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::100
+tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok
+tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok;tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
+tcp dport 80-90 dnat to [2001:838:35f:1::]:80;ok
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 494ade3..8bd5819 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -1,4 +1,4 @@
-# tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::80-100
+# tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 prerouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -11,7 +11,7 @@ ip6 test-ip6 prerouting
   [ immediate reg 4 0x00006400 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
 
-# tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:: :100
+# tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 prerouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -23,3 +23,13 @@ ip6 test-ip6 prerouting
   [ immediate reg 3 0x00006400 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 ]
 
+# tcp dport 80-90 dnat to [2001:838:35f:1::]:80
+ip6 test-ip6 prerouting
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00005000 ]
+  [ cmp lte reg 1 0x00005a00 ]
+  [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
+  [ immediate reg 2 0x00005000 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
diff --git a/tests/py/ip6/snat.t b/tests/py/ip6/snat.t
index b85d9af..c259f93 100644
--- a/tests/py/ip6/snat.t
+++ b/tests/py/ip6/snat.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;postrouting
 
-tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok;tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::80-100
-tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::100;ok
+tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok;tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
+tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index fbc99c1..ea40363 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -1,4 +1,4 @@
-# tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:: :80-100
+# tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
 ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -11,7 +11,7 @@ ip6 test-ip6 postrouting
   [ immediate reg 4 0x00006400 ]
   [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
 
-# tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::100
+# tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.1.4

