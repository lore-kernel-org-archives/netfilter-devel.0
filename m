From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v2] test: update and add the reject tests for ip, ip6, bridge and inet.
Date: Fri, 17 Oct 2014 14:24:37 +0200
Message-ID: <1413548677-10287-4-git-send-email-alvaroneay@gmail.com>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37425 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaJQMY3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:24:29 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so783897wgg.6
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 05:24:28 -0700 (PDT)
In-Reply-To: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Changed the format and added the rules with all the posible reasons

 tests/regression/bridge/reject.t |   30 ++++++++++++++++++++++++++++++
 tests/regression/inet/reject.t   |   28 ++++++++++++++++++++++++++++
 tests/regression/ip/reject.t     |   11 ++++++++++-
 tests/regression/ip6/reject.t    |    9 ++++++++-
 4 files changed, 76 insertions(+), 2 deletions(-)
 create mode 100644 tests/regression/bridge/reject.t
 create mode 100644 tests/regression/inet/reject.t

diff --git a/tests/regression/bridge/reject.t b/tests/regression/bridge/reject.t
new file mode 100644
index 0000000..68e6051
--- /dev/null
+++ b/tests/regression/bridge/reject.t
@@ -0,0 +1,30 @@
+*bridge;test-bridge
+:input;type filter hook input priority 0
+
+reject with icmp type host-unreachable;ok;ether type ip reject with icmp type host-unreachable
+reject with icmp type net-unreachable;ok;ether type ip reject with icmp type net-unreachable
+reject with icmp type prot-unreachable;ok;ether type ip reject with icmp type prot-unreachable
+reject with icmp type port-unreachable;ok;ether type ip reject
+reject with icmp type net-prohibited;ok;ether type ip reject with icmp type net-prohibited
+reject with icmp type host-prohibited;ok;ether type ip reject with icmp type host-prohibited
+reject with icmp type admin-prohibited;ok;ether type ip reject with icmp type admin-prohibited
+
+reject with icmpv6 type no-route;ok;ether type ip6 reject with icmpv6 type no-route
+reject with icmpv6 type admin-prohibited;ok;ether type ip6 reject with icmpv6 type admin-prohibited
+reject with icmpv6 type addr-unreachable;ok;ether type ip6 reject with icmpv6 type addr-unreachable
+reject with icmpv6 type port-unreachable;ok;ether type ip6 reject
+
+ip protocol tcp reject with tcp reset;ok;ip protocol 6 reject with tcp reset
+
+reject;ok
+reject with icmpx type host-unreachable;ok
+reject with icmpx type no-route;ok
+reject with icmpx type admin-prohibited;ok
+reject with icmpx type port-unreachable;ok;reject
+
+ether type ipv6 reject with icmp type host-unreachable;fail
+ether type ip6 reject with icmp type host-unreachable;fail
+ether type ip reject with icmpv6 type no-route;fail
+ether type vlan reject;fail
+ether type arp reject;fail
+ip protocol udp reject with tcp reset;fail
diff --git a/tests/regression/inet/reject.t b/tests/regression/inet/reject.t
new file mode 100644
index 0000000..7dd4598
--- /dev/null
+++ b/tests/regression/inet/reject.t
@@ -0,0 +1,28 @@
+*inet;test-inet
+:input;type filter hook input priority 0
+
+reject with icmp type host-unreachable;ok;meta nfproto ipv4 reject with icmp type host-unreachable
+reject with icmp type net-unreachable;ok;meta nfproto ipv4 reject with icmp type net-unreachable
+reject with icmp type prot-unreachable;ok;meta nfproto ipv4 reject with icmp type prot-unreachable
+reject with icmp type port-unreachable;ok;meta nfproto ipv4 reject
+reject with icmp type net-prohibited;ok;meta nfproto ipv4 reject with icmp type net-prohibited
+reject with icmp type host-prohibited;ok;meta nfproto ipv4 reject with icmp type host-prohibited
+reject with icmp type admin-prohibited;ok;meta nfproto ipv4 reject with icmp type admin-prohibited
+
+reject with icmpv6 type no-route;ok;meta nfproto ipv6 reject with icmpv6 type no-route
+reject with icmpv6 type admin-prohibited;ok;meta nfproto ipv6 reject with icmpv6 type admin-prohibited
+reject with icmpv6 type addr-unreachable;ok;meta nfproto ipv6 reject with icmpv6 type addr-unreachable
+reject with icmpv6 type port-unreachable;ok;meta nfproto ipv6 reject
+
+reject with tcp reset;ok;meta l4proto 6 reject with tcp reset
+
+reject;ok
+reject with icmpx type host-unreachable;ok
+reject with icmpx type no-route;ok
+reject with icmpx type admin-prohibited;ok
+reject with icmpx type port-unreachable;ok;reject
+
+meta nfproto ipv6 reject with icmp type host-unreachable;fail
+meta nfproto ipv4 ip protocol icmp reject with icmpv6 type no-route;fail
+meta nfproto ipv6 ip protocol icmp reject with icmp type host-unreachable;fail
+ip protocol udp reject with tcp reset;fail
diff --git a/tests/regression/ip/reject.t b/tests/regression/ip/reject.t
index e7fb15b..70a63a0 100644
--- a/tests/regression/ip/reject.t
+++ b/tests/regression/ip/reject.t
@@ -1,5 +1,14 @@
 *ip;test-ip4
-*ip;test-inet
 :output;type filter hook output priority 0
 
 reject;ok
+reject with icmp type host-unreachable;ok
+reject with icmp type net-unreachable;ok
+reject with icmp type prot-unreachable;ok
+reject with icmp type port-unreachable;ok;reject
+reject with icmp type net-prohibited;ok
+reject with icmp type host-prohibited;ok
+reject with icmp type admin-prohibited;ok
+
+reject with icmp type no-route;fail
+reject with icmpv6 type no-route;fail
diff --git a/tests/regression/ip6/reject.t b/tests/regression/ip6/reject.t
index b49c50b..60dec90 100644
--- a/tests/regression/ip6/reject.t
+++ b/tests/regression/ip6/reject.t
@@ -1,5 +1,12 @@
 *ip6;test-ip6
-*inet;test-inet
 :output;type filter hook output priority 0
 
 reject;ok
+reject with icmpv6 type no-route;ok
+reject with icmpv6 type admin-prohibited;ok
+reject with icmpv6 type addr-unreachable;ok
+reject with icmpv6 type port-unreachable;ok;reject
+reject with tcp reset;ok;ip6 nexthdr 6 reject with tcp reset
+
+reject with icmpv6 type host-unreachable;fail
+reject with icmp type host-unreachable;fail
-- 
1.7.10.4

