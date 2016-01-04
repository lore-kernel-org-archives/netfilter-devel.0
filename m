From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 6/6] tests/py: update test files syntax
Date: Mon,  4 Jan 2016 11:43:56 +0100
Message-ID: <1451904236-4481-6-git-send-email-pablombg@gmail.com>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37485 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbcADKoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 05:44:46 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so206989856wmf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 02:44:45 -0800 (PST)
In-Reply-To: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The test files have been adapted to the syntax defined in the previous
commit "tests/py: modify supported test file syntax"

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/py/any/ct.t         |  8 ++++----
 tests/py/any/frag.t       | 11 ++++++-----
 tests/py/any/limit.t      | 11 ++++++-----
 tests/py/any/log.t        | 11 ++++++-----
 tests/py/any/meta.t       | 12 ++++++------
 tests/py/any/queue.t      | 12 ++++++------
 tests/py/arp/arp.t        |  3 ++-
 tests/py/arp/chains.t     |  4 ++--
 tests/py/bridge/chains.t  |  4 ++--
 tests/py/bridge/ether.t   |  4 ++--
 tests/py/bridge/reject.t  |  3 ++-
 tests/py/bridge/vlan.t    |  3 ++-
 tests/py/inet/ah.t        |  7 ++++---
 tests/py/inet/comp.t      |  8 ++++----
 tests/py/inet/dccp.t      |  7 ++++---
 tests/py/inet/esp.t       |  7 ++++---
 tests/py/inet/ether-ip.t  |  3 ++-
 tests/py/inet/ether.t     | 10 +++++-----
 tests/py/inet/ip.t        |  8 ++++----
 tests/py/inet/reject.t    |  3 ++-
 tests/py/inet/sctp.t      |  7 ++++---
 tests/py/inet/tcp.t       |  7 ++++---
 tests/py/inet/udp.t       |  7 ++++---
 tests/py/inet/udplite.t   |  7 ++++---
 tests/py/ip/chains.t      |  4 ++--
 tests/py/ip/dnat.t        |  3 ++-
 tests/py/ip/dup.t         |  3 ++-
 tests/py/ip/ether.t       |  4 ++--
 tests/py/ip/icmp.t        |  3 ++-
 tests/py/ip/ip.t          |  5 +++--
 tests/py/ip/masquerade.t  |  3 ++-
 tests/py/ip/redirect.t    |  3 ++-
 tests/py/ip/reject.t      |  3 ++-
 tests/py/ip/sets.t        |  5 +++--
 tests/py/ip/snat.t        |  3 ++-
 tests/py/ip6/chains.t     |  4 ++--
 tests/py/ip6/dnat.t       |  3 ++-
 tests/py/ip6/dst.t        |  5 +++--
 tests/py/ip6/dup.t        |  3 ++-
 tests/py/ip6/ether.t      |  4 ++--
 tests/py/ip6/hbh.t        |  5 +++--
 tests/py/ip6/icmpv6.t     |  7 ++++---
 tests/py/ip6/ip6.t        |  5 +++--
 tests/py/ip6/masquerade.t |  3 ++-
 tests/py/ip6/mh.t         |  5 +++--
 tests/py/ip6/redirect.t   |  3 ++-
 tests/py/ip6/reject.t     |  3 ++-
 tests/py/ip6/rt.t         |  5 +++--
 tests/py/ip6/sets.t       |  5 +++--
 tests/py/ip6/snat.t       |  3 ++-
 tests/py/ip6/vmap.t       |  5 +++--
 51 files changed, 156 insertions(+), 118 deletions(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 059402e..056d9bb 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -1,9 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+
 ct state new,established, related, untracked;ok;ct state established,related,new,untracked
 ct state != related;ok
 ct state {new,established, related, untracked};ok
diff --git a/tests/py/any/frag.t b/tests/py/any/frag.t
index d61a3d4..9138637 100644
--- a/tests/py/any/frag.t
+++ b/tests/py/any/frag.t
@@ -1,10 +1,11 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*arp;test-arp
-*bridge;test-bridge
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+
 frag nexthdr tcp;ok;frag nexthdr 6
 frag nexthdr != icmp;ok;frag nexthdr != 1
 frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr { 51, 136, 132, 6, 108, 50, 17, 33}
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 96ffe60..2dcab81 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -1,10 +1,11 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*arp;test-arp
-*bridge;test-bridge
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+
 limit rate 400/minute;ok
 limit rate 20/second;ok
 limit rate 400/hour;ok
diff --git a/tests/py/any/log.t b/tests/py/any/log.t
index 0eed580..99a7f1f 100644
--- a/tests/py/any/log.t
+++ b/tests/py/any/log.t
@@ -1,10 +1,11 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*arp;test-arp
-*bridge;test-bridge
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+
 log;ok
 log level emerg;ok
 log level alert;ok
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c03e7f4..245f0ec 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -1,11 +1,11 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*arp;test-arp
-*bridge;test-bridge
-
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*arp;test-arp;input
+*bridge;test-bridge;input
+
 meta length 1000;ok
 meta length 22;ok
 meta length != 233;ok
diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index 600c112..a1aefa1 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -1,11 +1,11 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*arp;test-arp
-*bridge;test-bridge
-
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+
 queue;ok;queue num 0
 queue num 2;ok
 queue num 2-3;ok
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index c4e07d5..06b0fe3 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -1,7 +1,8 @@
-*arp;test-arp
 # filter chains available are: input, output, forward
 :input;type filter hook input priority 0
 
+*arp;test-arp;input
+
 arp htype 1;ok
 arp htype != 1;ok
 arp htype 22;ok
diff --git a/tests/py/arp/chains.t b/tests/py/arp/chains.t
index cf08c1a..59647f7 100644
--- a/tests/py/arp/chains.t
+++ b/tests/py/arp/chains.t
@@ -1,6 +1,6 @@
-*arp;test-arp
-
 # filter chains available are: input, output, forward
 :input;type filter hook input priority 0
 :forward;type filter hook forward priority 0
 :output;type filter hook output priority 0
+
+*arp;test-arp;input,forward,output
diff --git a/tests/py/bridge/chains.t b/tests/py/bridge/chains.t
index 8070de4..85dde73 100644
--- a/tests/py/bridge/chains.t
+++ b/tests/py/bridge/chains.t
@@ -1,8 +1,8 @@
-*bridge;test-bridge
-
 # filter chains available are: prerouting, input, output, forward, postrouting
 :filter-pre;type filter hook input priority 0
 :filter-output;type filter hook output priority 0
 :filter-forward;type filter hook forward priority 0
 :filter-input;type filter hook input priority 0
 :filter-post;type filter hook input priority 0
+
+*bridge;test-bridge;filter-pre,filter-output,filter-forward,filter-input,filter-post
diff --git a/tests/py/bridge/ether.t b/tests/py/bridge/ether.t
index 6257dfc..5b39fe0 100644
--- a/tests/py/bridge/ether.t
+++ b/tests/py/bridge/ether.t
@@ -1,7 +1,7 @@
-*bridge;test-bridge
-
 :input;type filter hook input priority 0
 
+*bridge;test-bridge;input
+
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4;ok
diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index 43e5461..4fa6ac0 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -1,6 +1,7 @@
-*bridge;test-bridge
 :input;type filter hook input priority 0
 
+*bridge;test-bridge;input
+
 # The output is specific for bridge family
 reject with icmp type host-unreachable;ok;ether type ip reject with icmp type host-unreachable
 reject with icmp type net-unreachable;ok;ether type ip reject with icmp type net-unreachable
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index f86561a..e7c75bb 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -1,6 +1,7 @@
-*bridge;test-bridge
 :input;type filter hook input priority 0
 
+*bridge;test-bridge;input
+
 vlan id 4094;ok
 vlan id 0;ok
 # bad vlan id
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index 666659d..f3848b7 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 # nexthdr Bug to list table.
 
 - ah nexthdr esp;ok
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index f4753bb..6396ff3 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -1,9 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 # BUG: nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.
 - comp nexthdr esp;ok;comp nexthdr 50
 comp nexthdr != esp;ok;comp nexthdr != 50
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index e323992..63de1c8 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 dccp sport 21-35;ok
 dccp sport != 21-35;ok
 dccp sport {23, 24, 25};ok
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index 3a8502d..105acb2 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 esp spi 100;ok
 esp spi != 100;ok
 esp spi 111-222;ok
diff --git a/tests/py/inet/ether-ip.t b/tests/py/inet/ether-ip.t
index 3726db4..a451588 100644
--- a/tests/py/inet/ether-ip.t
+++ b/tests/py/inet/ether-ip.t
@@ -1,5 +1,6 @@
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*inet;test-inet;input
+
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index 9d0f972..1659a30 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -1,10 +1,10 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
-*bridge;test-bridge
-
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*bridge;test-bridge;input
+
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4 accept
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept;ok
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index a56c5c9..ffcb47e 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -1,7 +1,7 @@
-*ip;test-ip4
-*inet;test-inet
-*bridge;test-bridge
-
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*inet;test-inet;input
+*bridge;test-bridge;input
+
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index 52e7b28..638f329 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -1,6 +1,7 @@
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*inet;test-inet;input
+
 # The output is specific for inet family
 reject with icmp type host-unreachable;ok;meta nfproto ipv4 reject with icmp type host-unreachable
 reject with icmp type net-unreachable;ok;meta nfproto ipv4 reject with icmp type net-unreachable
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 537a9b1..75c58b8 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 sctp sport 23;ok
 sctp sport != 23;ok
 sctp sport 23-44;ok
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 53a1689..cc19ed4 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 tcp dport 22;ok
 tcp dport != 233;ok
 tcp dport 33-45;ok
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 58f4002..30c06e4 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip;test-ip6
-*ip;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip;test-ip6;input
+*ip;test-inet;input
+
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
 udp sport 50-70 accept;ok
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index 9420ab4..ba01f67 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 udplite sport 80 accept;ok
 udplite sport != 60 accept;ok
 udplite sport 50-70 accept;ok
diff --git a/tests/py/ip/chains.t b/tests/py/ip/chains.t
index 8edf62b..fc3745e 100644
--- a/tests/py/ip/chains.t
+++ b/tests/py/ip/chains.t
@@ -1,5 +1,3 @@
-*ip;test-ip4
-
 # filter chains available are: input, output, forward, prerouting, postrouting
 :filter-input;type filter hook input priority 0
 :filter-pre;type filter hook prerouting priority 0
@@ -13,3 +11,5 @@
 :nat-post-t;type nat hook postrouting priority 0
 # route chain available are: output
 :route-out-t;type route hook output priority 0
+
+*ip;test-ip4;filter-input,filter-pre,filter-forw,filter-out,filter-post,nat-input-t,nat-pre-t,nat-out-t,nat-post-t,route-out-t
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index cdb7811..28e658d 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :prerouting;type nat hook prerouting priority 0
 
+*ip;test-ip4;prerouting
+
 iifname "eth0" tcp dport 80-90 dnat 192.168.3.2;ok
 iifname "eth0" tcp dport != 80-90 dnat 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} dnat 192.168.3.2;ok
