Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD04C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 10:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61FE610C7
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhDBKzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 06:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhDBKzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 06:55:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFB3C0613E6
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Apr 2021 03:55:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lSHS6-0007RR-Uz; Fri, 02 Apr 2021 12:54:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/4] proto: replace vlan ether type with 8021q
Date:   Fri,  2 Apr 2021 12:54:53 +0200
Message-Id: <20210402105453.16775-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401140846.24452-1-fw@strlen.de>
References: <20210401140846.24452-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous patches added "8021ad" mnemonic for IEEE 802.1AD frame type.
This adds the 8021q shorthand for the existing 'vlan' frame type.

nft will continue to recognize 'ether type vlan', but listing
will now print 8021q.

Adjust all test cases accordingly.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c                           |  5 ++++-
 src/scanner.l                         |  1 +
 tests/py/any/meta.t                   |  4 ++--
 tests/py/any/meta.t.json              |  4 ++--
 tests/py/any/meta.t.json.output       |  6 +++---
 tests/py/any/meta.t.payload           |  2 +-
 tests/py/bridge/meta.t                |  2 +-
 tests/py/bridge/meta.t.json           |  2 +-
 tests/py/bridge/reject.t              |  6 +++---
 tests/py/bridge/reject.t.json         |  6 +++---
 tests/py/bridge/reject.t.json.output  |  3 +--
 tests/py/bridge/reject.t.payload      |  2 +-
 tests/py/bridge/vlan.t                |  6 +++---
 tests/py/bridge/vlan.t.json           |  8 ++++----
 tests/py/bridge/vlan.t.json.output    | 10 +++++-----
 tests/py/bridge/vlan.t.payload        |  4 ++--
 tests/py/bridge/vlan.t.payload.netdev |  4 ++--
 17 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 67c519be1382..63727605a20a 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -1057,8 +1057,11 @@ static const struct symbol_table ethertype_tbl = {
 		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
 		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
 		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
-		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
+		SYMBOL("8021q",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL("8021ad",	__constant_htons(ETH_P_8021AD)),
+
+		/* for compatibility with older versions */
+		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL_LIST_END
 	},
 };
diff --git a/src/scanner.l b/src/scanner.l
index 9eb79d2d2454..a9232db8978e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -423,6 +423,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"pcp"		{ return PCP; }
 }
 "8021ad"		{ yylval->string = xstrdup(yytext); return STRING; }
+"8021q"			{ yylval->string = xstrdup(yytext); return STRING; }
 
 "arp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
 <SCANSTATE_ARP>{
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 7b5825051c8a..0b894cce19c8 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -20,8 +20,8 @@ meta length != { 33, 55, 67, 88};ok
 meta length { 33-55, 66-88};ok
 meta length != { 33-55, 66-88};ok
 
-meta protocol { ip, arp, ip6, vlan };ok;meta protocol { ip6, ip, vlan, arp}
-meta protocol != {ip, arp, ip6, vlan};ok
+meta protocol { ip, arp, ip6, vlan };ok;meta protocol { ip6, ip, 8021q, arp}
+meta protocol != {ip, arp, ip6, 8021q};ok
 meta protocol ip;ok
 meta protocol != ip;ok
 
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 47dc0724d0b8..1a98843c7b0e 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -199,7 +199,7 @@
     }
 ]
 
-# meta protocol != {ip, arp, ip6, vlan}
+# meta protocol != {ip, arp, ip6, 8021q}
 [
     {
         "match": {
@@ -212,7 +212,7 @@
                     "ip",
                     "arp",
                     "ip6",
-                    "vlan"
+                    "8021q"
                 ]
             }
         }
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 74b934b84839..4e9e669fdbc3 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -10,7 +10,7 @@
                 "set": [
                     "ip",
                     "arp",
-                    "vlan",
+                    "8021q",
                     "ip6"
                 ]
             }
@@ -18,7 +18,7 @@
     }
 ]
 
