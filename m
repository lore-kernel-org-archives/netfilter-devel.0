Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01463C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01CD60F6E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhGZPVL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:21:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33106 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbhGZPVK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:10 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 738DE60693
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jul 2021 17:52:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: promote 'reject with icmp CODE' syntax
Date:   Mon, 26 Jul 2021 17:53:09 +0200
Message-Id: <20210726155309.15092-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel already assumes that that ICMP type to reject a packet is
destination-unreachable, hence the user specifies the *ICMP code*.

Simplify the syntax to:

	... reject with icmp port-unreachable

this removes the 'type' keyword before the ICMP code to reject the
packet with.

IIRC, the original intention is to leave room for future extensions that
allow to specify both the ICMP type and the ICMP code, this is however
not possible with the current inconsistent syntax.

Update manpages which also refer to ICMP type.

Adjust tests/py to the new syntax.

Fixes: 5fdd0b6a0600 ("nft: complete reject support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/libnftables-json.adoc           |  2 +-
 doc/statements.txt                  |  6 ++--
 src/parser_bison.y                  | 20 +++++++++++
 src/statement.c                     |  6 ++--
 tests/py/bridge/reject.t            | 50 +++++++++++++-------------
 tests/py/bridge/reject.t.json       | 36 +++++++++----------
 tests/py/bridge/reject.t.payload    | 36 +++++++++----------
 tests/py/inet/reject.t              | 52 +++++++++++++--------------
 tests/py/inet/reject.t.json         | 38 ++++++++++----------
 tests/py/inet/reject.t.payload.inet | 40 ++++++++++-----------
 tests/py/ip/reject.t                | 20 +++++------
 tests/py/ip/reject.t.payload        | 16 ++++-----
 tests/py/ip6/reject.t               | 18 +++++-----
 tests/py/ip6/reject.t.payload.ip6   | 14 ++++----
 tests/py/netdev/reject.t            | 54 ++++++++++++++---------------
 tests/py/netdev/reject.t.json       | 42 +++++++++++-----------
 tests/py/netdev/reject.t.payload    | 42 +++++++++++-----------
 17 files changed, 256 insertions(+), 236 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index fba4cb08ccb6..c152dc055b50 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -904,7 +904,7 @@ Reject the packet and send the given error reply.
 *type*::
 	Type of reject, either *"tcp reset"*, *"icmpx"*, *"icmp"* or *"icmpv6"*.
 *expr*::
-	ICMP type to reject with.
+	ICMP code to reject with.
 
 All properties are optional.
 
diff --git a/doc/statements.txt b/doc/statements.txt
index 097cf2e07eeb..af98e42c3633 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -163,9 +163,9 @@ REJECT STATEMENT
 ____
 *reject* [ *with* 'REJECT_WITH' ]
 
-'REJECT_WITH' := *icmp type* 'icmp_code' |
-                 *icmpv6 type* 'icmpv6_code' |
-                 *icmpx type* 'icmpx_code' |
+'REJECT_WITH' := *icmp* 'icmp_code' |
+                 *icmpv6* 'icmpv6_code' |
+                 *icmpx* 'icmpx_code' |
                  *tcp reset*
 ____
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 79b5aef24512..b83ac9a298f5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3319,6 +3319,13 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
 			}
+			|	WITH	ICMP	reject_with_expr
+			{
+				$<stmt>0->reject.family = NFPROTO_IPV4;
+				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				$<stmt>0->reject.expr = $3;
+				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
+			}
 			|	WITH	ICMP6	TYPE	reject_with_expr
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
@@ -3326,12 +3333,25 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
 			}
+			|	WITH	ICMP6	reject_with_expr
+			{
+				$<stmt>0->reject.family = NFPROTO_IPV6;
+				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				$<stmt>0->reject.expr = $3;
+				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
+			}
 			|	WITH	ICMPX	TYPE	reject_with_expr
 			{
 				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
 				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
 			}