diff --git a/tests/py/ip/dup.t b/tests/py/ip/dup.t
index 9320d54..ac4e83a 100644
--- a/tests/py/ip/dup.t
+++ b/tests/py/ip/dup.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+
 dup to 192.168.2.1;ok
 dup to 192.168.2.1 device eth0;ok
 dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0;ok
diff --git a/tests/py/ip/ether.t b/tests/py/ip/ether.t
index 4d30f51..e1d302c 100644
--- a/tests/py/ip/ether.t
+++ b/tests/py/ip/ether.t
@@ -1,7 +1,7 @@
-*ip;test-ip
-
 :input;type filter hook input priority 0
 
+*ip;test-ip;input
+
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4;ok
diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index bd00f5c..02027b0 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -1,8 +1,9 @@
-*ip;test-ip4
 # BUG: There is a bug with icmp protocol and inet family.
 # *inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+
 icmp type echo-reply accept;ok
 icmp type destination-unreachable accept;ok
 icmp type source-quench accept;ok
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 0339c2a..152323b 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -1,7 +1,8 @@
-*ip;test-ip4
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*inet;test-inet;input
+
 - ip version 2;ok
 
 # bug ip hdrlength
diff --git a/tests/py/ip/masquerade.t b/tests/py/ip/masquerade.t
index 35001f3..0bb49a6 100644
--- a/tests/py/ip/masquerade.t
+++ b/tests/py/ip/masquerade.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :postrouting;type nat hook postrouting priority 0
 
