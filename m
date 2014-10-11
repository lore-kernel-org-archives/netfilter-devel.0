From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/3] test: update and add the reject tests for ip, ip6, bridge and inet.
Date: Sat, 11 Oct 2014 16:11:12 +0200
Message-ID: <1413036673-23022-3-git-send-email-alvaroneay@gmail.com>
References: <1413036673-23022-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44486 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaJKOLB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:11:01 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so229690wiw.4
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2014 07:10:59 -0700 (PDT)
In-Reply-To: <1413036673-23022-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/regression/bridge/reject.t |    9 +++++++++
 tests/regression/inet/reject.t   |   12 ++++++++++++
 tests/regression/ip/reject.t     |    6 +++++-
 tests/regression/ip6/reject.t    |    6 +++++-
 4 files changed, 31 insertions(+), 2 deletions(-)
 create mode 100644 tests/regression/bridge/reject.t
 create mode 100644 tests/regression/inet/reject.t

diff --git a/tests/regression/bridge/reject.t b/tests/regression/bridge/reject.t
new file mode 100644
index 0000000..5676755
--- /dev/null
+++ b/tests/regression/bridge/reject.t
@@ -0,0 +1,9 @@
+*bridge;test-bridge
+:input;type filter hook input priority 0
+
+reject with icmp type host-unreachable;ok;ether type ip reject with icmp type host-unreachable
+reject with icmpv6 type no-route;ok;ether type ip6 reject with icmpv6 type no-route
+ether type ip reject with icmp type host-unreachable;ok
+ether type ip6 reject with icmp type host-unreachable;fail
+reject with icmpx type host-unreachable;ok
+reject with icmpx type no-route;ok
diff --git a/tests/regression/inet/reject.t b/tests/regression/inet/reject.t
new file mode 100644
index 0000000..6e5d593
--- /dev/null
+++ b/tests/regression/inet/reject.t
@@ -0,0 +1,12 @@
+*inet;test-inet
+:input;type filter hook input priority 0
+
+reject with icmp type host-unreachable;ok;meta nfproto ipv4 reject with icmp type host-unreachable
+reject with icmpv6 type no-route;ok;meta nfproto ipv6 reject with icmpv6 type no-route
+udp dport 9999 reject with icmpv6 type no-route;ok;meta nfproto ipv6 meta l4proto 17 udp dport 9999 reject with icmpv6 type no-route
+reject with tcp reset;ok;meta l4proto 6 reject with tcp reset
+reject;ok
+meta nfproto ipv4 reject with icmp type host-unreachable;ok
+meta nfproto ipv6 reject with icmp type host-unreachable;fail
+reject with icmpx type host-unreachable;ok
+reject with icmpx type no-route;ok
diff --git a/tests/regression/ip/reject.t b/tests/regression/ip/reject.t
index e7fb15b..13fb4a3 100644
--- a/tests/regression/ip/reject.t
+++ b/tests/regression/ip/reject.t
@@ -1,5 +1,9 @@
 *ip;test-ip4
-*ip;test-inet
 :output;type filter hook output priority 0
 
 reject;ok
+udp dport 9999 reject with icmp type host-unreachable;ok
+tcp dport 9999 reject;ok
+reject with tcp reset;ok;ip protocol 6 reject with tcp reset
+reject with icmp type no-route;fail
+reject with icmpv6 type no-route;fail
diff --git a/tests/regression/ip6/reject.t b/tests/regression/ip6/reject.t
index b49c50b..92edcb7 100644
--- a/tests/regression/ip6/reject.t
+++ b/tests/regression/ip6/reject.t
@@ -1,5 +1,9 @@
 *ip6;test-ip6
-*inet;test-inet
 :output;type filter hook output priority 0
 
 reject;ok
+reject with icmpv6 type host-unreachable;fail
+reject with icmp type host-unreachable;fail
+tcp dport 9999 reject with icmpv6 type admin-prohibited;ok
+udp dport 9999 reject;ok
+reject with tcp reset;ok;ip6 nexthdr 6 reject with tcp reset
-- 
1.7.10.4

