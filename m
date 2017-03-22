From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/3] sets: Fix for missing space after last element
Date: Wed, 22 Mar 2017 01:26:36 +0100
Message-ID: <20170322002636.14081-3-phil@nwl.cc>
References: <20170321131902.GA30047@salvia>
 <20170322002636.14081-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43699 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757943AbdCVA1d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 20:27:33 -0400
In-Reply-To: <20170322002636.14081-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not having a space between the last element in a set and the closing
curly brace looks ugly, so add it here.

This also adjusts all shell testcases as they match whitespace in nft
output and therefore fail otherwise.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expression.c                                             |  2 +-
 tests/shell/testcases/maps/0003map_add_many_elements_0       |  2 +-
 tests/shell/testcases/maps/0004interval_map_create_once_0    |  2 +-
 .../testcases/maps/0005interval_map_add_many_elements_0      |  2 +-
 tests/shell/testcases/maps/0006interval_map_overlap_0        |  2 +-
 tests/shell/testcases/netns/0001nft-f_0                      | 12 ++++++------
 tests/shell/testcases/netns/0002loosecommands_0              |  4 ++--
 tests/shell/testcases/netns/0003many_0                       | 12 ++++++------
 tests/shell/testcases/nft-f/0002rollback_rule_0              |  4 ++--
 tests/shell/testcases/nft-f/0003rollback_jump_0              |  4 ++--
 tests/shell/testcases/nft-f/0004rollback_set_0               |  4 ++--
 tests/shell/testcases/nft-f/0005rollback_map_0               |  6 +++---
 tests/shell/testcases/sets/0021nesting_0                     |  2 +-
 tests/shell/testcases/transactions/0035set_0                 |  2 +-
 tests/shell/testcases/transactions/0038set_0                 |  2 +-
 tests/shell/testcases/transactions/0039set_0                 |  2 +-
 16 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index a6065524f8be8..45f3ed8da33c0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -746,7 +746,7 @@ static void set_expr_print(const struct expr *expr)
 {
 	printf("{ ");
 	compound_expr_print(expr, ", ");
-	printf("}");
+	printf(" }");
 }
 
 static void set_expr_set_type(const struct expr *expr,
diff --git a/tests/shell/testcases/maps/0003map_add_many_elements_0 b/tests/shell/testcases/maps/0003map_add_many_elements_0
index a2233e3909ecd..36b1be25eb664 100755
--- a/tests/shell/testcases/maps/0003map_add_many_elements_0
+++ b/tests/shell/testcases/maps/0003map_add_many_elements_0
@@ -49,7 +49,7 @@ $NFT -f $tmpfile
 EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
-		elements = { $(generate_test)}
+		elements = { $(generate_test) }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
index 7d4877eb6e964..1f043875729ee 100755
--- a/tests/shell/testcases/maps/0004interval_map_create_once_0
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -48,7 +48,7 @@ EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
 		flags interval
-		elements = { $(generate_test)}
+		elements = { $(generate_test) }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/maps/0005interval_map_add_many_elements_0 b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
index 824f2c85fb708..4d4f708e38760 100755
--- a/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
+++ b/tests/shell/testcases/maps/0005interval_map_add_many_elements_0
@@ -54,7 +54,7 @@ EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
 		flags interval
-		elements = { $(generate_test)}
+		elements = { $(generate_test) }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/maps/0006interval_map_overlap_0 b/tests/shell/testcases/maps/0006interval_map_overlap_0
index c1bf3de111ac9..8597639ea2aaa 100755
--- a/tests/shell/testcases/maps/0006interval_map_overlap_0
+++ b/tests/shell/testcases/maps/0006interval_map_overlap_0
@@ -29,7 +29,7 @@ EXPECTED="table ip x {
 	map y {
 		type ipv4_addr : ipv4_addr
 		flags interval
-		elements = { 10.0.1.0/24 : 10.0.0.1, 10.0.2.0/24 : 10.0.0.2}
+		elements = { 10.0.1.0/24 : 10.0.0.1, 10.0.2.0/24 : 10.0.0.2 }
 	}
 }"
 GET=$($NFT list ruleset)
diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
index 663167d741c57..435275233f75d 100755
--- a/tests/shell/testcases/netns/0001nft-f_0
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -19,12 +19,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 RULESET="table ip t {
 	set s {
 		type ipv4_addr
-		elements = { 1.1.0.0}
+		elements = { 1.1.0.0 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip saddr @s drop
 		jump other
 	}
@@ -35,12 +35,12 @@ RULESET="table ip t {
 table ip6 t {
 	set s {
 		type ipv6_addr
-		elements = { fe00::1}
+		elements = { fe00::1 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip6 saddr @s drop
 		jump other
 	}
@@ -51,12 +51,12 @@ table ip6 t {
 table inet t {
 	set s {
 		type ipv6_addr
-		elements = { fe00::1}
+		elements = { fe00::1 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip6 saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/netns/0002loosecommands_0 b/tests/shell/testcases/netns/0002loosecommands_0
index fbaa38658de6a..3910446a5565f 100755
--- a/tests/shell/testcases/netns/0002loosecommands_0
+++ b/tests/shell/testcases/netns/0002loosecommands_0
@@ -39,12 +39,12 @@ netns_exec $NETNS_NAME "$NFT add rule ip t c jump other"
 RULESET="table ip t {
 	set s {
 		type ipv4_addr
-		elements = { 1.1.0.0}
+		elements = { 1.1.0.0 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index 17d7b93588f34..03da6eec85973 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -22,12 +22,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 RULESET="table ip t {
 	set s {
 		type ipv4_addr
-		elements = { 1.1.0.0}
+		elements = { 1.1.0.0 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip saddr @s drop
 		jump other
 	}
@@ -38,12 +38,12 @@ RULESET="table ip t {
 table ip6 t {
 	set s {
 		type ipv6_addr
-		elements = { fe00::1}
+		elements = { fe00::1 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip6 saddr @s drop
 		jump other
 	}
@@ -54,12 +54,12 @@ table ip6 t {
 table inet t {
 	set s {
 		type ipv6_addr
-		elements = { fe00::1}
+		elements = { fe00::1 }
 	}
 
 	chain c {
 		ct state new
-		udp dport { 12345}
+		udp dport { 12345 }
 		ip6 saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
index 5518c0b2de46b..ddeb5423cc4c3 100755
--- a/tests/shell/testcases/nft-f/0002rollback_rule_0
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -14,12 +14,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 GOOD_RULESET="table ip t {
 	set t {
 		type ipv4_addr
-		elements = { 1.1.1.1}
+		elements = { 1.1.1.1 }
 	}
 
 	chain c {
 		ct state new
-		tcp dport { 22222}
+		tcp dport { 22222 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
index 5c8c6852bc98c..6c43df9db5f82 100755
--- a/tests/shell/testcases/nft-f/0003rollback_jump_0
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -14,12 +14,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 GOOD_RULESET="table ip t {
 	set t {
 		type ipv4_addr
-		elements = { 1.1.1.1}
+		elements = { 1.1.1.1 }
 	}
 
 	chain c {
 		ct state new
-		tcp dport { 22222}
+		tcp dport { 22222 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
index db1c84cb1b349..1dea85ec401ad 100755
--- a/tests/shell/testcases/nft-f/0004rollback_set_0
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -14,12 +14,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 GOOD_RULESET="table ip t {
 	set t {
 		type ipv4_addr
-		elements = { 1.1.1.1}
+		elements = { 1.1.1.1 }
 	}
 
 	chain c {
 		ct state new
-		tcp dport { 22222}
+		tcp dport { 22222 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
index 13bb90752ffc1..777cc7175ef10 100755
--- a/tests/shell/testcases/nft-f/0005rollback_map_0
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -14,12 +14,12 @@ trap "rm -rf $tmpfile" EXIT # cleanup if aborted
 GOOD_RULESET="table ip t {
 	set t {
 		type ipv4_addr
-		elements = { 1.1.1.1}
+		elements = { 1.1.1.1 }
 	}
 
 	chain c {
 		ct state new
-		tcp dport { 22222}
+		tcp dport { 22222 }
 		ip saddr @t drop
 		jump other
 	}
@@ -31,7 +31,7 @@ GOOD_RULESET="table ip t {
 BAD_RULESET="flush ruleset
 table ip t2 {
 	chain c2 {
-		tcp dport map {22222: jump other, 11111: jump invalid}
+		tcp dport map { 22222: jump other, 11111: jump invalid }
 	}
 
 	chain other {
diff --git a/tests/shell/testcases/sets/0021nesting_0 b/tests/shell/testcases/sets/0021nesting_0
index 3bcb61473198c..763d9ae1797e6 100755
--- a/tests/shell/testcases/sets/0021nesting_0
+++ b/tests/shell/testcases/sets/0021nesting_0
@@ -33,7 +33,7 @@ fi
 
 EXPECTED="table ip x {
 	chain y {
-		ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24}
+		ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24 }
 	}
 }"
 
diff --git a/tests/shell/testcases/transactions/0035set_0 b/tests/shell/testcases/transactions/0035set_0
index a014a69ecd41a..0788e2fe9489b 100755
--- a/tests/shell/testcases/transactions/0035set_0
+++ b/tests/shell/testcases/transactions/0035set_0
@@ -27,7 +27,7 @@ fi
 EXPECTED="table ip x {
 	set y {
 		type ipv4_addr
-		elements = { 3.3.3.3}
+		elements = { 3.3.3.3 }
 	}
 }"
 
diff --git a/tests/shell/testcases/transactions/0038set_0 b/tests/shell/testcases/transactions/0038set_0
index 2e36fa31d3f60..765507555814d 100755
--- a/tests/shell/testcases/transactions/0038set_0
+++ b/tests/shell/testcases/transactions/0038set_0
@@ -28,7 +28,7 @@ EXPECTED="table ip x {
 	set y {
 		type ipv4_addr
 		flags interval
-		elements = { 192.168.4.0/24}
+		elements = { 192.168.4.0/24 }
 	}
 }"
 
diff --git a/tests/shell/testcases/transactions/0039set_0 b/tests/shell/testcases/transactions/0039set_0
index 2e36fa31d3f60..765507555814d 100755
--- a/tests/shell/testcases/transactions/0039set_0
+++ b/tests/shell/testcases/transactions/0039set_0
@@ -28,7 +28,7 @@ EXPECTED="table ip x {
 	set y {
 		type ipv4_addr
 		flags interval
-		elements = { 192.168.4.0/24}
+		elements = { 192.168.4.0/24 }
 	}
 }"
 
-- 
2.11.0

