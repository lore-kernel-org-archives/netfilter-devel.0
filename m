From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: py: update quota and payload
Date: Wed, 14 Dec 2016 00:38:12 +0100
Message-ID: <1481672292-24147-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbcLMXiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 18:38:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18C46C2B08
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:38:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03310A7E72
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:38:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A85CA7E72
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:38:15 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include new consumed field for quota, and check for csum_flags in payload.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Sorry for breaking these tests.

 tests/py/any/quota.t.payload       | 26 +++++++++++++-------------
 tests/py/bridge/ether.t.payload    |  2 +-
 tests/py/inet/udp.t.payload.inet   |  4 ++--
 tests/py/inet/udp.t.payload.ip     |  4 ++--
 tests/py/inet/udp.t.payload.ip6    |  4 ++--
 tests/py/inet/udp.t.payload.netdev |  4 ++--
 tests/py/ip/ip.t.payload           | 14 +++++++-------
 tests/py/ip/ip.t.payload.inet      | 14 +++++++-------
 tests/py/ip/ip.t.payload.netdev    | 14 +++++++-------
 tests/py/ip6/ip6.t.payload.inet    | 18 +++++++++---------
 tests/py/ip6/ip6.t.payload.ip6     | 18 +++++++++---------
 11 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/tests/py/any/quota.t.payload b/tests/py/any/quota.t.payload
index 519db2c7c8c2..31cfccbf21ad 100644
--- a/tests/py/any/quota.t.payload
+++ b/tests/py/any/quota.t.payload
@@ -1,52 +1,52 @@
 # quota 1025 bytes
 ip test-ip4 output 
-  [ quota bytes 1025 flags 0 ]
+  [ quota bytes 1025 consumed 0 flags 0 ]
 
 # quota 1 kbytes
 ip test-ip4 output 
-  [ quota bytes 1024 flags 0 ]
+  [ quota bytes 1024 consumed 0 flags 0 ]
 
 # quota 2 kbytes
 ip test-ip4 output 
-  [ quota bytes 2048 flags 0 ]
+  [ quota bytes 2048 consumed 0 flags 0 ]
 
 # quota 1025 kbytes
 ip test-ip4 output 
-  [ quota bytes 1049600 flags 0 ]
+  [ quota bytes 1049600 consumed 0 flags 0 ]
 
 # quota 1023 mbytes
 ip test-ip4 output 
-  [ quota bytes 1072693248 flags 0 ]
+  [ quota bytes 1072693248 consumed 0 flags 0 ]
 
 # quota 10230 mbytes
 ip test-ip4 output 
-  [ quota bytes 10726932480 flags 0 ]
+  [ quota bytes 10726932480 consumed 0 flags 0 ]
 
 # quota 1023000 mbytes
 ip test-ip4 output 
-  [ quota bytes 1072693248000 flags 0 ]
+  [ quota bytes 1072693248000 consumed 0 flags 0 ]
 
 # quota over 1 kbytes
 ip test-ip4 output 
-  [ quota bytes 1024 flags 1 ]
+  [ quota bytes 1024 consumed 0 flags 1 ]
 
 # quota over 2 kbytes
 ip test-ip4 output 
-  [ quota bytes 2048 flags 1 ]
+  [ quota bytes 2048 consumed 0 flags 1 ]
 
 # quota over 1025 kbytes
 ip test-ip4 output 
-  [ quota bytes 1049600 flags 1 ]
+  [ quota bytes 1049600 consumed 0 flags 1 ]
 
 # quota over 1023 mbytes
 ip test-ip4 output 
-  [ quota bytes 1072693248 flags 1 ]
+  [ quota bytes 1072693248 consumed 0 flags 1 ]
 
 # quota over 10230 mbytes
 ip test-ip4 output 
-  [ quota bytes 10726932480 flags 1 ]
+  [ quota bytes 10726932480 consumed 0 flags 1 ]
 
 # quota over 1023000 mbytes
 ip test-ip4 output 
-  [ quota bytes 1072693248000 flags 1 ]
+  [ quota bytes 1072693248000 consumed 0 flags 1 ]
 
diff --git a/tests/py/bridge/ether.t.payload b/tests/py/bridge/ether.t.payload
index 74956b643564..1caa2d509ea2 100644
--- a/tests/py/bridge/ether.t.payload
+++ b/tests/py/bridge/ether.t.payload
@@ -47,6 +47,6 @@ bridge test-bridge input
   [ payload load 6b @ link header + 0 => reg 1 ]
   [ cmp eq reg 1 0x03020100 0x00000504 ]
   [ immediate reg 1 0xbadcfeff 0x00007698 ]