-# meta protocol != {ip, arp, ip6, vlan}
+# meta protocol != {ip, arp, ip6, 8021q}
 [
     {
         "match": {
@@ -30,7 +30,7 @@
                 "set": [
                     "ip",
                     "arp",
-                    "vlan",
+                    "8021q",
                     "ip6"
                 ]
             }
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 99aab29c54b2..4e43905e3094 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -68,7 +68,7 @@ ip test-ip4 input
   [ meta load protocol => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta protocol != {ip, arp, ip6, vlan}
+# meta protocol != {ip, arp, ip6, 8021q}
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00000008  : 0 [end]	element 00000608  : 0 [end]	element 0000dd86  : 0 [end]	element 00000081  : 0 [end]
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index 94525f2944ce..eda7082f02b4 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -4,5 +4,5 @@
 
 meta obrname "br0";ok
 meta ibrname "br0";ok
-meta ibrvproto vlan;ok
+meta ibrvproto vlan;ok;meta ibrvproto 8021q
 meta ibrpvid 100;ok
diff --git a/tests/py/bridge/meta.t.json b/tests/py/bridge/meta.t.json
index a7a180c29aa6..3122774eba8c 100644
--- a/tests/py/bridge/meta.t.json
+++ b/tests/py/bridge/meta.t.json
@@ -32,7 +32,7 @@
                 "meta": { "key": "ibrvproto" }
             },
 	    "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     }
 ]
diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index ee33af77eab6..b242eef49a2b 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -30,13 +30,13 @@ reject with icmpx type port-unreachable;ok;reject
 ether type ipv6 reject with icmp type host-unreachable;fail
 ether type ip6 reject with icmp type host-unreachable;fail
 ether type ip reject with icmpv6 type no-route;fail
-ether type vlan reject;ok
+ether type vlan reject;ok;ether type 8021q reject
 ether type arp reject;fail
-ether type vlan reject with tcp reset;ok;meta l4proto 6 ether type vlan reject with tcp reset
+ether type vlan reject with tcp reset;ok;meta l4proto 6 ether type 8021q reject with tcp reset
 ether type arp reject with tcp reset;fail
 ip protocol udp reject with tcp reset;fail
 
 ether type ip reject with icmpx type admin-prohibited;ok
 ether type ip6 reject with icmpx type admin-prohibited;ok
-ether type vlan reject with icmpx type admin-prohibited;ok
+ether type 8021q reject with icmpx type admin-prohibited;ok
 ether type arp reject with icmpx type admin-prohibited;fail
diff --git a/tests/py/bridge/reject.t.json b/tests/py/bridge/reject.t.json
index aea871f70907..fe21734d0ae3 100644
--- a/tests/py/bridge/reject.t.json
+++ b/tests/py/bridge/reject.t.json
@@ -289,7 +289,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
@@ -318,7 +318,7 @@
     }
 ]
 
-# ether type vlan reject with icmpx type admin-prohibited
+# ether type 8021q reject with icmpx type admin-prohibited
 [
     {
         "match": {
@@ -329,7 +329,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
diff --git a/tests/py/bridge/reject.t.json.output b/tests/py/bridge/reject.t.json.output
index e01a63af5a35..b8a44f0eeb02 100644
--- a/tests/py/bridge/reject.t.json.output
+++ b/tests/py/bridge/reject.t.json.output
@@ -71,7 +71,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
@@ -81,4 +81,3 @@
         }
     }
 ]
-
diff --git a/tests/py/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
index 7deb6fbf5fac..22569877c428 100644
--- a/tests/py/bridge/reject.t.payload
+++ b/tests/py/bridge/reject.t.payload
@@ -132,7 +132,7 @@ bridge
   [ cmp eq reg 1 0x00000081 ]
   [ reject type 1 code 0 ]
 
-# ether type vlan reject with icmpx type admin-prohibited
+# ether type 8021q reject with icmpx type admin-prohibited
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 8553ba56351d..f67b8180996e 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -32,12 +32,12 @@ ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53;ok;vlan id 1 ip sadd
 vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3;ok
 vlan id { 1, 2, 4, 100, 4096 };fail
 
-ether type vlan ip protocol 1 accept;ok
+ether type vlan ip protocol 1 accept;ok;ether type 8021q ip protocol 1 accept
 
 # IEEE 802.1AD
 ether type 8021ad vlan id 1 ip protocol 6 accept;ok
-ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter;ok
-ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6;ok;ether type 8021ad vlan id 1 vlan type vlan vlan id 2 ip protocol 6
+ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter;ok
+ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6;ok;ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 ip protocol 6
 
 # illegal dependencies
 ether type ip vlan id 1;fail
diff --git a/tests/py/bridge/vlan.t.json b/tests/py/bridge/vlan.t.json
index 8eab271d790b..2a4b64f2279f 100644
--- a/tests/py/bridge/vlan.t.json
+++ b/tests/py/bridge/vlan.t.json
@@ -573,7 +573,7 @@
     }
 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 [
     {
         "match": {
@@ -608,7 +608,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
@@ -643,7 +643,7 @@
     }
 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 [
     {
         "match": {
@@ -678,7 +678,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
diff --git a/tests/py/bridge/vlan.t.json.output b/tests/py/bridge/vlan.t.json.output
index a2cc212ea314..2f90c8ffd1e7 100644
--- a/tests/py/bridge/vlan.t.json.output
+++ b/tests/py/bridge/vlan.t.json.output
@@ -9,7 +9,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
@@ -72,7 +72,7 @@
     }
 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 [
     {
         "match": {
@@ -107,7 +107,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
@@ -139,7 +139,7 @@
     }
 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 [
     {
         "match": {
@@ -174,7 +174,7 @@
                 }
             },
             "op": "==",
-            "right": "vlan"
+            "right": "8021q"
         }
     },
     {
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index f60c752de401..a78f294671df 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -222,7 +222,7 @@ bridge
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 0 accept ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0000a888 ]
@@ -238,7 +238,7 @@ bridge
   [ cmp eq reg 1 0x00000008 ]
   [ counter pkts 0 bytes 0 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0000a888 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 94ca6867c271..22e244e2e791 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -260,7 +260,7 @@ netdev
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 0 accept ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter
 netdev
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -278,7 +278,7 @@ netdev
   [ cmp eq reg 1 0x00000008 ]
   [ counter pkts 0 bytes 0 ]
 
-# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+# ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip ip protocol 6
 netdev
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-- 
2.26.3

