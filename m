From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] tests: limit: extend them to validate new bytes/second and burst parameters
Date: Tue, 22 Sep 2015 13:02:20 +0200
Message-ID: <1442919740-12888-3-git-send-email-pablo@netfilter.org>
References: <1442919740-12888-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45370 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbbIVKzn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 06:55:43 -0400
In-Reply-To: <1442919740-12888-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/limit.t         |   15 +++++++++-
 tests/regression/any/limit.t.payload |   54 ++++++++++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/tests/regression/any/limit.t b/tests/regression/any/limit.t
index 9af1ea8..96ffe60 100644
--- a/tests/regression/any/limit.t
+++ b/tests/regression/any/limit.t
@@ -8,5 +8,18 @@
 limit rate 400/minute;ok
 limit rate 20/second;ok
 limit rate 400/hour;ok
-limit rate 400/week;ok
 limit rate 40/day;ok
+limit rate 400/week;ok
+limit rate 1023/second burst 10 packets;ok
+
+limit rate 1 kbytes/second;ok
+limit rate 2 kbytes/second;ok
+limit rate 1025 kbytes/second;ok
+limit rate 1023 mbytes/second;ok
+limit rate 10230 mbytes/second;ok
+limit rate 1023000 mbytes/second;ok
+
+limit rate 1025 bytes/second burst 512 bytes;ok
+limit rate 1025 kbytes/second burst 1023 kbytes;ok
+limit rate 1025 mbytes/second burst 1025 kbytes;ok
+limit rate 1025000 mbytes/second burst 1023 mbytes;ok
diff --git a/tests/regression/any/limit.t.payload b/tests/regression/any/limit.t.payload
index c196f12..a3c87d8 100644
--- a/tests/regression/any/limit.t.payload
+++ b/tests/regression/any/limit.t.payload
@@ -1,20 +1,64 @@
 # limit rate 400/minute
 ip test-ip4 output
-  [ limit rate 400/minute ]
+  [ limit rate 400/minute burst 0 type packets ]
 
 # limit rate 20/second
 ip test-ip4 output
-  [ limit rate 20/second ]
+  [ limit rate 20/second burst 0 type packets ]
 
 # limit rate 400/hour
 ip test-ip4 output
-  [ limit rate 400/hour ]
+  [ limit rate 400/hour burst 0 type packets ]
 
 # limit rate 400/week
 ip test-ip4 output
-  [ limit rate 400/week ]
+  [ limit rate 400/week burst 0 type packets ]
 
 # limit rate 40/day
 ip test-ip4 output
-  [ limit rate 40/day ]
+  [ limit rate 40/day burst 0 type packets ]
+
+# limit rate 1023/second burst 10 packets
+ip test-ip4 output
+  [ limit rate 1023/second burst 10 type packets ]
+
+# limit rate 1 kbytes/second
+ip test-ip4 output
+  [ limit rate 1024/second burst 0 type bytes ]
+
+# limit rate 2 kbytes/second
+ip test-ip4 output
+  [ limit rate 2048/second burst 0 type bytes ]
+
+# limit rate 1025 kbytes/second
+ip test-ip4 output
+  [ limit rate 1049600/second burst 0 type bytes ]
+
+# limit rate 1023 mbytes/second
+ip test-ip4 output
+  [ limit rate 1072693248/second burst 0 type bytes ]
+
+# limit rate 10230 mbytes/second
+ip test-ip4 output
+  [ limit rate 10726932480/second burst 0 type bytes ]
+
+# limit rate 1023000 mbytes/second
+ip test-ip4 output
+  [ limit rate 1072693248000/second burst 0 type bytes ]
+
+# limit rate 1025 bytes/second burst 512 bytes
+ip test-ip4 output
+  [ limit rate 1025/second burst 512 type bytes ]
+
+# limit rate 1025 kbytes/second burst 1023 kbytes
+ip test-ip4 output
+  [ limit rate 1049600/second burst 1047552 type bytes ]
+
+# limit rate 1025 mbytes/second burst 1025 kbytes
+ip test-ip4 output
+  [ limit rate 1074790400/second burst 1049600 type bytes ]
+
+# limit rate 1025000 mbytes/second burst 1023 mbytes
+ip test-ip4 output
+  [ limit rate 1074790400000/second burst 1072693248 type bytes ]
 
-- 
1.7.10.4