+*ip;test-ip4;postrouting
+
 # nf_nat flags combination
 udp dport 53 masquerade;ok
 udp dport 53 masquerade random;ok
diff --git a/tests/py/ip/redirect.t b/tests/py/ip/redirect.t
index b7eecb7..8161ae6 100644
--- a/tests/py/ip/redirect.t
+++ b/tests/py/ip/redirect.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :output;type nat hook output priority 0
 
+*ip;test-ip4;output
+
 # without arguments
 udp dport 53 redirect;ok
 
diff --git a/tests/py/ip/reject.t b/tests/py/ip/reject.t
index 70a63a0..6006f05 100644
--- a/tests/py/ip/reject.t
+++ b/tests/py/ip/reject.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :output;type filter hook output priority 0
 
+*ip;test-ip4;output
+
 reject;ok
 reject with icmp type host-unreachable;ok
 reject with icmp type net-unreachable;ok
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index c199dbd..d4a72ad 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -1,7 +1,8 @@
-*ip;test-ip4
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*inet;test-inet;input
+
 !set_ipv4_add ipv4_addr;ok
 !set_inet inet_proto;ok
 !set_inet_serv inet_service;ok
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index 1caf7c7..a8469a3 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -1,6 +1,7 @@
-*ip;test-ip4
 :postrouting;type nat hook postrouting priority 0
 
