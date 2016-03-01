From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 06/10] tests: add/fix inet+exthdr tests
Date: Tue,  1 Mar 2016 16:37:46 +0100
Message-ID: <1456846670-28179-7-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49307 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbcCAPhx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:53 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

exhdr needs to be treated as if we'd test an ipv6 header field, i.e.
inet, bridge, netdev need to add a dependency on ipv6 protocol.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip6/dst.t.payload.inet  |  30 ++++++++
 tests/py/ip6/frag.t.payload.inet | 145 +++++++++++++++++++++++++++++++++++++++
 tests/py/ip6/hbh.t.payload.inet  |  30 ++++++++
 tests/py/ip6/mh.t.payload.inet   |  64 +++++++++++++++++
 tests/py/ip6/rt.t.payload.inet   |  58 ++++++++++++++++
 5 files changed, 327 insertions(+)
 create mode 100644 tests/py/ip6/frag.t.payload.inet

diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 7a219f4..348506d 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -1,21 +1,29 @@
 # dst nexthdr 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst nexthdr != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst nexthdr 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # dst nexthdr != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -25,6 +33,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -33,6 +43,8 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -41,37 +53,51 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # dst nexthdr icmp
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # dst nexthdr != icmp
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # dst hdrlength 22
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst hdrlength != 233
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst hdrlength 33-45
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -81,6 +107,8 @@ set%d test-ip6 3
 set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -89,6 +117,8 @@ set%d test-ip6 7
 set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
new file mode 100644
index 0000000..7cedaf3
--- /dev/null
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -0,0 +1,145 @@
+# frag nexthdr tcp
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+set%d test-inet 3
+set%d test-inet 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag nexthdr esp
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp lt reg 1 0x00000021 ]
+  [ cmp gt reg 1 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag reserved { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag id 1
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp lt reg 1 0x21000000 ]
+  [ cmp gt reg 1 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag id { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+inet test-inet output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index 2b4c9c7..e9a583f 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -1,21 +1,29 @@
 # hbh hdrlength 22
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh hdrlength != 233
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh hdrlength 33-45
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # hbh hdrlength != 33-45
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -25,6 +33,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -33,6 +43,8 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -41,27 +53,37 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # hbh nexthdr 22
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh nexthdr != 233
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh nexthdr 33-45
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # hbh nexthdr != 33-45
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -71,6 +93,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -79,16 +103,22 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # hbh nexthdr ip
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # hbh nexthdr != ip
 inet test-inet filter-input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 53a0ce0..8be80e2 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -1,10 +1,14 @@
 # mh nexthdr 1
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != 1
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
@@ -13,37 +17,51 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # mh nexthdr icmp
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != icmp
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh nexthdr != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh nexthdr 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh nexthdr != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -53,6 +71,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -61,27 +81,37 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # mh hdrlength 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh hdrlength != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh hdrlength 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh hdrlength != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -91,6 +121,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -99,6 +131,8 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -107,37 +141,51 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # mh type home-agent-switch-message
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000000c ]
 
 # mh type != home-agent-switch-message
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000000c ]
 
 # mh reserved 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh reserved != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh reserved 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh reserved != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -147,6 +195,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -155,27 +205,37 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # mh checksum 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # mh checksum != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # mh checksum 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
 # mh checksum != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ cmp lt reg 1 0x00002100 ]
   [ cmp gt reg 1 0x00002d00 ]
@@ -185,6 +245,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -193,6 +255,8 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 9dc51b9..e7a7123 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -1,10 +1,14 @@
 # rt nexthdr 1
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != 1
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
@@ -13,37 +17,51 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # rt nexthdr icmp
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != icmp
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt nexthdr != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt nexthdr 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt nexthdr != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -53,6 +71,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -61,27 +81,37 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # rt hdrlength 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt hdrlength != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt hdrlength 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt hdrlength != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -91,6 +121,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -99,27 +131,37 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # rt type 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt type != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt type 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt type != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -129,6 +171,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -137,27 +181,37 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
 # rt seg-left 22
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt seg-left != 233
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt seg-left 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt seg-left != 33-45
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ cmp lt reg 1 0x00000021 ]
   [ cmp gt reg 1 0x0000002d ]
@@ -167,6 +221,8 @@ set%d test-inet 3
 set%d test-inet 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
@@ -175,6 +231,8 @@ set%d test-inet 7
 set%d test-inet 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
-- 
2.4.10

