From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCHv3] tests: py: Add test for ambiguity while setting the value
Date: Sat, 17 Jun 2017 01:05:42 +0530
Message-ID: <1497641742-25272-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33870 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbdFPTgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 15:36:10 -0400
Received: by mail-pg0-f65.google.com with SMTP id j186so7587969pge.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2017 12:36:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This test checks bug identified and fixed in the commit mentioned below
In a statement if there are  multiple src data then it  would be
totally ambiguous to decide which value to set.

Before the commit was made it returned 134(BUG), but now it returns 1
i.e, an error message.

Test: 986dea8 ("evaluate: avoid reference to multiple src data in
statements which set values")
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 tests/py/any/ct.t       | 10 ++++++++++
 tests/py/any/meta.t     |  8 ++++++++
 tests/py/bridge/ether.t |  7 +++++++
 tests/py/inet/tcp.t     |  7 +++++++
 tests/py/inet/udp.t     |  7 +++++++
 tests/py/ip/ip.t        |  7 +++++++
 6 files changed, 46 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 20f047a..f7c2321 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -58,6 +58,16 @@ ct mark set 0x11;ok;ct mark set 0x00000011
 ct mark set mark;ok;ct mark set mark
 ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
 
+# Following rules tests ambguity while setting the value
+# sudo nft add rule ip test-ip4 output ct mark set {0x11333, 0x11}
+# <cmdline>:1:41-55: Error: you cannot use a set here, unknown value to use
+# add rule ip test-ip4 output ct mark set {0x11333, 0x11}
+#                             ~~~~~~~~~~~~^^^^^^^^^^^^^^^
+ct mark set {0x11333, 0x11};fail
+ct zone set {123, 127};fail
+ct label set {123, 127};fail
+ct event set {new, related, destroy, label};fail
+
 ct expiration 30;ok;ct expiration 30s
 ct expiration 22;ok;ct expiration 22s
 ct expiration != 233;ok;ct expiration != 3m53s
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 2ff942f..e19a8f9 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -143,6 +143,14 @@ meta mark set 0xffffffde or 0x16;ok;mark set 0xffffffde
 meta mark set 0x32 or 0xfffff;ok;mark set 0x000fffff
 meta mark set 0xfffe xor 0x16;ok;mark set 0x0000ffe8
 
+# Test ambiguity while setting the value
+# sudo nft add rule ip test-ip4 input meta mark set {0xffff, 0xcc}
+# <cmdline>:1:42-55: Error: you cannot use a set here, unknown value to use
+# add rule ip test-ip4 input meta mark set {0xffff, 0xcc}
+#                            ~~~~~~~~~~~~~~^^^^^^^^^^^^^^
+meta mark set {0xffff, 0xcc};fail
+meta pkttype set {unicast, multicast, broadcast};fail
+
 meta iif "lo";ok;iif "lo"
 meta oif "lo";ok;oif "lo"
 meta oifname "dummy2" accept;ok;oifname "dummy2" accept
diff --git a/tests/py/bridge/ether.t b/tests/py/bridge/ether.t
index 5c6766e..94637a6 100644
--- a/tests/py/bridge/ether.t
+++ b/tests/py/bridge/ether.t
@@ -8,3 +8,10 @@ tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4;ok
 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept;ok
 
 ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop;ok
+
+#Test ambiguity while setting the value
+#sudo nft add rule bridge test-bridge input ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}
+#<cmdline>:1:51-88: Error: you cannot use a set here, unknown value to use
+#add rule bridge test-bridge input ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}
+#                                  ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02};fail
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 5a0aab6..0281387 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -6,6 +6,13 @@
 *inet;test-inet;input
 *netdev;test-netdev;ingress
 
+# Test ambiguity while setting the value
+# sudo nft add rule ip test-ip4 input tcp dport set {1, 2, 3}
+# <cmdline>:1:42-50: Error: you cannot use a set here, unknown value to use
+# add rule ip test-ip4 input tcp dport set {1, 2, 3}
+#                            ~~~~~~~~~~~~~~^^^^^^^^^
+tcp dport set {1, 2, 3};fail
+
 tcp dport 22;ok
 tcp dport != 233;ok
 tcp dport 33-45;ok
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 2f16e6a..bb09973 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -15,6 +15,13 @@ udp sport != { 50, 60} accept;ok
 udp sport { 12-40};ok
 udp sport != { 13-24};ok
 
+# Test ambiguity while the value
+# sudo nft add rule ip test-ip4 input udp dport set {1, 2, 3}
+# <cmdline>:1:42-50: Error: you cannot use a set here, unknown value to use
+# add rule ip test-ip4 input udp dport set {1, 2, 3}
+#                            ~~~~~~~~~~~~~~^^^^^^^^^
+udp dport set {1, 2, 3};fail
+
 udp dport 80 accept;ok
 udp dport != 60 accept;ok
 udp dport 70-75 accept;ok
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index f984646..3fa511a 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -85,6 +85,13 @@ ip checksum != { 33, 55, 67, 88};ok
 ip checksum { 33-55};ok
 ip checksum != { 33-55};ok
 
+# Test ambiguity while setting value
+# sudo nft add rule ip test-ip4 input ip saddr set {192.19.1.2, 191.1.22.1}
+# <cmdline>:1:41-64: Error: you cannot use a set here, unknown value to use
+# add rule ip test-ip4 input ip saddr set {192.19.1.2, 191.1.22.1}
+#                            ~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^
+ip saddr set {192.19.1.2, 191.1.22.1};fail
+
 ip saddr 192.168.2.0/24;ok
 ip saddr != 192.168.2.0/24;ok
 ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
-- 
1.9.1

