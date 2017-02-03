From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 9/9] tests: add test entries for conntrack zones
Date: Fri,  3 Feb 2017 13:35:56 +0100
Message-ID: <20170203123556.17357-10-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41986 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:36:09 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/ct.t         | 13 +++++++++++++
 tests/py/any/ct.t.payload | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 2cfbfe13ccd2..6f32d29c0c40 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -100,6 +100,19 @@ ct label 127;ok
 ct label set 127;ok
 ct label 128;fail
 
+ct zone 0;ok
+ct zone 23;ok
+ct zone 65536;fail
+ct both zone 1;fail
+ct original zone 1;ok
+ct reply zone 1;ok
+
+ct zone set 1;ok
+ct original zone set 1;ok
+ct reply zone set 1;ok
+ct zone set mark map { 1 : 1,  2 : 2 };ok;ct zone set mark map { 0x00000001 : 1, 0x00000002 : 2}
+ct both zone set 1;fail
+
 ct invalid;fail
 ct invalid original;fail
 ct set invalid original 42;fail
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 3370bcac0594..e4c7f62b69f5 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -402,6 +402,50 @@ ip test-ip4 output
   [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x80000000 ]
   [ ct set label with reg 1 ]
 
+# ct zone 0
+ip test-ip4 output
+  [ ct load zone => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ct zone 23
+ip test-ip4 output
+  [ ct load zone => reg 1 ]
+  [ cmp eq reg 1 0x00000017 ]
+
+# ct original zone 1
+ip test-ip4 output
+  [ ct load zone => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ct reply zone 1
+ip test-ip4 output
+  [ ct load zone => reg 1 , dir reply ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ct zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 ]
+
+# ct original zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 , dir original ]
+
+# ct reply zone set 1
+ip test-ip4 output
+  [ immediate reg 1 0x00000001 ]
+  [ ct set zone with reg 1 , dir reply ]
+
+# ct zone set mark map { 1 : 1,  2 : 2 }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 00000001  : 00000001 0 [end]    element 00000002  : 00000002 0 [end]
+ip test-ip4 output
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set zone with reg 1 ]
+
 # notrack
 ip test-ip4 output
   [ notrack ]
-- 
2.10.2

