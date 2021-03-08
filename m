Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCED5C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5918650E7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCHOnc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCHOnG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:43:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E5C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:43:05 -0800 (PST)
Received: from localhost ([::1]:53578 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJH67-0003ox-SU; Mon, 08 Mar 2021 15:43:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] mnl: Set NFTNL_SET_DATA_TYPE before dumping set elements
Date:   Mon,  8 Mar 2021 15:42:55 +0100
Message-Id: <20210308144255.13557-1-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In combination with libnftnl's commit "set_elem: Fix printing of verdict
map elements", This adds the vmap target to netlink dumps. Adjust dumps
in tests/py accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c                             |  3 +
 tests/py/any/ct.t.payload             |  2 +-
 tests/py/any/meta.t.payload           |  2 +-
 tests/py/inet/fib.t.payload           |  2 +-
 tests/py/inet/tcp.t.payload           |  6 +-
 tests/py/ip/ip.t.payload              |  4 +-
 tests/py/ip/ip.t.payload.bridge       |  4 +-
 tests/py/ip/ip.t.payload.inet         |  4 +-
 tests/py/ip/ip.t.payload.netdev       |  4 +-
 tests/py/ip/masquerade.t.payload      |  2 +-
 tests/py/ip/redirect.t.payload        |  2 +-
 tests/py/ip6/ip6.t.payload.inet       |  4 +-
 tests/py/ip6/ip6.t.payload.ip6        |  4 +-
 tests/py/ip6/masquerade.t.payload.ip6 |  2 +-
 tests/py/ip6/redirect.t.payload.ip6   |  2 +-
 tests/py/ip6/vmap.t.payload.inet      | 84 +++++++++++++--------------
 tests/py/ip6/vmap.t.payload.ip6       | 84 +++++++++++++--------------
 tests/py/ip6/vmap.t.payload.netdev    | 84 +++++++++++++--------------
 18 files changed, 151 insertions(+), 148 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 9c965446521c0..deea586f9b002 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1544,6 +1544,9 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 	nftnl_set_set_str(nls, NFTNL_SET_NAME, h->set.name);
 	if (h->set_id)
 		nftnl_set_set_u32(nls, NFTNL_SET_ID, h->set_id);
+	if (set_is_datamap(set->flags))
+		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
+				  dtype_map_to_kernel(set->data->dtype));
 
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls, ctx);
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index a80e5a8d48ffb..733276e196f20 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -485,7 +485,7 @@ ip test-ip4 output
 # ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept}
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-	element 00000008 12345678  : 0 [end]	element 00000002 87654321  : 0 [end]
+	element 00000008 12345678  : drop 0 [end]	element 00000002 87654321  : accept 0 [end]
 ip test-ip4 output 
   [ ct load state => reg 1 ]
   [ ct load mark => reg 9 ]
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index c366452514389..99aab29c54b22 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -728,7 +728,7 @@ ip test-ip4 output
 # meta iif . meta oif vmap { "lo" . "lo" : drop }
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000001 00000001  : 0 [end]
+	element 00000001 00000001  : drop 0 [end]
 ip test-ip4 output
   [ meta load iif => reg 1 ]
   [ meta load oif => reg 9 ]
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index 1d4c3d94aa0bf..050857d96994e 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -16,7 +16,7 @@ ip test-ip prerouting
 # fib daddr . iif type vmap { blackhole : drop, prohibit : drop, unicast : accept }
 __map%d test-ip b
 __map%d test-ip 0
