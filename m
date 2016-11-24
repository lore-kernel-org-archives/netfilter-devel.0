From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 2/7] tests/py/{arp,any}: Unmask negative set lookup
Date: Thu, 24 Nov 2016 15:16:21 +0100
Message-ID: <ee64d5dc81660dfdffaec2f6d54d648e670f2996.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59148 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965695AbcKXOW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:22:59 -0500
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many testcases were masked because of bug #888. This series of patches unmasks
them

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
Patches 2 through 7 update the tests, and are split because of the character
limit on netfilter-devel. They could be squashed together.

 tests/py/any/ct.t                 |  10 +-
 tests/py/any/ct.t.payload         |  49 +++++++++
 tests/py/any/meta.t               |  47 ++++-----
 tests/py/any/meta.t.payload       | 203 ++++++++++++++++++++++++++++++++++++++
 tests/py/arp/arp.t                |  14 +--
 tests/py/arp/arp.t.payload        |  56 +++++++++++
 tests/py/arp/arp.t.payload.netdev |  70 +++++++++++++
 7 files changed, 414 insertions(+), 35 deletions(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 7cb49c2..76be185 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -7,7 +7,7 @@
 ct state new,established, related, untracked;ok;ct state established,related,new,untracked
 ct state != related;ok
 ct state {new,established, related, untracked};ok
-- ct state != {new,established, related, untracked};ok
+ct state != {new,established, related, untracked};ok
 ct state invalid drop;ok
 ct state established accept;ok
 ct state 8;ok;ct state new
@@ -18,7 +18,7 @@ ct direction != original;ok
 ct direction reply;ok
 ct direction != reply;ok
 ct direction {reply, original};ok
-- ct direction != {reply, original};ok
+ct direction != {reply, original};ok
 ct direction xxx;fail
 
 ct status expected;ok
@@ -45,7 +45,7 @@ ct mark 0x00000032-0x00000045;ok
 ct mark != 0x00000032-0x00000045;ok
 ct mark {0x32, 0x2222, 0x42de3};ok;ct mark { 0x00042de3, 0x00002222, 0x00000032}
 ct mark {0x32-0x2222, 0x4444-0x42de3};ok;ct mark { 0x00000032-0x00002222, 0x00004444-0x00042de3}
-- ct mark != {0x32, 0x2222, 0x42de3};ok
+ct mark != {0x32, 0x2222, 0x42de3};ok;ct mark != { 0x00042de3, 0x00002222, 0x00000032}
 
 # ct mark != {0x32, 0x2222, 0x42de3};ok
 # BUG: invalid expression type set
@@ -64,9 +64,9 @@ ct expiration != 233;ok;ct expiration != 3m53s
 ct expiration 33-45;ok;ct expiration 33s-45s
 ct expiration != 33-45;ok;ct expiration != 33s-45s
 ct expiration {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
-- ct expiration != {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
+ct expiration != {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
 ct expiration {33-55};ok;ct expiration { 33s-55s}
-- ct expiration != {33-55};ok
+ct expiration != {33-55};ok; ct expiration != { 33s-55s}
 
 ct helper "ftp";ok
 ct helper "12345678901234567";fail
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 26aeec3..90fce9f 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -17,6 +17,14 @@ ip test-ip4 output
   [ ct load state => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ct state != {new,established, related, untracked}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000040  : 0 [end]
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct state invalid drop
 ip test-ip4 output
   [ ct load state => reg 1 ]
@@ -65,6 +73,14 @@ ip test-ip4 output
   [ ct load direction => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ct direction != {reply, original}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000000  : 0 [end]
+ip test-ip4 output
+  [ ct load direction => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct status expected
 ip test-ip4 output
   [ ct load status => reg 1 ]
@@ -95,6 +111,14 @@ ip test-ip4 output
   [ ct load status => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ct status != {expected, seen-reply, assured, confirmed, dying}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000008  : 0 [end]	element 00000200  : 0 [end]
+ip test-ip4 output
+  [ ct load status => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct mark 0
 ip test-ip4 output
   [ ct load mark => reg 1 ]
@@ -174,6 +198,14 @@ ip test-ip4 output
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# ct mark != {0x32, 0x2222, 0x42de3}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000032  : 0 [end]	element 00002222  : 0 [end]	element 00042de3  : 0 [end]
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct mark set 0x11 xor 0x1331
 ip test-ip4 output
   [ immediate reg 1 0x00001320 ]
@@ -230,6 +262,14 @@ ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# ct expiration != {33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 000080e8  : 0 [end]	element 0000d6d8  : 0 [end]	element 000105b8  : 0 [end]	element 000157c0  : 0 [end]
+ip test-ip4 output
+  [ ct load expiration => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct expiration {33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -239,6 +279,15 @@ ip test-ip4 output
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# ct expiration != {33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]
+ip test-ip4 output
+  [ ct load expiration => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # ct helper "ftp"
 ip test-ip4 output
   [ ct load helper => reg 1 ]
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 76ce06b..c3ac0a4 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -16,27 +16,28 @@ meta length != 33-45;ok
 meta length { 33, 55, 67, 88};ok
 meta length { 33-55, 67-88};ok
 meta length { 33-55, 55-88, 100-120};ok;meta length { 33-88, 100-120}
-- meta length != { 33, 55, 67, 88};ok
+meta length != { 33, 55, 67, 88};ok
 meta length { 33-55};ok
-- meta length != { 33-55};ok
+meta length != { 33-55};ok
 
 meta protocol { ip, arp, ip6, vlan };ok;meta protocol { ip6, ip, vlan, arp}
-- meta protocol != {ip, arp, ip6, vlan};ok
+meta protocol != {ip, arp, ip6, vlan};ok
 meta protocol ip;ok
 meta protocol != ip;ok
 
 meta nfproto ipv4;ok
 meta nfproto ipv6;ok
 meta nfproto {ipv4, ipv6};ok
+meta nfproto != {ipv4, ipv6};ok
 
 meta l4proto 22;ok
 meta l4proto != 233;ok
 meta l4proto 33-45;ok
 meta l4proto != 33-45;ok
 meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
-- meta l4proto != { 33, 55, 67, 88};ok
+meta l4proto != { 33, 55, 67, 88};ok
 meta l4proto { 33-55};ok
-- meta l4proto != { 33-55};ok
+meta l4proto != { 33-55};ok
 
 meta priority root;ok
 meta priority none;ok
@@ -51,7 +52,7 @@ meta priority bcad:dada-bcad:dadc;ok
 meta priority != bcad:dada-bcad:dadc;ok
 meta priority {bcad:dada, bcad:dadc, aaaa:bbbb};ok
 meta priority set cafe:beef;ok
-- meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb};ok
+meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb};ok
 
 meta mark 0x4;ok;mark 0x00000004
 meta mark 0x32;ok;mark 0x00000032
@@ -71,12 +72,12 @@ meta iif != "lo" accept;ok;iif != "lo" accept
 meta iifname "dummy0";ok;iifname "dummy0"
 meta iifname != "dummy0";ok;iifname != "dummy0"
 meta iifname {"dummy0", "lo"};ok
-- meta iifname != {"dummy0", "lo"};ok
+meta iifname != {"dummy0", "lo"};ok
 meta iifname "dummy*";ok;iifname "dummy*"
 meta iifname "dummy\*";ok;iifname "dummy\*"
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-- meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 meta iiftype != ether;ok;iiftype != ether
 meta iiftype ether;ok;iiftype ether
 meta iiftype != ppp;ok;iiftype != ppp
@@ -85,7 +86,7 @@ meta iiftype ppp;ok;iiftype ppp
 meta oif "lo" accept;ok;oif "lo" accept
 meta oif != "lo" accept;ok;oif != "lo" accept
 meta oif {"lo"} accept;ok
-- meta oif != {"lo"} accept;ok
+meta oif != {"lo"} accept;ok
 
 meta oifname "dummy0";ok;oifname "dummy0"
 meta oifname != "dummy0";ok;oifname != "dummy0"
@@ -94,12 +95,12 @@ meta oifname "dummy*";ok;oifname "dummy*"
 meta oifname "dummy\*";ok;oifname "dummy\*"
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-- meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
+meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 meta oiftype != ether;ok;oiftype != ether
 meta oiftype ether;ok;oiftype ether
 
 meta skuid {"bin", "root", "daemon"} accept;ok;skuid { 0, 1, 2} accept
-- meta skuid != {"bin", "root", "daemon"} accept;ok
+meta skuid != {"bin", "root", "daemon"} accept;ok;skuid != { 1, 0, 2} accept
 meta skuid "root";ok;skuid 0
 meta skuid != "root";ok;skuid != 0
 meta skuid lt 3000 accept;ok;skuid < 3000 accept
@@ -108,10 +109,10 @@ meta skuid eq 3000 accept;ok;skuid 3000 accept
 meta skuid 3001-3005 accept;ok;skuid 3001-3005 accept
 meta skuid != 2001-2005 accept;ok;skuid != 2001-2005 accept
 meta skuid { 2001-2005} accept;ok;skuid { 2001-2005} accept
-- meta skuid != { 2001-2005} accept;ok
+meta skuid != { 2001-2005} accept;ok
 
 meta skgid {"bin", "root", "daemon"} accept;ok;skgid { 0, 1, 2} accept
-- meta skgid != {"bin", "root", "daemon"} accept;ok
+meta skgid != {"bin", "root", "daemon"} accept;ok;skgid != { 1, 0, 2} accept
 meta skgid "root";ok;skgid 0
 meta skgid != "root";ok;skgid != 0
 meta skgid lt 3000 accept;ok;skgid < 3000 accept
@@ -120,7 +121,7 @@ meta skgid eq 3000 accept;ok;skgid 3000 accept
 meta skgid 2001-2005 accept;ok;skgid 2001-2005 accept
 meta skgid != 2001-2005 accept;ok;skgid != 2001-2005 accept
 meta skgid { 2001-2005} accept;ok;skgid { 2001-2005} accept
-- meta skgid != { 2001-2005} accept;ok;skgid != { 2001-2005} accept
+meta skgid != { 2001-2005} accept;ok;skgid != { 2001-2005} accept
 
 # BUG: meta nftrace 2 and meta nftrace 1
 # $ sudo nft add rule ip test input meta nftrace 2
@@ -166,37 +167,37 @@ meta cpu 1-3;ok;cpu 1-3
 meta cpu != 1-2;ok;cpu != 1-2
 meta cpu { 2,3};ok;cpu { 2,3}
 meta cpu { 2-3, 5-7};ok
--meta cpu != { 2,3};ok; cpu != { 2,3}
+meta cpu != { 2,3};ok; cpu != { 2,3}
 
 meta iifgroup 0;ok;iifgroup "default"
 meta iifgroup != 0;ok;iifgroup != "default"
 meta iifgroup "default";ok;iifgroup "default"
 meta iifgroup != "default";ok;iifgroup != "default"
 meta iifgroup {"default"};ok;iifgroup {"default"}
-- meta iifgroup != {"default"};ok
+meta iifgroup != {"default"};ok
 meta iifgroup { 11,33};ok
 meta iifgroup {11-33};ok
-- meta iifgroup != {11,33};ok
-- meta iifgroup != {11-33};ok
+meta iifgroup != { 11,33};ok
+meta iifgroup != {11-33};ok
 meta oifgroup 0;ok;oifgroup "default"
 meta oifgroup != 0;ok;oifgroup != "default"
 meta oifgroup "default";ok;oifgroup "default"
 meta oifgroup != "default";ok;oifgroup != "default"
 meta oifgroup {"default"};ok;oifgroup {"default"}
-- meta oifgroup != {"default"};ok
+meta oifgroup != {"default"};ok;oifgroup != {"default"}
 meta oifgroup { 11,33};ok
 meta oifgroup {11-33};ok
-- meta oifgroup != {11,33};ok
-- meta oifgroup != {11-33};ok
+meta oifgroup != { 11,33};ok
+meta oifgroup != {11-33};ok
 
 meta cgroup 1048577;ok;cgroup 1048577
 meta cgroup != 1048577;ok;cgroup != 1048577
 meta cgroup { 1048577, 1048578 };ok;cgroup { 1048577, 1048578}
-# meta cgroup != { 1048577, 1048578};ok;cgroup != { 1048577, 1048578}
+meta cgroup != { 1048577, 1048578};ok;cgroup != { 1048577, 1048578}
 meta cgroup 1048577-1048578;ok;cgroup 1048577-1048578
 meta cgroup != 1048577-1048578;ok;cgroup != 1048577-1048578
 meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
-# meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
+meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
 
 meta iif . meta oif { "lo" . "lo" };ok
 meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a };ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index f000bc8..e432656 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -61,6 +61,23 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# meta length != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip test-ip4 input
+  [ meta load len => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta length != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input
+  [ meta load len => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta protocol { ip, arp, ip6, vlan }
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -69,6 +86,14 @@ ip test-ip4 input
   [ meta load protocol => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta protocol != {ip, arp, ip6, vlan}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000608  : 0 [end]	element 0000dd86  : 0 [end]	element 00000081  : 0 [end]
+ip test-ip4 input
+  [ meta load protocol => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta protocol ip
 ip test-ip4 input
   [ meta load protocol => reg 1 ]
@@ -97,6 +122,14 @@ ip test-ip4 input
   [ meta load nfproto => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta nfproto != {ipv4, ipv6}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000002  : 0 [end]	element 0000000a  : 0 [end]
+ip test-ip4 input
+  [ meta load nfproto => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta l4proto 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
@@ -128,6 +161,14 @@ ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta l4proto != { 33, 55, 67, 88}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta l4proto { 33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -137,6 +178,15 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ lookup reg 1 set __set%d ]
 
+# meta l4proto != { 33-55}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta mark 0x4
 ip test-ip4 input
   [ meta load mark => reg 1 ]
@@ -221,6 +271,14 @@ ip test-ip4 input
   [ meta load iifname => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta iifname != {"dummy0", "lo"}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 6d6d7564 00003079 00000000 00000000  : 0 [end]	element 00006f6c 00000000 00000000 00000000  : 0 [end]
+ip test-ip4 input
+  [ meta load iifname => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta iifname "dummy*"
 ip test-ip4 input
   [ meta load iifname => reg 1 ]
@@ -239,6 +297,14 @@ ip test-ip4 input
   [ meta load iiftype => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+ip test-ip4 input
+  [ meta load iiftype => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta iiftype != ether
 ip test-ip4 input
   [ meta load iiftype => reg 1 ]
@@ -280,6 +346,15 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# meta oif != {"lo"} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]
+ip test-ip4 input
+  [ meta load oif => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # meta oifname "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
@@ -316,6 +391,14 @@ ip test-ip4 input
   [ meta load oiftype => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000200  : 0 [end]	element 00000300  : 0 [end]	element 00000301  : 0 [end]	element 00000304  : 0 [end]	element 00000308  : 0 [end]	element 0000030a  : 0 [end]
+ip test-ip4 input
+  [ meta load oiftype => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta oiftype != ether
 ip test-ip4 input
   [ meta load oiftype => reg 1 ]
@@ -335,6 +418,15 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# meta skuid != {"bin", "root", "daemon"} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+ip test-ip4 input
+  [ meta load skuid => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # meta skuid "root"
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
@@ -390,6 +482,16 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# meta skuid != { 2001-2005} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
+ip test-ip4 input
+  [ meta load skuid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # meta skgid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -399,6 +501,15 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# meta skgid != {"bin", "root", "daemon"} accept
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000001  : 0 [end]	element 00000000  : 0 [end]	element 00000002  : 0 [end]
+ip test-ip4 input
+  [ meta load skgid => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # meta skgid "root"
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
@@ -454,6 +565,16 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# meta skgid != { 2001-2005} accept
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
+ip test-ip4 input
+  [ meta load skgid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
 # meta mark set 0xffffffc8 xor 0x16
 ip test-ip4 input
   [ immediate reg 1 0xffffffde ]
@@ -595,6 +716,14 @@ ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta cpu != { 2,3}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000002  : 0 [end]	element 00000003  : 0 [end]
+ip test-ip4 input
+  [ meta load cpu => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta cpu { 2-3, 5-7}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -632,6 +761,14 @@ ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta iifgroup != {"default"}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000000  : 0 [end]
+ip test-ip4 input
+  [ meta load iifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta iifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -649,6 +786,23 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# meta iifgroup != { 11,33}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+ip test-ip4 input
+  [ meta load iifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta iifgroup != {11-33}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
+ip test-ip4 input
+  [ meta load iifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta oifgroup 0
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
@@ -677,6 +831,14 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta oifgroup != {"default"}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000000  : 0 [end]
+ip test-ip4 input
+  [ meta load oifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta oifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -694,6 +856,23 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# meta oifgroup != { 11,33}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+ip test-ip4 input
+  [ meta load oifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta oifgroup != {11-33}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
+ip test-ip4 input
+  [ meta load oifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta cgroup 1048577
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
@@ -712,6 +891,14 @@ ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# meta cgroup != { 1048577, 1048578}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00100001  : 0 [end]	element 00100002  : 0 [end]
+ip test-ip4 input
+  [ meta load cgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta cgroup 1048577-1048578
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
@@ -734,6 +921,14 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
+# meta cgroup != { 1048577-1048578}
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
+ip test-ip4 input
+  [ meta load cgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
 
 # meta iif . meta oif { "lo" . "lo" }
 __set%d test-ip4 3
@@ -834,6 +1029,14 @@ ip test-ip4 input
   [ immediate reg 1 0xcafebeef ]
   [ meta set priority with reg 1 ]
 
+# meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb}
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element bcaddada  : 0 [end]	element bcaddadc  : 0 [end]	element aaaabbbb  : 0 [end]
+ip test-ip4 input
+  [ meta load priority => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # meta priority 0x87654321
 ip test-ip4 input
   [ meta load priority => reg 1 ]
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 70f9a9c..94ab4a5 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -12,9 +12,9 @@ arp htype != 233;ok
 arp htype 33-45;ok
 arp htype != 33-45;ok
 arp htype { 33, 55, 67, 88};ok
-- arp htype != { 33, 55, 67, 88};ok
+arp htype != { 33, 55, 67, 88};ok
 arp htype { 33-55};ok
-- arp htype != { 33-55};ok
+arp htype != { 33-55};ok
 
 arp ptype 0x0800;ok;arp ptype ip
 
@@ -23,21 +23,21 @@ arp hlen != 233;ok
 arp hlen 33-45;ok
 arp hlen != 33-45;ok
 arp hlen { 33, 55, 67, 88};ok
-- arp hlen != { 33, 55, 67, 88};ok
+arp hlen != { 33, 55, 67, 88};ok
 arp hlen { 33-55};ok
-- arp hlen != { 33-55};ok
+arp hlen != { 33-55};ok
 
 arp plen 22;ok
 arp plen != 233;ok
 arp plen 33-45;ok
 arp plen != 33-45;ok
 arp plen { 33, 55, 67, 88};ok
-- arp plen != { 33, 55, 67, 88};ok
+arp plen != { 33, 55, 67, 88};ok
 arp plen { 33-55};ok
-- arp plen != {33-55};ok
+arp plen != {33-55};ok
 
 arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
-- arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
+arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
 arp operation request;ok
 arp operation reply;ok
 arp operation rrequest;ok
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index 5b8f8d5..ea778b2 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -37,6 +37,14 @@ arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp htype != { 33, 55, 67, 88}
+__set%d test-arp 3
+__set%d test-arp 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+arp test-arp input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp htype { 33-55}
 __set%d test-arp 7
 __set%d test-arp 0
@@ -45,6 +53,14 @@ arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp htype != { 33-55}
+__set%d test-arp 7
+__set%d test-arp 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+arp test-arp input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp ptype 0x0800
 arp test-arp input
   [ payload load 2b @ network header + 2 => reg 1 ]
@@ -79,6 +95,14 @@ arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp hlen != { 33, 55, 67, 88}
+__set%d test-arp 3
+__set%d test-arp 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+arp test-arp input
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp hlen { 33-55}
 __set%d test-arp 7
 __set%d test-arp 0
@@ -87,6 +111,14 @@ arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp hlen != { 33-55}
+__set%d test-arp 7
+__set%d test-arp 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+arp test-arp input
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp plen 22
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
@@ -116,6 +148,14 @@ arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp plen != { 33, 55, 67, 88}
+__set%d test-arp 3
+__set%d test-arp 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+arp test-arp input
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp plen { 33-55}
 __set%d test-arp 7
 __set%d test-arp 0
@@ -124,6 +164,14 @@ arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp plen != {33-55}
+__set%d test-arp 7
+__set%d test-arp 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+arp test-arp input
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-arp 3
 __set%d test-arp 0
@@ -132,6 +180,14 @@ arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request}
+__set%d test-arp 3
+__set%d test-arp 0
+	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+arp test-arp input
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp operation request
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 5188ed7..acf9eb1 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -51,6 +51,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp htype != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp htype { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -61,6 +71,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp htype != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp ptype 0x0800
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -107,6 +127,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp hlen != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp hlen { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -117,6 +147,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp hlen != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp plen 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -156,6 +196,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp plen != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp plen { 33-55}
 __set%d test-netdev 7
 __set%d test-netdev 0
@@ -166,6 +216,16 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp plen != {33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 1b @ network header + 5 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -176,6 +236,16 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000a00  : 0 [end]	element 00000900  : 0 [end]	element 00000800  : 0 [end]	element 00000400  : 0 [end]	element 00000300  : 0 [end]	element 00000200  : 0 [end]	element 00000100  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 2b @ network header + 6 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
 # arp operation request
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
-- 
2.11.0.rc2

