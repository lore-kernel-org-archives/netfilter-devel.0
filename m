From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/7] extensions: add more test cases for iptables-test.py
Date: Thu, 19 Feb 2015 14:11:20 +0100
Message-ID: <1424351483-27617-5-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58480 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbbBSNLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:47 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of using iptables-save-formatted files in the tests/ dir,
lets use the iptables-test.py framework for all matches/targets.

This obsoletes tests/ completely, will be removed in followup patch.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libip6t_DNAT.t       |  8 ++++++++
 extensions/libip6t_DNPT.t       |  6 ++++++
 extensions/libip6t_HL.t         | 10 ++++++++++
 extensions/libip6t_MASQUERADE.t |  8 ++++++++
 extensions/libip6t_NETMAP.t     |  4 ++++
 extensions/libip6t_REDIRECT.t   |  6 ++++++
 extensions/libip6t_SNAT.t       |  8 ++++++++
 extensions/libip6t_SNPT.t       |  6 ++++++
 extensions/libip6t_dst.t        |  4 ++++
 extensions/libip6t_frag.t       | 11 +++++++++++
 extensions/libip6t_hbh.t        |  5 +++++
 extensions/libip6t_hl.t         |  8 ++++++++
 extensions/libip6t_icmp6.t      |  6 ++++++
 extensions/libip6t_ipv6header.t |  4 ++++
 extensions/libip6t_mh.t         |  6 ++++++
 extensions/libip6t_rt.t         |  4 ++++
 extensions/libipt_NETMAP.t      |  4 ++++
 extensions/libipt_REDIRECT.t    |  6 ++++++
 extensions/libipt_TTL.t         | 10 ++++++++++
 extensions/libipt_realm.t       |  4 ++++
 extensions/libxt_CONNSECMARK.t  |  5 +++++
 extensions/libxt_HMARK.t        |  8 ++++++++
 extensions/libxt_IDLETIMER.t    |  4 ++++
 extensions/libxt_LED.t          |  4 ++++
 extensions/libxt_RATEEST.t      |  2 ++
 extensions/libxt_SET.t          |  3 +++
 extensions/libxt_SYNPROXY.t     |  3 +++
 extensions/libxt_TCPMSS.t       |  6 ++++++
 extensions/libxt_TCPOPTSTRIP.t  |  8 ++++++++
 extensions/libxt_TPROXY.t       |  5 +++++
 extensions/libxt_bpf.t          |  2 ++
 extensions/libxt_ecn.t          |  5 +++++
 extensions/libxt_mac.t          |  5 +++++
 extensions/libxt_osf.t          |  4 ++++
 extensions/libxt_policy.t       |  5 +++++
 extensions/libxt_recent.t       |  7 +++++++
 extensions/libxt_rpfilter.t     |  4 ++++
 extensions/libxt_set.t          |  4 ++++
 extensions/libxt_socket.t       |  4 ++++
 extensions/libxt_statistic.t    |  8 ++++++++
 extensions/libxt_tcpmss.t       |  5 +++++
 extensions/libxt_u32.t          |  2 ++
 42 files changed, 231 insertions(+)
 create mode 100644 extensions/libip6t_DNAT.t
 create mode 100644 extensions/libip6t_DNPT.t
 create mode 100644 extensions/libip6t_HL.t
 create mode 100644 extensions/libip6t_MASQUERADE.t
 create mode 100644 extensions/libip6t_NETMAP.t
 create mode 100644 extensions/libip6t_REDIRECT.t
 create mode 100644 extensions/libip6t_SNAT.t
 create mode 100644 extensions/libip6t_SNPT.t
 create mode 100644 extensions/libip6t_dst.t
 create mode 100644 extensions/libip6t_frag.t
 create mode 100644 extensions/libip6t_hbh.t
 create mode 100644 extensions/libip6t_hl.t
 create mode 100644 extensions/libip6t_icmp6.t
 create mode 100644 extensions/libip6t_ipv6header.t
 create mode 100644 extensions/libip6t_mh.t
 create mode 100644 extensions/libip6t_rt.t
 create mode 100644 extensions/libipt_NETMAP.t
 create mode 100644 extensions/libipt_REDIRECT.t
 create mode 100644 extensions/libipt_TTL.t
 create mode 100644 extensions/libipt_realm.t
 create mode 100644 extensions/libxt_CONNSECMARK.t
 create mode 100644 extensions/libxt_HMARK.t
 create mode 100644 extensions/libxt_IDLETIMER.t
 create mode 100644 extensions/libxt_LED.t
 create mode 100644 extensions/libxt_RATEEST.t
 create mode 100644 extensions/libxt_SET.t
 create mode 100644 extensions/libxt_SYNPROXY.t
 create mode 100644 extensions/libxt_TCPMSS.t
 create mode 100644 extensions/libxt_TCPOPTSTRIP.t
 create mode 100644 extensions/libxt_TPROXY.t
 create mode 100644 extensions/libxt_bpf.t
 create mode 100644 extensions/libxt_ecn.t
 create mode 100644 extensions/libxt_mac.t
 create mode 100644 extensions/libxt_osf.t
 create mode 100644 extensions/libxt_policy.t
 create mode 100644 extensions/libxt_recent.t
 create mode 100644 extensions/libxt_rpfilter.t
 create mode 100644 extensions/libxt_set.t
 create mode 100644 extensions/libxt_socket.t
 create mode 100644 extensions/libxt_statistic.t
 create mode 100644 extensions/libxt_tcpmss.t
 create mode 100644 extensions/libxt_u32.t

