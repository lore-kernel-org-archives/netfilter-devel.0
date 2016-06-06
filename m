From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] payload: don't update protocol context if we can't find a description
Date: Mon,  6 Jun 2016 22:01:18 +0200
Message-ID: <1465243278-22625-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53843 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbcFFUBB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 16:01:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since commit
20b1131c07acd2fc ("payload: fix stacked headers protocol context tracking")
we deref null pointer if we can't find a description for the desired
protocol, so "ip protocol 254" crashes while testing protocols 6 or 17
(tcp, udp) works.

Also add a test case for this.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1072
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c                   | 3 +++
 tests/py/ip/ip.t                | 3 +++
 tests/py/ip/ip.t.payload        | 5 +++++
 tests/py/ip/ip.t.payload.inet   | 7 +++++++
 tests/py/ip/ip.t.payload.netdev | 7 +++++++
 5 files changed, 25 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index ac0e917..9ba980a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -85,6 +85,9 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, proto);
 
+	if (!desc)
+		return;
+
 	assert(desc->base <= PROTO_BASE_MAX);
 	if (desc->base == base->base) {
 		assert(base->length > 0);
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 594136c..a265b75 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -75,6 +75,9 @@ ip protocol != tcp;ok;ip protocol != 6
 ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
 - ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
 
+ip protocol 255;ok
+ip protocol 256;fail
+
 ip checksum 13172 drop;ok
 ip checksum 22;ok
 ip checksum != 233;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 3bd3358..15cc590 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -204,6 +204,11 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol 255
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x000000ff ]
+
 # ip checksum 13172 drop
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index ef4692e..e495246 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -268,6 +268,13 @@ inet test-inet input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol 255
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x000000ff ]
+
 # ip checksum 13172 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 4feaa27..8eaee4c 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -204,6 +204,13 @@ netdev test-netdev ingress
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# ip protocol 255
+ip test-ip4 input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x000000ff ]
+
 # ip checksum 13172 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.7.3

