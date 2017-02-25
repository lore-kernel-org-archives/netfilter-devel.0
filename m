From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: py: fix incorrect bytecode in numgen and hash mappings
Date: Sat, 25 Feb 2017 12:43:15 +0100
Message-ID: <1488022995-20560-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbdBYLoa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 06:44:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E96E89B7E4
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:43:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC2E6DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:43:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34097DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:43:28 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Byteorder is not correct as it is expressed in network byteorder. This
uncovered when storing set byteorder in NFTA_USER_DATA.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/hash.t.payload   | 2 +-
 tests/py/ip/numgen.t.payload | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index c410a8c67ef3..8c28ad98987e 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -29,7 +29,7 @@ ip test-ip4 pre
 # dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 }
 __map%d test-ip4 b
 __map%d test-ip4 0
-	element 00000000  : 6414a8c0 0 [end]	element 01000000  : 641ea8c0 0 [end]
+	element 00000000  : 6414a8c0 0 [end]	element 00000001  : 641ea8c0 0 [end]
 ip test-ip4 pre 
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index a8ba21498795..04088b7562f3 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -6,7 +6,7 @@ ip test-ip4 pre
 # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
 __map%d x b
 __map%d x 0
-        element 00000000  : 640aa8c0 0 [end]    element 01000000  : c814a8c0 0 [end]
+        element 00000000  : 640aa8c0 0 [end]    element 00000001  : c814a8c0 0 [end]
 ip test-ip4 pre 
   [ numgen reg 1 = inc mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-- 
2.1.4

