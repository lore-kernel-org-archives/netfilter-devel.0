From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 02/10] src: add 'to' for snat and dnat
Date: Wed, 17 Aug 2016 15:29:53 +0200
Message-ID: <1471440601-5327-3-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44014 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcHQNaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E3EFE9777
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 09BF7DA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6A1ADA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:07 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is extra syntaxtic sugar to get this consistent with other
statements such as redirect, masquerade, dup and fwd that indicates
where to go.

Existing syntax is still preserved, but the listing shows the one
including 'to'.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y              | 14 +++++++-------
 src/statement.c                 |  2 +-
 tests/py/ip/dnat.t              | 16 ++++++++--------
 tests/py/ip/dnat.t.payload.ip   | 12 ++++++------
 tests/py/ip/snat.t              | 12 ++++++------
 tests/py/ip/snat.t.payload      |  8 ++++----
 tests/py/ip6/dnat.t             |  4 ++--
 tests/py/ip6/dnat.t.payload.ip6 |  4 ++--
 tests/py/ip6/snat.t             |  4 ++--
 tests/py/ip6/snat.t.payload.ip6 |  4 ++--
 10 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e16b8a3..ba2dba4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1649,18 +1649,18 @@ stmt_expr		:	map_stmt_expr
 			|	primary_rhs_expr
 			;
 
-nat_stmt_args		:	stmt_expr
+nat_stmt_args		:	TO	stmt_expr
 			{
-				$<stmt>0->nat.addr = $1;
+				$<stmt>0->nat.addr = $2;
 			}
-			|	stmt_expr	COLON	stmt_expr
+			|	TO	stmt_expr	COLON	stmt_expr
 			{
-				$<stmt>0->nat.addr = $1;
-				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.addr = $2;
+				$<stmt>0->nat.proto = $4;
 			}
-			|	COLON		stmt_expr
+			|	TO	COLON		stmt_expr
 			{
-				$<stmt>0->nat.proto = $2;
+				$<stmt>0->nat.proto = $3;
 			}
 			|       nat_stmt_args   nf_nat_flags
 			{
diff --git a/src/statement.c b/src/statement.c
index 7778a95..ccc16bb 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -396,7 +396,7 @@ static void nat_stmt_print(const struct stmt *stmt)
 		[NFT_NAT_DNAT]	= "dnat",
 	};
 
-	printf("%s ", nat_types[stmt->nat.type]);
+	printf("%s to ", nat_types[stmt->nat.type]);
 	if (stmt->nat.addr)
 		expr_print(stmt->nat.addr);
 	if (stmt->nat.proto) {
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index 28e658d..d1ffdd7 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -2,15 +2,15 @@
 
 *ip;test-ip4;prerouting
 
-iifname "eth0" tcp dport 80-90 dnat 192.168.3.2;ok
-iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2;ok
-iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+iifname "eth0" tcp dport 80-90 dnat to 192.168.3.2;ok
+iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2;ok
+iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2;ok
+iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2;ok
 
-dnat ct mark map { 0x00000014 : 1.2.3.4};ok
-dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
+dnat to ct mark map { 0x00000014 : 1.2.3.4};ok
+dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index bf972c6..be382da 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -1,4 +1,4 @@
-# iifname "eth0" tcp dport 80-90 dnat 192.168.3.2
+# iifname "eth0" tcp dport 80-90 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -10,7 +10,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2
+# iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -22,7 +22,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2
+# iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
@@ -36,7 +36,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2
+# iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2
 ip test-ip4 prerouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -48,7 +48,7 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# dnat ct mark map { 0x00000014 : 1.2.3.4}
+# dnat to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-ip4 b
 __map%d test-ip4 0
 	element 00000014  : 04030201 0 [end]
@@ -57,7 +57,7 @@ ip test-ip4 prerouting
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
-# dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+# dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
 __map%d test-ip4 b
 __map%d test-ip4 0
 	element 00000014 01010101  : 04030201 0 [end]
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index a8469a3..ec2df8c 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -2,12 +2,12 @@
 
 *ip;test-ip4;postrouting
 
-iifname "eth0" tcp dport 80-90 snat 192.168.3.2;ok
-iifname "eth0" tcp dport != 80-90 snat 192.168.3.2;ok
-iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
-- iifname "eth0" tcp dport != {80, 90, 23} snat 192.168.3.2;ok
+iifname "eth0" tcp dport 80-90 snat to 192.168.3.2;ok
+iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2;ok
+iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-iifname "eth0" tcp dport != 23-34 snat 192.168.3.2;ok
+iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index cbea641..bef97a8 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -1,4 +1,4 @@
-# iifname "eth0" tcp dport 80-90 snat 192.168.3.2
+# iifname "eth0" tcp dport 80-90 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -10,7 +10,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 80-90 snat 192.168.3.2
+# iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
@@ -22,7 +22,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2
+# iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00005000  : 0 [end]	element 00005a00  : 0 [end]	element 00001700  : 0 [end]
@@ -36,7 +36,7 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
-# iifname "eth0" tcp dport != 23-34 snat 192.168.3.2
+# iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip6/dnat.t b/tests/py/ip6/dnat.t
index b061f2f..b256e01 100644
--- a/tests/py/ip6/dnat.t
+++ b/tests/py/ip6/dnat.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;prerouting
 
-tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:::80-100;ok
-tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:: :100;ok;tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:::100
+tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::80-100;ok
+tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:: :100;ok;tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::100
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 13c7a0e..494ade3 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -1,4 +1,4 @@
-# tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:::80-100
+# tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:::80-100
 ip6 test-ip6 prerouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -11,7 +11,7 @@ ip6 test-ip6 prerouting
   [ immediate reg 4 0x00006400 ]
   [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
 
-# tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:: :100
+# tcp dport 80-90 dnat to 2001:838:35f:1::-2001:838:35f:2:: :100
 ip6 test-ip6 prerouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip6/snat.t b/tests/py/ip6/snat.t
index dec8dff..b85d9af 100644
--- a/tests/py/ip6/snat.t
+++ b/tests/py/ip6/snat.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;postrouting
 
-tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok;tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::80-100
-tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::100;ok
+tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok;tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::80-100
+tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::100;ok
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index 486bbb8..fbc99c1 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -1,4 +1,4 @@
-# tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:: :80-100
+# tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:: :80-100
 ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -11,7 +11,7 @@ ip6 test-ip6 postrouting
   [ immediate reg 4 0x00006400 ]
   [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
 
-# tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::100
+# tcp dport 80-90 snat to 2001:838:35f:1::-2001:838:35f:2:::100
 ip6 test-ip6 postrouting
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.1.4

