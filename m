From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/5] tests: add test cases for vmap binop transfer
Date: Thu, 11 Jan 2018 16:30:24 +0100
Message-ID: <20180111153024.25198-7-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57504 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932173AbeAKPmy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:54 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/ip.t                |  2 ++
 tests/py/ip/ip.t.payload        | 20 ++++++++++++++++++++
 tests/py/ip/ip.t.payload.bridge | 24 ++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 24 ++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev | 24 ++++++++++++++++++++++++
 tests/py/ip6/ip6.t              |  2 ++
 tests/py/ip6/ip6.t.payload.inet | 23 +++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 19 +++++++++++++++++++
 8 files changed, 138 insertions(+)

diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 35ea36e00061..d773042afe02 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -31,6 +31,7 @@ ip dscp != 0x20;ok;ip dscp != cs4
 ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 - ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
 ip dscp != {cs0, cs3};ok
+ip dscp vmap { cs1 : continue , cs4 : accept } counter;ok
 
 ip length 232;ok
 ip length != 233;ok
@@ -120,6 +121,7 @@ ip saddr \& 0xffff0000 == 0xffff0000;ok;ip saddr 255.255.0.0/16
 ip version 4 ip hdrlength 5;ok
 ip hdrlength 0;ok
 ip hdrlength 15;ok
+ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter;ok
 ip hdrlength 16;fail
 
 # limit impact to lo
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index f14f33bc5c1b..e9de690d8f70 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -40,6 +40,16 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip dscp vmap { cs1 : continue , cs4 : accept } counter
+__map%d test-ip4 b size 2
+__map%d test-ip4 0
+	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+ip test-ip4 input 
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip length 232
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
@@ -523,6 +533,16 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
+# ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
+__map%d test-ip4 f size 4
+__map%d test-ip4 0
+	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+ip test-ip4 input 
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # iif "lo" ip daddr set 127.0.0.1
 ip test-ip4 input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 5d5f7d22db92..d1c57a01db73 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -52,6 +52,18 @@ bridge test-bridge input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip dscp vmap { cs1 : continue , cs4 : accept } counter
+__map%d test-bridge b size 2
+__map%d test-bridge 0
+	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+bridge test-bridge input 
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip length 232
 bridge test-bridge input 
   [ payload load 2b @ link header + 12 => reg 1 ]
@@ -671,6 +683,18 @@ bridge test-bridge input
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
+# ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
+__map%d test-bridge f size 4
+__map%d test-bridge 0
+	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+bridge test-bridge input 
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # iif "lo" ip daddr set 127.0.0.1
 bridge test-bridge input 
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index ef6725ebf42a..e6cb700f0db3 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -52,6 +52,18 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip dscp vmap { cs1 : continue , cs4 : accept } counter
+__map%d test-inet b size 2
+__map%d test-inet 0
+	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip length 232
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -683,6 +695,18 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
+# ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
+__map%d test-inet f size 4
+__map%d test-inet 0
+	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # iif "lo" ip daddr set 127.0.0.1
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index e33ce4a15d5e..0f15247fa0f3 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -582,6 +582,18 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
+# ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
+__map%d test-netdev f size 4
+__map%d test-netdev 0
+	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip ttl 233
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -783,6 +795,18 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip dscp vmap { cs1 : continue , cs4 : accept } counter
+__map%d test-netdev b size 2
+__map%d test-netdev 0
+	element 00000020  : 0 [end]	element 00000080  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # iif "lo" ip daddr set 127.0.0.1
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 438b94db79e4..8210d22be3d5 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -15,6 +15,7 @@ ip6 dscp != cs1;ok
 ip6 dscp 0x38;ok;ip6 dscp cs7
 ip6 dscp != 0x20;ok;ip6 dscp != cs4
 ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter;ok
 
 ip6 flowlabel 22;ok
 ip6 flowlabel != 233;ok
@@ -25,6 +26,7 @@ ip6 flowlabel { 33, 55, 67, 88};ok
 ip6 flowlabel != { 33, 55, 67, 88};ok
 ip6 flowlabel { 33-55};ok
 ip6 flowlabel != { 33-55};ok
+ip6 flowlabel vmap { 0 : accept, 2 : continue } ;ok
 
 ip6 length 22;ok
 ip6 length != 233;ok
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index c9cb999dcdcd..d015c8efaa25 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -41,6 +41,18 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
+__map%d test-inet b size 2
+__map%d test-inet 0
+	element 00000001  : 0 [end]	element 0000c00f  : 0 [end]
+ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip6 flowlabel 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -101,6 +113,17 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip6 flowlabel vmap { 0 : accept, 2 : continue } 
+__map%d test-inet b size 2
+__map%d test-inet 0
+	element 00000000  : 0 [end]	element 00020000  : 0 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
 # ip6 length 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index d8afe60671b6..b2e8363c01e1 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -31,6 +31,16 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
+__map%d test-ip6 b size 2
+__map%d test-ip6 0
+	element 00000001  : 0 [end]	element 0000c00f  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+  [ counter pkts 0 bytes 0 ]
+
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
@@ -79,6 +89,15 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# ip6 flowlabel vmap { 0 : accept, 2 : continue } 
+__map%d test-ip6 b size 2
+__map%d test-ip6 0
+	element 00000000  : 0 [end]	element 00020000  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
 # ip6 length 22
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-- 
2.13.6

