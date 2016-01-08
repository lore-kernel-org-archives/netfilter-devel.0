From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] ct regression tests for bytes, packets
Date: Fri,  8 Jan 2016 10:42:50 +0100
Message-ID: <1452246171-13943-6-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47941 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbcAHJuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:46 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/ct.t         |  9 +++++++++
 tests/py/any/ct.t.payload | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index a0a2590..4c27c90 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -110,6 +110,15 @@ ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x1278563
 ct direction . ct mark { original . 0x12345678};ok
 ct state . ct mark vmap { new . 0x12345678 : drop};ok
 
+ct original bytes \> 100000;ok;ct original bytes > 100000
+ct reply packets \< 100;ok;ct reply packets < 100
+ct bytes \> 100000;ok;ct bytes > 100000
+
+# bogus direction
+ct both bytes gt 1;fail
+# nonsensical
+ct bytes original reply;fail
+
 # missing direction
 ct saddr 1.2.3.4;fail
 
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 651b644..8ca92b2 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -286,3 +286,22 @@ ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ lookup reg 1 set map%d dreg 1 ]
   [ ct set mark with reg 1 ]
+
+# ct original bytes \> 100000
+ip test-ip4 output
+  [ ct load bytes => reg 1 , dir original ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp gt reg 1 0x00000000 0xa0860100 ]
+
+# ct reply packets \< 100
+ip test-ip4 output
+  [ ct load packets => reg 1 , dir reply ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp lt reg 1 0x00000000 0x64000000 ]
+
+# ct bytes \> 100000
+ip test-ip4 output
+  [ ct load bytes => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp gt reg 1 0x00000000 0xa0860100 ]
+
-- 
2.4.10

