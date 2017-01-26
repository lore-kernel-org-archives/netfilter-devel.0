From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 6/6] tests: py: Add tests for stateful objects
Date: Thu, 26 Jan 2017 15:21:45 -0200
Message-ID: <20170126172145.GA8058@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35763 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbdAZR3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:29:33 -0500
Received: by mail-qt0-f194.google.com with SMTP id f4so39925517qte.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:28:44 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These test for adding counters and quotas, to tables of different
families, and for referencing the objects in rules.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v3: Created in v3.

 tests/py/any/objects.t        | 13 +++++++++++++
 tests/py/ip/objects.t         | 15 +++++++++++++++
 tests/py/ip/objects.t.payload | 31 +++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)
 create mode 100644 tests/py/any/objects.t
 create mode 100644 tests/py/ip/objects.t
 create mode 100644 tests/py/ip/objects.t.payload

diff --git a/tests/py/any/objects.t b/tests/py/any/objects.t
new file mode 100644
index 0000000..d44696d
--- /dev/null
+++ b/tests/py/any/objects.t
@@ -0,0 +1,13 @@
+:output;type filter hook output priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+*netdev;test-netdev;ingress
+
+%cnt1 type counter;ok
+%qt1 type quota 25 mbytes;ok
+%qt2 type quota over 1 kbytes;ok
diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
new file mode 100644
index 0000000..8109402
--- /dev/null
+++ b/tests/py/ip/objects.t
@@ -0,0 +1,15 @@
+:output;type filter hook output priority 0
+
+*ip;test-ip4;output
+
+%cnt1 type counter;ok
+%cnt2 type counter;ok
+%qt1 type quota 25 mbytes;ok
+%qt2 type quota over 1 kbytes;ok
+
+ip saddr 192.168.1.3 counter name "cnt2";ok
+ip saddr 192.168.1.3 counter name "cnt3";fail
+counter name tcp dport map {443 : "cnt1", 80 : "cnt2", 22 : "cnt1"};ok
+ip saddr 192.168.1.3 quota name "qt1";ok
+ip saddr 192.168.1.3 quota name "qt3";fail
+quota name tcp dport map {443 : "qt1", 80 : "qt2", 22 : "qt1"};ok
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
new file mode 100644
index 0000000..b5cad4d
--- /dev/null
+++ b/tests/py/ip/objects.t.payload
@@ -0,0 +1,31 @@
+# ip saddr 192.168.1.3 counter name "cnt2"
+ip test-ip4 output 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0301a8c0 ]
+  [ objref type 1 name cnt2 ]
+
+# counter name tcp dport map {443 : "cnt1", 80 : "cnt2", 22 : "cnt1"}
+__objmap%d test-ip4 43
+__objmap%d test-ip4 0
+	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
+ip test-ip4 output 
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ objref sreg 1 set __objmap%d id 1 ]
+
+# ip saddr 192.168.1.3 quota name "qt1"
+ip test-ip4 output 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0301a8c0 ]
+  [ objref type 2 name qt1 ]
+
+# quota name tcp dport map {443 : "qt1", 80 : "qt2", 22 : "qt1"}
+__objmap%d test-ip4 43
+__objmap%d test-ip4 0
+	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
+ip test-ip4 output 
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ objref sreg 1 set __objmap%d id 1 ]
-- 
2.7.4