+*ip;test-ip4;postrouting
+
 iifname "eth0" tcp dport 80-90 snat 192.168.3.2;ok
 iifname "eth0" tcp dport != 80-90 snat 192.168.3.2;ok
 iifname "eth0" tcp dport {80, 90, 23} snat 192.168.3.2;ok
diff --git a/tests/py/ip6/chains.t b/tests/py/ip6/chains.t
index c1e41e4..e78f9e0 100644
--- a/tests/py/ip6/chains.t
+++ b/tests/py/ip6/chains.t
@@ -1,5 +1,3 @@
-*ip6;test-ip6
-
 # filter chains available are: input, output, forward, forward, prerouting and postrouting.
 :filter-input;type filter hook input priority 0
 :filter-prer;type filter hook prerouting priority 0
@@ -15,3 +13,5 @@
 
 # route chain available is output.
 :route-out;type route hook output priority 0
+
+*ip6;test-ip6;filter-input,filter-prer,filter-forw-t,filter-out-t,filter-post-t,nat-input,nat-prerouting,nat-output,nat-postrou,route-out
diff --git a/tests/py/ip6/dnat.t b/tests/py/ip6/dnat.t
index 8341225..b061f2f 100644
--- a/tests/py/ip6/dnat.t
+++ b/tests/py/ip6/dnat.t
@@ -1,5 +1,6 @@
-*ip6;test-ip6
 :prerouting;type nat hook prerouting priority 0
 
+*ip6;test-ip6;prerouting
+
 tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:::80-100;ok
 tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:: :100;ok;tcp dport 80-90 dnat 2001:838:35f:1::-2001:838:35f:2:::100
diff --git a/tests/py/ip6/dst.t b/tests/py/ip6/dst.t
index 3207af7..f7b0979 100644
--- a/tests/py/ip6/dst.t
+++ b/tests/py/ip6/dst.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 dst nexthdr 22;ok
 dst nexthdr != 233;ok
 dst nexthdr 33-45;ok
diff --git a/tests/py/ip6/dup.t b/tests/py/ip6/dup.t
index 34f302f..e6bb78b 100644
--- a/tests/py/ip6/dup.t
+++ b/tests/py/ip6/dup.t
@@ -1,6 +1,7 @@
-*ip6;test-ip6
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+
 dup to abcd::1;ok
 dup to abcd::1 device eth0;ok
 dup to ip6 saddr map { abcd::1 : cafe::cafe } device eth0;ok
diff --git a/tests/py/ip6/ether.t b/tests/py/ip6/ether.t
index 98be273..d94a0d2 100644
--- a/tests/py/ip6/ether.t
+++ b/tests/py/ip6/ether.t
@@ -1,7 +1,7 @@
-*ip6;test-ip6
-
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+
 tcp dport 22 iiftype ether ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04;ok;tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2;ok
diff --git a/tests/py/ip6/hbh.t b/tests/py/ip6/hbh.t
index 4e67c42..235cce4 100644
--- a/tests/py/ip6/hbh.t
+++ b/tests/py/ip6/hbh.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :filter-input;type filter hook input priority 0
 
