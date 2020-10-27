Return-Path: <SRS0=ZDGT=EC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C33AC61DD8
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 16:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3759920809
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 16:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369091AbgJ0Q6r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Oct 2020 12:58:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:60418 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1814288AbgJ0Q4A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Oct 2020 12:56:00 -0400
Received: from localhost ([::1]:58272 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kXSGM-00028b-DX; Tue, 27 Oct 2020 17:55:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] src: Optimize prefix matches on byte-boundaries
Date:   Tue, 27 Oct 2020 17:56:02 +0100
Message-Id: <20201027165602.26630-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027165602.26630-1-phil@nwl.cc>
References: <20201027165602.26630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a prefix expression's length is on a byte-boundary, it is sufficient
to just reduce the length passed to "cmp" expression. No need for
explicit bitwise modification of data on LHS. The relevant code is
already there, used for string prefix matches. There is one exception
though, namely zero-length prefixes: Kernel doesn't accept zero-length
"cmp" expressions, so keep them in the old code-path for now.

This patch depends upon the previous one to correctly parse odd-sized
payload matches but has to extend support for non-payload LHS as well.
In practice, this is needed for "ct" expressions as they allow matching
against IP address prefixes, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c       | 5 +++--
 src/netlink_linearize.c         | 4 +++-
 tests/py/ip/ct.t.payload        | 4 ----
 tests/py/ip/ip.t.payload        | 6 ++----
 tests/py/ip/ip.t.payload.bridge | 6 ++----
 tests/py/ip/ip.t.payload.inet   | 6 ++----
 tests/py/ip/ip.t.payload.netdev | 6 ++----
 tests/py/ip6/ip6.t.payload.inet | 5 ++---
 tests/py/ip6/ip6.t.payload.ip6  | 5 ++---
 9 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b7876a8da8375..32ec07a091216 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -322,8 +322,9 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 
 	if (left->len > right->len &&
 	    expr_basetype(left) != &string_type) {
-		netlink_error(ctx, loc, "Relational expression size mismatch");
-		goto err_free;
+		mpz_lshift_ui(right->value, left->len - right->len);
+		right = prefix_expr_alloc(loc, right, right->len);
+		right->prefix->len = left->len;
 	} else if (left->len > 0 && left->len < right->len) {
 		expr_free(left);
 		left = netlink_parse_concat_expr(ctx, loc, sreg, right->len);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 38f66be8814f9..23cf54639303a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -533,7 +533,9 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_flagcmp(ctx, expr, dreg);
 	case EXPR_PREFIX:
 		sreg = get_register(ctx, expr->left);
-		if (expr_basetype(expr->left)->type != TYPE_STRING) {
+		if (expr_basetype(expr->left)->type != TYPE_STRING &&
+		    (!expr->right->prefix_len ||
+		     expr->right->prefix_len % BITS_PER_BYTE)) {
 			len = div_round_up(expr->right->len, BITS_PER_BYTE);
 			netlink_gen_expr(ctx, expr->left, sreg);
 			right = netlink_gen_prefix(ctx, expr, sreg);
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index d5faed4c667c5..a7e08f98e6a3e 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -21,25 +21,21 @@ ip test-ip4 output
 # ct original ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir original ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct reply ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src_ip => reg 1 , dir reply ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct original ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir original ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct reply ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst_ip => reg 1 , dir reply ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
 # ct l3proto ipv4
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d627b22f26148..825c0f0b1b6ed 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -358,14 +358,12 @@ ip test-ip4 input
 
 # ip saddr 192.168.2.0/24
 ip test-ip4 input
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0002a8c0 ]
 
 # ip saddr != 192.168.2.0/24
 ip test-ip4 input
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x0002a8c0 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 91a4fde382e65..e958a5b4b4e9e 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -466,16 +466,14 @@ bridge test-bridge input
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0002a8c0 ]
 
 # ip saddr != 192.168.2.0/24
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x0002a8c0 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index b9cb28a22e7a8..650147391c978 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -466,16 +466,14 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0002a8c0 ]
 
 # ip saddr != 192.168.2.0/24
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x0002a8c0 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 588e5ca2a3e30..58ae358bdc478 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -379,16 +379,14 @@ netdev test-netdev ingress
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0002a8c0 ]
 
 # ip saddr != 192.168.2.0/24
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ payload load 3b @ network header + 12 => reg 1 ]
   [ cmp neq reg 1 0x0002a8c0 ]
 
 # ip saddr 192.168.3.1 ip daddr 192.168.3.100
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index d015c8efaa257..ffc9b9f5b560b 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -604,9 +604,8 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ payload load 16b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ payload load 8b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1 ip6 daddr ::2
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index b2e8363c01e1f..18b8bcbe601a0 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -452,9 +452,8 @@ ip6 test-ip6 input
 
 # ip6 saddr ::/64
 ip6 test-ip6 input
-  [ payload load 16b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ payload load 8b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 ]
 
 # ip6 saddr ::1 ip6 daddr ::2
 ip6 test-ip6 input
-- 
2.28.0