-  [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 csum_flags 0x0 ]
   [ immediate reg 0 drop ]
 
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
index ca27953ed7ea..d91eb784ee96 100644
--- a/tests/py/inet/udp.t.payload.inet
+++ b/tests/py/inet/udp.t.payload.inet
@@ -318,7 +318,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
 
 # iif "lo" udp dport set 65535
 inet test-inet input
@@ -327,4 +327,4 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
index 9f1d0c7bb6e9..d49fc513ab66 100644
--- a/tests/py/inet/udp.t.payload.ip
+++ b/tests/py/inet/udp.t.payload.ip
@@ -318,7 +318,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
 
 # iif "lo" udp dport set 65535
 ip test-ip4 input
@@ -327,4 +327,4 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index af17e1c3a2fd..d16e0075f8ee 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -318,7 +318,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
 
 # iif "lo" udp dport set 65535
 ip test-ip4 input
@@ -327,4 +327,4 @@ ip test-ip4 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
index 832c913a4b0b..ab0f51a499d8 100644
--- a/tests/py/inet/udp.t.payload.netdev
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -318,7 +318,7 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
 
 # iif "lo" udp dport set 65535
 netdev test-netdev ingress
@@ -327,5 +327,5 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
 
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 5038628405a4..cd54ae0fea7e 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -528,21 +528,21 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x0100007f ]
-  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
 ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
 ip test-ip4 input
@@ -550,7 +550,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
 ip test-ip4 input
@@ -558,7 +558,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
 ip test-ip4 input
@@ -566,7 +566,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
 ip test-ip4 input
@@ -574,5 +574,5 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index e658a0ff1353..64606d956e10 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -690,7 +690,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ immediate reg 1 0x0100007f ]
-  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
 inet test-inet input
@@ -699,7 +699,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
 inet test-inet input
@@ -708,7 +708,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
 inet test-inet input
@@ -718,7 +718,7 @@ inet test-inet input
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
 inet test-netdev ingress
@@ -728,7 +728,7 @@ inet test-netdev ingress
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
 inet test-inet input
@@ -738,7 +738,7 @@ inet test-inet input
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
 inet test-inet input
@@ -748,5 +748,5 @@ inet test-inet input
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 6df41cb7bd38..acfa1eab5979 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -790,7 +790,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x0100007f ]
-  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 4b @ network header + 16 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip checksum set 0
 netdev test-netdev ingress
@@ -799,7 +799,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 10 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip id set 0
 netdev test-netdev ingress
@@ -808,7 +808,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 4 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set 1
 netdev test-netdev ingress
@@ -818,7 +818,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
 netdev test-netdev ingress
@@ -828,7 +828,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
 netdev test-netdev ingress
@@ -838,7 +838,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
 netdev test-netdev ingress
@@ -848,5 +848,5 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 40277fd8c5ce..c9cb999dcdcd 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -618,7 +618,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
-  [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" ip6 hoplimit set 1
 inet test-inet input
@@ -627,7 +627,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ immediate reg 1 0x00000001 ]
-  [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set af42
 inet test-inet input
@@ -637,7 +637,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
 inet test-inet input
@@ -647,7 +647,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
 inet test-inet input
@@ -657,7 +657,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
-  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
 inet test-inet input
@@ -667,7 +667,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
-  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
 inet test-inet input
@@ -677,7 +677,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
 inet test-inet input
@@ -687,7 +687,7 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
 inet test-inet input
@@ -697,5 +697,5 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 74d06b3ed231..d8afe60671b6 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -462,14 +462,14 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
-  [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 16b @ network header + 24 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" ip6 hoplimit set 1
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 1 0x00000001 ]
-  [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 7 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set af42
 ip6 test-ip6 input
@@ -477,7 +477,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
 ip6 test-ip6 input
@@ -485,7 +485,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
-  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
 ip6 test-ip6 input
@@ -493,7 +493,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
-  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
 ip6 test-ip6 input
@@ -501,7 +501,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
-  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
 ip6 test-ip6 input
@@ -509,7 +509,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
 ip6 test-ip6 input
@@ -517,7 +517,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
 ip6 test-ip6 input
@@ -525,5 +525,5 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
-  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 ]
+  [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
-- 
2.1.4

