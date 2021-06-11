Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE259C48BD1
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 945D5613D0
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFKRRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 13:17:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37682 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhFKRRA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 13:17:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A663164240
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 19:13:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add vlan dei
Date:   Fri, 11 Jun 2021 19:14:57 +0200
Message-Id: <20210611171457.13966-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

the CFI bit has been repurposed as DEI "Drop Eligible Indicator"
since 802.1Q-2011.

The vlan cfi field is still retained for compatibility.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1516
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/payload-expression.txt            |  6 +++---
 include/proto.h                       |  1 +
 src/parser_bison.y                    |  2 ++
 src/proto.c                           |  1 +
 src/scanner.l                         |  1 +
 tests/py/bridge/vlan.t                | 22 ++++++++++-----------
 tests/py/bridge/vlan.t.json           | 28 +++++++++++++--------------
 tests/py/bridge/vlan.t.payload        | 14 +++++++-------
 tests/py/bridge/vlan.t.payload.netdev | 14 +++++++-------
 9 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index cead33c7a910..930a18074a6c 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -21,7 +21,7 @@ ether_type
 VLAN HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*vlan* {*id* | *cfi* | *pcp* | *type*}
+*vlan* {*id* | *dei* | *pcp* | *type*}
 
 .VLAN header expression
 [options="header"]
@@ -30,8 +30,8 @@ VLAN HEADER EXPRESSION
 |id|
 VLAN ID (VID) |
 integer (12 bit)
-|cfi|
-Canonical Format Indicator|
+|dei|
+Drop Eligible Indicator|
 integer (1 bit)
 |pcp|
 Priority code point|
diff --git a/include/proto.h b/include/proto.h
index b9217588f3e3..580e409028bc 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -227,6 +227,7 @@ enum eth_hdr_fields {
 enum vlan_hdr_fields {
 	VLANHDR_INVALID,
 	VLANHDR_PCP,
+	VLANHDR_DEI,
 	VLANHDR_CFI,
 	VLANHDR_VID,
 	VLANHDR_TYPE,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3a11e6971177..7dcf6940a8ab 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -326,6 +326,7 @@ int nft_lex(void *, void *, void *);
 %token VLAN			"vlan"
 %token ID			"id"
 %token CFI			"cfi"
+%token DEI			"dei"
 %token PCP			"pcp"
 
 %token ARP			"arp"
@@ -5182,6 +5183,7 @@ vlan_hdr_expr		:	VLAN	vlan_hdr_field	close_scope_vlan
 
 vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
 			|	CFI		{ $$ = VLANHDR_CFI; }
+			|	DEI		{ $$ = VLANHDR_DEI; }
 			|	PCP		{ $$ = VLANHDR_PCP; }
 			|	TYPE		{ $$ = VLANHDR_TYPE; }
 			;
diff --git a/src/proto.c b/src/proto.c
index 63727605a20a..2b61e0ba47fd 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -1032,6 +1032,7 @@ const struct proto_desc proto_vlan = {
 	},
 	.templates	= {
 		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 0, 3),
+		[VLANHDR_DEI]		= VLANHDR_BITFIELD("dei", 3, 1),
 		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 3, 1),
 		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 4, 12),
 		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
diff --git a/src/scanner.l b/src/scanner.l
index 5c493e390c2c..b22e7683f086 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -424,6 +424,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "id"			{ return ID; }
 <SCANSTATE_VLAN>{
 	"cfi"		{ return CFI; }
+	"dei"		{ return DEI; }
 	"pcp"		{ return PCP; }
 }
 "8021ad"		{ yylval->string = xstrdup(yytext); return STRING; }
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index f67b8180996e..b59bf78ec61b 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -8,20 +8,20 @@ vlan id 4094;ok
 vlan id 0;ok
 # bad vlan id
 vlan id 4096;fail
-vlan id 4094 vlan cfi 0;ok
-vlan id 4094 vlan cfi != 1;ok
-vlan id 4094 vlan cfi 1;ok
-# bad cfi
-vlan id 4094 vlan cfi 2;fail
-vlan id 4094 vlan cfi 1 vlan pcp 8;fail
-vlan id 4094 vlan cfi 1 vlan pcp 7;ok
-vlan id 4094 vlan cfi 1 vlan pcp 3;ok
+vlan id 4094 vlan dei 0;ok
+vlan id 4094 vlan dei != 1;ok
+vlan id 4094 vlan dei 1;ok
+# bad dei
+vlan id 4094 vlan dei 2;fail
+vlan id 4094 vlan dei 1 vlan pcp 8;fail
+vlan id 4094 vlan dei 1 vlan pcp 7;ok
+vlan id 4094 vlan dei 1 vlan pcp 3;ok
 
 ether type vlan vlan id 4094;ok;vlan id 4094
 ether type vlan vlan id 0;ok;vlan id 0
