From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: py: replace "eth0" with "lo" in dup expr tests
Date: Sat, 10 Sep 2016 16:14:03 +0800
Message-ID: <1473495243-39716-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:45778 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751543AbcIJIOq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2016 04:14:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patch follow up on Manuel's commit a8871ba6daa0 ("tests: py: any:
Make tests more generic by using other interfaces"). The ifindex of
"eth0" is not always 1, furthermore, "eth0" maybe not exist on some
systems. So replace it with "lo" will make tests more rubost.

In other test cases, "eth0" is used by iifname or oifname, so there's no
need to convert it to "lo". Even if "eth0" is not exist, test will never
fail.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/py/ip/dup.t          | 4 ++--
 tests/py/ip/dup.t.payload  | 8 ++++----
 tests/py/ip6/dup.t         | 4 ++--
 tests/py/ip6/dup.t.payload | 8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/py/ip/dup.t b/tests/py/ip/dup.t
index 5119636..700031c 100644
--- a/tests/py/ip/dup.t
+++ b/tests/py/ip/dup.t
@@ -3,5 +3,5 @@
 *ip;test-ip4;input
 
 dup to 192.168.2.1;ok
-dup to 192.168.2.1 device "eth0";ok
-dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device "eth0";ok
+dup to 192.168.2.1 device "lo";ok
+dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device "lo";ok
diff --git a/tests/py/ip/dup.t.payload b/tests/py/ip/dup.t.payload
index 94d55c6..347dc07 100644
--- a/tests/py/ip/dup.t.payload
+++ b/tests/py/ip/dup.t.payload
@@ -3,19 +3,19 @@ ip test-ip4 test
   [ immediate reg 1 0x0102a8c0 ]
   [ dup sreg_addr 1 ]
 
-# dup to 192.168.2.1 device "eth0"
+# dup to 192.168.2.1 device "lo"
 ip test-ip4 test 
   [ immediate reg 1 0x0102a8c0 ]
-  [ immediate reg 2 0x00000002 ]
+  [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
-# dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device "eth0"
+# dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device "lo"
 __map%d test-ip4 b
 __map%d test-ip4 0
         element 7802a8c0  : 0102a8c0 0 [end]
 ip test-ip4 test 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ immediate reg 2 0x00000002 ]
+  [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
diff --git a/tests/py/ip6/dup.t b/tests/py/ip6/dup.t
index f3c8c83..72cc5d5 100644
--- a/tests/py/ip6/dup.t
+++ b/tests/py/ip6/dup.t
@@ -3,5 +3,5 @@
 *ip6;test-ip6;input
 
 dup to abcd::1;ok
-dup to abcd::1 device "eth0";ok
-dup to ip6 saddr map { abcd::1 : cafe::cafe } device "eth0";ok
+dup to abcd::1 device "lo";ok
+dup to ip6 saddr map { abcd::1 : cafe::cafe } device "lo";ok
diff --git a/tests/py/ip6/dup.t.payload b/tests/py/ip6/dup.t.payload
index 30015cc..c441d4b 100644
--- a/tests/py/ip6/dup.t.payload
+++ b/tests/py/ip6/dup.t.payload
@@ -3,19 +3,19 @@ ip6 test test
   [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
   [ dup sreg_addr 1 ]
 
-# dup to abcd::1 device "eth0"
+# dup to abcd::1 device "lo"
 ip6 test test 
   [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
-  [ immediate reg 2 0x00000002 ]
+  [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
-# dup to ip6 saddr map { abcd::1 : cafe::cafe } device "eth0"
+# dup to ip6 saddr map { abcd::1 : cafe::cafe } device "lo"
 __map%d test-ip6 b
 __map%d test-ip6 0
         element 0000cdab 00000000 00000000 01000000  : 0000feca 00000000 00000000 feca0000 0 [end]
 ip6 test-ip6 input 
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ immediate reg 2 0x00000002 ]
+  [ immediate reg 2 0x00000001 ]
   [ dup sreg_addr 1 sreg_dev 2 ]
 
-- 
2.5.5