diff --git a/extensions/libip6t_DNAT.t b/extensions/libip6t_DNAT.t
new file mode 100644
index 0000000..3141c29
--- /dev/null
+++ b/extensions/libip6t_DNAT.t
@@ -0,0 +1,8 @@
+:PREROUTING
+*nat
+-j DNAT --to-destination dead::beef;=;OK
+-j DNAT --to-destination dead::beef-dead::fee7;=;OK
+-p tcp -j DNAT --to-destination [dead::beef]:1025-65535;=;OK
+-p tcp -j DNAT --to-destination [dead::beef-dead::fee7]:1025-65535;=;OK
+-p tcp -j DNAT --to-destination [dead::beef-dead::fee7]:1025-65536;;FAIL
+-j DNAT;;FAIL
diff --git a/extensions/libip6t_DNPT.t b/extensions/libip6t_DNPT.t
new file mode 100644
index 0000000..25ec935
--- /dev/null
+++ b/extensions/libip6t_DNPT.t
@@ -0,0 +1,6 @@
+:PREROUTING
+*mangle
+-j DNPT --src-pfx dead::beef --dst-pfx 1c3::/64;;FAIL
+-j DNPT --src-pfx dead::/64;;FAIL
+-j DNPT --dst-pfx dead::/64;;FAIL
+-j DNPT;;FAIL
diff --git a/extensions/libip6t_HL.t b/extensions/libip6t_HL.t
new file mode 100644
index 0000000..4e529f8
--- /dev/null
+++ b/extensions/libip6t_HL.t
@@ -0,0 +1,10 @@
+:PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING
+*mangle
+-j HL --hl-set 42;=;OK
+-j HL --hl-inc 1;=;OK
+-j HL --hl-dec 1;=;OK
+-j HL --hl-set 256;;FAIL
+-j HL --hl-inc 0;;FAIL
+-j HL --hl-dec 0;;FAIL
+-j HL --hl-dec 1 --hl-inc 1;;FAIL
+-j HL --hl-set --hl-inc 1;;FAIL
diff --git a/extensions/libip6t_MASQUERADE.t b/extensions/libip6t_MASQUERADE.t
new file mode 100644
index 0000000..4650204
--- /dev/null
+++ b/extensions/libip6t_MASQUERADE.t
@@ -0,0 +1,8 @@
+:POSTROUTING
+*nat
+-j MASQUERADE;=;OK
+-j MASQUERADE --random;=;OK
+-p tcp -j MASQUERADE --to-ports 1024;=;OK
+-p udp -j MASQUERADE --to-ports 1024-65535;=;OK
+-p udp -j MASQUERADE --to-ports 1024-65536;;FAIL
+-p udp -j MASQUERADE --to-ports -1;;FAIL
diff --git a/extensions/libip6t_NETMAP.t b/extensions/libip6t_NETMAP.t
new file mode 100644
index 0000000..043562d
--- /dev/null
+++ b/extensions/libip6t_NETMAP.t
@@ -0,0 +1,4 @@
+:PREROUTING,INPUT,OUTPUT,POSTROUTING
+*nat
+-j NETMAP --to dead::/64;=;OK
+-j NETMAP --to dead::beef;=;OK
diff --git a/extensions/libip6t_REDIRECT.t b/extensions/libip6t_REDIRECT.t
new file mode 100644
index 0000000..a0fb0ed
--- /dev/null
+++ b/extensions/libip6t_REDIRECT.t
@@ -0,0 +1,6 @@
+:PREROUTING,OUTPUT
+*nat
+-p tcp -j REDIRECT --to-ports 42;=;OK
+-p udp -j REDIRECT --to-ports 42-1234;=;OK
+-p tcp -j REDIRECT --to-ports 42-1234 --random;=;OK
+-j REDIRECT --to-ports 42;;FAIL
diff --git a/extensions/libip6t_SNAT.t b/extensions/libip6t_SNAT.t
new file mode 100644
index 0000000..bb08049
--- /dev/null
+++ b/extensions/libip6t_SNAT.t
@@ -0,0 +1,8 @@
+:POSTROUTING
+*nat
+-j SNAT --to-source dead::beef;=;OK
+-j SNAT --to-source dead::beef-dead::fee7;=;OK
+-p tcp -j SNAT --to-source [dead::beef]:1025-65535;=;OK
+-p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65535;=;OK
+-p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65536;;FAIL
+-j SNAT;;FAIL
diff --git a/extensions/libip6t_SNPT.t b/extensions/libip6t_SNPT.t
new file mode 100644
index 0000000..5a2fe7f
--- /dev/null
+++ b/extensions/libip6t_SNPT.t
@@ -0,0 +1,6 @@
+:INPUT,POSTROUTING
+*mangle
+-j SNPT --src-pfx dead::beef --dst-pfx 1c3::/64;;FAIL
+-j SNPT --src-pfx dead::/64;;FAIL
+-j SNPT --dst-pfx dead::/64;;FAIL
+-j SNPT;;FAIL
diff --git a/extensions/libip6t_dst.t b/extensions/libip6t_dst.t
new file mode 100644
index 0000000..b2788aa
--- /dev/null
+++ b/extensions/libip6t_dst.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m dst --dst-len 0;=;OK
+-m dst --dst-opts 149:92,12:12,123:12;=;OK
+-m dst --dst-len 42 --dst-opts 149:92,12:12,123:12;=;OK
diff --git a/extensions/libip6t_frag.t b/extensions/libip6t_frag.t
new file mode 100644
index 0000000..dab4989
--- /dev/null
+++ b/extensions/libip6t_frag.t
@@ -0,0 +1,11 @@
+:INPUT,FORWARD,OUTPUT
+-m frag --fragid 1:42;=;OK
+-m frag --fraglen 42;=;OK
+-m frag --fragres;=;OK
+-m frag --fragfirst;=;OK
+-m frag --fragmore;=;OK
+-m frag --fraglast;=;OK
+-m frag ! --fragid 1 ! --fraglen 42 --fragres --fragfirst;=;OK
+-m frag --fragfirst --fragmore;=;OK
+-m frag --fragfirst --fraglast;=;OK
+-m frag --fraglast --fragmore;;FAIL
diff --git a/extensions/libip6t_hbh.t b/extensions/libip6t_hbh.t
new file mode 100644
index 0000000..4b58f25
--- /dev/null
+++ b/extensions/libip6t_hbh.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-m hbh;=;OK
+-m hbh --hbh-len 42;=;OK
+-m hbh ! --hbh-len 42;=;OK
+-m hbh --hbh-len 42 --hbh-opts 1:2,23:42,4:6,8:10,42,23,4:5;=;OK
diff --git a/extensions/libip6t_hl.t b/extensions/libip6t_hl.t
new file mode 100644
index 0000000..b02816a
--- /dev/null
+++ b/extensions/libip6t_hl.t
@@ -0,0 +1,8 @@
+:INPUT,FORWARD,OUTPUT
+-m hl;;FAIL
+-m hl --hl-eq 42;=;OK
+-m hl ! --hl-eq 42;=;OK
+-m hl --hl-lt 42;=;OK
+-m hl --hl-gt 42;=;OK
+-m hl --hl-gt 42 --hl-eq 42;;FAIL
+-m hl --hl-gt;;FAIL
diff --git a/extensions/libip6t_icmp6.t b/extensions/libip6t_icmp6.t
new file mode 100644
index 0000000..028cfc1
--- /dev/null
+++ b/extensions/libip6t_icmp6.t
@@ -0,0 +1,6 @@
+:INPUT,FORWARD,OUTPUT
+-m icmpv6;;FAIL
+-p ipv6-icmp -m icmp6 --icmpv6-type 1/0;=;OK
+-p ipv6-icmp -m icmp6 --icmpv6-type 2;=;OK
+# cannot use option twice:
+-p ipv6-icmp -m icmp6 --icmpv6-type no-route --icmpv6-type packet-too-big;;FAIL
diff --git a/extensions/libip6t_ipv6header.t b/extensions/libip6t_ipv6header.t
new file mode 100644
index 0000000..67fa479
--- /dev/null
+++ b/extensions/libip6t_ipv6header.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m ipv6header --header hop-by-hop;=;OK
+-m ipv6header --header hop-by-hop --soft;=;OK
+-m ipv6header --header ipv6-nonxt;=;OK
diff --git a/extensions/libip6t_mh.t b/extensions/libip6t_mh.t
new file mode 100644
index 0000000..6b76d13
--- /dev/null
+++ b/extensions/libip6t_mh.t
@@ -0,0 +1,6 @@
+:INPUT,FORWARD,OUTPUT
+-m mh;;FAIL
+-p mobility-header -m mh;=;OK
+-p mobility-header -m mh --mh-type 1;=;OK
+-p mobility-header -m mh ! --mh-type 4;=;OK
+-p mobility-header -m mh --mh-type 4:123;=;OK
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
new file mode 100644
index 0000000..7170138
--- /dev/null
+++ b/extensions/libip6t_rt.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m rt --rt-type 0 --rt-segsleft 1:23 --rt-len 42 --rt-0-res;=;OK
+-m rt --rt-type 0 ! --rt-segsleft 1:23 ! --rt-len 42 --rt-0-res;=;OK
+-m rt ! --rt-type 1 ! --rt-segsleft 12:23 ! --rt-len 42;=;OK
diff --git a/extensions/libipt_NETMAP.t b/extensions/libipt_NETMAP.t
new file mode 100644
index 0000000..31924b9
--- /dev/null
+++ b/extensions/libipt_NETMAP.t
@@ -0,0 +1,4 @@
+:PREROUTING,INPUT,OUTPUT,POSTROUTING
+*nat
+-j NETMAP --to 1.2.3.0/24;=;OK
+-j NETMAP --to 1.2.3.4;=;OK
diff --git a/extensions/libipt_REDIRECT.t b/extensions/libipt_REDIRECT.t
new file mode 100644
index 0000000..a0fb0ed
--- /dev/null
+++ b/extensions/libipt_REDIRECT.t
@@ -0,0 +1,6 @@
+:PREROUTING,OUTPUT
+*nat
+-p tcp -j REDIRECT --to-ports 42;=;OK
+-p udp -j REDIRECT --to-ports 42-1234;=;OK
+-p tcp -j REDIRECT --to-ports 42-1234 --random;=;OK
+-j REDIRECT --to-ports 42;;FAIL
diff --git a/extensions/libipt_TTL.t b/extensions/libipt_TTL.t
new file mode 100644
index 0000000..3680979
--- /dev/null
+++ b/extensions/libipt_TTL.t
@@ -0,0 +1,10 @@
+:PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING
+*mangle
+-j TTL --ttl-set 42;=;OK
+-j TTL --ttl-inc 1;=;OK
+-j TTL --ttl-dec 1;=;OK
+-j TTL --ttl-set 256;;FAIL
+-j TTL --ttl-inc 0;;FAIL
+-j TTL --ttl-dec 0;;FAIL
+-j TTL --ttl-dec 1 --ttl-inc 1;;FAIL
+-j TTL --ttl-set --ttl-inc 1;;FAIL
diff --git a/extensions/libipt_realm.t b/extensions/libipt_realm.t
new file mode 100644
index 0000000..ca66640
--- /dev/null
+++ b/extensions/libipt_realm.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m realm --realm 0x1/0x2a;=;OK
+-m realm --realm 0x2a;=;OK
+-m realm;;FAIL
diff --git a/extensions/libxt_CONNSECMARK.t b/extensions/libxt_CONNSECMARK.t
new file mode 100644
index 0000000..2751b25
--- /dev/null
+++ b/extensions/libxt_CONNSECMARK.t
@@ -0,0 +1,5 @@
+:PREROUTING,FORWARD,OUTPUT,POSTROUTING
+*mangle
+-j CONNSECMARK --restore;=;OK
+-j CONNSECMARK --save;=;OK
+-j CONNSECMARK;;FAIL
diff --git a/extensions/libxt_HMARK.t b/extensions/libxt_HMARK.t
new file mode 100644
index 0000000..3bcf1da
--- /dev/null
+++ b/extensions/libxt_HMARK.t
@@ -0,0 +1,8 @@
+:INPUT,FORWARD,OUTPUT
+-j HMARK;;FAIL
+-j HMARK --hmark-src-prefix 32 --hmark-rnd 0x00000004 --hmark-mod 42;=;OK
+-j HMARK --hmark-src-prefix 32 --hmark-dst-prefix 32 --hmark-sport-mask 0xffff --hmark-dport-mask 0xffff --hmark-proto-mask 0xffff --hmark-rnd 0x00000004 --hmark-mod 42 --hmark-offset 1 --hmark-tuple ct;=;OK
+-j HMARK --hmark-src-prefix 32 --hmark-dst-prefix 32 --hmark-spi-mask 0x00000004 --hmark-proto-mask 0xffff --hmark-rnd 0x00000004 --hmark-mod 42 --hmark-offset 1 --hmark-tuple ct;=;OK
+-j HMARK --hmark-src-prefix 1 --hmark-dst-prefix 2 --hmark-sport-mask 0x0003 --hmark-dport-mask 0x0004 --hmark-proto-mask 0x05 --hmark-rnd 0x00000004 --hmark-mod 42 --hmark-offset 1 --hmark-tuple ct;=;OK
+# cannot mix in spi mask:
+-j HMARK --hmark-src-prefix 32 --hmark-dst-prefix 32 --hmark-sport-mask 0xffff --hmark-dport-mask 0xffff --hmark-proto-mask 0xffff --hmark-rnd 0x00000004 --hmark-mod 42 --hmark-offset 1 --hmark-tuple ct --hmark-spi-mask 4;;FAIL
diff --git a/extensions/libxt_IDLETIMER.t b/extensions/libxt_IDLETIMER.t
new file mode 100644
index 0000000..6afd92c
--- /dev/null
+++ b/extensions/libxt_IDLETIMER.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-j IDLETIMER --timeout;;FAIL
+-j IDLETIMER --timeout 42;;FAIL
+-j IDLETIMER --timeout 42 --label foo;=;OK
diff --git a/extensions/libxt_LED.t b/extensions/libxt_LED.t
new file mode 100644
index 0000000..1f6705f
--- /dev/null
+++ b/extensions/libxt_LED.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-j LED;;FAIL
+-j LED --led-trigger-id "foo";=;OK
+-j LED --led-trigger-id "foo" --led-delay 42 --led-always-blink;=;OK
diff --git a/extensions/libxt_RATEEST.t b/extensions/libxt_RATEEST.t
new file mode 100644
index 0000000..c2b6bb3
--- /dev/null
+++ b/extensions/libxt_RATEEST.t
@@ -0,0 +1,2 @@
+:INPUT,FORWARD,OUTPUT
+-j RATEEST --rateest-name RE1 --rateest-interval 250.0ms --rateest-ewmalog 500.0ms;=;OK
diff --git a/extensions/libxt_SET.t b/extensions/libxt_SET.t
new file mode 100644
index 0000000..30c27ca
--- /dev/null
+++ b/extensions/libxt_SET.t
@@ -0,0 +1,3 @@
+:INPUT,FORWARD,OUTPUT
+# fails: foo does not exist
+-j SET --add-set foo src,dst;;FAIL
diff --git a/extensions/libxt_SYNPROXY.t b/extensions/libxt_SYNPROXY.t
new file mode 100644
index 0000000..dd8b0e7
--- /dev/null
+++ b/extensions/libxt_SYNPROXY.t
@@ -0,0 +1,3 @@
+:INPUT,FORWARD
+-j SYNPROXY --sack-perm --timestamp --mss 1460 --wscale 9;;FAIL
+-p tcp -m tcp --dport 42 -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 9 --mss 1460;=;OK
diff --git a/extensions/libxt_TCPMSS.t b/extensions/libxt_TCPMSS.t
new file mode 100644
index 0000000..553a345
--- /dev/null
+++ b/extensions/libxt_TCPMSS.t
@@ -0,0 +1,6 @@
+:FORWARD,OUTPUT,POSTROUTING
+*mangle
+-j TCPMSS;;FAIL
+-p tcp -j TCPMSS --set-mss 42;;FAIL
+-p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 42;=;OK
+-p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --clamp-mss-to-pmtu;=;OK
diff --git a/extensions/libxt_TCPOPTSTRIP.t b/extensions/libxt_TCPOPTSTRIP.t
new file mode 100644
index 0000000..b5c7a10
--- /dev/null
+++ b/extensions/libxt_TCPOPTSTRIP.t
@@ -0,0 +1,8 @@
+:PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING
+*mangle
+-j TCPOPTSTRIP;;FAIL
+-p tcp -j TCPOPTSTRIP;=;OK
+-p tcp -j TCPOPTSTRIP --strip-options 2,3,4,5,6,7;=;OK
+-p tcp -j TCPOPTSTRIP --strip-options 0;;FAIL
+-p tcp -j TCPOPTSTRIP --strip-options 1;;FAIL
+-p tcp -j TCPOPTSTRIP --strip-options 1,2;;FAIL
diff --git a/extensions/libxt_TPROXY.t b/extensions/libxt_TPROXY.t
new file mode 100644
index 0000000..12f82b1
--- /dev/null
+++ b/extensions/libxt_TPROXY.t
@@ -0,0 +1,5 @@
+:PREROUTING
+*mangle
+-j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff;;FAIL
+-p udp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff;=;OK
+-p tcp -m tcp --dport 2342 -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff;=;OK
diff --git a/extensions/libxt_bpf.t b/extensions/libxt_bpf.t
new file mode 100644
index 0000000..80361ad
--- /dev/null
+++ b/extensions/libxt_bpf.t
@@ -0,0 +1,2 @@
+:INPUT,FORWARD,OUTPUT
+-m bpf --bytecode "4,48 0 0 9,21 0 1 6,6 0 0 1,6 0 0 0";=;OK
diff --git a/extensions/libxt_ecn.t b/extensions/libxt_ecn.t
new file mode 100644
index 0000000..b32aea3
--- /dev/null
+++ b/extensions/libxt_ecn.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-m ecn --ecn-tcp-cwr;;FAIL
+-p tcp -m ecn --ecn-tcp-cwr;=;OK
+-p tcp -m ecn --ecn-tcp-ece --ecn-tcp-cwr --ecn-ip-ect 2;=;OK
+-p tcp -m ecn ! --ecn-tcp-ece ! --ecn-tcp-cwr ! --ecn-ip-ect 2;=;OK
diff --git a/extensions/libxt_mac.t b/extensions/libxt_mac.t
new file mode 100644
index 0000000..a5ec81d
--- /dev/null
+++ b/extensions/libxt_mac.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD
+-m mac --mac-source 42:01:02:03:04:05;=;OK
+-m mac --mac-source 42:01:02:03:04;=;FAIL
+-m mac --mac-source 42:01:02:03:04:05:06;=;FAIL
+-m mac;;FAIL
diff --git a/extensions/libxt_osf.t b/extensions/libxt_osf.t
new file mode 100644
index 0000000..ede6d32
--- /dev/null
+++ b/extensions/libxt_osf.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD
+-m osf --genre linux --ttl 0 --log 0;;FAIL
+-p tcp -m osf --genre linux --ttl 0 --log 0;=;OK
+-p tcp -m osf --genre linux --ttl 3 --log 0;;FAIL
diff --git a/extensions/libxt_policy.t b/extensions/libxt_policy.t
new file mode 100644
index 0000000..24a3e2f
--- /dev/null
+++ b/extensions/libxt_policy.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD
+-m policy --dir in --pol ipsec;=;OK
+-m policy --dir in --pol ipsec --strict;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 10.0.0.0/8;;FAIL
diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
new file mode 100644
index 0000000..cb4049f
--- /dev/null
+++ b/extensions/libxt_recent.t
@@ -0,0 +1,7 @@
+:INPUT,FORWARD,OUTPUT
+-m recent --set;=;OK
+-m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --update --rttl;=;OK
+-m recent --set --rttl;=;FAIL
+-m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;=;FAIL
diff --git a/extensions/libxt_rpfilter.t b/extensions/libxt_rpfilter.t
new file mode 100644
index 0000000..390268f
--- /dev/null
+++ b/extensions/libxt_rpfilter.t
@@ -0,0 +1,4 @@
+:PREROUTING
+*mangle
+-m rpfilter;=;OK
+-m rpfilter --loose --validmark --accept-local --invert;=;OK
diff --git a/extensions/libxt_set.t b/extensions/libxt_set.t
new file mode 100644
index 0000000..dd9e9f1
--- /dev/null
+++ b/extensions/libxt_set.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m set --match-set foo;;FAIL
+# fails: foo does not exist
+-m set --match-set foo src,dst;;FAIL
diff --git a/extensions/libxt_socket.t b/extensions/libxt_socket.t
new file mode 100644
index 0000000..8c0036e
--- /dev/null
+++ b/extensions/libxt_socket.t
@@ -0,0 +1,4 @@
+:PREROUTING,INPUT
+*mangle
+-m socket;=;OK
+-m socket --transparent --nowildcard;=;OK
diff --git a/extensions/libxt_statistic.t b/extensions/libxt_statistic.t
new file mode 100644
index 0000000..bb6673d
--- /dev/null
+++ b/extensions/libxt_statistic.t
@@ -0,0 +1,8 @@
+:INPUT,FORWARD,OUTPUT
+-m statistic;;FAIL
+-m statistic --mode random ! --probability 0.50000000000;=;OK
+-m statistic --mode random ! --probability 1.1;;FAIL
+-m statistic --probability 1;;FAIL
+-m statistic --mode nth ! --every 5 --packet 2;=;OK
+-m statistic --mode nth ! --every 5;;FAIL
+-m statistic --mode nth ! --every 5 --packet 5;;FAIL
diff --git a/extensions/libxt_tcpmss.t b/extensions/libxt_tcpmss.t
new file mode 100644
index 0000000..3181e49
--- /dev/null
+++ b/extensions/libxt_tcpmss.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-m tcpmss --mss 42;;FAIL
+-p tcp -m tcpmss --mss 42;=;OK
+-p tcp -m tcpmss --mss 42:12345;=;OK
+-p tcp -m tcpmss --mss 42:65536;;FAIL
diff --git a/extensions/libxt_u32.t b/extensions/libxt_u32.t
new file mode 100644
index 0000000..0d9be47
--- /dev/null
+++ b/extensions/libxt_u32.t
@@ -0,0 +1,2 @@
+:INPUT,FORWARD,OUTPUT
+-m u32 --u32 "0x0=0x0&&0x0=0x1";=;OK
-- 
2.0.5

