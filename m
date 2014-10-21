From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v4] test: update and add the reject tests for ip, ip6, bridge and inet.
Date: Tue, 21 Oct 2014 16:15:46 +0200
Message-ID: <1413900946-15820-4-git-send-email-alvaroneay@gmail.com>
References: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39840 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaJUOXx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:23:53 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so1259865wib.11
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 07:23:51 -0700 (PDT)
In-Reply-To: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v4]
 * Add rules that we have to check the network context in inet and bridge tables

 tests/regression/bridge/reject.t |   35 +++++++++++++++++++++++++++++++++++
 tests/regression/inet/reject.t   |   32 ++++++++++++++++++++++++++++++++
 tests/regression/ip/reject.t     |   11 ++++++++++-
 tests/regression/ip6/reject.t    |    9 ++++++++-
 4 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 tests/regression/bridge/reject.t
 create mode 100644 tests/regression/inet/reject.t

diff --git a/tests/regression/bridge/reject.t b/tests/regression/bridge/reject.t
new file mode 100644
index 0000000..11a0f1c
--- /dev/null
+++ b/tests/regression/bridge/reject.t
@@ -0,0 +1,35 @@
+*bridge;test-bridge
+:input;type filter hook input priority 0
+
+# The output is specific for bridge family
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
+ether type vlan reject;fail
+ether type arp reject;fail
+ether type vlan reject with tcp reset;fail
+ether type arp reject with tcp reset;fail
+ip protocol udp reject with tcp reset;fail
diff --git a/tests/regression/inet/reject.t b/tests/regression/inet/reject.t
new file mode 100644
index 0000000..2f5aef3
--- /dev/null
+++ b/tests/regression/inet/reject.t
@@ -0,0 +1,32 @@
+*inet;test-inet
+:input;type filter hook input priority 0
+
+# The output is specific for inet family
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
+meta nfproto ipv4 reject with icmp type host-unreachable;ok
+meta nfproto ipv6 reject with icmpv6 type no-route;ok
+
+meta nfproto ipv6 reject with icmp type host-unreachable;fail
+meta nfproto ipv4 ip protocol icmp reject with icmpv6 type no-route;fail
+meta nfproto ipv6 ip protocol icmp reject with icmp type host-unreachable;fail
+meta l4proto udp reject with tcp reset;fail
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

