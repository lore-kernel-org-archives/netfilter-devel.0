From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 4/7] tests/py/ip6: Unmark inverted set lookup testcases
Date: Thu, 24 Nov 2016 15:16:23 +0100
Message-ID: <18dcb153be9d6d45947110d2193dccf9affa3396.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59216 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756890AbcKXObc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:31:32 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 tests/py/ip6/dst.t                 |  10 +--
 tests/py/ip6/dst.t.payload.inet    |  50 +++++++++++++
 tests/py/ip6/dst.t.payload.ip6     |  40 +++++++++++
 tests/py/ip6/frag.t                |  14 ++--
 tests/py/ip6/frag.t.payload.inet   |  72 +++++++++++++++++++
 tests/py/ip6/frag.t.payload.ip6    |  58 +++++++++++++++
 tests/py/ip6/hbh.t                 |  10 +--
 tests/py/ip6/hbh.t.payload.inet    |  50 +++++++++++++
 tests/py/ip6/hbh.t.payload.ip6     |  40 +++++++++++
 tests/py/ip6/icmpv6.t              |  26 +++----
 tests/py/ip6/icmpv6.t.payload.ip6  | 143 +++++++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t                 |  20 +++---
 tests/py/ip6/ip6.t.payload.inet    | 102 ++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6     |  82 +++++++++++++++++++++
 tests/py/ip6/mh.t                  |  18 ++---
 tests/py/ip6/mh.t.payload.inet     |  90 +++++++++++++++++++++++
 tests/py/ip6/mh.t.payload.ip6      |  72 +++++++++++++++++++
 tests/py/ip6/rt.t                  |  18 ++---
 tests/py/ip6/rt.t.payload.inet     |  90 +++++++++++++++++++++++
 tests/py/ip6/rt.t.payload.ip6      |  72 +++++++++++++++++++
 tests/py/ip6/sets.t                |   2 +
 tests/py/ip6/sets.t.payload.inet   |   8 +++
 tests/py/ip6/sets.t.payload.ip6    |   6 ++
 tests/py/ip6/sets.t.payload.netdev |   8 +++
 24 files changed, 1043 insertions(+), 58 deletions(-)

diff --git a/tests/py/ip6/dst.t b/tests/py/ip6/dst.t
index f7b0979..9e7c554 100644
--- a/tests/py/ip6/dst.t
+++ b/tests/py/ip6/dst.t
@@ -8,11 +8,11 @@ dst nexthdr != 233;ok
 dst nexthdr 33-45;ok
 dst nexthdr != 33-45;ok
 dst nexthdr { 33, 55, 67, 88};ok
-- dst nexthdr != { 33, 55, 67, 88};ok
+dst nexthdr != { 33, 55, 67, 88};ok
 dst nexthdr { 33-55};ok
-- dst nexthdr != { 33-55};ok
+dst nexthdr != { 33-55};ok
 dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;dst nexthdr { 51, 50, 17, 136, 58, 6, 33, 132, 108}
-- dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;dst nexthdr != { 51, 50, 17, 136, 58, 6, 33, 132, 108}
 dst nexthdr icmp;ok;dst nexthdr 1
 dst nexthdr != icmp;ok;dst nexthdr != 1
 
@@ -21,6 +21,6 @@ dst hdrlength != 233;ok
 dst hdrlength 33-45;ok
 dst hdrlength != 33-45;ok
 dst hdrlength { 33, 55, 67, 88};ok
-- dst hdrlength != { 33, 55, 67, 88};ok
+dst hdrlength != { 33, 55, 67, 88};ok
 dst hdrlength { 33-55};ok
