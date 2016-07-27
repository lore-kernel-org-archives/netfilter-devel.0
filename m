From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 7/7] tests: ip payload set support for ecn and dscp
Date: Wed, 27 Jul 2016 02:43:16 +0200
Message-ID: <1469580196-2100-8-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60776 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbcG0BP2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:28 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/ip.t                |  5 +++++
 tests/py/ip/ip.t.payload        | 32 ++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 42 +++++++++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev | 44 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+)

diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 90e117a..8fa53be 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -126,3 +126,8 @@ ip hdrlength 16;fail
 iif lo ip daddr set 127.0.0.1;ok
 iif lo ip checksum set 0;ok
 iif lo ip id set 0;ok
+iif lo ip ecn set 1;ok;iif lo ip ecn set ect1
+iif lo ip ecn set ce;ok
+
+iif lo ip dscp set af23;ok
+iif lo ip dscp set cs0;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d6ef540..75e85c1 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -437,3 +437,35 @@ ip test-ip4 input
   [ immediate reg 1 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
 
+# iif lo ip ecn set 1
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip ecn set ce
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set af23
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set cs0
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 6c78536..5cdf2a6 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -573,3 +573,45 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ immediate reg 1 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
+
+# iif lo ip ecn set 1
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip ecn set ce
+inet test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set af23
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set cs0
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 714b0d2..134fb73 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -671,3 +671,47 @@ netdev test-netdev ingress
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ immediate reg 1 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
+
+# iif lo ip ecn set 1
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip ecn set ce
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set af23
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
+# iif lo ip dscp set cs0
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+
-- 
2.7.3

