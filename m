From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 5/7] tests: ip6 dscp, flowlabel and ecn test cases
Date: Wed, 27 Jul 2016 02:43:14 +0200
Message-ID: <1469580196-2100-6-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60756 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbcG0BPQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:16 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip6/ip6.t              | 12 +++++++
 tests/py/ip6/ip6.t.payload.inet | 71 +++++++++++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 57 +++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 0a58fa8..7dea2f7 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -145,3 +145,15 @@ ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234
 # limit impact to lo
 iif lo ip6 daddr set ::1;ok
 iif lo ip6 hoplimit set 1;ok
+iif lo ip6 dscp set af42;ok
+iif lo ip6 dscp set 63;ok;iif lo ip6 dscp set 0x3f
+iif lo ip6 ecn set ect0;ok
+iif lo ip6 ecn set ce;ok
+
+iif lo ip6 flowlabel set 0;ok
+iif lo ip6 flowlabel set 12345;ok
+iif lo ip6 flowlabel set 0xfffff;ok;iif lo ip6 flowlabel set 1048575
+
+iif lo ip6 ecn set 4;fail
+iif lo ip6 dscp set 64;fail
+iif lo ip6 flowlabel set 1048576;fail
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 45bdd09..bf21b5b 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -530,3 +530,74 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ immediate reg 1 0x00000001 ]
   [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 dscp set af42
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 dscp set 63
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 ecn set ect0
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 ecn set ce
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 0
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 12345
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 0xfffff
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 7e158a8..70d2ea0 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -392,3 +392,60 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000001 ]
   [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 dscp set af42
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 dscp set 63
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 ecn set ect0
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 ecn set ce
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 0
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 12345
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
+# iif lo ip6 flowlabel set 0xfffff
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+
-- 
2.7.3