-        element 00000006  : 0 [end]     element 00000008  : 0 [end]     element 00000001  : 0 [end]
+	element 00000006  : drop 0 [end]	element 00000008  : drop 0 [end]	element 00000001  : accept 0 [end]
 ip test-ip prerouting
   [ fib daddr . iif type => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 3b7a4468ca2ca..5eaf4090462db 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -81,7 +81,7 @@ inet test-inet input
 # tcp dport vmap { 22 : accept, 23 : drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001600  : 0 [end]	element 00001700  : 0 [end]
+	element 00001600  : accept 0 [end]	element 00001700  : drop 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -91,7 +91,7 @@ inet test-inet input
 # tcp dport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
+	element 00001900  : accept 0 [end]	element 00001c00  : drop 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -190,7 +190,7 @@ inet test-inet input
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
-	element 00001900  : 0 [end]	element 00001c00  : 0 [end]
+	element 00001900  : accept 0 [end]	element 00001c00  : drop 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 578c8d3705930..bbff508bc604e 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -43,7 +43,7 @@ ip test-ip4 input
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-ip4 b size 2
 __map%d test-ip4 0
-	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
@@ -526,7 +526,7 @@ ip test-ip4 input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-ip4 f size 4
 __map%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 6ac5e74043368..33c9654f1c343 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -55,7 +55,7 @@ bridge test-bridge input
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-bridge b size 2
 __map%d test-bridge 0
-	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -686,7 +686,7 @@ bridge test-bridge input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-bridge f size 4
 __map%d test-bridge 0
-	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 8c778f99b0fa1..0d387da946d2c 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -55,7 +55,7 @@ inet test-inet input
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
@@ -686,7 +686,7 @@ inet test-inet input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-inet f size 4
 __map%d test-inet 0
-	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index d4e029b07a8ac..f75f789fe75f9 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -585,7 +585,7 @@ netdev test-netdev ingress
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-netdev f size 4
 __map%d test-netdev 0
-	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -686,7 +686,7 @@ netdev test-netdev ingress
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
 __map%d test-netdev b size 2
 __map%d test-netdev 0
-	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+	element 00000020  : continue 0 [end]	element 00000080  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index c4870ab8ae43b..79e52856a22d3 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -112,7 +112,7 @@ ip test-ip4 postrouting
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } masquerade
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
+	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
 ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index bdfc6d72d0055..424ad7b4f7ec0 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -194,7 +194,7 @@ ip test-ip4 output
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
+	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
 ip test-ip4 output
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 11ba34a1bca2b..a107abd7adc82 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -44,7 +44,7 @@ inet test-inet input
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000001  : 0 [end]	element 0000c00f  : 0 [end]
+	element 00000001  : accept 0 [end]	element 0000c00f  : continue 0 [end]
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -116,7 +116,7 @@ inet test-inet input
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-inet b size 2
 __map%d test-inet 0
-	element 00000000  : 0 [end]	element 00020000  : 0 [end]
+	element 00000000  : accept 0 [end]	element 00020000  : continue 0 [end]
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 78479253abbdf..6766622085e1f 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -34,7 +34,7 @@ ip6 test-ip6 input
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
-	element 00000001  : 0 [end]	element 0000c00f  : 0 [end]
+	element 00000001  : accept 0 [end]	element 0000c00f  : continue 0 [end]
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
@@ -92,7 +92,7 @@ ip6 test-ip6 input
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
-	element 00000000  : 0 [end]	element 00020000  : 0 [end]
+	element 00000000  : accept 0 [end]	element 00020000  : continue 0 [end]
 ip6 test-ip6 input 
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index d6410b2cf2db3..43ae2ae48244f 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -112,7 +112,7 @@ ip6 test-ip6 postrouting
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } masquerade
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
+	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
 ip6 test-ip6 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 20405cea54ef3..e9a2031614856 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -178,7 +178,7 @@ ip6 test-ip6 output
 # iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00001600  : 0 [end]	element 0000de00  : 0 [end]
+	element 00001600  : drop 0 [end]	element 0000de00  : drop 0 [end]
 ip6 test-ip6 output
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
diff --git a/tests/py/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
index 53f19eb9d0db6..522564a310447 100644
--- a/tests/py/ip6/vmap.t.payload.inet
+++ b/tests/py/ip6/vmap.t.payload.inet
@@ -1,7 +1,7 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-inet b
 __map%d test-inet 0
