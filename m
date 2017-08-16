From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: add test case for ttl/protocol set
Date: Wed, 16 Aug 2017 19:01:56 +0200
Message-ID: <20170816170156.11594-2-fw@strlen.de>
References: <20170816170156.11594-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47186 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751943AbdHPRBl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 13:01:41 -0400
In-Reply-To: <20170816170156.11594-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft .. ip ttl set 42

did set the protocol field and left ttl alone, add test cases for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/ip.t                |  2 ++
 tests/py/ip/ip.t.payload        | 16 ++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 20 ++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev | 20 ++++++++++++++++++++
 4 files changed, 58 insertions(+)

diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 9ab15df63a3d..f779dd9aa572 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -127,6 +127,8 @@ iif "lo" ip checksum set 0;ok
 iif "lo" ip id set 0;ok
 iif "lo" ip ecn set 1;ok;iif "lo" ip ecn set ect1
 iif "lo" ip ecn set ce;ok
+iif "lo" ip ttl set 23;ok
+iif "lo" ip protocol set 1;ok
 
 iif "lo" ip dscp set af23;ok
 iif "lo" ip dscp set cs0;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index cd54ae0fea7e..dcf5e348c9e9 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -576,3 +576,19 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip ttl set 23
+ip test-ip4 input 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip protocol set 1
+ip test-ip4 input 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
+
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 64606d956e10..96a77b5969a2 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -750,3 +750,23 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip ttl set 23
+inet test-inet input 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip protocol set 1
+inet test-inet input 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
+
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index acfa1eab5979..45d29b3491cc 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -850,3 +850,23 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip ttl set 23
+netdev test-netdev ingress 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip protocol set 1
+netdev test-netdev ingress 
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 8 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
+
-- 
2.13.0

