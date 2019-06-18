Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D797C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50272206BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfFRS4O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:56:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54558 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbfFRS4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:56:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hdJGz-0002ey-FP; Tue, 18 Jun 2019 20:56:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] src: prefer meta protocol as bridge l3 dependency
Date:   Tue, 18 Jun 2019 20:43:59 +0200
Message-Id: <20190618184359.29760-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618184359.29760-1-fw@strlen.de>
References: <20190618184359.29760-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On families other than 'ip', the rule

ip protocol icmp

needs a dependency on the ip protocol so we do not treat e.g. an ipv6
header as ip.

Bridge currently uses eth_hdr.type for this, but that will cause the
rule above to not match in case the ip packet is within a VLAN tagged
frame -- ether.type will appear as ETH_P_8021Q.

Due to vlan tag stripping, skb->protocol will be ETH_P_IP -- so prefer
to use this instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c                            |   6 +-
 src/payload.c                         |  18 +++
 tests/py/bridge/ether.t               |   4 +-
 tests/py/bridge/ether.t.payload       |  24 ++--
 tests/py/bridge/icmpX.t.payload       |   4 +-
 tests/py/bridge/reject.t.payload      |  24 ++--
 tests/py/inet/ip_tcp.t.payload.bridge |   8 +-
 tests/py/inet/sets.t.payload.bridge   |   4 +-
 tests/py/ip/ip.t.payload.bridge       | 180 +++++++++++++-------------
 9 files changed, 151 insertions(+), 121 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 583e790ff47d..1e8964eb48c4 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -539,7 +539,11 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
 		break;
 	case NFT_META_PROTOCOL:
-		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_NETDEV)
+		if (h->base != PROTO_BASE_LL_HDR)
+			return;
+
+		if (ctx->family != NFPROTO_NETDEV &&
+		    ctx->family != NFPROTO_BRIDGE)
 			return;
 
 		desc = proto_find_upper(h->desc, ntohs(mpz_get_uint16(right->value)));
diff --git a/src/payload.c b/src/payload.c
index 338a4b762cf8..7e4f935be293 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -18,6 +18,7 @@
 #include <net/if_arp.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
+#include <linux/if_ether.h>
 
 #include <rule.h>
 #include <expression.h>
@@ -369,6 +370,23 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  "no %s protocol specified",
 				  proto_base_names[expr->payload.base - 1]);
 
+	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
+		/* prefer netdev proto, which adds dependencies based
+		 * on skb->protocol.
+		 *
+		 * This has the advantage that we will also match
+		 * vlan encapsulated traffic.
+		 *
+		 * eth_hdr(skb)->type would not match, as nft_payload
+		 * will pretend vlan tag was not offloaded, i.e.
+		 * type is ETH_P_8021Q in such a case, but skb->protocol
+		 * would still match the l3 header type.
+		 */
+		if (expr->payload.desc == &proto_ip ||
+		    expr->payload.desc == &proto_ip6)
+			desc = &proto_netdev;
+	}
+
 	return payload_add_dependency(ctx, desc, expr->payload.desc, expr, res);
 }
 
diff --git a/tests/py/bridge/ether.t b/tests/py/bridge/ether.t
index 15f5f857b198..e4f75d160477 100644
--- a/tests/py/bridge/ether.t
+++ b/tests/py/bridge/ether.t
@@ -2,8 +2,8 @@
 
 *bridge;test-bridge;input
 
-tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
-tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
+tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04 accept
+tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4;ok
 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept;ok
 
diff --git a/tests/py/bridge/ether.t.payload b/tests/py/bridge/ether.t.payload
index 1caa2d509ea2..eaff9c312bae 100644
--- a/tests/py/bridge/ether.t.payload
+++ b/tests/py/bridge/ether.t.payload
@@ -6,10 +6,12 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00001600 ]
   [ meta load iiftype => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x04030201 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
 # tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
@@ -18,10 +20,12 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
-  [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x04030201 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
 
 # tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
 bridge test-bridge input
@@ -29,15 +33,19 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
-  [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x04030201 ]
 
 # ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 bridge test-bridge input
-  [ payload load 8b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00080411 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x04030201 ]
   [ immediate reg 0 accept ]
diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
index 0fab1abf61ea..f9ea7b60450a 100644
--- a/tests/py/bridge/icmpX.t.payload
+++ b/tests/py/bridge/icmpX.t.payload
@@ -1,6 +1,6 @@
 # ip protocol icmp icmp type echo-request
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
@@ -18,7 +18,7 @@ bridge test-bridge input
 
 # ip6 nexthdr icmpv6 icmpv6 type echo-request
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
diff --git a/tests/py/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
index 888179df9c97..0d10547bbce6 100644
--- a/tests/py/bridge/reject.t.payload
+++ b/tests/py/bridge/reject.t.payload
@@ -1,66 +1,66 @@
 # reject with icmp type host-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 1 ]
 
 # reject with icmp type net-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 0 ]
 
 # reject with icmp type prot-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 2 ]
 
 # reject with icmp type port-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 3 ]
 
 # reject with icmp type net-prohibited
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 9 ]
 
 # reject with icmp type host-prohibited
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 10 ]
 
 # reject with icmp type admin-prohibited
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ reject type 0 code 13 ]
 
 # reject with icmpv6 type no-route
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 0 ]
 
 # reject with icmpv6 type admin-prohibited
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 1 ]
 
 # reject with icmpv6 type addr-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 3 ]
 
 # reject with icmpv6 type port-unreachable
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 4 ]
 
