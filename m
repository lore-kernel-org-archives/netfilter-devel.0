From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v3] test: update and add the reject tests for ip, ip6, bridge and inet.
Date: Fri, 17 Oct 2014 15:13:24 +0200
Message-ID: <1413551604-11275-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48583 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaJQNNO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:13:14 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so2023929wiv.14
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 06:13:12 -0700 (PDT)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id cz3sm1661741wjb.23.2014.10.17.06.13.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Oct 2014 06:13:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* Added and fixed some rules for inet family

 tests/regression/bridge/reject.t |   31 +++++++++++++++++++++++++++++++
 tests/regression/inet/reject.t   |   29 +++++++++++++++++++++++++++++
 tests/regression/ip/reject.t     |   11 ++++++++++-
 tests/regression/ip6/reject.t    |    9 ++++++++-
 4 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100644 tests/regression/bridge/reject.t
 create mode 100644 tests/regression/inet/reject.t

diff --git a/tests/regression/bridge/reject.t b/tests/regression/bridge/reject.t
new file mode 100644
index 0000000..e5b8aa6
--- /dev/null
+++ b/tests/regression/bridge/reject.t
@@ -0,0 +1,31 @@
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
+ip protocol udp reject with tcp reset;fail
diff --git a/tests/regression/inet/reject.t b/tests/regression/inet/reject.t
new file mode 100644
index 0000000..9d2d381
--- /dev/null
+++ b/tests/regression/inet/reject.t
@@ -0,0 +1,29 @@
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

