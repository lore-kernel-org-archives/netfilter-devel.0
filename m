From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 3/3] tests: py: add some testcases for log flags
Date: Sun, 25 Sep 2016 17:07:01 +0800
Message-ID: <1474794421-5365-4-git-send-email-zlpnobody@163.com>
References: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:43569 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965617AbcIYJH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 05:07:59 -0400
In-Reply-To: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Add both good and bad nft rules to cover log flags, also update t.payload
due to changes in libnftnl, i.e. "prefix (null)" and "flags 0" will never
be printed out.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/py/any/log.t                |  4 ++++
 tests/py/any/log.t.payload        | 33 ++++++++++++++++++++-------------
 tests/py/ip/icmp.t.payload.ip     |  2 +-
 tests/py/ip6/icmpv6.t.payload.ip6 |  6 +++---
 4 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/tests/py/any/log.t b/tests/py/any/log.t
index 99a7f1f..eb7779c 100644
--- a/tests/py/any/log.t
+++ b/tests/py/any/log.t
@@ -25,3 +25,7 @@ log prefix aaaaa-aaaaaa group 2 snaplen 33;ok;log prefix "aaaaa-aaaaaa" group 2
 log group 2 queue-threshold 2;ok
 log group 2 snaplen 33;ok
 log group 2 prefix \"nft-test: \";ok;log prefix "nft-test: " group 2
+
+log uid;ok
+log level debug tcpseq,ipopt,uid;ok
+log tcpopt,macdecoed group 2;fail
diff --git a/tests/py/any/log.t.payload b/tests/py/any/log.t.payload
index 689668b..cecdcee 100644
--- a/tests/py/any/log.t.payload
+++ b/tests/py/any/log.t.payload
@@ -1,52 +1,59 @@
 # log
 ip test-ip4 output
-  [ log prefix (null) ]
+  [ log ]
 
 # log level emerg
 ip test-ip4 output
-  [ log prefix (null) level 0 flags 0]
+  [ log level 0 ]
 
 # log level alert
 ip test-ip4 output
-  [ log prefix (null) level 1 flags 0]
+  [ log level 1 ]
 
 # log level crit
 ip test-ip4 output
-  [ log prefix (null) level 2 flags 0]
+  [ log level 2 ]
 
 # log level err
 ip test-ip4 output
-  [ log prefix (null) level 3 flags 0]
+  [ log level 3 ]
 
 # log level warn
 ip test-ip4 output
-  [ log prefix (null) level 4 flags 0]
+  [ log level 4 ]
 
 # log level notice
 ip test-ip4 output
-  [ log prefix (null) level 5 flags 0]
+  [ log level 5 ]
 
 # log level info
 ip test-ip4 output
-  [ log prefix (null) level 6 flags 0]
+  [ log level 6 ]
 
 # log level debug
 ip test-ip4 output
-  [ log prefix (null) level 7 flags 0]
+  [ log level 7 ]
 
 # log prefix aaaaa-aaaaaa group 2 snaplen 33
 ip test-ip4 output
-  [ log prefix aaaaa-aaaaaa group 2 snaplen 33 qthreshold 0]
+  [ log prefix aaaaa-aaaaaa group 2 snaplen 33 qthreshold 0 ]
 
 # log group 2 queue-threshold 2
 ip test-ip4 output
-  [ log prefix (null) group 2 snaplen 0 qthreshold 2]
+  [ log group 2 snaplen 0 qthreshold 2 ]
 
 # log group 2 snaplen 33
 ip test-ip4 output
-  [ log prefix (null) group 2 snaplen 33 qthreshold 0]
+  [ log group 2 snaplen 33 qthreshold 0 ]
 
 # log group 2 prefix \"nft-test: \"
 ip test-ip4 output
-  [ log prefix nft-test:  group 2 snaplen 0 qthreshold 0]
+  [ log prefix nft-test:  group 2 snaplen 0 qthreshold 0 ]
 
+# log uid
+ip test-ip4 output
+  [ log uid ]
+
+# log level debug tcpseq,ipopt,uid
+ip test-ip4 output
+  [ log level 7 tcpseq ipopt uid ]
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 32f2685..ecfb9ce 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -227,7 +227,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x0000dd04 ]
-  [ log prefix (null) ]
+  [ log ]
 
 # icmp id 22
 ip test-ip4 input
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 4b6f541..d9fa1ee 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -193,7 +193,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000ae08 ]
-  [ log prefix (null) ]
+  [ log ]
 
 # icmpv6 checksum != 2222 log
 ip6 test-ip6 input
@@ -201,7 +201,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000ae08 ]
-  [ log prefix (null) ]
+  [ log ]
 
 # icmpv6 checksum 222-226
 ip6 test-ip6 input
@@ -217,7 +217,7 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000ae08 ]
-  [ log prefix (null) ]
+  [ log ]
 
 # icmpv6 checksum { 222, 226}
 __set%d test-ip6 3
-- 
2.5.5


