From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] tests: regression: revisit chain tests
Date: Mon, 22 Dec 2014 13:45:50 +0100
Message-ID: <1419252350-24317-2-git-send-email-pablo@netfilter.org>
References: <1419252350-24317-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbaLVMnZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:43:25 -0500
In-Reply-To: <1419252350-24317-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure support chain don't stop working.

Remove some minor mistakes and out of scope tests from chain*.t

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/arp/chains.t    |    3 ++-
 tests/regression/bridge/chains.t |   11 ++++++-----
 tests/regression/ip/chains.t     |    7 -------
 tests/regression/ip6/chains.t    |    1 -
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/tests/regression/arp/chains.t b/tests/regression/arp/chains.t
index 6b0c042..cf08c1a 100644
--- a/tests/regression/arp/chains.t
+++ b/tests/regression/arp/chains.t
@@ -1,5 +1,6 @@
 *arp;test-arp
-- filter chains available are: input, output, forward
+
+# filter chains available are: input, output, forward
 :input;type filter hook input priority 0
 :forward;type filter hook forward priority 0
 :output;type filter hook output priority 0
diff --git a/tests/regression/bridge/chains.t b/tests/regression/bridge/chains.t
index 3fb1c89..8070de4 100644
--- a/tests/regression/bridge/chains.t
+++ b/tests/regression/bridge/chains.t
@@ -1,7 +1,8 @@
 *bridge;test-bridge
-# filter chains available are: input, output, forward
-:filter-input;type filter hook input priority 0
-:filter-forward;type filter hook forward priority 0
-:filter-output;type filter hook output priority 0
 
-- ether type 1;ok
+# filter chains available are: prerouting, input, output, forward, postrouting
+:filter-pre;type filter hook input priority 0
+:filter-output;type filter hook output priority 0
+:filter-forward;type filter hook forward priority 0
+:filter-input;type filter hook input priority 0
+:filter-post;type filter hook input priority 0
diff --git a/tests/regression/ip/chains.t b/tests/regression/ip/chains.t
index 92a1147..8edf62b 100644
--- a/tests/regression/ip/chains.t
+++ b/tests/regression/ip/chains.t
@@ -1,5 +1,4 @@
 *ip;test-ip4
--*inet;test-inet
 
 # filter chains available are: input, output, forward, prerouting, postrouting
 :filter-input;type filter hook input priority 0
@@ -14,9 +13,3 @@
 :nat-post-t;type nat hook postrouting priority 0
 # route chain available are: output
 :route-out-t;type route hook output priority 0
-
-#ip daddr 192.168.0.1-192.168.0.250;ok
-#ip daddr 192.168.0.1;ok
-#ip daddr 192.168.0.1 drop;ok
-#ip daddr 192.168.0.2 log;ok
-#ip daddr 192.168.0.2 log;ok
diff --git a/tests/regression/ip6/chains.t b/tests/regression/ip6/chains.t
index ef975b2..c1e41e4 100644
--- a/tests/regression/ip6/chains.t
+++ b/tests/regression/ip6/chains.t
@@ -1,5 +1,4 @@
 *ip6;test-ip6
--*inet;test-inet
 
 # filter chains available are: input, output, forward, forward, prerouting and postrouting.
 :filter-input;type filter hook input priority 0
-- 
1.7.10.4