-ether type vlan vlan id 4094 vlan cfi 0;ok;vlan id 4094 vlan cfi 0
-ether type vlan vlan id 4094 vlan cfi 1;ok;vlan id 4094 vlan cfi 1
-ether type vlan vlan id 4094 vlan cfi 2;fail
+ether type vlan vlan id 4094 vlan dei 0;ok;vlan id 4094 vlan dei 0
+ether type vlan vlan id 4094 vlan dei 1;ok;vlan id 4094 vlan dei 1
+ether type vlan vlan id 4094 vlan dei 2;fail
 
 vlan id 4094 tcp dport 22;ok
 vlan id 1 ip saddr 10.0.0.1;ok
diff --git a/tests/py/bridge/vlan.t.json b/tests/py/bridge/vlan.t.json
index 2a4b64f2279f..d86d7223839e 100644
--- a/tests/py/bridge/vlan.t.json
+++ b/tests/py/bridge/vlan.t.json
@@ -30,7 +30,7 @@
     }
 ]
 
-# vlan id 4094 vlan cfi 0
+# vlan id 4094 vlan dei 0
 [
     {
         "match": {
@@ -48,7 +48,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -58,7 +58,7 @@
     }
 ]
 
-# vlan id 4094 vlan cfi != 1
+# vlan id 4094 vlan dei != 1
 [
     {
         "match": {
@@ -76,7 +76,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -86,7 +86,7 @@
     }
 ]
 
-# vlan id 4094 vlan cfi 1
+# vlan id 4094 vlan dei 1
 [
     {
         "match": {
@@ -104,7 +104,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -114,7 +114,7 @@
     }
 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 7
+# vlan id 4094 vlan dei 1 vlan pcp 7
 [
     {
         "match": {
@@ -132,7 +132,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -154,7 +154,7 @@
     }
 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 3
+# vlan id 4094 vlan dei 1 vlan pcp 3
 [
     {
         "match": {
@@ -172,7 +172,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -226,7 +226,7 @@
     }
 ]
 
-# ether type vlan vlan id 4094 vlan cfi 0
+# ether type vlan vlan id 4094 vlan dei 0
 [
     {
         "match": {
@@ -244,7 +244,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
@@ -254,7 +254,7 @@
     }
 ]
 
-# ether type vlan vlan id 4094 vlan cfi 1
+# ether type vlan vlan id 4094 vlan dei 1
 [
     {
         "match": {
@@ -272,7 +272,7 @@
         "match": {
             "left": {
                 "payload": {
-                    "field": "cfi",
+                    "field": "dei",
                     "protocol": "vlan"
                 }
             },
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index a78f294671df..1063a9a237fd 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -14,7 +14,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# vlan id 4094 vlan cfi 0
+# vlan id 4094 vlan dei 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -25,7 +25,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# vlan id 4094 vlan cfi != 1
+# vlan id 4094 vlan dei != 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -36,7 +36,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000010 ]
 
-# vlan id 4094 vlan cfi 1
+# vlan id 4094 vlan dei 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -63,7 +63,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# ether type vlan vlan id 4094 vlan cfi 0
+# ether type vlan vlan id 4094 vlan dei 0
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -74,7 +74,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# ether type vlan vlan id 4094 vlan cfi 1
+# ether type vlan vlan id 4094 vlan dei 1
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -156,7 +156,7 @@ bridge test-bridge input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 7
+# vlan id 4094 vlan dei 1 vlan pcp 7
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
@@ -170,7 +170,7 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 3
+# vlan id 4094 vlan dei 1 vlan pcp 3
 bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 22e244e2e791..5c96d3e9947f 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -18,7 +18,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# vlan id 4094 vlan cfi 0
+# vlan id 4094 vlan dei 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -31,7 +31,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# vlan id 4094 vlan cfi != 1
+# vlan id 4094 vlan dei != 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -44,7 +44,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000010 ]
 
-# vlan id 4094 vlan cfi 1
+# vlan id 4094 vlan dei 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -77,7 +77,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# ether type vlan vlan id 4094 vlan cfi 0
+# ether type vlan vlan id 4094 vlan dei 0
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -90,7 +90,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# ether type vlan vlan id 4094 vlan cfi 1
+# ether type vlan vlan id 4094 vlan dei 1
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -184,7 +184,7 @@ netdev test-netdev ingress
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 7
+# vlan id 4094 vlan dei 1 vlan pcp 7
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -200,7 +200,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
-# vlan id 4094 vlan cfi 1 vlan pcp 3
+# vlan id 4094 vlan dei 1 vlan pcp 3
 netdev test-netdev ingress 
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-- 
2.20.1

