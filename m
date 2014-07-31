From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 2/6] [nft] tests: Add ip6 folder with test files.
Date: Thu, 31 Jul 2014 11:08:07 +0200
Message-ID: <1406797691-1080-3-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:42626 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaGaJIb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:31 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so2400738wes.28
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:28 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"ip6" folder contains the test files that are executed in ip6 and inet
family of tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/ip6/chains.t |  16 ++++++
 tests/ip6/dst.t    |  25 ++++++++++
 tests/ip6/hbh.t    |  17 +++++++
 tests/ip6/icmpv6.t | 115 +++++++++++++++++++++++++++++++++++++++++++
 tests/ip6/ip6.t    | 141 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ip6/mh.t     |  50 +++++++++++++++++++
 tests/ip6/nat.t    |   8 +++
 tests/ip6/reject.t |   5 ++
 tests/ip6/rt.t     |  50 +++++++++++++++++++
 tests/ip6/sets.t   |  27 ++++++++++
 tests/ip6/vmap.t   |  54 ++++++++++++++++++++
 11 files changed, 508 insertions(+)
 create mode 100644 tests/ip6/chains.t
 create mode 100644 tests/ip6/dst.t
 create mode 100644 tests/ip6/hbh.t
 create mode 100644 tests/ip6/icmpv6.t
 create mode 100644 tests/ip6/ip6.t
 create mode 100644 tests/ip6/mh.t
 create mode 100644 tests/ip6/nat.t
 create mode 100644 tests/ip6/reject.t
 create mode 100644 tests/ip6/rt.t
 create mode 100644 tests/ip6/sets.t
 create mode 100644 tests/ip6/vmap.t

