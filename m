From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/3] tests: Adjust for changed exthdr debug output
Date: Sat, 11 Mar 2017 14:31:40 +0100
Message-ID: <20170311133141.8748-3-phil@nwl.cc>
References: <20170311133141.8748-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40971 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932485AbdCKNcN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2017 08:32:13 -0500
In-Reply-To: <20170311133141.8748-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debug output from libnftnl has changed to include 'present' keyword if
NFT_EXTHDR_F_PRESENT flag is set in expression.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Patch introduced.
---
 tests/py/inet/tcpopt.t.payload.inet |  4 ++--
 tests/py/ip6/exthdr.t.payload.ip6   | 24 ++++++++++++------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tests/py/inet/tcpopt.t.payload.inet b/tests/py/inet/tcpopt.t.payload.inet
index 0d14e77929cca..10cf0c00f402f 100644
--- a/tests/py/inet/tcpopt.t.payload.inet
+++ b/tests/py/inet/tcpopt.t.payload.inet
@@ -184,12 +184,12 @@ inet test-inet input
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option window missing
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
diff --git a/tests/py/ip6/exthdr.t.payload.ip6 b/tests/py/ip6/exthdr.t.payload.ip6
index b45eb8e74272f..3b6bb6219fa4b 100644
--- a/tests/py/ip6/exthdr.t.payload.ip6
+++ b/tests/py/ip6/exthdr.t.payload.ip6
@@ -1,60 +1,60 @@
 # exthdr hbh exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr rt exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load 1b @ 43 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr frag exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load 1b @ 44 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr dst exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load 1b @ 60 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr mh exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load 1b @ 135 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # exthdr hbh == exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh == missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # exthdr hbh != exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # exthdr hbh != missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # exthdr hbh 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh 0
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-- 
2.11.0