+			|	WITH	ICMPX	reject_with_expr
+			{
+				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
+				$<stmt>0->reject.expr = $3;
+				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
+			}
 			|	WITH	TCP	RESET
 			{
 				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
diff --git a/src/statement.c b/src/statement.c
index 06742c04f027..97b163e8ac06 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -585,7 +585,7 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_REJECT_ICMPX_UNREACH:
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
-		nft_print(octx, " with icmpx type ");
+		nft_print(octx, " with icmpx ");
 		expr_print(stmt->reject.expr, octx);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
@@ -594,14 +594,14 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			if (!stmt->reject.verbose_print &&
 			     stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
-			nft_print(octx, " with icmp type ");
+			nft_print(octx, " with icmp ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
 			if (!stmt->reject.verbose_print &&
 			    stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
-			nft_print(octx, " with icmpv6 type ");
+			nft_print(octx, " with icmpv6 ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		}
diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index b242eef49a2b..336b51bb9a1c 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -3,40 +3,40 @@
 *bridge;test-bridge;input
 
 # The output is specific for bridge family
-reject with icmp type host-unreachable;ok
-reject with icmp type net-unreachable;ok
-reject with icmp type prot-unreachable;ok
-reject with icmp type port-unreachable;ok
-reject with icmp type net-prohibited;ok
-reject with icmp type host-prohibited;ok
-reject with icmp type admin-prohibited;ok
-
-reject with icmpv6 type no-route;ok
-reject with icmpv6 type admin-prohibited;ok
-reject with icmpv6 type addr-unreachable;ok
-reject with icmpv6 type port-unreachable;ok
+reject with icmp host-unreachable;ok
+reject with icmp net-unreachable;ok
+reject with icmp prot-unreachable;ok
+reject with icmp port-unreachable;ok
+reject with icmp net-prohibited;ok
+reject with icmp host-prohibited;ok
+reject with icmp admin-prohibited;ok
+
+reject with icmpv6 no-route;ok
+reject with icmpv6 admin-prohibited;ok
+reject with icmpv6 addr-unreachable;ok
+reject with icmpv6 port-unreachable;ok
 
 mark 12345 ip protocol tcp reject with tcp reset;ok;meta mark 0x00003039 ip protocol 6 reject with tcp reset
 
 reject;ok
-ether type ip reject;ok;reject with icmp type port-unreachable
-ether type ip6 reject;ok;reject with icmpv6 type port-unreachable
+ether type ip reject;ok;reject with icmp port-unreachable
+ether type ip6 reject;ok;reject with icmpv6 port-unreachable
 
-reject with icmpx type host-unreachable;ok
-reject with icmpx type no-route;ok
-reject with icmpx type admin-prohibited;ok
-reject with icmpx type port-unreachable;ok;reject
+reject with icmpx host-unreachable;ok
+reject with icmpx no-route;ok
+reject with icmpx admin-prohibited;ok
+reject with icmpx port-unreachable;ok;reject
 
-ether type ipv6 reject with icmp type host-unreachable;fail
-ether type ip6 reject with icmp type host-unreachable;fail
-ether type ip reject with icmpv6 type no-route;fail
+ether type ipv6 reject with icmp host-unreachable;fail
+ether type ip6 reject with icmp host-unreachable;fail
+ether type ip reject with icmpv6 no-route;fail
 ether type vlan reject;ok;ether type 8021q reject
 ether type arp reject;fail
 ether type vlan reject with tcp reset;ok;meta l4proto 6 ether type 8021q reject with tcp reset
 ether type arp reject with tcp reset;fail
 ip protocol udp reject with tcp reset;fail
 
-ether type ip reject with icmpx type admin-prohibited;ok
-ether type ip6 reject with icmpx type admin-prohibited;ok
-ether type 8021q reject with icmpx type admin-prohibited;ok
-ether type arp reject with icmpx type admin-prohibited;fail
+ether type ip reject with icmpx admin-prohibited;ok
+ether type ip6 reject with icmpx admin-prohibited;ok
+ether type 8021q reject with icmpx admin-prohibited;ok
+ether type arp reject with icmpx admin-prohibited;fail
diff --git a/tests/py/bridge/reject.t.json b/tests/py/bridge/reject.t.json
index fe21734d0ae3..9f9e6c1eab3a 100644
--- a/tests/py/bridge/reject.t.json
+++ b/tests/py/bridge/reject.t.json
@@ -1,4 +1,4 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 [
     {
         "reject": {
@@ -8,7 +8,7 @@
     }
 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 [
     {
         "reject": {
@@ -18,7 +18,7 @@
     }
 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 [
     {
         "reject": {
@@ -28,7 +28,7 @@
     }
 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 [
     {
         "reject": {
@@ -38,7 +38,7 @@
     }
 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 [
     {
         "reject": {
@@ -48,7 +48,7 @@
     }
 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 [
     {
         "reject": {
@@ -58,7 +58,7 @@
     }
 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 [
     {
         "reject": {
@@ -68,7 +68,7 @@
     }
 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 [
     {
         "reject": {
@@ -78,7 +78,7 @@
     }
 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 [
     {
         "reject": {
@@ -88,7 +88,7 @@
     }
 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 [
     {
         "reject": {
@@ -98,7 +98,7 @@
     }
 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 [
     {
         "reject": {
@@ -183,7 +183,7 @@
     }
 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 [
     {
         "reject": {
@@ -193,7 +193,7 @@
     }
 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 [
     {
         "reject": {
@@ -203,7 +203,7 @@
     }
 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 [
     {
         "reject": {
@@ -213,7 +213,7 @@
     }
 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 [
     {
         "reject": {
@@ -223,7 +223,7 @@
     }
 ]
 
-# ether type ip reject with icmpx type admin-prohibited
+# ether type ip reject with icmpx admin-prohibited
 [
     {
         "match": {
@@ -245,7 +245,7 @@
     }
 ]
 
-# ether type ip6 reject with icmpx type admin-prohibited
+# ether type ip6 reject with icmpx admin-prohibited
 [
     {
         "match": {
@@ -318,7 +318,7 @@
     }
 ]
 
-# ether type 8021q reject with icmpx type admin-prohibited
+# ether type 8021q reject with icmpx admin-prohibited
 [
     {
         "match": {
diff --git a/tests/py/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
index 22569877c428..bad9adc02852 100644
--- a/tests/py/bridge/reject.t.payload
+++ b/tests/py/bridge/reject.t.payload
@@ -1,64 +1,64 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 1 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 0 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 2 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 3 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 9 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 10 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 13 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 0 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 1 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 3 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -90,29 +90,29 @@ bridge test-bridge input
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 bridge test-bridge input
   [ reject type 2 code 2 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 bridge test-bridge input
   [ reject type 2 code 0 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 bridge test-bridge input
   [ reject type 2 code 3 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 bridge test-bridge input
   [ reject type 2 code 1 ]
 
-# ether type ip reject with icmpx type admin-prohibited
+# ether type ip reject with icmpx admin-prohibited
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 2 code 3 ]
 
-# ether type ip6 reject with icmpx type admin-prohibited
+# ether type ip6 reject with icmpx admin-prohibited
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -132,7 +132,7 @@ bridge
   [ cmp eq reg 1 0x00000081 ]
   [ reject type 1 code 0 ]
 
-# ether type 8021q reject with icmpx type admin-prohibited
+# ether type 8021q reject with icmpx admin-prohibited
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index bae8fc2ecdb1..1c8aeebe1b07 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -2,38 +2,38 @@
 
 *inet;test-inet;input
 
-reject with icmp type host-unreachable;ok
-reject with icmp type net-unreachable;ok
-reject with icmp type prot-unreachable;ok
-reject with icmp type port-unreachable;ok
-reject with icmp type net-prohibited;ok
-reject with icmp type host-prohibited;ok
-reject with icmp type admin-prohibited;ok
-
-reject with icmpv6 type no-route;ok
-reject with icmpv6 type admin-prohibited;ok
-reject with icmpv6 type addr-unreachable;ok
-reject with icmpv6 type port-unreachable;ok
+reject with icmp host-unreachable;ok
+reject with icmp net-unreachable;ok
+reject with icmp prot-unreachable;ok
+reject with icmp port-unreachable;ok
+reject with icmp net-prohibited;ok
+reject with icmp host-prohibited;ok
+reject with icmp admin-prohibited;ok
+
+reject with icmpv6 no-route;ok
+reject with icmpv6 admin-prohibited;ok
+reject with icmpv6 addr-unreachable;ok
+reject with icmpv6 port-unreachable;ok
 
 mark 12345 reject with tcp reset;ok;meta l4proto 6 meta mark 0x00003039 reject with tcp reset
 
 reject;ok
-meta nfproto ipv4 reject;ok;reject with icmp type port-unreachable
-meta nfproto ipv6 reject;ok;reject with icmpv6 type port-unreachable
+meta nfproto ipv4 reject;ok;reject with icmp port-unreachable
+meta nfproto ipv6 reject;ok;reject with icmpv6 port-unreachable
 
-reject with icmpx type host-unreachable;ok
-reject with icmpx type no-route;ok
-reject with icmpx type admin-prohibited;ok
-reject with icmpx type port-unreachable;ok;reject
-reject with icmpx type 3;ok;reject with icmpx type admin-prohibited
+reject with icmpx host-unreachable;ok
+reject with icmpx no-route;ok
+reject with icmpx admin-prohibited;ok
+reject with icmpx port-unreachable;ok;reject
+reject with icmpx 3;ok;reject with icmpx admin-prohibited
 
-meta nfproto ipv4 reject with icmp type host-unreachable;ok;reject with icmp type host-unreachable
-meta nfproto ipv6 reject with icmpv6 type no-route;ok;reject with icmpv6 type no-route
+meta nfproto ipv4 reject with icmp host-unreachable;ok;reject with icmp host-unreachable
+meta nfproto ipv6 reject with icmpv6 no-route;ok;reject with icmpv6 no-route
 
-meta nfproto ipv6 reject with icmp type host-unreachable;fail
-meta nfproto ipv4 ip protocol icmp reject with icmpv6 type no-route;fail
-meta nfproto ipv6 ip protocol icmp reject with icmp type host-unreachable;fail
+meta nfproto ipv6 reject with icmp host-unreachable;fail
+meta nfproto ipv4 ip protocol icmp reject with icmpv6 no-route;fail
+meta nfproto ipv6 ip protocol icmp reject with icmp host-unreachable;fail
 meta l4proto udp reject with tcp reset;fail
 
-meta nfproto ipv4 reject with icmpx type admin-prohibited;ok
-meta nfproto ipv6 reject with icmpx type admin-prohibited;ok
+meta nfproto ipv4 reject with icmpx admin-prohibited;ok
+meta nfproto ipv6 reject with icmpx admin-prohibited;ok
diff --git a/tests/py/inet/reject.t.json b/tests/py/inet/reject.t.json
index bfa94f8468b7..e60cd4f205f6 100644
--- a/tests/py/inet/reject.t.json
+++ b/tests/py/inet/reject.t.json
@@ -1,4 +1,4 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 [
     {
         "reject": {
@@ -8,7 +8,7 @@
     }
 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 [
     {
         "reject": {
@@ -18,7 +18,7 @@
     }
 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 [
     {
         "reject": {
@@ -28,7 +28,7 @@
     }
 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 [
     {
         "reject": {
@@ -38,7 +38,7 @@
     }
 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 [
     {
         "reject": {
@@ -48,7 +48,7 @@
     }
 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 [
     {
         "reject": {
@@ -58,7 +58,7 @@
     }
 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 [
     {
         "reject": {
@@ -68,7 +68,7 @@
     }
 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 [
     {
         "reject": {
@@ -78,7 +78,7 @@
     }
 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 [
     {
         "reject": {
@@ -88,7 +88,7 @@
     }
 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 [
     {
         "reject": {
@@ -98,7 +98,7 @@
     }
 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 [
     {
         "reject": {
@@ -165,7 +165,7 @@
     }
 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 [
     {
         "reject": {
@@ -175,7 +175,7 @@
     }
 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 [
     {
         "reject": {
@@ -185,7 +185,7 @@
     }
 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 [
     {
         "reject": {
@@ -195,7 +195,7 @@
     }
 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 [
     {
         "reject": {
@@ -205,7 +205,7 @@
     }
 ]
 
-# meta nfproto ipv4 reject with icmp type host-unreachable
+# meta nfproto ipv4 reject with icmp host-unreachable
 [
     {
         "match": {
@@ -224,7 +224,7 @@
     }
 ]
 
-# meta nfproto ipv6 reject with icmpv6 type no-route
+# meta nfproto ipv6 reject with icmpv6 no-route
 [
     {
         "match": {
@@ -243,7 +243,7 @@
     }
 ]
 
-# meta nfproto ipv4 reject with icmpx type admin-prohibited
+# meta nfproto ipv4 reject with icmpx admin-prohibited
 [
     {
         "match": {
@@ -264,7 +264,7 @@
     }
 ]
 
-# meta nfproto ipv6 reject with icmpx type admin-prohibited
+# meta nfproto ipv6 reject with icmpx admin-prohibited
 [
     {
         "match": {
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index be6ad3943f12..62078d91b0cf 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -1,64 +1,64 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 1 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 0 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 2 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 3 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 9 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 10 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 13 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 0 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 1 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 3 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -88,45 +88,45 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 4 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 inet test-inet input
   [ reject type 2 code 2 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 inet test-inet input
   [ reject type 2 code 0 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 inet test-inet input
   [ reject type 2 code 3 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 inet test-inet input
   [ reject type 2 code 1 ]
 
-# reject with icmpx type 3
+# reject with icmpx 3
 inet test-inet input
   [ reject type 2 code 3 ]
 
-# meta nfproto ipv4 reject with icmp type host-unreachable
+# meta nfproto ipv4 reject with icmp host-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 0 code 1 ]
 
-# meta nfproto ipv6 reject with icmpv6 type no-route
+# meta nfproto ipv6 reject with icmpv6 no-route
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 0 ]
 
-# meta nfproto ipv4 reject with icmpx type admin-prohibited
+# meta nfproto ipv4 reject with icmpx admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ reject type 2 code 3 ]
 
-# meta nfproto ipv6 reject with icmpx type admin-prohibited
+# meta nfproto ipv6 reject with icmpx admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip/reject.t b/tests/py/ip/reject.t
index 74a5a04101bf..ad009944fc52 100644
--- a/tests/py/ip/reject.t
+++ b/tests/py/ip/reject.t
@@ -3,15 +3,15 @@
 *ip;test-ip4;output
 
 reject;ok
-reject with icmp type host-unreachable;ok
-reject with icmp type net-unreachable;ok
-reject with icmp type prot-unreachable;ok
-reject with icmp type port-unreachable;ok;reject
-reject with icmp type net-prohibited;ok
-reject with icmp type host-prohibited;ok
-reject with icmp type admin-prohibited;ok
-reject with icmp type 3;ok;reject
+reject with icmp host-unreachable;ok
+reject with icmp net-unreachable;ok
+reject with icmp prot-unreachable;ok
+reject with icmp port-unreachable;ok;reject
+reject with icmp net-prohibited;ok
+reject with icmp host-prohibited;ok
+reject with icmp admin-prohibited;ok
+reject with icmp 3;ok;reject
 mark 0x80000000 reject with tcp reset;ok;meta mark 0x80000000 reject with tcp reset
 
-reject with icmp type no-route;fail
-reject with icmpv6 type no-route;fail
+reject with icmp no-route;fail
+reject with icmpv6 no-route;fail
diff --git a/tests/py/ip/reject.t.payload b/tests/py/ip/reject.t.payload
index 80fc5042e421..5829065a154f 100644
--- a/tests/py/ip/reject.t.payload
+++ b/tests/py/ip/reject.t.payload
@@ -2,35 +2,35 @@
 ip test-ip4 output
   [ reject type 0 code 3 ]
 
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 ip test-ip4 output
   [ reject type 0 code 1 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 ip test-ip4 output
   [ reject type 0 code 0 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 ip test-ip4 output
   [ reject type 0 code 2 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 ip test-ip4 output
   [ reject type 0 code 3 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 ip test-ip4 output
   [ reject type 0 code 9 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 ip test-ip4 output
   [ reject type 0 code 10 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 ip test-ip4 output
   [ reject type 0 code 13 ]
 
-# reject with icmp type 3
+# reject with icmp 3
 ip test-ip4 output
   [ reject type 0 code 3 ]
 
diff --git a/tests/py/ip6/reject.t b/tests/py/ip6/reject.t
index 79f3d5577f8f..bfdd094e4690 100644
--- a/tests/py/ip6/reject.t
+++ b/tests/py/ip6/reject.t
@@ -3,14 +3,14 @@
 *ip6;test-ip6;output
 
 reject;ok
-reject with icmpv6 type no-route;ok
-reject with icmpv6 type admin-prohibited;ok
-reject with icmpv6 type addr-unreachable;ok
-reject with icmpv6 type port-unreachable;ok;reject
-reject with icmpv6 type policy-fail;ok
-reject with icmpv6 type reject-route;ok
-reject with icmpv6 type 3;ok;reject with icmpv6 type addr-unreachable
+reject with icmpv6 no-route;ok
+reject with icmpv6 admin-prohibited;ok
+reject with icmpv6 addr-unreachable;ok
+reject with icmpv6 port-unreachable;ok;reject
+reject with icmpv6 policy-fail;ok
+reject with icmpv6 reject-route;ok
+reject with icmpv6 3;ok;reject with icmpv6 addr-unreachable
 mark 0x80000000 reject with tcp reset;ok;meta mark 0x80000000 reject with tcp reset
 
-reject with icmpv6 type host-unreachable;fail
-reject with icmp type host-unreachable;fail
+reject with icmpv6 host-unreachable;fail
+reject with icmp host-unreachable;fail
diff --git a/tests/py/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
index 9f90734efd73..3d4321b098c2 100644
--- a/tests/py/ip6/reject.t.payload.ip6
+++ b/tests/py/ip6/reject.t.payload.ip6
@@ -2,31 +2,31 @@
 ip6 test-ip6 output
   [ reject type 0 code 4 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 ip6 test-ip6 output
   [ reject type 0 code 0 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 ip6 test-ip6 output
   [ reject type 0 code 1 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 ip6 test-ip6 output
   [ reject type 0 code 3 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 ip6 test-ip6 output
   [ reject type 0 code 4 ]
 
-# reject with icmpv6 type policy-fail
+# reject with icmpv6 policy-fail
 ip6 test-ip6 output
   [ reject type 0 code 5 ]
 
-# reject with icmpv6 type reject-route
+# reject with icmpv6 reject-route
 ip6 test-ip6 output
   [ reject type 0 code 6 ]
 
-# reject with icmpv6 type 3
+# reject with icmpv6 3
 ip6 test-ip6 output
   [ reject type 0 code 3 ]
 
diff --git a/tests/py/netdev/reject.t b/tests/py/netdev/reject.t
index af1090860fd5..c66e649cdd72 100644
--- a/tests/py/netdev/reject.t
+++ b/tests/py/netdev/reject.t
@@ -2,39 +2,39 @@
 
 *netdev;test-netdev;ingress
 
-reject with icmp type host-unreachable;ok
-reject with icmp type net-unreachable;ok
-reject with icmp type prot-unreachable;ok
-reject with icmp type port-unreachable;ok
-reject with icmp type net-prohibited;ok
-reject with icmp type host-prohibited;ok
-reject with icmp type admin-prohibited;ok
-
-reject with icmpv6 type no-route;ok
-reject with icmpv6 type admin-prohibited;ok
-reject with icmpv6 type addr-unreachable;ok
-reject with icmpv6 type port-unreachable;ok
-reject with icmpv6 type policy-fail;ok
-reject with icmpv6 type reject-route;ok
+reject with icmp host-unreachable;ok
+reject with icmp net-unreachable;ok
+reject with icmp prot-unreachable;ok
+reject with icmp port-unreachable;ok
+reject with icmp net-prohibited;ok
+reject with icmp host-prohibited;ok
+reject with icmp admin-prohibited;ok
+
+reject with icmpv6 no-route;ok
+reject with icmpv6 admin-prohibited;ok
+reject with icmpv6 addr-unreachable;ok
+reject with icmpv6 port-unreachable;ok
+reject with icmpv6 policy-fail;ok
+reject with icmpv6 reject-route;ok
 
 mark 12345 reject with tcp reset;ok;meta l4proto 6 meta mark 0x00003039 reject with tcp reset
 
 reject;ok
-meta protocol ip reject;ok;reject with icmp type port-unreachable
-meta protocol ip6 reject;ok;reject with icmpv6 type port-unreachable
+meta protocol ip reject;ok;reject with icmp port-unreachable
+meta protocol ip6 reject;ok;reject with icmpv6 port-unreachable
 
-reject with icmpx type host-unreachable;ok
-reject with icmpx type no-route;ok
-reject with icmpx type admin-prohibited;ok
-reject with icmpx type port-unreachable;ok;reject
+reject with icmpx host-unreachable;ok
+reject with icmpx no-route;ok
+reject with icmpx admin-prohibited;ok
+reject with icmpx port-unreachable;ok;reject
 
-meta protocol ip reject with icmp type host-unreachable;ok;reject with icmp type host-unreachable
-meta protocol ip6 reject with icmpv6 type no-route;ok;reject with icmpv6 type no-route
+meta protocol ip reject with icmp host-unreachable;ok;reject with icmp host-unreachable
+meta protocol ip6 reject with icmpv6 no-route;ok;reject with icmpv6 no-route
 
-meta protocol ip6 reject with icmp type host-unreachable;fail
-meta protocol ip ip protocol icmp reject with icmpv6 type no-route;fail
-meta protocol ip6 ip protocol icmp reject with icmp type host-unreachable;fail
+meta protocol ip6 reject with icmp host-unreachable;fail
+meta protocol ip ip protocol icmp reject with icmpv6 no-route;fail
+meta protocol ip6 ip protocol icmp reject with icmp host-unreachable;fail
 meta l4proto udp reject with tcp reset;fail
 
-meta protocol ip reject with icmpx type admin-prohibited;ok
-meta protocol ip6 reject with icmpx type admin-prohibited;ok
+meta protocol ip reject with icmpx admin-prohibited;ok
+meta protocol ip6 reject with icmpx admin-prohibited;ok
diff --git a/tests/py/netdev/reject.t.json b/tests/py/netdev/reject.t.json
index 616a2bc1cb64..9968aaf834ec 100644
--- a/tests/py/netdev/reject.t.json
+++ b/tests/py/netdev/reject.t.json
@@ -1,4 +1,4 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 [
     {
         "reject": {
@@ -8,7 +8,7 @@
     }
 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 [
     {
         "reject": {
@@ -18,7 +18,7 @@
     }
 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 [
     {
         "reject": {
@@ -28,7 +28,7 @@
     }
 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 [
     {
         "reject": {
@@ -38,7 +38,7 @@
     }
 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 [
     {
         "reject": {
@@ -48,7 +48,7 @@
     }
 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 [
     {
         "reject": {
@@ -58,7 +58,7 @@
     }
 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 [
     {
         "reject": {
@@ -68,7 +68,7 @@
     }
 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 [
     {
         "reject": {
@@ -78,7 +78,7 @@
     }
 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 [
     {
         "reject": {
@@ -88,7 +88,7 @@
     }
 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 [
     {
         "reject": {
@@ -98,7 +98,7 @@
     }
 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 [
     {
         "reject": {
@@ -108,7 +108,7 @@
     }
 ]
 
-# reject with icmpv6 type policy-fail
+# reject with icmpv6 policy-fail
 [
     {
         "reject": {
@@ -118,7 +118,7 @@
     }
 ]
 
-# reject with icmpv6 type reject-route
+# reject with icmpv6 reject-route
 [
     {
         "reject": {
@@ -189,7 +189,7 @@
     }
 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 [
     {
         "reject": {
@@ -199,7 +199,7 @@
     }
 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 [
     {
         "reject": {
@@ -209,7 +209,7 @@
     }
 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 [
     {
         "reject": {
@@ -219,7 +219,7 @@
     }
 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 [
     {
         "reject": {
@@ -229,7 +229,7 @@
     }
 ]
 
-# meta protocol ip reject with icmp type host-unreachable
+# meta protocol ip reject with icmp host-unreachable
 [
     {
         "reject": {
@@ -239,7 +239,7 @@
     }
 ]
 
-# meta protocol ip6 reject with icmpv6 type no-route
+# meta protocol ip6 reject with icmpv6 no-route
 [
     {
         "reject": {
@@ -249,7 +249,7 @@
     }
 ]
 
-# meta protocol ip reject with icmpx type admin-prohibited
+# meta protocol ip reject with icmpx admin-prohibited
 [
     {
         "match": {
@@ -270,7 +270,7 @@
     }
 ]
 
-# meta protocol ip6 reject with icmpx type admin-prohibited
+# meta protocol ip6 reject with icmpx admin-prohibited
 [
     {
         "match": {
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
index 5f76b0915d5c..d014adab0d52 100644
--- a/tests/py/netdev/reject.t.payload
+++ b/tests/py/netdev/reject.t.payload
@@ -1,76 +1,76 @@
-# reject with icmp type host-unreachable
+# reject with icmp host-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 1 ]
 
-# reject with icmp type net-unreachable
+# reject with icmp net-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 0 ]
 
-# reject with icmp type prot-unreachable
+# reject with icmp prot-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 2 ]
 
-# reject with icmp type port-unreachable
+# reject with icmp port-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 3 ]
 
-# reject with icmp type net-prohibited
+# reject with icmp net-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 9 ]
 
-# reject with icmp type host-prohibited
+# reject with icmp host-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 10 ]
 
-# reject with icmp type admin-prohibited
+# reject with icmp admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 13 ]
 
-# reject with icmpv6 type no-route
+# reject with icmpv6 no-route
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 0 ]
 
-# reject with icmpv6 type admin-prohibited
+# reject with icmpv6 admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 1 ]
 
-# reject with icmpv6 type addr-unreachable
+# reject with icmpv6 addr-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 3 ]
 
-# reject with icmpv6 type port-unreachable
+# reject with icmpv6 port-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
-# reject with icmpv6 type policy-fail
+# reject with icmpv6 policy-fail
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 5 ]
 
-# reject with icmpv6 type reject-route
+# reject with icmpv6 reject-route
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -100,41 +100,41 @@ netdev
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
-# reject with icmpx type host-unreachable
+# reject with icmpx host-unreachable
 netdev 
   [ reject type 2 code 2 ]
 
-# reject with icmpx type no-route
+# reject with icmpx no-route
 netdev 
   [ reject type 2 code 0 ]
 
-# reject with icmpx type admin-prohibited
+# reject with icmpx admin-prohibited
 netdev 
   [ reject type 2 code 3 ]
 
-# reject with icmpx type port-unreachable
+# reject with icmpx port-unreachable
 netdev 
   [ reject type 2 code 1 ]
 
-# meta protocol ip reject with icmp type host-unreachable
+# meta protocol ip reject with icmp host-unreachable
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 1 ]
 
-# meta protocol ip6 reject with icmpv6 type no-route
+# meta protocol ip6 reject with icmpv6 no-route
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 0 ]
 
-# meta protocol ip reject with icmpx type admin-prohibited
+# meta protocol ip reject with icmpx admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 2 code 3 ]
 
-# meta protocol ip6 reject with icmpx type admin-prohibited
+# meta protocol ip6 reject with icmpx admin-prohibited
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
-- 
2.20.1

