From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 02/12] tests: add 'awkward' prefix match expression
Date: Sun, 16 Aug 2015 21:05:45 +0200
Message-ID: <1439751955-31190-3-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34743 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbbHPTGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:07 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Its just a more complicated way of saying 'ip saddr 255.255.0.0/16'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/regression/ip/ip.t              | 3 +++
 tests/regression/ip/ip.t.payload      | 6 ++++++
 tests/regression/ip/ip.t.payload.inet | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
index 11a9598..6e29ffb 100644
--- a/tests/regression/ip/ip.t
+++ b/tests/regression/ip/ip.t
@@ -108,3 +108,6 @@ ip daddr 192.168.0.2 log;ok
 
 ip saddr \& 0xff == 1;ok;ip saddr & 0.0.0.255 == 0.0.0.1
 ip saddr \& 0.0.0.255 \< 0.0.0.127;ok;ip saddr & 0.0.0.255 < 0.0.0.127
+
+ip saddr \& 0xffff0000 == 0xffff0000;ok;ip saddr 255.255.0.0/16
+
diff --git a/tests/regression/ip/ip.t.payload b/tests/regression/ip/ip.t.payload
index ec4897e..7a77dc4 100644
--- a/tests/regression/ip/ip.t.payload
+++ b/tests/regression/ip/ip.t.payload
@@ -347,3 +347,9 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
+# ip saddr \& 0xffff0000 == 0xffff0000
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000ffff ]
+
diff --git a/tests/regression/ip/ip.t.payload.inet b/tests/regression/ip/ip.t.payload.inet
index 1a2b1b5..dbc7852 100644
--- a/tests/regression/ip/ip.t.payload.inet
+++ b/tests/regression/ip/ip.t.payload.inet
@@ -457,3 +457,11 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
+# ip saddr \& 0xffff0000 == 0xffff0000
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000ffff ]
+
-- 
2.0.5