+*ip6;test-ip6;filter-input
+*inet;test-inet;filter-input
+
 hbh hdrlength 22;ok
 hbh hdrlength != 233;ok
 hbh hdrlength 33-45;ok
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index fca903f..af40bf7 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -1,8 +1,9 @@
-*ip6;test-ip6
-# BUG: There is a bug with icmpv6 and inet tables
-# *inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+# BUG: There is a bug with icmpv6 and inet tables
+# *inet;test-inet;input
+
 icmpv6 type destination-unreachable accept;ok
 icmpv6 type packet-too-big accept;ok
 icmpv6 type time-exceeded accept;ok
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index d4c5c7e..ceb2a82 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 # BUG: Problem with version, priority
 # <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
 # add rule ip6 test6 input ip6 version 1
diff --git a/tests/py/ip6/masquerade.t b/tests/py/ip6/masquerade.t
index 4e6c086..8040280 100644
--- a/tests/py/ip6/masquerade.t
+++ b/tests/py/ip6/masquerade.t
@@ -1,6 +1,7 @@
-*ip6;test-ip6
 :postrouting;type nat hook postrouting priority 0
 
+*ip6;test-ip6;postrouting
+
 # nf_nat flags combination
 udp dport 53 masquerade;ok
 udp dport 53 masquerade random;ok
diff --git a/tests/py/ip6/mh.t b/tests/py/ip6/mh.t
index cd652b3..099a6eb 100644
--- a/tests/py/ip6/mh.t
+++ b/tests/py/ip6/mh.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 mh nexthdr 1;ok
 mh nexthdr != 1;ok
 mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp };ok;mh nexthdr { 58, 17, 108, 6, 51, 136, 50, 132, 33}
diff --git a/tests/py/ip6/redirect.t b/tests/py/ip6/redirect.t
index 31ffe8c..d5a0a3b 100644
--- a/tests/py/ip6/redirect.t
+++ b/tests/py/ip6/redirect.t
@@ -1,6 +1,7 @@
-*ip6;test-ip6
 :output;type nat hook output priority 0
 
+*ip6;test-ip6;output
+
 # with no arguments
 redirect;ok
 udp dport 954 redirect;ok
diff --git a/tests/py/ip6/reject.t b/tests/py/ip6/reject.t
index 60dec90..2979956 100644
--- a/tests/py/ip6/reject.t
+++ b/tests/py/ip6/reject.t
@@ -1,6 +1,7 @@
-*ip6;test-ip6
 :output;type filter hook output priority 0
 
+*ip6;test-ip6;output
+
 reject;ok
 reject with icmpv6 type no-route;ok
 reject with icmpv6 type admin-prohibited;ok
diff --git a/tests/py/ip6/rt.t b/tests/py/ip6/rt.t
index eca47ca..7e700a5 100644
--- a/tests/py/ip6/rt.t
+++ b/tests/py/ip6/rt.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 rt nexthdr 1;ok
 rt nexthdr != 1;ok
 rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;rt nexthdr { 33, 136, 50, 132, 51, 17, 108, 6, 58}
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 4938929..e0daa3a 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 !set_ipv6_add1 ipv6_addr;ok
 !set_inet1 inet_proto;ok
 !set_inet inet_service;ok
diff --git a/tests/py/ip6/snat.t b/tests/py/ip6/snat.t
index 37bf1a1..dec8dff 100644
--- a/tests/py/ip6/snat.t
+++ b/tests/py/ip6/snat.t
@@ -1,5 +1,6 @@
-*ip6;test-ip6
 :postrouting;type nat hook postrouting priority 0
 
+*ip6;test-ip6;postrouting
+
 tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:: :80-100;ok;tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::80-100
 tcp dport 80-90 snat 2001:838:35f:1::-2001:838:35f:2:::100;ok
diff --git a/tests/py/ip6/vmap.t b/tests/py/ip6/vmap.t
index 301a28a..6a3a004 100644
--- a/tests/py/ip6/vmap.t
+++ b/tests/py/ip6/vmap.t
@@ -1,7 +1,8 @@
-*ip6;test-ip6
-*inet;test-inet
 :input;type filter hook input priority 0
 
+*ip6;test-ip6;input
+*inet;test-inet;input
+
 ip6 saddr vmap { abcd::3 : accept };ok
 ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
 
-- 
2.6.4

