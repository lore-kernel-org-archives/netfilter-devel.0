From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] meta: add tests for probability matching
Date: Thu,  3 Mar 2016 18:56:54 +0100
Message-ID: <1457027814-14795-3-git-send-email-fw@strlen.de>
References: <1457027814-14795-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56313 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532AbcCCR4u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 12:56:50 -0500
In-Reply-To: <1457027814-14795-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t         | 16 ++++++++++++++++
 tests/py/any/meta.t.payload | 15 +++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c10297a..4fa961f 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -197,3 +197,19 @@ meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
 meta iif . meta oif { lo . eth0 };ok
 meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a };ok
 meta iif . meta oif vmap { lo . eth0 : drop };ok
+
+meta probability 0.0000001;ok
+meta probability 0.5;ok;meta probability 0.5000000
+meta probability 0.9999999;ok
+
+# outside of supported precision range
+meta probability 0.00000001;fail
+meta probability 0.99999999;fail
+
+# meta probability cannot be used with operators
+meta probability eq 0.5;fail
+
+# not 0.xxx format
+meta probability 1.5;fail
+meta probability foobar;fail
+meta probability 0;fail
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 9f7a6d9..7c5eb72 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -754,3 +754,18 @@ ip test-ip4 output
   [ meta load oif => reg 9 ]
   [ lookup reg 1 set map%d dreg 0 ]
 
+# meta probability 0.0000001
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0xad010000 ]
+
+# meta probability 0.5
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0xffffff7f ]
+
+# meta probability 0.9999999
+ip test-ip4 input
+  [ meta load prandom => reg 1 ]
+  [ cmp lte reg 1 0x51feffff ]
+
-- 
2.4.10