-	element 0000cdab 00000000 00000000 03000000  : 0 [end]
+	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -11,7 +11,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 34123412  : 0 [end]
+	element 34123412 34123412 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -21,7 +21,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34120000 34123412 34123412 34123412  : 0 [end]
+	element 34120000 34123412 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -31,7 +31,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 34123412 34123412 34123412  : 0 [end]
+	element 00003412 34123412 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -41,7 +41,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34120000 34123412 34123412  : 0 [end]
+	element 34123412 34120000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -51,7 +51,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 34123412 34123412  : 0 [end]
+	element 34123412 00003412 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -61,7 +61,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34120000 34123412  : 0 [end]
+	element 34123412 34123412 34120000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -71,7 +71,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 34123412  : 0 [end]
+	element 34123412 34123412 00003412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -81,7 +81,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 34120000  : 0 [end]
+	element 34123412 34123412 34123412 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -91,7 +91,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 00003412  : 0 [end]
+	element 34123412 34123412 34123412 00003412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -101,7 +101,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 34123412 34123412 34123412  : 0 [end]
+	element 00000000 34123412 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -111,7 +111,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 34120000 34123412 34123412  : 0 [end]
+	element 00003412 34120000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -121,7 +121,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 34123412 34123412  : 0 [end]
+	element 34123412 00000000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -131,7 +131,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 34120000 34123412  : 0 [end]
+	element 34123412 00003412 34120000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -141,7 +141,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 34123412  : 0 [end]
+	element 34123412 34123412 00000000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -151,7 +151,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 34120000  : 0 [end]
+	element 34123412 34123412 00003412 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -161,7 +161,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 00000000  : 0 [end]
+	element 34123412 34123412 34123412 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -171,7 +171,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 34120000 34123412 34123412  : 0 [end]
+	element 00000000 34120000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -181,7 +181,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 34123412 34123412  : 0 [end]
+	element 00003412 00000000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -191,7 +191,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 34120000 34123412  : 0 [end]
+	element 34123412 00000000 34120000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -201,7 +201,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 34123412  : 0 [end]
+	element 34123412 00003412 00000000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -211,7 +211,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 34120000  : 0 [end]
+	element 34123412 34123412 00000000 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -221,7 +221,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00003412 00000000  : 0 [end]
+	element 34123412 34123412 00003412 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -231,7 +231,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 34123412 34123412  : 0 [end]
+	element 00000000 00000000 34123412 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -241,7 +241,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 34120000 34123412  : 0 [end]
+	element 00003412 00000000 34120000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -251,7 +251,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 34123412  : 0 [end]
+	element 34123412 00000000 00000000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -261,7 +261,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 34120000  : 0 [end]
+	element 34123412 00003412 00000000 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -271,7 +271,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 00000000 00000000  : 0 [end]
+	element 34123412 34123412 00000000 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -281,7 +281,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 34120000 34123412  : 0 [end]
+	element 00000000 00000000 34120000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -291,7 +291,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 34123412  : 0 [end]
+	element 00003412 00000000 00000000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -301,7 +301,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 34120000  : 0 [end]
+	element 34123412 00000000 00000000 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -311,7 +311,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00003412 00000000 00000000  : 0 [end]
+	element 34123412 00003412 00000000 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -321,7 +321,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 00000000 34123412  : 0 [end]
+	element 00000000 00000000 00000000 34123412  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -331,7 +331,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 34120000  : 0 [end]
+	element 00003412 00000000 00000000 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -341,7 +341,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 00000000 00000000 00000000  : 0 [end]
+	element 34123412 00000000 00000000 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -351,7 +351,7 @@ inet test-inet input
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00000000 00000000 00000000 34120000  : 0 [end]
+	element 00000000 00000000 00000000 34120000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -361,7 +361,7 @@ inet test-inet input
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
-	element 00003412 00000000 00000000 00000000  : 0 [end]
+	element 00003412 00000000 00000000 00000000  : accept 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -371,7 +371,7 @@ inet test-inet input
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-inet f
 __map%d test-inet 0
-	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -381,7 +381,7 @@ inet test-inet input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -391,7 +391,7 @@ inet test-inet input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -401,7 +401,7 @@ inet test-inet input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
@@ -411,7 +411,7 @@ inet test-inet input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-inet b
 __map%d test-inet 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
