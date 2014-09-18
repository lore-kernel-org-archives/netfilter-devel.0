From: Ana Rey <anarey@gmail.com>
Subject: [v3 nft 5/7] tests: Add arp folder with test files.
Date: Thu, 18 Sep 2014 12:39:19 +0200
Message-ID: <1411036761-26825-6-git-send-email-anarey@gmail.com>
References: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47062 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaIRKhH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:37:07 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so659138wgh.17
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 03:37:06 -0700 (PDT)
In-Reply-To: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"arp" folder contains the test files that are executed in arp tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/arp/arp.t    |   53 +++++++++++++++++++++++++++++++++++++++++
 tests/regression/arp/chains.t |    5 ++++
 2 files changed, 58 insertions(+)
 create mode 100644 tests/regression/arp/arp.t
 create mode 100644 tests/regression/arp/chains.t

diff --git a/tests/regression/arp/arp.t b/tests/regression/arp/arp.t
new file mode 100644
index 0000000..797e394
--- /dev/null
+++ b/tests/regression/arp/arp.t
@@ -0,0 +1,53 @@
+*arp;test-arp
+# filter chains available are: input, output, forward
+:input;type filter hook input priority 0
+
+arp htype 1;ok
+arp htype != 1;ok
+arp htype 22;ok
+arp htype != 233;ok
+arp htype 33-45;ok;arp htype >= 33 arp htype <= 45
+arp htype != 33-45;ok;arp htype < 33 arp htype > 45
+arp htype { 33, 55, 67, 88};ok
+- arp htype != { 33, 55, 67, 88};ok
+arp htype { 33-55};ok
+- arp htype != { 33-55};ok
+
+arp ptype 0x0800;ok
+
+arp hlen 22;ok
+arp hlen != 233;ok
+arp hlen 33-45;ok;arp hlen >= 33 arp hlen <= 45
+arp hlen != 33-45;ok;arp hlen < 33 arp hlen > 45
+arp hlen { 33, 55, 67, 88};ok
+- arp hlen != { 33, 55, 67, 88};ok
+arp hlen { 33-55};ok
+- arp hlen != { 33-55};ok
+
+arp plen 22;ok
+arp plen != 233;ok
+arp plen 33-45;ok;arp plen >= 33 arp plen <= 45
+arp plen != 33-45;ok;arp plen < 33 arp plen > 45
+arp plen { 33, 55, 67, 88};ok
+- arp plen != { 33, 55, 67, 88};ok
+arp plen { 33-55};ok
+- arp plen != {33-55};ok
+
+arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+- arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+arp operation request;ok
+arp operation reply;ok
+arp operation rrequest;ok
+arp operation rreply;ok
+arp operation inrequest;ok
+arp operation inreply;ok
+arp operation nak;ok
+arp operation reply;ok
+arp operation != request;ok
+arp operation != reply;ok
+arp operation != rrequest;ok
+arp operation != rreply;ok
+arp operation != inrequest;ok
+arp operation != inreply;ok
+arp operation != nak;ok
+arp operation != reply;ok
diff --git a/tests/regression/arp/chains.t b/tests/regression/arp/chains.t
new file mode 100644
index 0000000..6b0c042
--- /dev/null
+++ b/tests/regression/arp/chains.t
@@ -0,0 +1,5 @@
+*arp;test-arp
+- filter chains available are: input, output, forward
+:input;type filter hook input priority 0
+:forward;type filter hook forward priority 0
+:output;type filter hook output priority 0
-- 
1.7.10.4

