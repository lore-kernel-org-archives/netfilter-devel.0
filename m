From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft] tests: py: add tests for limit stateful object
Date: Mon, 28 Aug 2017 20:20:49 +0200
Message-ID: <20170828182049.523-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35903 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdH1SVT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 14:21:19 -0400
Received: by mail-wr0-f195.google.com with SMTP id 40so642887wrv.3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2017 11:21:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch also reorganizes ip/objects.t file.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/py/any/objects.t        |  2 ++
 tests/py/ip/objects.t         | 20 +++++++++++++++++---
 tests/py/ip/objects.t.payload | 16 ++++++++++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/tests/py/any/objects.t b/tests/py/any/objects.t
index d44696d..89a9545 100644
--- a/tests/py/any/objects.t
+++ b/tests/py/any/objects.t
@@ -11,3 +11,5 @@
 %cnt1 type counter;ok
 %qt1 type quota 25 mbytes;ok
 %qt2 type quota over 1 kbytes;ok
+%lim0 type limit rate 400/minute;ok
+%lim2 type limit rate over 1024 bytes/second burst 512 bytes;ok
diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index 742ec6a..76b802a 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -2,19 +2,33 @@
 
 *ip;test-ip4;output
 
+# counter
 %cnt1 type counter;ok
 %cnt2 type counter;ok
-%qt1 type quota 25 mbytes;ok
-%qt2 type quota over 1 kbytes;ok
-%cthelp2 type ct helper { type \"ftp\" protocol tcp\; l3proto ip6\; };fail
 
 ip saddr 192.168.1.3 counter name "cnt2";ok
 ip saddr 192.168.1.3 counter name "cnt3";fail
 counter name tcp dport map {443 : "cnt1", 80 : "cnt2", 22 : "cnt1"};ok
+
+# quota
+%qt1 type quota 25 mbytes;ok
+%qt2 type quota over 1 kbytes;ok
+
 ip saddr 192.168.1.3 quota name "qt1";ok
 ip saddr 192.168.1.3 quota name "qt3";fail
 quota name tcp dport map {443 : "qt1", 80 : "qt2", 22 : "qt1"};ok
 
+# ct helper
 %cthelp1 type ct helper { type \"ftp\" protocol tcp\; };ok
+%cthelp2 type ct helper { type \"ftp\" protocol tcp\; l3proto ip6\; };fail
+
 ct helper set "cthelp1";ok
 ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" };ok
+
+# limit
+%lim1 type limit rate 400/minute;ok
+%lim2 type limit rate over 1024 bytes/second burst 512 bytes;ok
+
+ip saddr 192.168.1.3 limit name "lim1";ok
+ip saddr 192.168.1.3 limit name "lim3";fail
+limit name tcp dport map {443 : "lim1", 80 : "lim2", 22 : "lim1"};ok
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 7f16c5a..007eadd 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -43,3 +43,19 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d id 1 ]
+
+# ip saddr 192.168.1.3 limit name "lim1"
+ip test-ip4 output
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0301a8c0 ]
+  [ objref type 4 name lim1 ]
+
+# limit name tcp dport map {443 : "lim1", 80 : "lim2", 22 : "lim1"}
+__objmap%d test-ip4 43 size 3
+__objmap%d test-ip4 0
+        element 0000bb01  : 0 [end]     element 00005000  : 0 [end]     element 00001600  : 0 [end]
+ip test-ip4 output
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ objref sreg 1 set __objmap%d id 1 ]
-- 
2.14.1