diff --git a/tests/ip6/chains.t b/tests/ip6/chains.t
new file mode 100644
index 0000000..36c33af
--- /dev/null
+++ b/tests/ip6/chains.t
@@ -0,0 +1,16 @@
+*ip6;test-ip6
+-*inet;test-inet
+
+# filter chains available are: input, output, forward, forward, prerouting and postrouting.
+:filter-input;type filter hook input priority 0
+:filter-prer;type filter hook prerouting priority 0
+:filter-forw-t;type filter hook forward priority 0
+:filter-out-t;type filter hook output priority 0
+:filter-post-t;type filter hook postrouting priority 0
+# nat chains available are: input, output, forward, prerouting and postrouting.
+:nat-input;type nat hook input priority 0
+:nat-prerouting;type nat hook prerouting priority 0
+:nat-output;type nat hook output priority 0
+:nat-postrou;type nat hook postrouting priority 0
+# route chain available is output.
+:route-out;type route hook output priority 0
diff --git a/tests/ip6/dst.t b/tests/ip6/dst.t
new file mode 100644
index 0000000..71e71e3
--- /dev/null
+++ b/tests/ip6/dst.t
@@ -0,0 +1,25 @@
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+dst nexthdr 22;ok;dst nexthdr xns-idp
+dst nexthdr != 233;ok
+dst nexthdr 33-45;ok;dst nexthdr >= dccp dst nexthdr <= idrp
+dst nexthdr != 33-45;ok;dst nexthdr < dccp dst nexthdr > idrp
+dst nexthdr { 33, 55, 67, 88};ok;dst nexthdr { 67, dccp, eigrp, 55}
+- dst nexthdr != { 33, 55, 67, 88};ok
+dst nexthdr { 33-55};ok;dst nexthdr { dccp-55}
+- dst nexthdr != { 33-55};ok
+dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+-dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+-dst nexthdr icmp;ok
+dst nexthdr != icmp;ok
+
+dst hdrlength 22;ok
+dst hdrlength != 233;ok
+dst hdrlength 33-45;ok;dst hdrlength >= 33 dst hdrlength <= 45
+dst hdrlength != 33-45;ok;dst hdrlength < 33 dst hdrlength > 45
+dst hdrlength { 33, 55, 67, 88};ok
+-dst hdrlength != { 33, 55, 67, 88};ok
+dst hdrlength { 33-55};ok
+-dst hdrlength != { 33-55};ok
diff --git a/tests/ip6/hbh.t b/tests/ip6/hbh.t
new file mode 100644
index 0000000..ea4ac9c
--- /dev/null
+++ b/tests/ip6/hbh.t
@@ -0,0 +1,17 @@
+*ip6;test-ip6
+*inet;test-inet
+:filter-input;type filter hook input priority 0
+
+hbh hdrlength 22;ok
+hbh hdrlength != 233;ok
+hbh hdrlength 33-45;ok;hbh hdrlength >= 33 hbh hdrlength <= 45
+hbh hdrlength != 33-45;ok;hbh hdrlength < 33 hbh hdrlength > 45
+hbh hdrlength {33, 55, 67, 88};ok
+-hbh hdrlength != {33, 55, 67, 88};ok
+hbh hdrlength { 33-55};ok
+-hbh hdrlength != {33-55};ok
+
+hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+-hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+hbh nexthdr ip;ok
+hbh nexthdr != ip;ok
diff --git a/tests/ip6/icmpv6.t b/tests/ip6/icmpv6.t
new file mode 100644
index 0000000..a15fb8f
--- /dev/null
+++ b/tests/ip6/icmpv6.t
@@ -0,0 +1,115 @@
+*ip6;test-ip4
+# There is a bug with icmpv6 and inet tables
+-*inet;test-inet
+
+:input;type filter hook input priority 0
+
+icmpv6 type destination-unreachable accept;ok
+icmpv6 type packet-too-big accept;ok
+icmpv6 type time-exceeded accept;ok
+icmpv6 type echo-request accept;ok
+icmpv6 type echo-reply accept;ok
+icmpv6 type mld-listener-query accept;ok
+icmpv6 type mld-listener-report accept;ok
+icmpv6 type mld-listener-reduction accept;ok
+icmpv6 type nd-router-solicit accept;ok
+icmpv6 type nd-router-advert accept;ok
+icmpv6 type nd-neighbor-solicit accept;ok
+icmpv6 type nd-neighbor-advert accept;ok
+icmpv6 type nd-redirect accept;ok
+icmpv6 type router-renumbering accept;ok
+
+icmpv6 type {destination-unreachable, time-exceeded, nd-router-solicit} accept;ok
+icmpv6 type {router-renumbering, mld-listener-reduction, time-exceeded, nd-router-solicit} accept;ok
+icmpv6 type {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
+
+-# icmpv6 type != {mld-listener-query, time-exceeded, nd-router-advert} accept;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmpv6 code 4;ok
+icmpv6 code 3-66;ok;icmpv6 code >= 3 icmpv6 code <= 66
+icmpv6 code {5, 6, 7} accept;ok
+- icmpv6 code != {3, 66, 34};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+icmpv6 code { 3-66};ok
+- icmpv6 code != { 3-44};ok
+
+icmpv6 checksum 2222 log;ok
+icmpv6 checksum != 2222 log;ok
+icmpv6 checksum 222-226;ok;icmpv6 checksum >= 222 icmpv6 checksum <= 226
+icmpv6 checksum != 2222 log;ok
+icmpv6 checksum { 222, 226};ok
+- icmpv6 checksum != { 222, 226};ok
+icmpv6 checksum { 222-226};ok
+- icmpv6 checksum != { 222-226};ok
+
+# icmpv6 parameter-problem, pptr, mtu, packet-too-big
+# [ICMP6HDR_PPTR]         = ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
+# [ICMP6HDR_MTU]          = ICMP6HDR_FIELD("packet-too-big", icmp6_mtu),
+# $ sudo nft add rule ip6 test6 input icmpv6 parameter-problem 35
+# <cmdline>:1:53-53: Error: syntax error, unexpected end of file
+# add rule ip6 test6 input icmpv6 parameter-problem 35
+#                                                    ^
+# $ sudo nft add rule ip6 test6 input icmpv6 parameter-problem
+# <cmdline>:1:26-31: Error: Value 58 exceeds valid range 0-0
+# add rule ip6 test6 input icmpv6 parameter-problem
+#                         ^^^^^^
+# $ sudo nft add rule ip6 test6 input icmpv6 parameter-problem 2-4
+# <cmdline>:1:54-54: Error: syntax error, unexpected end of file
+# add rule ip6 test6 input icmpv6 parameter-problem 2-4
+
+#packet-too-big
+#$ sudo nft add rule ip6 test6 input icmpv6 packet-too-big 34
+#<cmdline>:1:50-50: Error: syntax error, unexpected end of file
+#add rule ip6 test6 input icmpv6 packet-too-big 34
+
+icmpv6 mtu 22;ok
+icmpv6 mtu != 233;ok
+icmpv6 mtu 33-45;ok
+icmpv6 mtu != 33-45;ok
+# bug to list icmpv6 parameter-problem { 738197504, 1142226944 }
+icmpv6 mtu {33, 55, 67, 88};ok
+-icmpv6 mtu != {33, 55, 67, 88};ok
+icmpv6 mtu {33-55};ok
+-icmpv6 mtu != {33-55};ok
+
+##- id
+icmpv6 id 2;ok
+#  $ sudo nft list table ip6 test6
+#table ip6 test6 {
+#	chain input {
+#		 payload @th,32,16 0x2 [invalid type]
+#	}
+#}
+
+icmpv6 sequence 2;ok
+icmpv6 sequence {3, 4, 5, 6, 7} accept;ok
+
+# icmpv6 sequence 2-4;ok
+# BUG: invalid byte order conversion 0 => 2
+# nft: src/evaluate.c:153: byteorder_conversion_op: Assertion '0' failed.
+
+icmpv6 sequence {2, 4};ok
+-icmpv6 sequence != {2, 4};ok
+icmpv6 sequence 2-4;ok
+icmpv6 sequence != 2-4;ok
+icmpv6 sequence { 2-4};ok
+- icmpv6 sequence != {2-4};ok
+
+# BUG max-delay payload @th,32,16 0x21 [invalid type]
+# $ sudo nft add rule ip6 test6 input icmpv6 max-delay 33
+# $ sudo nft list table ip6 test6
+# table ip6 test6 {
+#	chain input {
+#		 payload @th,32,16 0x21 [invalid type]
+
+icmpv6 max-delay 22;ok
+icmpv6 max-delay != 233;ok
+icmpv6 max-delay 33-45;ok
+icmpv6 max-delay != 33-45;ok
+icmpv6 max-delay {33, 55, 67, 88};ok
+-icmpv6 max-delay != {33, 55, 67, 88};ok
+icmpv6 max-delay {33-55};ok
+-icmpv6 max-delay != {33-55};ok
diff --git a/tests/ip6/ip6.t b/tests/ip6/ip6.t
new file mode 100644
index 0000000..c905223
--- /dev/null
+++ b/tests/ip6/ip6.t
@@ -0,0 +1,141 @@
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+# Problem with version, priority
+-ip6 version 6;ok
+-ip6 priority 3;ok
+
+# $ sudo nft add rule ip6 test6 input ip6 priority 33
+# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-15
+# add rule ip6 test6 input ip6 priority 33
+# $ sudo nft add rule ip6 test6 input ip6 version 33
+# <cmdline>:1:38-39: Error: Value 33 exceeds valid range 0-15
+# add rule ip6 test6 input ip6 version 33
+# $ sudo nft add rule ip6 test6 input ip6 version 2
+# <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
+# add rule ip6 test6 input ip6 version 2
+#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+ip6 flowlabel 22;ok
+ip6 flowlabel != 233;ok
+-ip6 flowlabel 33-45;ok
+-ip6 flowlabel != 33-45;ok
+ip6 flowlabel { 33, 55, 67, 88};ok
+# BUG ip6 flowlabel { 5046528, 2883584, 13522432 }
+-ip6 flowlabel != { 33, 55, 67, 88};ok
+ip6 flowlabel { 33-55};ok
+-ip6 flowlabel != { 33-55};ok
+
+ip6 length 2222;ok
+
+ip6 length 22;ok
+ip6 length != 233;ok
+ip6 length 33-45;ok;ip6 length >= 33 ip6 length <= 45
+ip6 length != 33-45;ok;ip6 length < 33 ip6 length > 45
+-ip6 length { 33, 55, 67, 88};ok
+# BUG to list: ip6 length { 11266, 5632, 8704 }
+-ip6 length != {33, 55, 67, 88};ok
+ip6 length { 33-55};ok
+-ip6 length != { 33-55};ok
+
+ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp} log;ok
+ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+-ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
+ip6 nexthdr esp;ok
+ip6 nexthdr != esp;ok
+
+ip6 hoplimit 1 log;ok
+ip6 hoplimit != 233;ok
+ip6 hoplimit 33-45;ok;ip6 hoplimit >= 33 ip6 hoplimit <= 45
+ip6 hoplimit != 33-45;ok;ip6 hoplimit < 33 ip6 hoplimit > 45
+ip6 hoplimit {33, 55, 67, 88};ok
+-ip6 hoplimit != {33, 55, 67, 88};ok
+ip6 hoplimit {33-55};ok
+-ip6 hoplimit != {33-55};ok
+
+#from src/scanner.l
+#v680		(({hex4}:){7}{hex4})
+ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234;ok
+#v670		((:)(:{hex4}{7}))
+ip6 saddr ::1234:1234:1234:1234:1234:1234:1234;ok
+#v671		((({hex4}:){1})(:{hex4}{6}))
+ip6 saddr 1234::1234:1234:1234:1234:1234:1234;ok
+#v672		((({hex4}:){2})(:{hex4}{5}))
+ip6 saddr 1234:1234::1234:1234:1234:1234:1234;ok
+#v673		((({hex4}:){3})(:{hex4}{4}))
+ip6 saddr 1234:1234:1234::1234:1234:1234:1234;ok
+#v674		((({hex4}:){4})(:{hex4}{3}))
+ip6 saddr 1234:1234:1234:1234::1234:1234:1234;ok
+#v675		((({hex4}:){5})(:{hex4}{2}))
+ip6 saddr 1234:1234:1234:1234:1234::1234:1234;ok
+#v676		((({hex4}:){6})(:{hex4}{1}))
+ip6 saddr 1234:1234:1234:1234:1234:1234::1234;ok
+#v677		((({hex4}:){7})(:))
+ip6 saddr 1234:1234:1234:1234:1234:1234:1234::;ok
+#v67		({v670}|{v671}|{v672}|{v673}|{v674}|{v675}|{v676}|{v677})
+#v660		((:)(:{hex4}{6}))
+ip6 saddr ::1234:1234:1234:1234:1234:1234;ok
+#v661		((({hex4}:){1})(:{hex4}{5}))
+ip6 saddr 1234::1234:1234:1234:1234:1234;ok
+#v662		((({hex4}:){2})(:{hex4}{4}))
+ip6 saddr 1234:1234::1234:1234:1234:1234;ok
+#v663		((({hex4}:){3})(:{hex4}{3}))
+ip6 saddr 1234:1234:1234::1234:1234:1234;ok
+#v664		((({hex4}:){4})(:{hex4}{2}))
+ip6 saddr 1234:1234:1234:1234::1234:1234;ok
+#v665		((({hex4}:){5})(:{hex4}{1}))
+ip6 saddr 1234:1234:1234:1234:1234::1234;ok
+#v666		((({hex4}:){6})(:))
+ip6 saddr 1234:1234:1234:1234:1234:1234::;ok
+#v66		({v660}|{v661}|{v662}|{v663}|{v664}|{v665}|{v666})
+#v650		((:)(:{hex4}{5}))
+ip6 saddr ::1234:1234:1234:1234:1234;ok
+#v651		((({hex4}:){1})(:{hex4}{4}))
+ip6 saddr 1234::1234:1234:1234:1234;ok
+#v652		((({hex4}:){2})(:{hex4}{3}))
+ip6 saddr 1234:1234::1234:1234:1234;ok
+#v653		((({hex4}:){3})(:{hex4}{2}))
+ip6 saddr 1234:1234:1234::1234:1234;ok
+#v654		((({hex4}:){4})(:{hex4}{1}))
+ip6 saddr 1234:1234:1234:1234::1234;ok
+#v655		((({hex4}:){5})(:))
+ip6 saddr 1234:1234:1234:1234:1234::;ok
+#v65		({v650}|{v651}|{v652}|{v653}|{v654}|{v655})
+#v640		((:)(:{hex4}{4}))
+ip6 saddr ::1234:1234:1234:1234;ok
+#v641		((({hex4}:){1})(:{hex4}{3}))
+ip6 saddr 1234::1234:1234:1234;ok
+#v642		((({hex4}:){2})(:{hex4}{2}))
+ip6 saddr 1234:1234::1234:1234;ok
+#v643		((({hex4}:){3})(:{hex4}{1}))
+ip6 saddr 1234:1234:1234::1234;ok
+#v644		((({hex4}:){4})(:))
+ip6 saddr 1234:1234:1234:1234::;ok
+#v64		({v640}|{v641}|{v642}|{v643}|{v644})
+#v630		((:)(:{hex4}{3}))
+ip6 saddr ::1234:1234:1234;ok
+#v631		((({hex4}:){1})(:{hex4}{2}))
+ip6 saddr 1234::1234:1234;ok
+#v632		((({hex4}:){2})(:{hex4}{1}))
+ip6 saddr 1234:1234::1234;ok
+#v633		((({hex4}:){3})(:))
+ip6 saddr 1234:1234:1234::;ok
+#v63		({v630}|{v631}|{v632}|{v633})
+#v620		((:)(:{hex4}{2}))
+ip6 saddr ::1234:1234;ok
+#v621		((({hex4}:){1})(:{hex4}{1}))
+ip6 saddr 1234::1234;ok
+#v622		((({hex4}:){2})(:))
+ip6 saddr 1234:1234::;ok
+#v62		({v620}|{v621}|{v622})
+#v610		((:)(:{hex4}{1}))
+ip6 saddr ::1234;ok
+#v611		((({hex4}:){1})(:))
+ip6 saddr 1234::;ok
+#v61		({v610}|{v611})
+#v60		(::)
+ip6 saddr ::/64;ok
+
+- ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok
+ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok
diff --git a/tests/ip6/mh.t b/tests/ip6/mh.t
new file mode 100644
index 0000000..1ad7ec4
--- /dev/null
+++ b/tests/ip6/mh.t
@@ -0,0 +1,50 @@
+*ip6;test-ip6
+*inet;test-inet
+
+:input;type filter hook input priority 0
+
+mh nexthdr 1;ok;mh nexthdr icmp
+mh nexthdr != 1;ok;mh nexthdr != icmp
+mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp };ok
+-mh nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+mh nexthdr icmp;ok
+mh nexthdr != icmp;ok
+mh nexthdr 22;ok;mh nexthdr xns-idp
+mh nexthdr != 233;ok
+mh nexthdr 33-45;ok;mh nexthdr >= dccp mh nexthdr <= idrp
+mh nexthdr != 33-45;ok;mh nexthdr < dccp mh nexthdr > idrp
+mh nexthdr { 33, 55, 67, 88 };ok;mh nexthdr { 67, dccp, eigrp, 55}
+- mh nexthdr != { 33, 55, 67, 88 };ok
+mh nexthdr { 33-55 };ok;mh nexthdr { dccp-55}
+- mh nexthdr != { 33-55 };ok
+
+mh hdrlength 22;ok
+mh hdrlength != 233;ok
+mh hdrlength 33-45;ok;mh hdrlength >= 33 mh hdrlength <= 45
+mh hdrlength != 33-45;ok;mh hdrlength < 33 mh hdrlength > 45
+mh hdrlength { 33, 55, 67, 88 };ok;mh hdrlength { 67, 33, 88, 55}
+-mh hdrlength != { 33, 55, 67, 88 };ok
+mh hdrlength { 33-55 };ok
+-mh hdrlength != { 33-55 };ok
+
+mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message};ok
+mh type home-agent-switch-message;ok
+mh type != home-agent-switch-message;ok
+
+mh reserved 22;ok
+mh reserved != 233;ok
+mh reserved 33-45;ok;mh reserved >= 33 mh reserved <= 45
+mh reserved != 33-45;ok;mh reserved < 33 mh reserved > 45
+mh reserved { 33, 55, 67, 88};ok
+-mh reserved != {33, 55, 67, 88};ok
+mh reserved { 33-55};ok
+-mh reserved != { 33-55};ok
+
+mh checksum 22;ok
+mh checksum != 233;ok
+mh checksum 33-45;ok;mh checksum >= 33 mh checksum <= 45
+mh checksum != 33-45;ok;mh checksum < 33 mh checksum > 45
+mh checksum { 33, 55, 67, 88};ok
+-mh checksum != { 33, 55, 67, 88};ok
+mh checksum { 33-55};ok
+-mh checksum != { 33-55};ok
diff --git a/tests/ip6/nat.t b/tests/ip6/nat.t
new file mode 100644
index 0000000..bd795de
--- /dev/null
+++ b/tests/ip6/nat.t
@@ -0,0 +1,8 @@
+*ip6;test-ip6
+-*inet;test-inet
+
+:input;type nat hook input priority 0
+
+# TODO
+tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok
+tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:: :100;ok
diff --git a/tests/ip6/reject.t b/tests/ip6/reject.t
new file mode 100644
index 0000000..b49c50b
--- /dev/null
+++ b/tests/ip6/reject.t
@@ -0,0 +1,5 @@
+*ip6;test-ip6
+*inet;test-inet
+:output;type filter hook output priority 0
+
+reject;ok
diff --git a/tests/ip6/rt.t b/tests/ip6/rt.t
new file mode 100644
index 0000000..5a076e4
--- /dev/null
+++ b/tests/ip6/rt.t
@@ -0,0 +1,50 @@
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+rt nexthdr 1;ok;rt nexthdr icmp
+rt nexthdr != 1;ok;rt nexthdr != icmp
+
+rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+-rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok
+
+rt nexthdr icmp;ok
+rt nexthdr != icmp;ok
+
+rt nexthdr 22;ok;rt nexthdr xns-idp
+rt nexthdr != 233;ok
+rt nexthdr 33-45;ok;rt nexthdr >= dccp rt nexthdr <= idrp
+rt nexthdr != 33-45;ok;rt nexthdr < dccp rt nexthdr > idrp
+rt nexthdr { 33, 55, 67, 88};ok;rt nexthdr { 67, dccp, eigrp, 55}
+- rt nexthdr != { 33, 55, 67, 88};ok
+rt nexthdr { 33-55};ok;rt nexthdr { dccp-55}
+- rt nexthdr != { 33-55};ok
+
+rt hdrlength 22;ok
+rt hdrlength != 233;ok
+rt hdrlength 33-45;ok;rt hdrlength >= 33 rt hdrlength <= 45
+rt hdrlength != 33-45;ok;rt hdrlength < 33 rt hdrlength > 45
+rt hdrlength { 33, 55, 67, 88};ok
+-rt hdrlength != { 33, 55, 67, 88};ok
+rt hdrlength { 33-55};ok
+-rt hdrlength != { 33-55};ok
+
+rt type 22;ok
+rt type != 233;ok
+rt type 33-45;ok;rt type >= 33 rt type <= 45
+rt type != 33-45;ok;rt type < 33 rt type > 45
+rt type { 33, 55, 67, 88};ok
+
+# BUG rt type and set
+-rt type != { 33, 55, 67, 88};ok
+rt type { 33-55};ok
+-rt type != { 33-55};ok
+
+rt seg-left 22;ok
+rt seg-left != 233;ok
+rt seg-left 33-45;ok;rt seg-left >= 33 rt seg-left <= 45
+rt seg-left != 33-45;ok;rt seg-left < 33 rt seg-left > 45
+rt seg-left { 33, 55, 67, 88};ok
+-rt seg-left != { 33, 55, 67, 88};ok
+rt seg-left { 33-55};ok
+-rt seg-left != { 33-55};ok
diff --git a/tests/ip6/sets.t b/tests/ip6/sets.t
new file mode 100644
index 0000000..3645e94
--- /dev/null
+++ b/tests/ip6/sets.t
@@ -0,0 +1,27 @@
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+!set_ipv6_add1 ipv6_addr;ok
+!set_inet1 inet_proto;ok
+!set_inet inet_service;ok
+!set_time time;ok
+
+?set2 192.168.3.4;fail
+!set2 ipv6_addr;ok
+?set2 1234:1234::1234:1234:1234:1234:1234;ok
+# Bug: nft shows the error (for a repeat value in the set but the return value is 0
+# nft does not return an error code.
+-?set2 1234:1234::1234:1234:1234:1234:1234;fail
+
+?set2 1234::1234:1234:1234;ok
+?set2 1234:1234:1234:1234:1234::1234:1234 1234:1234::123;ok
+?set2 192.168.3.8 192.168.3.9;fail
+?set2 1234:1234::1234:1234:1234:1234;ok
+-?set2 1234:1234::1234:1234:1234:1234;fail
+?set2 1234:1234:1234::1234;ok
+
+ip saddr @set2 drop;fail
+
+ip6 saddr @set2 drop;ok
+ip6 saddr @set33 drop;fail
diff --git a/tests/ip6/vmap.t b/tests/ip6/vmap.t
new file mode 100644
index 0000000..50fca82
--- /dev/null
+++ b/tests/ip6/vmap.t
@@ -0,0 +1,54 @@
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+ip6 saddr vmap { abcd::3 : accept };ok
+ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
+
+# Ipv6 address combinations
+#from src/scanner.l
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234:1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234::1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234::1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234::1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234::1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234:1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234::1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234::1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234::1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234:1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept};ok
+ip6 saddr vmap { ::1234:1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234::1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234:1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234:1234 : accept};ok
+ip6 saddr vmap { 1234:1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234:1234 : accept};ok
+ip6 saddr vmap { 1234::1234 : accept};ok
+ip6 saddr vmap { 1234:1234:: : accept};ok
+ip6 saddr vmap { ::1234 : accept};ok
+ip6 saddr vmap { 1234:: : accept};ok
+ip6 saddr vmap { ::/64 : accept};ok
+
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:: : accept, ::aaaa : drop};ok
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept, ::bbbb : drop};ok
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::cccc : drop};ok
+ip6 saddr vmap {1234:1234:1234:1234:1234:1234:aaaa:::accept,::dddd: drop};ok
+
+# rule without comma:
+filter-input ip6 saddr vmap { 1234:1234:1234:1234:1234:1234:bbbb:::accept::adda : drop};fail
-- 
2.0.0

