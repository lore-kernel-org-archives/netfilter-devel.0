From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: add concatenations and maps; combine them too
Date: Fri, 11 Sep 2015 14:42:25 +0200
Message-ID: <1441975345-5962-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37983 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbIKMfw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2015 08:35:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds simple tests for concatenation and maps, including more
advanced tests that combine them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/ct.t             |    5 +++++
 tests/regression/any/ct.t.payload     |   36 +++++++++++++++++++++++++++++++++
 tests/regression/any/meta.t           |    4 ++++
 tests/regression/any/meta.t.payload   |   29 ++++++++++++++++++++++++++
 tests/regression/ip/dnat.t            |    3 +++
 tests/regression/ip/dnat.t.payload.ip |   19 +++++++++++++++++
 tests/regression/ip/ip.t.payload      |   10 +++++++++
 tests/regression/ip/ip.t.payload.inet |   12 +++++++++++
 8 files changed, 118 insertions(+)

diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index 6ec0526..ab4b167 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -105,3 +105,8 @@ ct helper "12345678901234567";fail
 # <cmdline>:1:37-39: Error: datatype mismatch, expected invalid, expression has type Internet protocol
 # add rule ip test input ct proto-dst udp
 #                        ~~~~~~~~~~~~ ^^^
+
+ct state . ct mark { new . 0x12345678};ok
+ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634};ok
+ct direction . ct mark { original . 0x12345678};ok
+ct state . ct mark vmap { new . 0x12345678 : drop};ok
diff --git a/tests/regression/any/ct.t.payload b/tests/regression/any/ct.t.payload
index f77c284..2e7c1ff 100644
--- a/tests/regression/any/ct.t.payload
+++ b/tests/regression/any/ct.t.payload
@@ -237,3 +237,39 @@ ip test-ip4 output
   [ ct load helper => reg 1 ]
   [ cmp eq reg 1 0x00707466 0x00000000 0x00000000 0x00000000 ]
 
+# ct state . ct mark { new . 0x12345678}
+set%d test 3
+set%d test 0
+	element 00000008 12345678  : 0 [end]
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set set%d ]
+
+# ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00000008 12345678  : 0 [end]	element 00000008 34127856  : 0 [end]	element 00000002 12785634  : 0 [end]
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set set%d ]
+
+# ct direction . ct mark { original . 0x12345678}
+set%d test 3
+set%d test 0
+	element 00000000 12345678  : 0 [end]
+ip test-ip4 output
+  [ ct load direction => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set set%d ]
+
+# ct state . ct mark vmap { new . 0x12345678 : drop}
+map%d test-ip4 b
+map%d test-ip4 0
+        element 00000008 12345678  : 0 [end]
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index 24bcafa..ddb360d 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -187,3 +187,7 @@ meta cgroup 1048577-1048578;ok;cgroup 1048577-1048578
 meta cgroup != 1048577-1048578;ok;cgroup != 1048577-1048578
 meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
 # meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
+
+meta iif . meta oif { lo . eth0 };ok
+meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a };ok
+meta iif . meta oif vmap { lo . eth0 : drop };ok
diff --git a/tests/regression/any/meta.t.payload b/tests/regression/any/meta.t.payload
index 921e42e..481903e 100644
--- a/tests/regression/any/meta.t.payload
+++ b/tests/regression/any/meta.t.payload
@@ -705,3 +705,32 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set set%d ]
 
+
+# meta iif . meta oif { lo . eth0 }
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00000001 00000002  : 0 [end]
+ip test-ip4 output 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ lookup reg 1 set set%d ]
+
+# meta iif . meta oif . meta mark { lo . eth0 . 0x0000000a }
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00000001 00000002 0000000a  : 0 [end]
+ip test-ip4 output 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ meta load mark => reg 10 ]
+  [ lookup reg 1 set set%d ]
+
+# meta iif . meta oif vmap { lo . eth0 : drop }
+map%d test-ip4 b
+map%d test-ip4 0
+	element 00000001 00000002  : 0 [end]
+ip test-ip4 output 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ lookup reg 1 set map%d dreg 0 ]
+
diff --git a/tests/regression/ip/dnat.t b/tests/regression/ip/dnat.t
index 78fc454..cdb7811 100644
--- a/tests/regression/ip/dnat.t
+++ b/tests/regression/ip/dnat.t
@@ -10,3 +10,6 @@ iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
 iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2;ok
+
+dnat ct mark map { 0x00000014 : 1.2.3.4};ok
+dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
diff --git a/tests/regression/ip/dnat.t.payload.ip b/tests/regression/ip/dnat.t.payload.ip
index 93c4d68..026e871 100644
--- a/tests/regression/ip/dnat.t.payload.ip
+++ b/tests/regression/ip/dnat.t.payload.ip
@@ -48,3 +48,22 @@ ip test-ip4 prerouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
+# dnat ct mark map { 0x00000014 : 1.2.3.4}
+map%d test-ip4 b
+map%d test-ip4 0
+	element 00000014  : 04030201 0 [end]
+ip test-ip4 prerouting
+  [ ct load mark => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
+# dnat ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+map%d test-ip4 b
+map%d test-ip4 0
+	element 00000014 01010101  : 04030201 0 [end]
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
diff --git a/tests/regression/ip/ip.t.payload b/tests/regression/ip/ip.t.payload
index 7a77dc4..147923c 100644
--- a/tests/regression/ip/ip.t.payload
+++ b/tests/regression/ip/ip.t.payload
@@ -353,3 +353,13 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
+set%d test-ip 3
+set%d test-ip 0
+	element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
+ip test-ip input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 1b @ network header + 9 => reg 10 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/regression/ip/ip.t.payload.inet b/tests/regression/ip/ip.t.payload.inet
index dbc7852..4caea1e 100644
--- a/tests/regression/ip/ip.t.payload.inet
+++ b/tests/regression/ip/ip.t.payload.inet
@@ -465,3 +465,15 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
+set%d test-ip 3
+set%d test-ip 0
+        element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
+inet test-ip input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 1b @ network header + 9 => reg 10 ]
+  [ lookup reg 1 set set%d ]
+
-- 
1.7.10.4