index 620979f07782e..3850a7c58fd13 100644
--- a/tests/py/ip6/vmap.t.payload.ip6
+++ b/tests/py/ip6/vmap.t.payload.ip6
@@ -1,7 +1,7 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 0000cdab 00000000 00000000 03000000  : 0 [end]
+	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -9,7 +9,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 34123412  : 0 [end]
+	element 34123412 34123412 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -17,7 +17,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34120000 34123412 34123412 34123412  : 0 [end]
+	element 34120000 34123412 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -25,7 +25,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 34123412 34123412 34123412  : 0 [end]
+	element 00003412 34123412 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -33,7 +33,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34120000 34123412 34123412  : 0 [end]
+	element 34123412 34120000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -41,7 +41,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 34123412 34123412  : 0 [end]
+	element 34123412 00003412 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -49,7 +49,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34120000 34123412  : 0 [end]
+	element 34123412 34123412 34120000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -57,7 +57,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 34123412  : 0 [end]
+	element 34123412 34123412 00003412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -65,7 +65,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 34120000  : 0 [end]
+	element 34123412 34123412 34123412 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -73,7 +73,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 00003412  : 0 [end]
+	element 34123412 34123412 34123412 00003412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -81,7 +81,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 34123412 34123412 34123412  : 0 [end]
+	element 00000000 34123412 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -89,7 +89,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 34120000 34123412 34123412  : 0 [end]
+	element 00003412 34120000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -97,7 +97,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 34123412 34123412  : 0 [end]
+	element 34123412 00000000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -105,7 +105,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 34120000 34123412  : 0 [end]
+	element 34123412 00003412 34120000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -113,7 +113,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 34123412  : 0 [end]
+	element 34123412 34123412 00000000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -121,7 +121,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 34120000  : 0 [end]
+	element 34123412 34123412 00003412 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -129,7 +129,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 00000000  : 0 [end]
+	element 34123412 34123412 34123412 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -137,7 +137,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 34120000 34123412 34123412  : 0 [end]
+	element 00000000 34120000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -145,7 +145,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 34123412 34123412  : 0 [end]
+	element 00003412 00000000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -153,7 +153,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 34120000 34123412  : 0 [end]
+	element 34123412 00000000 34120000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -161,7 +161,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 34123412  : 0 [end]
+	element 34123412 00003412 00000000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -169,7 +169,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 34120000  : 0 [end]
+	element 34123412 34123412 00000000 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -177,7 +177,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00003412 00000000  : 0 [end]
+	element 34123412 34123412 00003412 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -185,7 +185,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 34123412 34123412  : 0 [end]
+	element 00000000 00000000 34123412 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -193,7 +193,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 34120000 34123412  : 0 [end]
+	element 00003412 00000000 34120000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -201,7 +201,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 34123412  : 0 [end]
+	element 34123412 00000000 00000000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -209,7 +209,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 34120000  : 0 [end]
+	element 34123412 00003412 00000000 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -217,7 +217,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 00000000 00000000  : 0 [end]
+	element 34123412 34123412 00000000 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -225,7 +225,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 34120000 34123412  : 0 [end]
+	element 00000000 00000000 34120000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -233,7 +233,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 34123412  : 0 [end]
+	element 00003412 00000000 00000000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -241,7 +241,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 34120000  : 0 [end]
+	element 34123412 00000000 00000000 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -249,7 +249,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00003412 00000000 00000000  : 0 [end]
+	element 34123412 00003412 00000000 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -257,7 +257,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 34123412  : 0 [end]
+	element 00000000 00000000 00000000 34123412  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -265,7 +265,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 34120000  : 0 [end]
+	element 00003412 00000000 00000000 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -273,7 +273,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 00000000 00000000 00000000  : 0 [end]
+	element 34123412 00000000 00000000 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -281,7 +281,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 34120000  : 0 [end]
+	element 00000000 00000000 00000000 34120000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -289,7 +289,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 00003412 00000000 00000000 00000000  : 0 [end]
+	element 00003412 00000000 00000000 00000000  : accept 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -297,7 +297,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-ip6 f
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -305,7 +305,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -313,7 +313,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -321,7 +321,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
@@ -329,7 +329,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-ip6 b
 __map%d test-ip6 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
