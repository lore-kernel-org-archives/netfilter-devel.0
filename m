From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6 nft] tests: regression: fix warnings related to range listing
Date: Tue,  2 Jun 2015 19:03:07 +0200
Message-ID: <1433264587-29705-7-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbbFBQ6E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:04 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix lots of warnings, mostly related to the listing of ranges in many of the
tests that we have, eg.

any/meta.t: WARNING: line: 30: 'nft add rule ip test-ip4 input meta l4proto 33-45': 'meta l4proto 33-45' mismatches 'meta l4proto 33-45'
any/meta.t: WARNING: line: 31: 'nft add rule ip test-ip4 input meta l4proto != 33-45': 'meta l4proto != 33-45' mismatches 'meta l4proto != 33-45'
any/meta.t: WARNING: line: 99: 'nft add rule ip test-ip4 input meta skuid 3001-3005 accept': 'meta skuid 3001-3005 accept' mismatches 'skuid 3001-3005 accept'
any/meta.t: WARNING: line: 100: 'nft add rule ip test-ip4 input meta skuid != 2001-2005 accept': 'meta skuid != 2001-2005 accept' mismatches 'skuid != 2001-2005 accept'
any/meta.t: WARNING: line: 111: 'nft add rule ip test-ip4 input meta skgid 2001-2005 accept': 'meta skgid 2001-2005 accept' mismatches 'skgid 2001-2005 accept'
any/meta.t: WARNING: line: 112: 'nft add rule ip test-ip4 input meta skgid != 2001-2005 accept': 'meta skgid != 2001-2005 accept' mismatches 'skgid != 2001-2005 accept'
any/meta.t: WARNING: line: 156: 'nft add rule ip test-ip4 input meta cpu 1-3': 'meta cpu 1-3' mismatches 'cpu 1-3'
any/meta.t: WARNING: line: 158: 'nft add rule ip test-ip4 input meta cpu != 1-2': 'meta cpu != 1-2' mismatches 'cpu != 1-2'
any/meta.t: WARNING: line: 187: 'nft add rule ip test-ip4 input meta cgroup 0x100001 - 0x100003': 'meta cgroup 0x100001 - 0x100003' mismatches 'cgroup 1048577-1048579'
...

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/ct.t         |   26 +++++++++++-----------
 tests/regression/any/frag.t       |   10 ++++-----
 tests/regression/any/meta.t       |   43 ++++++++++++++++++-------------------
 tests/regression/arp/arp.t        |   14 ++++++------
 tests/regression/inet/ah.t        |   16 +++++++-------
 tests/regression/inet/comp.t      |    8 +++----
 tests/regression/inet/dccp.t      |   11 +++++-----
 tests/regression/inet/esp.t       |    8 +++----
 tests/regression/inet/sctp.t      |   16 +++++++-------
 tests/regression/inet/tcp.t       |   30 +++++++++++++-------------
 tests/regression/inet/udp.t       |   20 ++++++++---------
 tests/regression/inet/udplite.t   |   18 ++++++++--------
 tests/regression/ip/icmp.t        |   20 ++++++++---------
 tests/regression/ip/ip.t          |   38 ++++++++++++++++----------------
 tests/regression/ip/masquerade.t  |    2 +-
 tests/regression/ip/nat.t         |   14 ++++++------
 tests/regression/ip/redirect.t    |    2 +-
 tests/regression/ip6/dst.t        |    8 +++----
 tests/regression/ip6/hbh.t        |    8 +++----
 tests/regression/ip6/ip6.t        |   12 +++++------
 tests/regression/ip6/masquerade.t |    2 +-
 tests/regression/ip6/mh.t         |   18 ++++++++--------
 tests/regression/ip6/redirect.t   |    2 +-
 tests/regression/ip6/rt.t         |   16 +++++++-------
 24 files changed, 180 insertions(+), 182 deletions(-)

diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index bb26cb8..6ec0526 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -44,10 +44,10 @@ ct mark and 0x3 != 0x1;ok;ct mark & 0x00000003 != 0x00000001
 ct mark xor 0x23 == 0x11;ok;ct mark 0x00000032
 ct mark xor 0x3 != 0x1;ok;ct mark != 0x00000002
 
-ct mark 0x32;ok;ct mark 0x00000032
-ct mark != 0x32;ok;ct mark != 0x00000032
-ct mark 0x32-0x45;ok
-ct mark != 0x32-0x43;ok
+ct mark 0x00000032;ok
+ct mark != 0x00000032;ok
+ct mark 0x00000032-0x00000045;ok
+ct mark != 0x00000032-0x00000045;ok
 ct mark {0x32, 0x2222, 0x42de3};ok;ct mark { 0x00042de3, 0x00002222, 0x00000032}
 - ct mark != {0x32, 0x2222, 0x42de3};ok
 
@@ -60,16 +60,14 @@ ct mark set 0x11333 and 0x11;ok;ct mark set 0x00000011
 ct mark set 0x12 or 0x11;ok;ct mark set 0x00000013
 ct mark set 0x11;ok;ct mark set 0x00000011
 
