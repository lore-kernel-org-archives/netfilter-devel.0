From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: add test cases for meta random
Date: Tue,  2 Feb 2016 00:19:01 +0100
Message-ID: <1454368741-16368-4-git-send-email-fw@strlen.de>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35233 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbcBAXVo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 18:21:44 -0500
In-Reply-To: <1454368741-16368-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t         |  6 ++++++
 tests/py/any/meta.t.payload | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c10297a..6298e5c 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -197,3 +197,9 @@ meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
 meta iif . meta oif { lo . eth0 };ok
 meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a };ok
 meta iif . meta oif vmap { lo . eth0 : drop };ok
+
+meta random 0.999999999;ok;meta random <= 0.999999999
+meta random 0.5;ok;meta random <= 0.500000000
+meta random 0.001;ok;meta random <= 0.001000000
+meta random 0.000000001;ok;meta random <= 0.000000001
+meta random 0.0000000005;fail
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 9f7a6d9..5ca13b0 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -754,3 +754,22 @@ ip test-ip4 output
   [ meta load oif => reg 9 ]
   [ lookup reg 1 set map%d dreg 0 ]
 
+# meta random 0.999999999
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0xfbffffff ]
+
+# meta random 0.5
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0x00000080 ]
+
+# meta random 0.001
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0x37894100 ]
+
+# meta random 0.000000001
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0x04000000 ]
-- 
2.4.10

