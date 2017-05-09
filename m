From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 05/10] tests: meta: add icmpv6 test case
Date: Tue,  9 May 2017 17:51:17 +0200
Message-ID: <20170509155122.26356-6-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44556 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755779AbdEIPvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:22 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t         | 1 +
 tests/py/any/meta.t.payload | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c3ac0a4c267a..2ff942ff039d 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -38,6 +38,7 @@ meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 meta l4proto != { 33, 55, 67, 88};ok
 meta l4proto { 33-55};ok
 meta l4proto != { 33-55};ok
+meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 
 meta priority root;ok
 meta priority none;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index e432656624b6..871f1ada5abe 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -187,6 +187,13 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# meta l4proto ipv6-icmp icmpv6 type nd-router-advert
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000086 ]
+
 # meta mark 0x4
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-- 
2.10.2

