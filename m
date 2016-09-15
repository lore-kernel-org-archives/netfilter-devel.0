From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: py: fix numgen case failed due to changes in libnftnl
Date: Thu, 15 Sep 2016 21:42:49 +0800
Message-ID: <1473946969-4978-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:55316 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753383AbcIONnU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Sep 2016 09:43:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In nftnl_expr_ng_snprintf_default, format "(%u)" was changed to
"mod %u", so numgen test case failed:
  ...
  '[ numgen reg 1 = inc(2) ]' mismatches '[ numgen reg 1 = inc mod 2 ]'
  ...
  ip/numgen.t: 3 unit tests, 3 error, 0 warning

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/py/ip/numgen.t.payload | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index 1099e73..a548b5c 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -1,6 +1,6 @@
 # ct mark set numgen inc mod 2
 ip test-ip4 pre
-  [ numgen reg 1 = inc(2) ]
+  [ numgen reg 1 = inc mod 2 ]
   [ ct set mark with reg 1 ]
 
 # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
@@ -8,7 +8,7 @@ __map%d x b
 __map%d x 0
         element 00000000  : 640aa8c0 0 [end]    element 01000000  : c814a8c0 0 [end]
 ip test-ip4 pre 
-  [ numgen reg 1 = inc(2) ]
+  [ numgen reg 1 = inc mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
@@ -17,7 +17,7 @@ __map%d test-ip4 f
 __map%d test-ip4 0
         element 00000000  : 640aa8c0 0 [end]    element 06000000  : c814a8c0 0 [end]    element 0a000000  : 1 [end]
 ip test-ip4 pre
-  [ numgen reg 1 = inc(10) ]
+  [ numgen reg 1 = inc mod 10 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
-- 
2.5.5


