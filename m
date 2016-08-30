From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: py: adapt netlink bytecode output of numgen and hash
Date: Tue, 30 Aug 2016 12:41:46 +0200
Message-ID: <1472553706-2031-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755400AbcH3Klz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 06:41:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B4C6C12A690
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A661E100A6C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 022BF100A6C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:51 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adapt them to the revisited output string now in libnftnl.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/hash.t.payload   | 4 ++--
 tests/py/ip/numgen.t.payload | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index 429e2b7..d9a22eb 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -2,7 +2,7 @@
 ip test-ip4 pre 
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ payload load 4b @ network header + 16 => reg 13 ]
-  [ hash reg 1 = jhash(reg 2, 8, 3735928559) % modulus 2]
+  [ hash reg 1 = jhash(reg 2, 8, 0xdeadbeef) % mod 2 ]
   [ ct set mark with reg 1 ]
 
 # dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 }
@@ -11,7 +11,7 @@ __map%d test-ip4 0
 	element 00000000  : 6414a8c0 0 [end]	element 01000000  : 641ea8c0 0 [end]
 ip test-ip4 pre 
   [ payload load 4b @ network header + 12 => reg 2 ]
-  [ hash reg 1 = jhash(reg 2, 4, 3735928559) % modulus 2]
+  [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index cc07485..1099e73 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -1,6 +1,6 @@
 # ct mark set numgen inc mod 2
 ip test-ip4 pre
-  [ numgen reg 1 = inc(2)]
+  [ numgen reg 1 = inc(2) ]
   [ ct set mark with reg 1 ]
 
 # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
@@ -8,7 +8,7 @@ __map%d x b
 __map%d x 0
         element 00000000  : 640aa8c0 0 [end]    element 01000000  : c814a8c0 0 [end]
 ip test-ip4 pre 
-  [ numgen reg 1 = inc(2)]
+  [ numgen reg 1 = inc(2) ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
@@ -17,7 +17,7 @@ __map%d test-ip4 f
 __map%d test-ip4 0
         element 00000000  : 640aa8c0 0 [end]    element 06000000  : c814a8c0 0 [end]    element 0a000000  : 1 [end]
 ip test-ip4 pre
-  [ numgen reg 1 = inc(10)]
+  [ numgen reg 1 = inc(10) ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
-- 
2.1.4

