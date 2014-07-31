From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 5/6] [nft] tests: Add arp folder with test files.
Date: Thu, 31 Jul 2014 11:08:10 +0200
Message-ID: <1406797691-1080-6-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:38567 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaGaJIe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:34 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so2466350wes.39
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:33 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"arp" folder contains the test files that are executed in arp tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/arp/arp.t    | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/arp/chains.t |  5 +++++
 2 files changed, 63 insertions(+)
 create mode 100644 tests/arp/arp.t
 create mode 100644 tests/arp/chains.t

diff --git a/tests/arp/arp.t b/tests/arp/arp.t
new file mode 100644
index 0000000..e7f3cf7
--- /dev/null
+++ b/tests/arp/arp.t
@@ -0,0 +1,58 @@
+*arp;test-arp
+# filter chains available are: input, output, forward
+:input;type filter hook input priority 0
+
+arp htype 1;ok
+arp htype != 1;ok
+# http://www.iana.org/assignments/arp-parameters/arp-parameters.xhtml
+arp htype 22;ok
+arp htype != 233;ok
+arp htype 33-45;ok;arp htype >= 33 arp htype <= 45
+arp htype != 33-45;ok;arp htype < 33 arp htype > 45
+arp htype { 33, 55, 67, 88};ok
+# Bug to list arp htype { 1280, 1024, 256 }
+-arp htype != { 33, 55, 67, 88};ok
+arp htype { 33-55};ok
+-arp htype != { 33-55};ok
+
+arp ptype 0x0800;ok
+
+arp hlen 22;ok
+arp hlen != 233;ok
+arp hlen 33-45;ok;arp hlen >= 33 arp hlen <= 45
+arp hlen != 33-45;ok;arp hlen < 33 arp hlen > 45
+arp hlen { 33, 55, 67, 88};ok
+-arp hlen != { 33, 55, 67, 88};ok
+arp hlen { 33-55};ok
+-arp hlen != { 33-55};ok
+
+arp plen 22;ok
+arp plen != 233;ok
+arp plen 33-45;ok;arp plen >= 33 arp plen <= 45
+arp plen != 33-45;ok;arp plen < 33 arp plen > 45
+arp plen { 33, 55, 67, 88};ok
+-arp plen != { 33, 55, 67, 88};ok
+arp plen { 33-55};ok
+-arp plen != {33-55};ok
+
+
+arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+-arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+# BUG to list arp operation { 1024, 2304, 768, 2048, 512, 2560, 256}
+
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
diff --git a/tests/arp/chains.t b/tests/arp/chains.t
new file mode 100644
index 0000000..6b0c042
--- /dev/null
+++ b/tests/arp/chains.t
@@ -0,0 +1,5 @@
+*arp;test-arp
+- filter chains available are: input, output, forward
+:input;type filter hook input priority 0
+:forward;type filter hook forward priority 0
+:output;type filter hook output priority 0
-- 
2.0.0

