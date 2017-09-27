From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 07/10] tests: ct: adjust test case commands
Date: Wed, 27 Sep 2017 20:16:51 +0200
Message-ID: <20170927181654.3129-8-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:59 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use 'ip saddr', 'ip6 saddr', etc.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/ct.t         |  7 +++++--
 tests/py/inet/ct.t.payload |  4 ++--
 tests/py/ip/ct.t           | 18 +++++++++---------
 tests/py/ip/ct.t.payload   | 16 ++++++++--------
 4 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/tests/py/inet/ct.t b/tests/py/inet/ct.t
index c56c3bc86151..1a656aa4375f 100644
--- a/tests/py/inet/ct.t
+++ b/tests/py/inet/ct.t
@@ -3,8 +3,11 @@
 
 *inet;test-inet;input
 
-meta nfproto ipv4 ct original saddr 1.2.3.4;ok
-meta nfproto ipv6 ct original saddr ::1;ok
+meta nfproto ipv4 ct original saddr 1.2.3.4;ok;ct original ip saddr 1.2.3.4
+ct original ip6 saddr ::1;ok
 
 # missing protocol context
 ct original saddr ::1;fail
+
+# wrong protocol context
+ct original ip saddr ::1;fail
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
index 21c74581de3a..97128eccf540 100644
--- a/tests/py/inet/ct.t.payload
+++ b/tests/py/inet/ct.t.payload
@@ -5,9 +5,9 @@ ip test-ip4 output
   [ ct load src => reg 1 , dir original ]
   [ cmp eq reg 1 0x04030201 ]
 
-# meta nfproto ipv6 ct original saddr ::1
+# ct original ip6 saddr ::1
 inet test-inet input
-  [ meta load nfproto => reg 1 ]
+  [ ct load l3protocol => reg 1 , dir original ]
   [ cmp eq reg 1 0x0000000a ]
   [ ct load src => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index d0f16c51fa4c..d3247f79113f 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -2,16 +2,16 @@
 
 *ip;test-ip4;output
 
-ct original saddr 192.168.0.1;ok
-ct reply saddr 192.168.0.1;ok
-ct original daddr 192.168.0.1;ok
-ct reply daddr 192.168.0.1;ok
+ct original ip saddr 192.168.0.1;ok
+ct reply ip saddr 192.168.0.1;ok
+ct original ip daddr 192.168.0.1;ok
+ct reply ip daddr 192.168.0.1;ok
 
 # same, but with a netmask
-ct original saddr 192.168.1.0/24;ok
-ct reply saddr 192.168.1.0/24;ok
-ct original daddr 192.168.1.0/24;ok
-ct reply daddr 192.168.1.0/24;ok
+ct original ip saddr 192.168.1.0/24;ok
+ct reply ip saddr 192.168.1.0/24;ok
+ct original ip daddr 192.168.1.0/24;ok
+ct reply ip daddr 192.168.1.0/24;ok
 
 ct l3proto ipv4;ok
 ct l3proto foobar;fail
@@ -20,4 +20,4 @@ ct protocol 6 ct original proto-dst 22;ok
 ct original protocol 17 ct reply proto-src 53;ok;ct protocol 17 ct reply proto-src 53
 
 # wrong address family
-ct reply daddr dead::beef;fail
+ct reply ip daddr dead::beef;fail
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 56633a248c8c..b7cd130dbea2 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -1,42 +1,42 @@
-# ct original saddr 192.168.0.1
+# ct original ip saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct reply saddr 192.168.0.1
+# ct reply ip saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct original daddr 192.168.0.1
+# ct original ip daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct reply daddr 192.168.0.1
+# ct reply ip daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct original saddr 192.168.1.0/24
+# ct original ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct reply saddr 192.168.1.0/24
+# ct reply ip saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct original daddr 192.168.1.0/24
+# ct original ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct reply daddr 192.168.1.0/24
+# ct reply ip daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
-- 
2.13.5

