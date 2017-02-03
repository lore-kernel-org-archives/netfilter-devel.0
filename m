From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] statement: fix print of ip dnat address
Date: Fri,  3 Feb 2017 15:25:45 +0100
Message-ID: <20170203142545.13724-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42314 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751958AbdBCOZa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 09:25:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the change causes non-ipv6 addresses to not be printed at all in case
a nfproto was given.

Also add a test case to catch this.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1117
Fixes: 5ab0e10fc6e2c22363a ("src: support for RFC2732 IPv6 address format with brackets")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/statement.c               |  2 ++
 tests/py/ip/dnat.t            |  1 +
 tests/py/ip/dnat.t.payload.ip | 12 ++++++++++++
 3 files changed, 15 insertions(+)

diff --git a/src/statement.c b/src/statement.c
index 9cdabbb979e8..3beb86ab4263 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -508,6 +508,8 @@ static void nat_stmt_print(const struct stmt *stmt)
 				printf("]-[");
 				expr_print(stmt->nat.addr->right);
 				printf("]");
+			} else {
+				expr_print(stmt->nat.addr);
 			}
 		} else {
 			expr_print(stmt->nat.addr);
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index da00106edbb4..089017c84704 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -7,6 +7,7 @@ iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2;ok
 iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2;ok
+iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080;ok
 
 dnat to ct mark map { 0x00000014 : 1.2.3.4};ok
 dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 66926990d880..7a7f5a82dd5a 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -60,6 +60,18 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
+# iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080
+ip test-ip4 prerouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005100 ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ immediate reg 2 0x0000901f ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+
 # dnat to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-ip4 b
 __map%d test-ip4 0
-- 
2.10.2