-- dst hdrlength != { 33-55};ok
+dst hdrlength != { 33-55};ok
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 62d1c5a..768b4f1 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -37,6 +37,16 @@ inet test-inet input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -57,6 +77,16 @@ inet test-inet input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -110,6 +140,16 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst hdrlength != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst hdrlength { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -120,3 +160,13 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst hdrlength != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index c022c7f..56afc12 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -27,6 +27,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -35,6 +43,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -43,6 +59,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
@@ -82,6 +106,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst hdrlength != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # dst hdrlength { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -90,4 +122,12 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# dst hdrlength != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 
diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index 0e632bc..e16529a 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -7,7 +7,7 @@
 frag nexthdr tcp;ok;frag nexthdr 6
 frag nexthdr != icmp;ok;frag nexthdr != 1
 frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr { 51, 136, 132, 6, 108, 50, 17, 33}
-- frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr != { 51, 136, 132, 6, 108, 50, 17, 33}
 frag nexthdr esp;ok;frag nexthdr 50
 frag nexthdr ah;ok;frag nexthdr 51
 
@@ -16,18 +16,18 @@ frag reserved != 233;ok
 frag reserved 33-45;ok
 frag reserved != 33-45;ok
 frag reserved { 33, 55, 67, 88};ok
-- frag reserved != { 33, 55, 67, 88};ok
+frag reserved != { 33, 55, 67, 88};ok
 frag reserved { 33-55};ok
-- frag reserved != { 33-55};ok
+frag reserved != { 33-55};ok
 
 frag frag-off 22;ok
 frag frag-off != 233;ok
 frag frag-off 33-45;ok
 frag frag-off != 33-45;ok
 frag frag-off { 33, 55, 67, 88};ok
-- frag frag-off != { 33, 55, 67, 88};ok
+frag frag-off != { 33, 55, 67, 88};ok
 frag frag-off { 33-55};ok
-- frag frag-off != { 33-55};ok
+frag frag-off != { 33-55};ok
 
 frag reserved2 1;ok
 frag more-fragments 0;ok
@@ -39,6 +39,6 @@ frag id != 33;ok
 frag id 33-45;ok
 frag id != 33-45;ok
 frag id { 33, 55, 67, 88};ok
-- frag id != { 33, 55, 67, 88};ok
+frag id != { 33, 55, 67, 88};ok
 frag id { 33-55};ok
-- frag id != { 33-55};ok
+frag id != { 33-55};ok
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index bf57eca..0630533 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -22,6 +22,16 @@ inet test-inet output
   [ exthdr load 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag nexthdr esp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
@@ -75,6 +85,16 @@ inet test-inet output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag reserved { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -85,6 +105,16 @@ inet test-inet output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag frag-off 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
@@ -129,6 +159,17 @@ inet test-inet output
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag frag-off { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -140,6 +181,17 @@ inet test-inet output
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# frag frag-off != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag more-fragments 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
@@ -194,6 +246,16 @@ inet test-inet output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag id != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag id { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -204,6 +266,16 @@ inet test-inet output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag id != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag reserved2 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index aa27005..6e86b8a 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -16,6 +16,14 @@ ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag nexthdr esp
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 0 => reg 1 ]
@@ -55,6 +63,14 @@ ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag reserved { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -63,6 +79,14 @@ ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag reserved != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag frag-off 22
 ip6 test-ip6 output
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
@@ -97,6 +121,15 @@ ip6 test-ip6 output
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag frag-off { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -106,6 +139,15 @@ ip6 test-ip6 output
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# frag frag-off != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+ip6 test-ip6 output 
+  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag more-fragments 1
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 3 => reg 1 ]
@@ -146,6 +188,14 @@ ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag id != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag id { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -154,6 +204,14 @@ ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# frag id != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # frag reserved2 1
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 3 => reg 1 ]
diff --git a/tests/py/ip6/hbh.t b/tests/py/ip6/hbh.t
index 235cce4..f367a38 100644
--- a/tests/py/ip6/hbh.t
+++ b/tests/py/ip6/hbh.t
@@ -8,19 +8,19 @@ hbh hdrlength != 233;ok
 hbh hdrlength 33-45;ok
 hbh hdrlength != 33-45;ok
 hbh hdrlength {33, 55, 67, 88};ok
-- hbh hdrlength != {33, 55, 67, 88};ok
+hbh hdrlength != {33, 55, 67, 88};ok
 hbh hdrlength { 33-55};ok
-- hbh hdrlength != {33-55};ok
+hbh hdrlength != { 33-55};ok
 
 hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;hbh nexthdr { 58, 136, 51, 50, 6, 17, 132, 33, 108}
-- hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;hbh nexthdr != { 58, 136, 51, 50, 6, 17, 132, 33, 108}
 hbh nexthdr 22;ok
 hbh nexthdr != 233;ok
 hbh nexthdr 33-45;ok
 hbh nexthdr != 33-45;ok
 hbh nexthdr {33, 55, 67, 88};ok
-- hbh nexthdr != {33, 55, 67, 88};ok
+hbh nexthdr != {33, 55, 67, 88};ok
 hbh nexthdr { 33-55};ok
-- hbh nexthdr != {33-55};ok
+hbh nexthdr != { 33-55};ok
 hbh nexthdr ip;ok;hbh nexthdr 0
 hbh nexthdr != ip;ok;hbh nexthdr != 0
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index 7e0d079..cf7e353 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -37,6 +37,16 @@ inet test-inet filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh hdrlength != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh hdrlength { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -47,6 +57,16 @@ inet test-inet filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh hdrlength != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -57,6 +77,16 @@ inet test-inet filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr 22
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
@@ -96,6 +126,16 @@ inet test-inet filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -106,6 +146,16 @@ inet test-inet filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index 783fc6a..93522c4 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -27,6 +27,14 @@ ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh hdrlength != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 filter-input
+  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh hdrlength { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -35,6 +43,14 @@ ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh hdrlength != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 filter-input
+  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -43,6 +59,14 @@ ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+ip6 test-ip6 filter-input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr 22
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
@@ -72,6 +96,14 @@ ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 filter-input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -80,6 +112,14 @@ ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# hbh nexthdr != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 filter-input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # hbh nexthdr ip
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 6892273..afbd451 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -22,23 +22,23 @@ icmpv6 type router-renumbering accept;ok
 icmpv6 type {destination-unreachable, time-exceeded, nd-router-solicit} accept;ok
 icmpv6 type {router-renumbering, mld-listener-reduction, time-exceeded, nd-router-solicit} accept;ok
 icmpv6 type {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
-- icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
+icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
 
 icmpv6 code 4;ok
 icmpv6 code 3-66;ok
 icmpv6 code {5, 6, 7} accept;ok
-- icmpv6 code != {3, 66, 34};ok
+icmpv6 code != {5, 6, 7} accept;ok
 icmpv6 code { 3-66};ok
-- icmpv6 code != { 3-44};ok
+icmpv6 code != { 3-66};ok
 
 icmpv6 checksum 2222 log;ok
 icmpv6 checksum != 2222 log;ok
 icmpv6 checksum 222-226;ok
 icmpv6 checksum != 2222 log;ok
 icmpv6 checksum { 222, 226};ok
-- icmpv6 checksum != { 222, 226};ok
+icmpv6 checksum != { 222, 226};ok
 icmpv6 checksum { 222-226};ok
-- icmpv6 checksum != { 222-226};ok
+icmpv6 checksum != { 222-226};ok
 
 # BUG: icmpv6 parameter-problem, pptr, mtu, packet-too-big
 # [ICMP6HDR_PPTR]         = ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
@@ -65,34 +65,34 @@ icmpv6 mtu != 233;ok
 icmpv6 mtu 33-45;ok
 icmpv6 mtu != 33-45;ok
 icmpv6 mtu {33, 55, 67, 88};ok
-- icmpv6 mtu != {33, 55, 67, 88};ok
+icmpv6 mtu != {33, 55, 67, 88};ok
 icmpv6 mtu {33-55};ok
-- icmpv6 mtu != {33-55};ok
+icmpv6 mtu != {33-55};ok
 
 - icmpv6 id 2;ok
 - icmpv6 id != 233;ok
 icmpv6 id 33-45;ok
 icmpv6 id != 33-45;ok
 icmpv6 id {33, 55, 67, 88};ok
-- icmpv6 id != {33, 55, 67, 88};ok
+icmpv6 id != {33, 55, 67, 88};ok
 icmpv6 id {33-55};ok
-- icmpv6 id != {33-55};ok
+icmpv6 id != {33-55};ok
 
 icmpv6 sequence 2;ok
 icmpv6 sequence {3, 4, 5, 6, 7} accept;ok
 
 icmpv6 sequence {2, 4};ok
-- icmpv6 sequence != {2, 4};ok
+icmpv6 sequence != {2, 4};ok
 icmpv6 sequence 2-4;ok
 icmpv6 sequence != 2-4;ok
 icmpv6 sequence { 2-4};ok
-- icmpv6 sequence != {2-4};ok
+icmpv6 sequence != { 2-4};ok
 
 - icmpv6 max-delay 22;ok
 - icmpv6 max-delay != 233;ok
 icmpv6 max-delay 33-45;ok
 icmpv6 max-delay != 33-45;ok
 icmpv6 max-delay {33, 55, 67, 88};ok
-- icmpv6 max-delay != {33, 55, 67, 88};ok
+icmpv6 max-delay != {33, 55, 67, 88};ok
 icmpv6 max-delay {33-55};ok
-- icmpv6 max-delay != {33-55};ok
+icmpv6 max-delay != {33-55};ok
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 8d33249..9fe2496 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -151,6 +151,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000082  : 0 [end]	element 00000003  : 0 [end]	element 00000086  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # icmpv6 code 4
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -177,6 +188,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmpv6 code != {5, 6, 7} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # icmpv6 code { 3-66}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -187,6 +209,16 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 code != { 3-66}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 checksum 2222 log
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -229,6 +261,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 checksum != { 222, 226}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 0000de00  : 0 [end]	element 0000e200  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 checksum { 222-226}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -239,6 +281,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 checksum != { 222-226}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 mtu 22
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -278,6 +330,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 mtu != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 mtu {33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -288,6 +350,16 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 mtu != {33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 id 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -313,6 +385,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 id != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 id {33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -323,6 +405,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 id != {33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 sequence 2
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -341,6 +433,17 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmpv6 sequence != {3, 4, 5, 6, 7} accept
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000300  : 0 [end]	element 00000400  : 0 [end]	element 00000500  : 0 [end]	element 00000600  : 0 [end]	element 00000700  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # icmpv6 sequence {2, 4}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -351,6 +454,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 sequence != {2, 4}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000200  : 0 [end]	element 00000400  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 sequence 2-4
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -376,6 +489,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 sequence != { 2-4}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 max-delay 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -401,6 +524,16 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 max-delay != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # icmpv6 max-delay {33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -411,3 +544,13 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# icmpv6 max-delay != {33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 9a18f7a..438b94d 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -22,26 +22,26 @@ ip6 flowlabel != 233;ok
 - ip6 flowlabel != 33-45;ok
 ip6 flowlabel { 33, 55, 67, 88};ok
 # BUG ip6 flowlabel { 5046528, 2883584, 13522432 }
-- ip6 flowlabel != { 33, 55, 67, 88};ok
+ip6 flowlabel != { 33, 55, 67, 88};ok
 ip6 flowlabel { 33-55};ok
-- ip6 flowlabel != { 33-55};ok
+ip6 flowlabel != { 33-55};ok
 
 ip6 length 22;ok
 ip6 length != 233;ok
 ip6 length 33-45;ok
 ip6 length != 33-45;ok
-- ip6 length { 33, 55, 67, 88};ok
-- ip6 length != {33, 55, 67, 88};ok
+ip6 length { 33, 55, 67, 88};ok
+ip6 length != {33, 55, 67, 88};ok
 ip6 length { 33-55};ok
-- ip6 length != { 33-55};ok
+ip6 length != { 33-55};ok
 
 ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp};ok;ip6 nexthdr { 132, 51, 108, 136, 17, 33, 6}
 ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;ip6 nexthdr { 6, 136, 108, 33, 50, 17, 132, 58, 51}
-- ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;ip6 nexthdr != { 6, 136, 108, 33, 50, 17, 132, 58, 51}
 ip6 nexthdr esp;ok;ip6 nexthdr 50
 ip6 nexthdr != esp;ok;ip6 nexthdr != 50
 ip6 nexthdr { 33-44};ok
-- p6 nexthdr != { 33-44};ok
+ip6 nexthdr != { 33-44};ok
 ip6 nexthdr 33-44;ok
 ip6 nexthdr != 33-44;ok
 
@@ -50,9 +50,9 @@ ip6 hoplimit != 233;ok
 ip6 hoplimit 33-45;ok
 ip6 hoplimit != 33-45;ok
 ip6 hoplimit {33, 55, 67, 88};ok
-- ip6 hoplimit != {33, 55, 67, 88};ok
+ip6 hoplimit != {33, 55, 67, 88};ok
 ip6 hoplimit {33-55};ok
-- ip6 hoplimit != {33-55};ok
+ip6 hoplimit != {33-55};ok
 
 # from src/scanner.l
 # v680		(({hex4}:){7}{hex4})
@@ -139,7 +139,7 @@ ip6 saddr 1234::;ok
 ip6 saddr ::/64;ok
 ip6 saddr ::1 ip6 daddr ::2;ok
 
-- ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok
+ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok;ip6 daddr != {0:1234:1234:1234:1234:1234:1234:1234, 1234:1234:0:1234:1234:1234:1234:1234}
 ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok;ip6 daddr != 0:1234:1234:1234:1234:1234:1234:1234-1234:1234:0:1234:1234:1234:1234:1234
 
 # limit impact to lo
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 1aa0f5b..40277fd 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -68,6 +68,17 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 flowlabel != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 flowlabel { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -79,6 +90,17 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 flowlabel != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 length 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -108,6 +130,26 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
+# ip6 length { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip6 length != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 length { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -118,6 +160,16 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 length != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -138,6 +190,16 @@ inet test-inet input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr esp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -162,6 +224,16 @@ inet test-inet input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 nexthdr != { 33-44}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr 33-44
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -216,6 +288,16 @@ inet test-inet input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 hoplimit != {33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 7 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 hoplimit {33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -226,6 +308,16 @@ inet test-inet input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 hoplimit != {33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 7 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -502,6 +594,16 @@ inet test-inet input
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
 
+# ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 34120000 34123412 34123412 34123412  : 0 [end]	element 34123412 34120000 34123412 34123412  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 56ed8bd..74d06b3 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -52,6 +52,15 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 flowlabel != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 flowlabel { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -61,6 +70,15 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 flowlabel != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 length 22
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
@@ -82,6 +100,22 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
+# ip6 length { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip6 length != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 length { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -90,6 +124,14 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 length != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -106,6 +148,14 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr esp
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -124,6 +174,14 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 nexthdr != { 33-44}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 nexthdr 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -164,6 +222,14 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 hoplimit != {33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 7 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 hoplimit {33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -172,6 +238,14 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ip6 hoplimit != {33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 7 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
@@ -370,6 +444,14 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
 
+# ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 34120000 34123412 34123412 34123412  : 0 [end]	element 34123412 34120000 34123412 34123412  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
diff --git a/tests/py/ip6/mh.t b/tests/py/ip6/mh.t
index 099a6eb..61f5f78 100644
--- a/tests/py/ip6/mh.t
+++ b/tests/py/ip6/mh.t
@@ -6,7 +6,7 @@
 mh nexthdr 1;ok
 mh nexthdr != 1;ok
 mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp };ok;mh nexthdr { 58, 17, 108, 6, 51, 136, 50, 132, 33}
-- mh nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp };ok;mh nexthdr { 58, 17, 108, 6, 51, 136, 50, 132, 33}
 mh nexthdr icmp;ok;mh nexthdr 1
 mh nexthdr != icmp;ok;mh nexthdr != 1
 mh nexthdr 22;ok
@@ -14,18 +14,18 @@ mh nexthdr != 233;ok
 mh nexthdr 33-45;ok
 mh nexthdr != 33-45;ok
 mh nexthdr { 33, 55, 67, 88 };ok
-- mh nexthdr != { 33, 55, 67, 88 };ok
+mh nexthdr != { 33, 55, 67, 88 };ok
 mh nexthdr { 33-55 };ok
-- mh nexthdr != { 33-55 };ok
+mh nexthdr != { 33-55 };ok
 
 mh hdrlength 22;ok
 mh hdrlength != 233;ok
 mh hdrlength 33-45;ok
 mh hdrlength != 33-45;ok
 mh hdrlength { 33, 55, 67, 88 };ok
-- mh hdrlength != { 33, 55, 67, 88 };ok
+mh hdrlength != { 33, 55, 67, 88 };ok
 mh hdrlength { 33-55 };ok
-- mh hdrlength != { 33-55 };ok
+mh hdrlength != { 33-55 };ok
 
 mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message};ok
 mh type home-agent-switch-message;ok
@@ -36,15 +36,15 @@ mh reserved != 233;ok
 mh reserved 33-45;ok
 mh reserved != 33-45;ok
 mh reserved { 33, 55, 67, 88};ok
-- mh reserved != {33, 55, 67, 88};ok
+mh reserved != { 33, 55, 67, 88};ok
 mh reserved { 33-55};ok
-- mh reserved != { 33-55};ok
+mh reserved != { 33-55};ok
 
 mh checksum 22;ok
 mh checksum != 233;ok
 mh checksum 33-45;ok
 mh checksum != 33-45;ok
 mh checksum { 33, 55, 67, 88};ok
-- mh checksum != { 33, 55, 67, 88};ok
+mh checksum != { 33, 55, 67, 88};ok
 mh checksum { 33-55};ok
-- mh checksum != { 33-55};ok
+mh checksum != { 33-55};ok
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 471af09..24335b1 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -22,6 +22,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -75,6 +85,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { 33, 55, 67, 88 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh nexthdr { 33-55 }
 __set%d test-inet 7
 __set%d test-inet 0
@@ -85,6 +105,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { 33-55 }
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -124,6 +154,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh hdrlength != { 33, 55, 67, 88 }
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh hdrlength { 33-55 }
 __set%d test-inet 7
 __set%d test-inet 0
@@ -134,6 +174,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh hdrlength != { 33-55 }
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -197,6 +247,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh reserved != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh reserved { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -207,6 +267,16 @@ inet test-inet input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh reserved != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh checksum 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -246,6 +316,16 @@ inet test-inet input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh checksum != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh checksum { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -256,3 +336,13 @@ inet test-inet input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh checksum != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index 7a9aa35..d19b6e6 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -16,6 +16,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
@@ -55,6 +63,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { 33, 55, 67, 88 }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh nexthdr { 33-55 }
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -63,6 +79,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh nexthdr != { 33-55 }
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh hdrlength 22
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
@@ -92,6 +116,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh hdrlength != { 33, 55, 67, 88 }
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh hdrlength { 33-55 }
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -100,6 +132,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh hdrlength != { 33-55 }
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -147,6 +187,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh reserved != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh reserved { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -155,6 +203,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh reserved != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh checksum 22
 ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
@@ -184,6 +240,14 @@ ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh checksum != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # mh checksum { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -192,3 +256,11 @@ ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# mh checksum != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/rt.t b/tests/py/ip6/rt.t
index 7e700a5..2d044c3 100644
--- a/tests/py/ip6/rt.t
+++ b/tests/py/ip6/rt.t
@@ -6,7 +6,7 @@
 rt nexthdr 1;ok
 rt nexthdr != 1;ok
 rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;rt nexthdr { 33, 136, 50, 132, 51, 17, 108, 6, 58}
-- rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;rt nexthdr != { 33, 136, 50, 132, 51, 17, 108, 6, 58}
 rt nexthdr icmp;ok;rt nexthdr 1
 rt nexthdr != icmp;ok;rt nexthdr != 1
 rt nexthdr 22;ok
@@ -14,33 +14,33 @@ rt nexthdr != 233;ok
 rt nexthdr 33-45;ok
 rt nexthdr != 33-45;ok
 rt nexthdr { 33, 55, 67, 88};ok
-- rt nexthdr != { 33, 55, 67, 88};ok
+rt nexthdr != { 33, 55, 67, 88};ok
 rt nexthdr { 33-55};ok;rt nexthdr { 33-55}
-- rt nexthdr != { 33-55};ok
+rt nexthdr != { 33-55};ok
 
 rt hdrlength 22;ok
 rt hdrlength != 233;ok
 rt hdrlength 33-45;ok
 rt hdrlength != 33-45;ok
 rt hdrlength { 33, 55, 67, 88};ok
-- rt hdrlength != { 33, 55, 67, 88};ok
+rt hdrlength != { 33, 55, 67, 88};ok
 rt hdrlength { 33-55};ok
-- rt hdrlength != { 33-55};ok
+rt hdrlength != { 33-55};ok
 
 rt type 22;ok
 rt type != 233;ok
 rt type 33-45;ok
 rt type != 33-45;ok
 rt type { 33, 55, 67, 88};ok
-- rt type != { 33, 55, 67, 88};ok
+rt type != { 33, 55, 67, 88};ok
 rt type { 33-55};ok
-- rt type != { 33-55};ok
+rt type != { 33-55};ok
 
 rt seg-left 22;ok
 rt seg-left != 233;ok
 rt seg-left 33-45;ok
 rt seg-left != 33-45;ok
 rt seg-left { 33, 55, 67, 88};ok
-- rt seg-left != { 33, 55, 67, 88};ok
+rt seg-left != { 33, 55, 67, 88};ok
 rt seg-left { 33-55};ok
-- rt seg-left != { 33-55};ok
+rt seg-left != { 33-55};ok
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 30e29a5..8fb717f 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -22,6 +22,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -75,6 +85,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt nexthdr { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -85,6 +105,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -124,6 +154,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt hdrlength != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt hdrlength { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -134,6 +174,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt hdrlength != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt type 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -173,6 +223,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt type != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt type { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -183,6 +243,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt type != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt seg-left 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -222,6 +292,16 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt seg-left != { 33, 55, 67, 88}
+__set%d test-inet 3
+__set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt seg-left { 33-55}
 __set%d test-inet 7
 __set%d test-inet 0
@@ -232,3 +312,13 @@ inet test-inet input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt seg-left != { 33-55}
+__set%d test-inet 7
+__set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index b96980b..5a57463 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -16,6 +16,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt nexthdr icmp
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
@@ -55,6 +63,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt nexthdr { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -63,6 +79,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt nexthdr != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt hdrlength 22
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
@@ -92,6 +116,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt hdrlength != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt hdrlength { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -100,6 +132,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt hdrlength != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt type 22
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
@@ -129,6 +169,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt type != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt type { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -137,6 +185,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt type != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt seg-left 22
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
@@ -166,6 +222,14 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt seg-left != { 33, 55, 67, 88}
+__set%d test-ip6 3
+__set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # rt seg-left { 33-55}
 __set%d test-ip6 7
 __set%d test-ip6 0
@@ -174,3 +238,11 @@ ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# rt seg-left != { 33-55}
+__set%d test-ip6 7
+__set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index ea20834..3ea2d83 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -22,7 +22,9 @@
 ?set2 1234:1234:1234::1234;ok
 
 ip6 saddr @set2 drop;ok
+ip6 saddr != @set2 drop;ok
 ip6 saddr @set33 drop;fail
+ip6 saddr != @set33 drop;fail
 
 !set3 type ipv6_addr flags interval;ok
 ?set3 1234:1234:1234:1234::/64;ok
diff --git a/tests/py/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
index 27be86b..b45f630 100644
--- a/tests/py/ip6/sets.t.payload.inet
+++ b/tests/py/ip6/sets.t.payload.inet
@@ -6,3 +6,11 @@ inet test-inet input
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip6 saddr != @set2 drop
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
index 0e51fd3..0fab365 100644
--- a/tests/py/ip6/sets.t.payload.ip6
+++ b/tests/py/ip6/sets.t.payload.ip6
@@ -4,3 +4,9 @@ ip6 test-ip6 input
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip6 saddr != @set2 drop
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
index 8f432d0..7c4ba3e 100644
--- a/tests/py/ip6/sets.t.payload.netdev
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -6,3 +6,11 @@ netdev test-netdev ingress
   [ lookup reg 1 set set2 ]
   [ immediate reg 0 drop ]
 
+# ip6 saddr != @set2 drop
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set set2 0x1 ]
+  [ immediate reg 0 drop ]
+
-- 
2.11.0.rc2

