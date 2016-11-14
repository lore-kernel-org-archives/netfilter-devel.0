From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] tests: py: add some testcases for log flags
Date: Mon, 14 Nov 2016 22:01:28 +0100
Message-ID: <1479157289-26503-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753364AbcKNVBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 16:01:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCAD51F4B6F
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:01:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCD80A7D41
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:01:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0A12A7D41
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:01:40 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove null and zero flags from tests, to reduce the noise when running
tests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/log.t.payload        | 26 +++++++++++++-------------
 tests/py/ip/icmp.t.payload.ip     |  2 +-
 tests/py/ip6/icmpv6.t.payload.ip6 |  6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tests/py/any/log.t.payload b/tests/py/any/log.t.payload
index 689668b6ed68..dc885b4b3e47 100644
--- a/tests/py/any/log.t.payload
+++ b/tests/py/any/log.t.payload
@@ -1,52 +1,52 @@
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
 
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index c7df75db1f70..b740ff80eff6 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -225,7 +225,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x0000dd04 ]
-  [ log prefix (null) ]
+  [ log ]
 
 # icmp id 22
 ip test-ip4 input
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 822db2d5a2c5..a00f392e9bb7 100644
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
2.1.4