index 0ae5d5b035555..d9cbad5877ae4 100644
--- a/tests/py/ip6/vmap.t.payload.netdev
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -1,7 +1,7 @@
 # ip6 saddr vmap { abcd::3 : accept }
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 0000cdab 00000000 00000000 03000000  : 0 [end]
+	element 0000cdab 00000000 00000000 03000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -11,7 +11,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 34123412  : 0 [end]
+	element 34123412 34123412 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -21,7 +21,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34120000 34123412 34123412 34123412  : 0 [end]
+	element 34120000 34123412 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -31,7 +31,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 34123412 34123412 34123412  : 0 [end]
+	element 00003412 34123412 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -41,7 +41,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34120000 34123412 34123412  : 0 [end]
+	element 34123412 34120000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -51,7 +51,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 34123412 34123412  : 0 [end]
+	element 34123412 00003412 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -61,7 +61,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34120000 34123412  : 0 [end]
+	element 34123412 34123412 34120000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -71,7 +71,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 34123412  : 0 [end]
+	element 34123412 34123412 00003412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -81,7 +81,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 34120000  : 0 [end]
+	element 34123412 34123412 34123412 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -91,7 +91,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 00003412  : 0 [end]
+	element 34123412 34123412 34123412 00003412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -101,7 +101,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 34123412 34123412 34123412  : 0 [end]
+	element 00000000 34123412 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -111,7 +111,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 34120000 34123412 34123412  : 0 [end]
+	element 00003412 34120000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -121,7 +121,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 34123412 34123412  : 0 [end]
+	element 34123412 00000000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -131,7 +131,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 34120000 34123412  : 0 [end]
+	element 34123412 00003412 34120000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -141,7 +141,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 34123412  : 0 [end]
+	element 34123412 34123412 00000000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -151,7 +151,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 34120000  : 0 [end]
+	element 34123412 34123412 00003412 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -161,7 +161,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 00000000  : 0 [end]
+	element 34123412 34123412 34123412 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -171,7 +171,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 34120000 34123412 34123412  : 0 [end]
+	element 00000000 34120000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -181,7 +181,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 34123412 34123412  : 0 [end]
+	element 00003412 00000000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -191,7 +191,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 34120000 34123412  : 0 [end]
+	element 34123412 00000000 34120000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -201,7 +201,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 34123412  : 0 [end]
+	element 34123412 00003412 00000000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -211,7 +211,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 34120000  : 0 [end]
+	element 34123412 34123412 00000000 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -221,7 +221,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00003412 00000000  : 0 [end]
+	element 34123412 34123412 00003412 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -231,7 +231,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 34123412 34123412  : 0 [end]
+	element 00000000 00000000 34123412 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -241,7 +241,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 34120000 34123412  : 0 [end]
+	element 00003412 00000000 34120000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -251,7 +251,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 34123412  : 0 [end]
+	element 34123412 00000000 00000000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -261,7 +261,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 34120000  : 0 [end]
+	element 34123412 00003412 00000000 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -271,7 +271,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 00000000 00000000  : 0 [end]
+	element 34123412 34123412 00000000 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -281,7 +281,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 34120000 34123412  : 0 [end]
+	element 00000000 00000000 34120000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -291,7 +291,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 34123412  : 0 [end]
+	element 00003412 00000000 00000000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -301,7 +301,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 34120000  : 0 [end]
+	element 34123412 00000000 00000000 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -311,7 +311,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00003412 00000000 00000000  : 0 [end]
+	element 34123412 00003412 00000000 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -321,7 +321,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234:1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 34123412  : 0 [end]
+	element 00000000 00000000 00000000 34123412  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -331,7 +331,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 34120000  : 0 [end]
+	element 00003412 00000000 00000000 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -341,7 +341,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 00000000 00000000 00000000  : 0 [end]
+	element 34123412 00000000 00000000 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -351,7 +351,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::1234 : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 34120000  : 0 [end]
+	element 00000000 00000000 00000000 34120000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -361,7 +361,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { 1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 00003412 00000000 00000000 00000000  : 0 [end]
+	element 00003412 00000000 00000000 00000000  : accept 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -371,7 +371,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-netdev f
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 00000000  : 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -381,7 +381,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 aaaa0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 aaaa0000  : drop 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -391,7 +391,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 bbbb0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 bbbb0000  : drop 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -401,7 +401,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 cccc0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 cccc0000  : drop 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
@@ -411,7 +411,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop}
 __map%d test-netdev b
 __map%d test-netdev 0
-	element 34123412 34123412 34123412 0000aaaa  : 0 [end]	element 00000000 00000000 00000000 dddd0000  : 0 [end]
+	element 34123412 34123412 34123412 0000aaaa  : accept 0 [end]	element 00000000 00000000 00000000 dddd0000  : drop 0 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
-- 
2.30.1