@@ -68,7 +68,7 @@ bridge test-bridge input
 bridge test-bridge input
   [ meta load mark => reg 1 ]
   [ cmp eq reg 1 0x00003039 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/inet/ip_tcp.t.payload.bridge b/tests/py/inet/ip_tcp.t.payload.bridge
index f9f2e0a137f6..0344cd66668c 100644
--- a/tests/py/inet/ip_tcp.t.payload.bridge
+++ b/tests/py/inet/ip_tcp.t.payload.bridge
@@ -1,6 +1,6 @@
 # ip protocol tcp tcp dport 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -9,7 +9,7 @@ bridge test-bridge input
 
 # ip protocol tcp ip saddr 1.2.3.4 tcp dport 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -20,7 +20,7 @@ bridge test-bridge input
 
 # ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -32,7 +32,7 @@ bridge test-bridge input
 
 # ip protocol tcp counter tcp dport 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index 6f21f827bc96..f5aaab1d79bc 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -1,6 +1,6 @@
 # ip saddr @set1 drop
 bridge test-inet input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
@@ -8,7 +8,7 @@ bridge test-inet input
 
 # ip6 daddr != @set2 accept
 bridge test-inet input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index ad1d0aa801d5..91a4fde382e6 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -1,6 +1,6 @@
 # ip dscp cs1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -8,7 +8,7 @@ bridge test-bridge input
 
 # ip dscp != cs1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -16,7 +16,7 @@ bridge test-bridge input
 
 # ip dscp 0x38
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -24,7 +24,7 @@ bridge test-bridge input
 
 # ip dscp != 0x20
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -35,7 +35,7 @@ __set%d test-bridge 3 size 21
 __set%d test-bridge 0
 	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -46,7 +46,7 @@ __set%d test-bridge 3 size 2
 __set%d test-bridge 0
 	element 00000000  : 0 [end]	element 00000060  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -57,7 +57,7 @@ __map%d test-bridge b size 2
 __map%d test-bridge 0
 	element 00000020  : 0 [end]	element 00000080  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
@@ -66,21 +66,21 @@ bridge test-bridge input
 
 # ip length 232
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000e800 ]
 
 # ip length != 233
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # ip length 333-435
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ cmp gte reg 1 0x00004d01 ]
@@ -88,7 +88,7 @@ bridge test-bridge input
 
 # ip length != 333-453
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ range neq reg 1 0x00004d01 0x0000c501 ]
@@ -98,7 +98,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -108,7 +108,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00004d01  : 0 [end]	element 00002902  : 0 [end]	element 0000a102  : 0 [end]	element 00004603  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -118,7 +118,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -128,28 +128,28 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip id 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # ip id != 233
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # ip id 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -157,7 +157,7 @@ bridge test-bridge input
 
 # ip id != 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -167,7 +167,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -177,7 +177,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -187,7 +187,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -197,14 +197,14 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip frag-off 222 accept
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000de00 ]
@@ -212,14 +212,14 @@ bridge test-bridge input
 
 # ip frag-off != 233
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # ip frag-off 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -227,7 +227,7 @@ bridge test-bridge input
 
 # ip frag-off != 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -237,7 +237,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -247,7 +247,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -257,7 +257,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -267,14 +267,14 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip ttl 0 drop
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
@@ -282,14 +282,14 @@ bridge test-bridge input
 
 # ip ttl 233
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ cmp eq reg 1 0x000000e9 ]
 
 # ip ttl 33-55
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
@@ -297,7 +297,7 @@ bridge test-bridge input
 
 # ip ttl != 45-50
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ range neq reg 1 0x0000002d 0x00000032 ]
@@ -307,7 +307,7 @@ __set%d test-bridge 3 size 3
 __set%d test-bridge 0
 	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -317,7 +317,7 @@ __set%d test-bridge 3 size 3
 __set%d test-bridge 0
 	element 0000002b  : 0 [end]	element 00000035  : 0 [end]	element 0000002d  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -327,7 +327,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -337,21 +337,21 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip protocol tcp
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
 
 # ip protocol != tcp
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp neq reg 1 0x00000006 ]
@@ -361,7 +361,7 @@ __set%d test-bridge 3 size 9
 __set%d test-bridge 0
 	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -372,7 +372,7 @@ __set%d test-bridge 3 size 9
 __set%d test-bridge 0
 	element 00000001  : 0 [end]	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -380,14 +380,14 @@ bridge test-bridge input
 
 # ip protocol 255
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x000000ff ]
 
 # ip checksum 13172 drop
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ cmp eq reg 1 0x00007433 ]
@@ -395,21 +395,21 @@ bridge test-bridge input
 
 # ip checksum 22
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # ip checksum != 233
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # ip checksum 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
@@ -417,7 +417,7 @@ bridge test-bridge input
 
 # ip checksum != 33-45
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
@@ -427,7 +427,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -437,7 +437,7 @@ __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -447,7 +447,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -457,14 +457,14 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip saddr 192.168.2.0/24
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
@@ -472,7 +472,7 @@ bridge test-bridge input
 
 # ip saddr != 192.168.2.0/24
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
@@ -480,7 +480,7 @@ bridge test-bridge input
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0103a8c0 ]
@@ -489,21 +489,21 @@ bridge test-bridge input
 
 # ip saddr != 1.1.1.1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x01010101 ]
 
 # ip saddr 1.1.1.1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x01010101 ]
 
 # ip daddr 192.168.0.1-192.168.0.250
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0100a8c0 ]
@@ -511,7 +511,7 @@ bridge test-bridge input
 
 # ip daddr 10.0.0.0-10.255.255.255
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0000000a ]
@@ -519,7 +519,7 @@ bridge test-bridge input
 
 # ip daddr 172.16.0.0-172.31.255.255
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x000010ac ]
@@ -527,7 +527,7 @@ bridge test-bridge input
 
 # ip daddr 192.168.3.1-192.168.4.250
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0103a8c0 ]
@@ -535,7 +535,7 @@ bridge test-bridge input
 
 # ip daddr != 192.168.0.1-192.168.0.250
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
@@ -545,7 +545,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -555,7 +555,7 @@ __set%d test-bridge 7 size 3
 __set%d test-bridge 0
 	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -565,7 +565,7 @@ __set%d test-bridge 3 size 3
 __set%d test-bridge 0
 	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -576,7 +576,7 @@ __set%d test-bridge 3 size 3
 __set%d test-bridge 0
 	element 0105a8c0  : 0 [end]	element 0205a8c0  : 0 [end]	element 0305a8c0  : 0 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -584,7 +584,7 @@ bridge test-bridge input
 
 # ip daddr 192.168.1.2-192.168.1.55
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp gte reg 1 0x0201a8c0 ]
@@ -592,14 +592,14 @@ bridge test-bridge input
 
 # ip daddr != 192.168.1.2-192.168.1.55
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp gte reg 1 0x0301a8c0 ]
@@ -607,21 +607,21 @@ bridge test-bridge input
 
 # ip saddr != 192.168.1.3-192.168.33.55
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip daddr 192.168.0.1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
 # ip daddr 192.168.0.1 drop
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0100a8c0 ]
@@ -629,14 +629,14 @@ bridge test-bridge input
 
 # ip daddr 192.168.0.2
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0200a8c0 ]
 
 # ip saddr & 0xff == 1
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
@@ -644,7 +644,7 @@ bridge test-bridge input
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
@@ -652,7 +652,7 @@ bridge test-bridge input
 
 # ip saddr & 0xffff0000 == 0xffff0000
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
@@ -660,7 +660,7 @@ bridge test-bridge input
 
 # ip version 4 ip hdrlength 5
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
@@ -671,7 +671,7 @@ bridge test-bridge input
 
 # ip hdrlength 0
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
@@ -679,7 +679,7 @@ bridge test-bridge input
 
 # ip hdrlength 15
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
@@ -690,7 +690,7 @@ __map%d test-bridge f size 4
 __map%d test-bridge 0
 	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
 bridge test-bridge input 
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
@@ -701,7 +701,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x0100007f ]
   [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
@@ -710,7 +710,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
@@ -719,7 +719,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
@@ -728,7 +728,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
@@ -738,7 +738,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
@@ -748,7 +748,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
@@ -758,7 +758,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
@@ -768,7 +768,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
@@ -778,7 +778,7 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
-- 
2.21.0