-ct expiration 30;ok
-ct expiration 22;ok
-ct expiration != 233;ok
-ct expiration 33-45;ok
-# BUG: ct expiration 33-45 and  ct expiration != 33-45
-# Broken output: ct expiration >= "33s" ct expiration <= "9709d53m20s"
-ct expiration != 33-45;ok
-ct expiration {33, 55, 67, 88};ok
-- ct expiration != {33, 55, 67, 88};ok
-ct expiration {33-55};ok
+ct expiration 30;ok;ct expiration 30s
+ct expiration 22;ok;ct expiration 22s
+ct expiration != 233;ok;ct expiration != 3m53s
+ct expiration 33-45;ok;ct expiration 33s-45s
+ct expiration != 33-45;ok;ct expiration != 33s-45s
+ct expiration {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
+- ct expiration != {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
+ct expiration {33-55};ok;ct expiration { 33s-55s}
 # BUG: ct expiration {33-55}
 # Broken output: ct expiration { "4271d23h25m52s"-"8738d3h11m59s" }
 - ct expiration != {33-55};ok
diff --git a/tests/regression/any/frag.t b/tests/regression/any/frag.t
index 92caf1e..d61a3d4 100644
--- a/tests/regression/any/frag.t
+++ b/tests/regression/any/frag.t
@@ -14,9 +14,9 @@ frag nexthdr ah;ok;frag nexthdr 51
 
 frag reserved 22;ok
 frag reserved != 233;ok
-frag reserved 33-45;ok;frag reserved >= 33 frag reserved <= 45
-frag reserved != 33-45;ok;frag reserved < 33 frag reserved > 45
-frag reserved { 33, 55, 67, 88};ok;frag reserved { 88, 33, 67, 55}
+frag reserved 33-45;ok
+frag reserved != 33-45;ok
+frag reserved { 33, 55, 67, 88};ok
 - frag reserved != { 33, 55, 67, 88};ok
 frag reserved { 33-55};ok
 - frag reserved != { 33-55};ok
@@ -56,8 +56,8 @@ frag reserved { 33-55};ok
 frag id 1;ok
 frag id 22;ok
 frag id != 33;ok
-frag id 33-45;ok;frag id >= 33 frag id <= 45
-frag id != 33-45;ok;frag id < 33 frag id > 45
+frag id 33-45;ok
+frag id != 33-45;ok
 frag id { 33, 55, 67, 88};ok
 - frag id != { 33, 55, 67, 88};ok
 frag id { 33-55};ok
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index 7108d17..ca0b4d4 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -27,8 +27,8 @@ meta nfproto {ipv4, ipv6};ok
 
 meta l4proto 22;ok
 meta l4proto != 233;ok
-meta l4proto 33-45;ok;meta l4proto >= 33 meta l4proto <= 45
-meta l4proto != 33-45;ok;meta l4proto < 33 meta l4proto > 45
+meta l4proto 33-45;ok
+meta l4proto != 33-45;ok
 meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 - meta l4proto != { 33, 55, 67, 88};ok
 meta l4proto { 33-55};ok
@@ -96,9 +96,9 @@ meta skuid != man;ok;skuid != 6
 meta skuid lt 3000 accept;ok;skuid < 3000 accept
 meta skuid gt 3000 accept;ok;skuid > 3000 accept
 meta skuid eq 3000 accept;ok;skuid 3000 accept
-meta skuid 3001-3005 accept;ok
-meta skuid != 2001-2005 accept;ok
-meta skuid { 2001-2005} accept;ok
+meta skuid 3001-3005 accept;ok;skuid 3001-3005 accept
+meta skuid != 2001-2005 accept;ok;skuid != 2001-2005 accept
+meta skuid { 2001-2005} accept;ok;skuid { 2001-2005} accept
 - meta skuid != { 2001-2005} accept;ok
 
 meta skgid {man, root, backup} accept;ok;skgid { 34, 12, 0} accept
@@ -108,10 +108,10 @@ meta skgid != man;ok;skgid != 12
 meta skgid lt 3000 accept;ok;skgid < 3000 accept
 meta skgid gt 3000 accept;ok;skgid > 3000 accept
 meta skgid eq 3000 accept;ok;skgid 3000 accept
-meta skgid 2001-2005 accept;ok
-meta skgid != 2001-2005 accept;ok
-meta skgid { 2001-2005} accept;ok
-- meta skgid != { 2001-2005} accept;ok
+meta skgid 2001-2005 accept;ok;skgid 2001-2005 accept
+meta skgid != 2001-2005 accept;ok;skgid != 2001-2005 accept
+meta skgid { 2001-2005} accept;ok;skgid { 2001-2005} accept
+- meta skgid != { 2001-2005} accept;ok;skgid != { 2001-2005} accept
 
 # BUG: meta nftrace 2 and meta nftrace 1
 # $ sudo nft add rule ip test input meta nftrace 2
@@ -153,11 +153,10 @@ meta pkttype { broadcast, multicast} accept;ok
 
 meta cpu 1;ok;cpu 1
 meta cpu != 1;ok;cpu != 1
-meta cpu 1-3;ok;cpu >= 1 cpu <= 3
-# BUG: there is not matching of packets with this rule.
-meta cpu != 1-2;ok;cpu < 1 cpu > 2
-meta cpu { 2,3};ok;cpu { 2, 3}
--meta cpu != { 2,3};ok
+meta cpu 1-3;ok;cpu 1-3
+meta cpu != 1-2;ok;cpu != 1-2
+meta cpu { 2,3};ok;cpu { 2,3}
+-meta cpu != { 2,3};ok; cpu != { 2,3}
 
 meta iifgroup 0;ok;iifgroup default
 meta iifgroup != 0;ok;iifgroup != default
@@ -180,11 +179,11 @@ meta oifgroup {11-33};ok
 - meta oifgroup != {11,33};ok
 - meta oifgroup != {11-33};ok
 
-meta cgroup 0x100001;ok;cgroup 1048577
-meta cgroup != 0x100001;ok;cgroup != 1048577
-meta cgroup { 0x100001, 0x100002};ok
-# meta cgroup != { 0x100001, 0x100002};ok
-meta cgroup 0x100001 - 0x100003;ok
-# meta cgroup != 0x100001 - 0x100003;ok
-meta cgroup {0x100001 - 0x100003};ok
-# meta cgroup != { 0x100001 - 0x100003};ok
+meta cgroup 1048577;ok;cgroup 1048577
+meta cgroup != 1048577;ok;cgroup != 1048577
+meta cgroup { 1048577, 1048578 };ok;cgroup { 1048577, 1048578}
+# meta cgroup != { 1048577, 1048578};ok;cgroup != { 1048577, 1048578}
+meta cgroup 1048577-1048578;ok;cgroup 1048577-1048578
+meta cgroup != 1048577-1048578;ok;cgroup != 1048577-1048578
+meta cgroup {1048577-1048578};ok;cgroup { 1048577-1048578}
+# meta cgroup != { 1048577-1048578};ok;cgroup != { 1048577-1048578}
diff --git a/tests/regression/arp/arp.t b/tests/regression/arp/arp.t
index 797e394..c4e07d5 100644
--- a/tests/regression/arp/arp.t
+++ b/tests/regression/arp/arp.t
@@ -6,19 +6,19 @@ arp htype 1;ok
 arp htype != 1;ok
 arp htype 22;ok
 arp htype != 233;ok
-arp htype 33-45;ok;arp htype >= 33 arp htype <= 45
-arp htype != 33-45;ok;arp htype < 33 arp htype > 45
+arp htype 33-45;ok
+arp htype != 33-45;ok
 arp htype { 33, 55, 67, 88};ok
 - arp htype != { 33, 55, 67, 88};ok
 arp htype { 33-55};ok
 - arp htype != { 33-55};ok
 
-arp ptype 0x0800;ok
+arp ptype 0x0800;ok;arp ptype ip
 
 arp hlen 22;ok
 arp hlen != 233;ok
-arp hlen 33-45;ok;arp hlen >= 33 arp hlen <= 45
-arp hlen != 33-45;ok;arp hlen < 33 arp hlen > 45
+arp hlen 33-45;ok
+arp hlen != 33-45;ok
 arp hlen { 33, 55, 67, 88};ok
 - arp hlen != { 33, 55, 67, 88};ok
 arp hlen { 33-55};ok
@@ -26,8 +26,8 @@ arp hlen { 33-55};ok
 
 arp plen 22;ok
 arp plen != 233;ok
-arp plen 33-45;ok;arp plen >= 33 arp plen <= 45
-arp plen != 33-45;ok;arp plen < 33 arp plen > 45
+arp plen 33-45;ok
+arp plen != 33-45;ok
 arp plen { 33, 55, 67, 88};ok
 - arp plen != { 33, 55, 67, 88};ok
 arp plen { 33-55};ok
diff --git a/tests/regression/inet/ah.t b/tests/regression/inet/ah.t
index 6defc35..666659d 100644
--- a/tests/regression/inet/ah.t
+++ b/tests/regression/inet/ah.t
@@ -17,8 +17,8 @@
 - ah nexthdr { esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;ah nexthdr { 6, 132, 50, 17, 136, 33, 51, 108}
 - ah nexthdr != { esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
 
-ah hdrlength 11-23;ok;ah hdrlength >= 11 ah hdrlength <= 23
-ah hdrlength != 11-23;ok;ah hdrlength < 11 ah hdrlength > 23
+ah hdrlength 11-23;ok
+ah hdrlength != 11-23;ok
 ah hdrlength { 11-23};ok
 - ah hdrlength != { 11-23};ok
 ah hdrlength {11, 23, 44 };ok
@@ -26,8 +26,8 @@ ah hdrlength {11, 23, 44 };ok
 
 ah reserved 22;ok
 ah reserved != 233;ok
-ah reserved 33-45;ok;ah reserved >= 33 ah reserved <= 45
-ah reserved != 33-45;ok;ah reserved < 33 ah reserved > 45
+ah reserved 33-45;ok
+ah reserved != 33-45;ok
 ah reserved {23, 100};ok
 - ah reserved != {33, 55, 67, 88};ok
 ah reserved { 33-55};ok
@@ -35,8 +35,8 @@ ah reserved { 33-55};ok
 
 ah spi 111;ok
 ah spi != 111;ok
-ah spi 111-222;ok;ah spi >= 111 ah spi <= 222
-ah spi != 111-222;ok;ah spi < 111 ah spi > 222
+ah spi 111-222;ok
+ah spi != 111-222;ok
 ah spi {111, 122};ok
 - ah spi != {111, 122};ok
 # BUG: invalid expression type set
@@ -54,5 +54,5 @@ ah sequence {23, 25, 33};ok
 - ah sequence != {23, 25, 33};ok
 ah sequence { 23-33};ok
 - ah sequence != { 33-44};ok
-ah sequence 23-33;ok;ah sequence >= 23 ah sequence <= 33
-ah sequence != 23-33;ok;ah sequence < 23 ah sequence > 33
+ah sequence 23-33;ok
+ah sequence != 23-33;ok
diff --git a/tests/regression/inet/comp.t b/tests/regression/inet/comp.t
index 32db32b..afdc63f 100644
--- a/tests/regression/inet/comp.t
+++ b/tests/regression/inet/comp.t
@@ -4,9 +4,9 @@
 
 :input;type filter hook input priority 0
 
-# BUG: Do no list table.
+# BUG: nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.
 - comp nexthdr esp;ok;comp nexthdr 50
-comp nexthdr != esp;ok
+comp nexthdr != esp;ok;comp nexthdr != 50
 
 - comp nexthdr {esp, ah, comp, udp, udplite, tcp, tcp, dccp, sctp};ok
 # comp flags ## 8-bit field.  Reserved for future use.  MUST be set to zero.
@@ -23,8 +23,8 @@ comp flags { 0x33-0x55};ok
 
 comp cpi 22;ok
 comp cpi != 233;ok
-comp cpi 33-45;ok;comp cpi >= 33 comp cpi <= 45
-comp cpi != 33-45;ok;comp cpi < 33 comp cpi > 45
+comp cpi 33-45;ok
+comp cpi != 33-45;ok
 comp cpi {33, 55, 67, 88};ok
 - comp cpi != {33, 55, 67, 88};ok
 comp cpi { 33-55};ok
diff --git a/tests/regression/inet/dccp.t b/tests/regression/inet/dccp.t
index 272c0e2..e323992 100644
--- a/tests/regression/inet/dccp.t
+++ b/tests/regression/inet/dccp.t
@@ -3,15 +3,16 @@
 *inet;test-inet
 :input;type filter hook input priority 0
 
-dccp sport 21-35;ok;dccp sport >= 21 dccp sport <= 35
-dccp sport != 21-35;ok;dccp sport < 21 dccp sport > 35
-dccp sport {23, 24, 25};ok;dccp sport { 23, 24, 25}
+dccp sport 21-35;ok
+dccp sport != 21-35;ok
+dccp sport {23, 24, 25};ok
 - dccp sport != { 27, 34};ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-dccp sport { ftp-data - re-mail-ck};ok;dccp sport { 20-50}
-dccp sport ftp-data - re-mail-ck;ok;dccp sport >= 20 dccp sport <= 50
+dccp sport { 20-50 };ok
+dccp sport ftp-data - re-mail-ck;ok;dccp sport 20-50
+dccp sport 20-50;ok
 dccp sport { 20-50};ok
 - dccp sport != {27-34};ok
 # dccp sport != {27-34};ok
diff --git a/tests/regression/inet/esp.t b/tests/regression/inet/esp.t
index 1f23aa4..3a8502d 100644
--- a/tests/regression/inet/esp.t
+++ b/tests/regression/inet/esp.t
@@ -5,16 +5,16 @@
 
 esp spi 100;ok
 esp spi != 100;ok
-esp spi 111-222;ok;esp spi >= 111 esp spi <= 222
-esp spi != 111-222;ok;esp spi < 111 esp spi > 222
+esp spi 111-222;ok
+esp spi != 111-222;ok
 esp spi { 100, 102};ok
 - esp spi != { 100, 102};ok
 esp spi { 100-102};ok
 - esp spi {100-102};ok
 
 esp sequence 22;ok
-esp sequence 22-24;ok;esp sequence >= 22 esp sequence <= 24
-esp sequence != 22-24;ok;esp sequence < 22 esp sequence > 24
+esp sequence 22-24;ok
+esp sequence != 22-24;ok
 esp sequence { 22, 24};ok
 - esp sequence != { 22, 24};ok
 # BUG: invalid expression type set
diff --git a/tests/regression/inet/sctp.t b/tests/regression/inet/sctp.t
index b98b0af..537a9b1 100644
--- a/tests/regression/inet/sctp.t
+++ b/tests/regression/inet/sctp.t
@@ -5,8 +5,8 @@
 
 sctp sport 23;ok
 sctp sport != 23;ok
-sctp sport 23-44;ok;sctp sport >= 23 sctp sport <= 44
-sctp sport != 23-44;ok;sctp sport < 23 sctp sport > 44
+sctp sport 23-44;ok
+sctp sport != 23-44;ok
 sctp sport { 23, 24, 25};ok
 - sctp sport != { 23, 24, 25};ok
 sctp sport { 23-44};ok
@@ -16,8 +16,8 @@ sctp sport { 23-44};ok
 
 sctp dport 23;ok
 sctp dport != 23;ok
-sctp dport 23-44;ok;sctp dport >= 23 sctp dport <= 44
-sctp dport != 23-44;ok;sctp dport < 23 sctp dport > 44
+sctp dport 23-44;ok
+sctp dport != 23-44;ok
 sctp dport { 23, 24, 25};ok
 - sctp dport != { 23, 24, 25};ok
 sctp dport { 23-44};ok
@@ -25,8 +25,8 @@ sctp dport { 23-44};ok
 
 sctp checksum 1111;ok
 sctp checksum != 11;ok
-sctp checksum 21-333;ok;sctp checksum >= 21 sctp checksum <= 333
-sctp checksum != 32-111;ok;sctp checksum < 32 sctp checksum > 111
+sctp checksum 21-333;ok
+sctp checksum != 32-111;ok
 sctp checksum { 22, 33, 44};ok
 - sctp checksum != { 22, 33, 44};ok
 sctp checksum { 22-44};ok
@@ -34,8 +34,8 @@ sctp checksum { 22-44};ok
 
 sctp vtag 22;ok
 sctp vtag != 233;ok
-sctp vtag 33-45;ok;sctp vtag >= 33 sctp vtag <= 45
-sctp vtag != 33-45;ok;sctp vtag < 33 sctp vtag > 45
+sctp vtag 33-45;ok
+sctp vtag != 33-45;ok
 sctp vtag {33, 55, 67, 88};ok
 - sctp vtag != {33, 55, 67, 88};ok
 sctp vtag { 33-55};ok
diff --git a/tests/regression/inet/tcp.t b/tests/regression/inet/tcp.t
index f72ec52..5eb3882 100644
--- a/tests/regression/inet/tcp.t
+++ b/tests/regression/inet/tcp.t
@@ -5,8 +5,8 @@
 
 tcp dport 22;ok
 tcp dport != 233;ok
-tcp dport 33-45;ok;tcp dport >= 33 tcp dport <= 45
-tcp dport != 33-45;ok;tcp dport < 33 tcp dport > 45
+tcp dport 33-45;ok
+tcp dport != 33-45;ok
 tcp dport { 33, 55, 67, 88};ok
 - tcp dport != { 33, 55, 67, 88};ok
 tcp dport { 33-55};ok
@@ -21,8 +21,8 @@ tcp dport { 22, 53, 80, 110 };ok
 
 tcp sport 22;ok
 tcp sport != 233;ok
-tcp sport 33-45;ok;tcp sport >= 33 tcp sport <= 45
-tcp sport != 33-45;ok;tcp sport < 33 tcp sport > 45
+tcp sport 33-45;ok
+tcp sport != 33-45;ok
 tcp sport { 33, 55, 67, 88};ok
 - tcp sport != { 33, 55, 67, 88};ok
 tcp sport { 33-55};ok
@@ -33,13 +33,13 @@ tcp sport 8080 drop;ok
 tcp sport 1024 tcp dport 22;ok
 tcp sport 1024 tcp dport 22 tcp sequence 0;ok
 
-tcp sequence 0 tcp sport 1024 tcp dport 22;ok;tcp sport 1024 tcp dport 22 tcp sequence 0
+tcp sequence 0 tcp sport 1024 tcp dport 22;ok
 tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22;ok
 
 tcp sequence 22;ok
 tcp sequence != 233;ok
-tcp sequence 33-45;ok;tcp sequence >= 33 tcp sequence <= 45
-tcp sequence != 33-45;ok;tcp sequence < 33 tcp sequence > 45
+tcp sequence 33-45;ok
+tcp sequence != 33-45;ok
 tcp sequence { 33, 55, 67, 88};ok
 - tcp sequence != { 33, 55, 67, 88};ok
 tcp sequence { 33-55};ok
@@ -48,8 +48,8 @@ tcp sequence { 33-55};ok
 tcp ackseq 42949672 drop;ok
 tcp ackseq 22;ok
 tcp ackseq != 233;ok
-tcp ackseq 33-45;ok;tcp ackseq >= 33 tcp ackseq <= 45
-tcp ackseq != 33-45;ok;tcp ackseq < 33 tcp ackseq > 45
+tcp ackseq 33-45;ok
+tcp ackseq != 33-45;ok
 tcp ackseq { 33, 55, 67, 88};ok
 - tcp ackseq != { 33, 55, 67, 88};ok
 tcp ackseq { 33-55};ok
@@ -75,8 +75,8 @@ tcp flags != cwr;ok
 tcp window 22222;ok
 tcp window 22;ok
 tcp window != 233;ok
-tcp window 33-45;ok;tcp window >= 33 tcp window <= 45
-tcp window != 33-45;ok;tcp window < 33 tcp window > 45
+tcp window 33-45;ok
+tcp window != 33-45;ok
 tcp window { 33, 55, 67, 88};ok
 - tcp window != { 33, 55, 67, 88};ok
 tcp window { 33-55};ok
@@ -85,8 +85,8 @@ tcp window { 33-55};ok
 tcp checksum 23456 log drop;ok
 tcp checksum 22;ok
 tcp checksum != 233;ok
-tcp checksum 33-45;ok;tcp checksum >= 33 tcp checksum <= 45
-tcp checksum != 33-45;ok;tcp checksum < 33 tcp checksum > 45
+tcp checksum 33-45;ok
+tcp checksum != 33-45;ok
 tcp checksum { 33, 55, 67, 88};ok
 - tcp checksum != { 33, 55, 67, 88};ok
 tcp checksum { 33-55};ok
@@ -95,8 +95,8 @@ tcp checksum { 33-55};ok
 tcp urgptr 1234 accept;ok
 tcp urgptr 22;ok
 tcp urgptr != 233;ok
-tcp urgptr 33-45;ok;tcp urgptr >= 33 tcp urgptr <= 45
-tcp urgptr != 33-45;ok;tcp urgptr < 33 tcp urgptr > 45
+tcp urgptr 33-45;ok
+tcp urgptr != 33-45;ok
 tcp urgptr { 33, 55, 67, 88};ok
 - tcp urgptr != { 33, 55, 67, 88};ok
 tcp urgptr { 33-55};ok
diff --git a/tests/regression/inet/udp.t b/tests/regression/inet/udp.t
index 0e8a01f..58f4002 100644
--- a/tests/regression/inet/udp.t
+++ b/tests/regression/inet/udp.t
@@ -5,9 +5,9 @@
 
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
-udp sport 50-70 accept;ok;udp sport >= 50 udp sport <= 70 accept
-udp sport != 50-60 accept;ok;udp sport < 50 udp sport > 60 accept
-udp sport { 49, 50} drop;ok;udp sport { 49, 50} drop
+udp sport 50-70 accept;ok
+udp sport != 50-60 accept;ok
+udp sport { 49, 50} drop;ok
 - udp sport != { 50, 60} accept;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
@@ -16,19 +16,19 @@ udp sport { 12-40};ok
 
 udp dport 80 accept;ok
 udp dport != 60 accept;ok
-udp dport 70-75 accept;ok;udp dport >= 70 udp dport <= 75 accept
-udp dport != 50-60 accept;ok;udp dport < 50 udp dport > 60 accept
+udp dport 70-75 accept;ok
+udp dport != 50-60 accept;ok
 udp dport { 49, 50} drop;ok
 - udp dport != { 50, 60} accept;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
-udp dport { 70-75} accept;ok;udp dport { 70-75} accept
+udp dport { 70-75} accept;ok
 - udp dport != { 50-60} accept;ok
 
 udp length 6666;ok
 udp length != 6666;ok
-udp length 50-65 accept;ok;udp length >= 50 udp length <= 65 accept
-udp length != 50-65 accept;ok;udp length < 50 udp length > 65 accept
+udp length 50-65 accept;ok
+udp length != 50-65 accept;ok
 udp length { 50, 65} accept;ok
 - udp length != { 50, 65} accept;ok
 udp length { 35-50};ok
@@ -41,8 +41,8 @@ udp checksum 6666 drop;ok
 
 udp checksum 22;ok
 udp checksum != 233;ok
-udp checksum 33-45;ok;udp checksum >= 33 udp checksum <= 45
-udp checksum != 33-45;ok;udp checksum < 33 udp checksum > 45
+udp checksum 33-45;ok
+udp checksum != 33-45;ok
 udp checksum { 33, 55, 67, 88};ok
 - udp checksum != { 33, 55, 67, 88};ok
 udp checksum { 33-55};ok
diff --git a/tests/regression/inet/udplite.t b/tests/regression/inet/udplite.t
index 1d5fbb3..9420ab4 100644
--- a/tests/regression/inet/udplite.t
+++ b/tests/regression/inet/udplite.t
@@ -5,20 +5,20 @@
 
 udplite sport 80 accept;ok
 udplite sport != 60 accept;ok
-udplite sport 50-70 accept;ok;udplite sport >= 50 udplite sport <= 70 accept
-udplite sport != 50-60 accept;ok;udplite sport < 50 udplite sport > 60 accept
-udplite sport { 49, 50} drop;ok;udplite sport { 49, 50} drop
+udplite sport 50-70 accept;ok
+udplite sport != 50-60 accept;ok
+udplite sport { 49, 50} drop;ok
 - udplite sport != { 50, 60} accept;ok
 udplite sport { 12-40};ok
 - udplite sport != { 13-24};ok
 
 udplite dport 80 accept;ok
 udplite dport != 60 accept;ok
-udplite dport 70-75 accept;ok;udplite dport >= 70 udplite dport <= 75 accept
-udplite dport != 50-60 accept;ok;udplite dport < 50 udplite dport > 60 accept
-udplite dport { 49, 50} drop;ok;udplite dport { 49, 50} drop
+udplite dport 70-75 accept;ok
+udplite dport != 50-60 accept;ok
+udplite dport { 49, 50} drop;ok
 - udplite dport != { 50, 60} accept;ok
-udplite dport { 70-75} accept;ok;udplite dport { 70-75} accept
+udplite dport { 70-75} accept;ok
 - udplite dport != { 50-60} accept;ok
 
 - udplite csumcov 6666;ok
@@ -34,8 +34,8 @@ udplite checksum 6666 drop;ok
 - udplite checksum != { 444, 555} accept;ok
 udplite checksum 22;ok
 udplite checksum != 233;ok
-udplite checksum 33-45;ok;udplite checksum >= 33 udplite checksum <= 45
-udplite checksum != 33-45;ok;udplite checksum < 33 udplite checksum > 45
+udplite checksum 33-45;ok
+udplite checksum != 33-45;ok
 udplite checksum { 33, 55, 67, 88};ok
 - udplite checksum != { 33, 55, 67, 88};ok
 udplite checksum { 33-55};ok
diff --git a/tests/regression/ip/icmp.t b/tests/regression/ip/icmp.t
index cd43a66..9c2aba7 100644
--- a/tests/regression/ip/icmp.t
+++ b/tests/regression/ip/icmp.t
@@ -24,8 +24,8 @@ icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-re
 
 icmp code 111 accept;ok
 icmp code != 111 accept;ok
-icmp code 33-55;ok;icmp code >= 33 icmp code <= 55
-icmp code != 33-55;ok;icmp code < 33 icmp code > 55
+icmp code 33-55;ok
+icmp code != 33-55;ok
 icmp code { 33-55};ok
 - icmp code != { 33-55};ok
 icmp code { 2, 4, 54, 33, 56};ok
@@ -36,8 +36,8 @@ icmp code { 2, 4, 54, 33, 56};ok
 
 icmp checksum 12343 accept;ok
 icmp checksum != 12343 accept;ok
-icmp checksum 11-343 accept;ok;icmp checksum >= 11 icmp checksum <= 343 accept
-icmp checksum != 11-343 accept;ok;icmp checksum < 11 icmp checksum > 343 accept
+icmp checksum 11-343 accept;ok
+icmp checksum != 11-343 accept;ok
 icmp checksum { 11-343} accept;ok
 - icmp checksum != { 11-343} accept;ok
 icmp checksum { 1111, 222, 343} accept;ok
@@ -49,8 +49,8 @@ icmp checksum { 1111, 222, 343} accept;ok
 icmp id 1245 log;ok
 icmp id 22;ok
 icmp id != 233;ok
-icmp id 33-45;ok;icmp id >= 33 icmp id <= 45
-icmp id != 33-45;ok;icmp id < 33 icmp id > 45
+icmp id 33-45;ok
+icmp id != 33-45;ok
 icmp id { 33-55};ok
 - icmp id != { 33-55};ok
 icmp id { 22, 34, 333};ok
@@ -61,8 +61,8 @@ icmp id { 22, 34, 333};ok
 
 icmp sequence 22;ok
 icmp sequence != 233;ok
-icmp sequence 33-45;ok;icmp sequence >= 33 icmp sequence <= 45
-icmp sequence != 33-45;ok;icmp sequence < 33 icmp sequence > 45
+icmp sequence 33-45;ok
+icmp sequence != 33-45;ok
 icmp sequence { 33, 55, 67, 88};ok
 - icmp sequence != { 33, 55, 67, 88};ok
 icmp sequence { 33-55};ok
@@ -83,8 +83,8 @@ icmp mtu { 33-55};ok
 
 icmp gateway 22;ok
 icmp gateway != 233;ok
-icmp gateway 33-45;ok;icmp gateway >= 33 icmp gateway <= 45
-icmp gateway != 33-45;ok;icmp gateway < 33 icmp gateway > 45
+icmp gateway 33-45;ok
+icmp gateway != 33-45;ok
 icmp gateway { 33, 55, 67, 88};ok
 - icmp gateway != { 33, 55, 67, 88};ok
 icmp gateway { 33-55};ok
diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
index a781de5..fa864df 100644
--- a/tests/regression/ip/ip.t
+++ b/tests/regression/ip/ip.t
@@ -30,8 +30,8 @@
 
 ip length 232;ok
 ip length != 233;ok
-ip length 333-435;ok;ip length >= 333 ip length <= 435
-ip length != 333-453;ok;ip length < 333 ip length > 453
+ip length 333-435;ok
+ip length != 333-453;ok
 ip length { 333, 553, 673, 838};ok
 - ip length != { 333, 535, 637, 883};ok
 ip length { 333-535};ok
@@ -39,8 +39,8 @@ ip length { 333-535};ok
 
 ip id 22;ok
 ip id != 233;ok
-ip id 33-45;ok;ip id >= 33 ip id <= 45
-ip id != 33-45;ok;ip id < 33 ip id > 45
+ip id 33-45;ok
+ip id != 33-45;ok
 ip id { 33, 55, 67, 88};ok
 - ip id != { 33, 55, 67, 88};ok
 ip id { 33-55};ok
@@ -48,8 +48,8 @@ ip id { 33-55};ok
 
 ip frag-off 222 accept;ok
 ip frag-off != 233;ok
-ip frag-off 33-45;ok;ip frag-off >= 33 ip frag-off <= 45
-ip frag-off != 33-45;ok;ip frag-off < 33 ip frag-off > 45
+ip frag-off 33-45;ok
+ip frag-off != 33-45;ok
 ip frag-off { 33, 55, 67, 88};ok
 - ip frag-off != { 33, 55, 67, 88};ok
 ip frag-off { 33-55};ok
@@ -57,8 +57,8 @@ ip frag-off { 33-55};ok
 
 ip ttl 0 drop;ok
 ip ttl 233 log;ok
-ip ttl 33-55;ok;ip ttl >= 33 ip ttl <= 55
-ip ttl != 45-50;ok;ip ttl < 45 ip ttl > 50
+ip ttl 33-55;ok
+ip ttl != 45-50;ok
 ip ttl {43, 53, 45 };ok
 - ip ttl != {46, 56, 93 };ok
 # BUG: ip ttl != {46, 56, 93 };ok
@@ -75,8 +75,8 @@ ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip p
 ip checksum 13172 drop;ok
 ip checksum 22;ok
 ip checksum != 233;ok
-ip checksum 33-45;ok;ip checksum >= 33 ip checksum <= 45
-ip checksum != 33-45;ok;ip checksum < 33 ip checksum > 45
+ip checksum 33-45;ok
+ip checksum != 33-45;ok
 ip checksum { 33, 55, 67, 88};ok
 - ip checksum != { 33, 55, 67, 88};ok
 ip checksum { 33-55};ok
@@ -87,20 +87,20 @@ ip saddr != 192.168.2.0/24;ok
 ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
 ip saddr != 1.1.1.1 log prefix giuseppe;ok;ip saddr != 1.1.1.1 log prefix "giuseppe"
 ip saddr 1.1.1.1 log prefix example group 1;ok;ip saddr 1.1.1.1 log prefix "example" group 1
-ip daddr 192.168.0.1-192.168.0.250;ok;ip daddr >= 192.168.0.1 ip daddr <= 192.168.0.250
-ip daddr 10.0.0.0-10.255.255.255;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.255.255.255
-ip daddr 172.16.0.0-172.31.255.255;ok;ip daddr >= 172.16.0.0 ip daddr <= 172.31.255.255
-ip daddr 192.168.3.1-192.168.4.250;ok;ip daddr >= 192.168.3.1 ip daddr <= 192.168.4.250
-ip daddr != 192.168.0.1-192.168.0.250;ok;ip daddr < 192.168.0.1 ip daddr > 192.168.0.250
+ip daddr 192.168.0.1-192.168.0.250;ok
+ip daddr 10.0.0.0-10.255.255.255;ok
+ip daddr 172.16.0.0-172.31.255.255;ok
+ip daddr 192.168.3.1-192.168.4.250;ok
+ip daddr != 192.168.0.1-192.168.0.250;ok
 ip daddr { 192.168.0.1-192.168.0.250};ok
 - ip daddr != { 192.168.0.1-192.168.0.250};ok
 ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
 - ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
 
-ip daddr 192.168.1.2-192.168.1.55;ok;ip daddr >= 192.168.1.2 ip daddr <= 192.168.1.55
-ip daddr != 192.168.1.2-192.168.1.55;ok;ip daddr < 192.168.1.2 ip daddr > 192.168.1.55
-ip saddr 192.168.1.3-192.168.33.55;ok;ip saddr >= 192.168.1.3 ip saddr <= 192.168.33.55
-ip saddr != 192.168.1.3-192.168.33.55;ok;ip saddr < 192.168.1.3 ip saddr > 192.168.33.55
+ip daddr 192.168.1.2-192.168.1.55;ok
+ip daddr != 192.168.1.2-192.168.1.55;ok
+ip saddr 192.168.1.3-192.168.33.55;ok
+ip saddr != 192.168.1.3-192.168.33.55;ok
 
 ip daddr 192.168.0.1;ok
 ip daddr 192.168.0.1 drop;ok
diff --git a/tests/regression/ip/masquerade.t b/tests/regression/ip/masquerade.t
index d0fe02d..35001f3 100644
--- a/tests/regression/ip/masquerade.t
+++ b/tests/regression/ip/masquerade.t
@@ -21,5 +21,5 @@ ip saddr 10.1.1.1 masquerade drop;fail
 
 # masquerade with sets
 tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 masquerade;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok
diff --git a/tests/regression/ip/nat.t b/tests/regression/ip/nat.t
index 5afe823..26c8cbf 100644
--- a/tests/regression/ip/nat.t
+++ b/tests/regression/ip/nat.t
@@ -4,15 +4,15 @@
 
 :output;type nat hook output priority 0
 
-iifname eth0 tcp dport 80-90 dnat 192.168.3.2;ok;iifname "eth0" tcp dport >= 80 tcp dport <= 90 dnat 192.168.3.2
-iifname eth0 tcp dport != 80-90 dnat 192.168.3.2;ok;iifname "eth0" tcp dport < 80 tcp dport > 90 dnat 192.168.3.2
-iifname eth0 tcp dport {80, 90, 23} dnat 192.168.3.2;ok
-- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+iifname "eth0" tcp dport 80-90 dnat 192.168.3.2;ok
+iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2;ok
+iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
 
-iifname eth0 tcp sport 23-34 snat 192.168.3.2;ok;iifname "eth0" tcp sport >= 23 tcp sport <= 34 snat 192.168.3.2
+iifname eth0 tcp sport 23-34 snat 192.168.3.2;ok
 
-- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+- iifname "eth0" tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
 # BUG: invalid expression type set
 # nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
 
-iifname eth0 tcp dport != 23-34 dnat 192.168.3.2;ok;iifname "eth0" tcp dport < 23 tcp dport > 34 dnat 192.168.3.2
+iifname "eth0" tcp dport != 23-34 dnat 192.168.3.2;ok
diff --git a/tests/regression/ip/redirect.t b/tests/regression/ip/redirect.t
index bbf440d..b7eecb7 100644
--- a/tests/regression/ip/redirect.t
+++ b/tests/regression/ip/redirect.t
@@ -41,5 +41,5 @@ ip saddr 10.1.1.1 redirect drop;fail
 
 # redirect with sets
 tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect;ok
-ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect
+ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
diff --git a/tests/regression/ip6/dst.t b/tests/regression/ip6/dst.t
index 1b1bc52..3207af7 100644
--- a/tests/regression/ip6/dst.t
+++ b/tests/regression/ip6/dst.t
@@ -4,8 +4,8 @@
 
 dst nexthdr 22;ok
 dst nexthdr != 233;ok
-dst nexthdr 33-45;ok;dst nexthdr >= 33 dst nexthdr <= 45
-dst nexthdr != 33-45;ok;dst nexthdr < 33 dst nexthdr > 45
+dst nexthdr 33-45;ok
+dst nexthdr != 33-45;ok
 dst nexthdr { 33, 55, 67, 88};ok
 - dst nexthdr != { 33, 55, 67, 88};ok
 dst nexthdr { 33-55};ok
@@ -17,8 +17,8 @@ dst nexthdr != icmp;ok;dst nexthdr != 1
 
 dst hdrlength 22;ok
 dst hdrlength != 233;ok
-dst hdrlength 33-45;ok;dst hdrlength >= 33 dst hdrlength <= 45
-dst hdrlength != 33-45;ok;dst hdrlength < 33 dst hdrlength > 45
+dst hdrlength 33-45;ok
+dst hdrlength != 33-45;ok
 dst hdrlength { 33, 55, 67, 88};ok
 - dst hdrlength != { 33, 55, 67, 88};ok
 dst hdrlength { 33-55};ok
diff --git a/tests/regression/ip6/hbh.t b/tests/regression/ip6/hbh.t
index b274b8b..4e67c42 100644
--- a/tests/regression/ip6/hbh.t
+++ b/tests/regression/ip6/hbh.t
@@ -4,8 +4,8 @@
 
 hbh hdrlength 22;ok
 hbh hdrlength != 233;ok
-hbh hdrlength 33-45;ok;hbh hdrlength >= 33 hbh hdrlength <= 45
-hbh hdrlength != 33-45;ok;hbh hdrlength < 33 hbh hdrlength > 45
+hbh hdrlength 33-45;ok
+hbh hdrlength != 33-45;ok
 hbh hdrlength {33, 55, 67, 88};ok
 - hbh hdrlength != {33, 55, 67, 88};ok
 hbh hdrlength { 33-55};ok
@@ -15,8 +15,8 @@ hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;hbh nexthd
 - hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok
 hbh nexthdr 22;ok
 hbh nexthdr != 233;ok
-hbh nexthdr 33-45;ok;hbh nexthdr >= 33 hbh nexthdr <= 45
-hbh nexthdr != 33-45;ok;hbh nexthdr < 33 hbh nexthdr > 45
+hbh nexthdr 33-45;ok
+hbh nexthdr != 33-45;ok
 hbh nexthdr {33, 55, 67, 88};ok
 - hbh nexthdr != {33, 55, 67, 88};ok
 hbh nexthdr { 33-55};ok
diff --git a/tests/regression/ip6/ip6.t b/tests/regression/ip6/ip6.t
index 243c789..529a068 100644
--- a/tests/regression/ip6/ip6.t
+++ b/tests/regression/ip6/ip6.t
@@ -29,8 +29,8 @@ ip6 flowlabel { 33-55};ok
 
 ip6 length 22;ok
 ip6 length != 233;ok
-ip6 length 33-45;ok;ip6 length >= 33 ip6 length <= 45
-ip6 length != 33-45;ok;ip6 length < 33 ip6 length > 45
+ip6 length 33-45;ok
+ip6 length != 33-45;ok
 - ip6 length { 33, 55, 67, 88};ok
 - ip6 length != {33, 55, 67, 88};ok
 ip6 length { 33-55};ok
@@ -43,13 +43,13 @@ ip6 nexthdr esp;ok;ip6 nexthdr 50
 ip6 nexthdr != esp;ok;ip6 nexthdr != 50
 ip6 nexthdr { 33-44};ok
 - p6 nexthdr != { 33-44};ok
-ip6 nexthdr 33-44;ok;ip6 nexthdr >= 33 ip6 nexthdr <= 44
-ip6 nexthdr != 33-44;ok;ip6 nexthdr < 33 ip6 nexthdr > 44
+ip6 nexthdr 33-44;ok
+ip6 nexthdr != 33-44;ok
 
 ip6 hoplimit 1 log;ok
 ip6 hoplimit != 233;ok
-ip6 hoplimit 33-45;ok;ip6 hoplimit >= 33 ip6 hoplimit <= 45
-ip6 hoplimit != 33-45;ok;ip6 hoplimit < 33 ip6 hoplimit > 45
+ip6 hoplimit 33-45;ok
+ip6 hoplimit != 33-45;ok
 ip6 hoplimit {33, 55, 67, 88};ok
 - ip6 hoplimit != {33, 55, 67, 88};ok
 ip6 hoplimit {33-55};ok
diff --git a/tests/regression/ip6/masquerade.t b/tests/regression/ip6/masquerade.t
index 817acd4..4e6c086 100644
--- a/tests/regression/ip6/masquerade.t
+++ b/tests/regression/ip6/masquerade.t
@@ -21,5 +21,5 @@ ip6 saddr ::1 masquerade drop;fail
 
 # masquerade with sets
 tcp dport { 1,2,3,4,5,6,7,8,101,202,303,1001,2002,3003} masquerade;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade;ok;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 masquerade;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } masquerade;ok
diff --git a/tests/regression/ip6/mh.t b/tests/regression/ip6/mh.t
index 4ff58a1..cd652b3 100644
--- a/tests/regression/ip6/mh.t
+++ b/tests/regression/ip6/mh.t
@@ -10,8 +10,8 @@ mh nexthdr icmp;ok;mh nexthdr 1
 mh nexthdr != icmp;ok;mh nexthdr != 1
 mh nexthdr 22;ok
 mh nexthdr != 233;ok
-mh nexthdr 33-45;ok;mh nexthdr >= 33 mh nexthdr <= 45
-mh nexthdr != 33-45;ok;mh nexthdr < 33 mh nexthdr > 45
+mh nexthdr 33-45;ok
+mh nexthdr != 33-45;ok
 mh nexthdr { 33, 55, 67, 88 };ok
 - mh nexthdr != { 33, 55, 67, 88 };ok
 mh nexthdr { 33-55 };ok
@@ -19,9 +19,9 @@ mh nexthdr { 33-55 };ok
 
 mh hdrlength 22;ok
 mh hdrlength != 233;ok
-mh hdrlength 33-45;ok;mh hdrlength >= 33 mh hdrlength <= 45
-mh hdrlength != 33-45;ok;mh hdrlength < 33 mh hdrlength > 45
-mh hdrlength { 33, 55, 67, 88 };ok;mh hdrlength { 67, 33, 88, 55}
+mh hdrlength 33-45;ok
+mh hdrlength != 33-45;ok
+mh hdrlength { 33, 55, 67, 88 };ok
 - mh hdrlength != { 33, 55, 67, 88 };ok
 mh hdrlength { 33-55 };ok
 - mh hdrlength != { 33-55 };ok
@@ -32,8 +32,8 @@ mh type != home-agent-switch-message;ok
 
 mh reserved 22;ok
 mh reserved != 233;ok
-mh reserved 33-45;ok;mh reserved >= 33 mh reserved <= 45
-mh reserved != 33-45;ok;mh reserved < 33 mh reserved > 45
+mh reserved 33-45;ok
+mh reserved != 33-45;ok
 mh reserved { 33, 55, 67, 88};ok
 - mh reserved != {33, 55, 67, 88};ok
 mh reserved { 33-55};ok
@@ -41,8 +41,8 @@ mh reserved { 33-55};ok
 
 mh checksum 22;ok
 mh checksum != 233;ok
-mh checksum 33-45;ok;mh checksum >= 33 mh checksum <= 45
-mh checksum != 33-45;ok;mh checksum < 33 mh checksum > 45
+mh checksum 33-45;ok
+mh checksum != 33-45;ok
 mh checksum { 33, 55, 67, 88};ok
 - mh checksum != { 33, 55, 67, 88};ok
 mh checksum { 33-55};ok
diff --git a/tests/regression/ip6/redirect.t b/tests/regression/ip6/redirect.t
index 730d733..31ffe8c 100644
--- a/tests/regression/ip6/redirect.t
+++ b/tests/regression/ip6/redirect.t
@@ -40,5 +40,5 @@ ip6 saddr ::1 redirect drop;fail
 
 # redirect with sets
 tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect;ok
-ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect;ok;ip6 daddr >= fe00::1 ip6 daddr <= fe00::200 udp dport 53 counter packets 0 bytes 0 redirect
+ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
diff --git a/tests/regression/ip6/rt.t b/tests/regression/ip6/rt.t
index 76579ba..eca47ca 100644
--- a/tests/regression/ip6/rt.t
+++ b/tests/regression/ip6/rt.t
@@ -10,8 +10,8 @@ rt nexthdr icmp;ok;rt nexthdr 1
 rt nexthdr != icmp;ok;rt nexthdr != 1
 rt nexthdr 22;ok
 rt nexthdr != 233;ok
-rt nexthdr 33-45;ok;rt nexthdr >= 33 rt nexthdr <= 45
-rt nexthdr != 33-45;ok;rt nexthdr < 33 rt nexthdr > 45
+rt nexthdr 33-45;ok
+rt nexthdr != 33-45;ok
 rt nexthdr { 33, 55, 67, 88};ok
 - rt nexthdr != { 33, 55, 67, 88};ok
 rt nexthdr { 33-55};ok;rt nexthdr { 33-55}
@@ -19,8 +19,8 @@ rt nexthdr { 33-55};ok;rt nexthdr { 33-55}
 
 rt hdrlength 22;ok
 rt hdrlength != 233;ok
-rt hdrlength 33-45;ok;rt hdrlength >= 33 rt hdrlength <= 45
-rt hdrlength != 33-45;ok;rt hdrlength < 33 rt hdrlength > 45
+rt hdrlength 33-45;ok
+rt hdrlength != 33-45;ok
 rt hdrlength { 33, 55, 67, 88};ok
 - rt hdrlength != { 33, 55, 67, 88};ok
 rt hdrlength { 33-55};ok
@@ -28,8 +28,8 @@ rt hdrlength { 33-55};ok
 
 rt type 22;ok
 rt type != 233;ok
-rt type 33-45;ok;rt type >= 33 rt type <= 45
-rt type != 33-45;ok;rt type < 33 rt type > 45
+rt type 33-45;ok
+rt type != 33-45;ok
 rt type { 33, 55, 67, 88};ok
 - rt type != { 33, 55, 67, 88};ok
 rt type { 33-55};ok
@@ -37,8 +37,8 @@ rt type { 33-55};ok
 
 rt seg-left 22;ok
 rt seg-left != 233;ok
-rt seg-left 33-45;ok;rt seg-left >= 33 rt seg-left <= 45
-rt seg-left != 33-45;ok;rt seg-left < 33 rt seg-left > 45
+rt seg-left 33-45;ok
+rt seg-left != 33-45;ok
 rt seg-left { 33, 55, 67, 88};ok
 - rt seg-left != { 33, 55, 67, 88};ok
 rt seg-left { 33-55};ok
-- 
1.7.10.4

