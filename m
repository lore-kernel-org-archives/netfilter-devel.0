From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 3/4] Update chain creation format.
Date: Mon, 16 Sep 2013 18:27:37 +0200
Message-ID: <1379348858-29187-4-git-send-email-eric@regit.org>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37455 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3IPRHq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:07:46 -0400
In-Reply-To: <1379348858-29187-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

type keyword is now mandatory when creating a new chain. This
patc halso implement the change required following the usage of human
notation in hook.

It also suppressed non currently supported mangle chains.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 files/nftables/bridge-filter | 6 +++---
 files/nftables/ipv4-filter   | 6 +++---
 files/nftables/ipv4-mangle   | 6 +-----
 files/nftables/ipv4-nat      | 6 ++++++
 files/nftables/ipv6-filter   | 6 +++---
 files/nftables/ipv6-mangle   | 6 +-----
 files/nftables/ipv6-nat      | 6 ++++++
 7 files changed, 23 insertions(+), 19 deletions(-)
 create mode 100644 files/nftables/ipv4-nat
 create mode 100644 files/nftables/ipv6-nat

diff --git a/files/nftables/bridge-filter b/files/nftables/bridge-filter
index ca306d4..6ed303e 100644
--- a/files/nftables/bridge-filter
+++ b/files/nftables/bridge-filter
@@ -1,7 +1,7 @@
 #! nft -f
 
 table bridge filter {
-	chain input		{ hook NF_INET_LOCAL_IN		-200; }
-	chain forward		{ hook NF_INET_FORWARD		-200; }
-	chain output		{ hook NF_INET_LOCAL_OUT	200; }
+	chain input		{ table filter hook input priority -200; }
+	chain forward		{ table filter hook forward priority -200; }
+	chain output		{ table filter hook output priority 200; }
 }
diff --git a/files/nftables/ipv4-filter b/files/nftables/ipv4-filter
index 3f96214..3174e7a 100644
--- a/files/nftables/ipv4-filter
+++ b/files/nftables/ipv4-filter
@@ -1,7 +1,7 @@
 #! nft -f
 
 table filter {
-	chain input		{ hook NF_INET_LOCAL_IN		0; }
-	chain forward		{ hook NF_INET_FORWARD		0; }
-	chain output		{ hook NF_INET_LOCAL_OUT	0; }
+	chain input		{ type filter hook input priority 0; }
+	chain forward		{ type filter hook forward priority 0; }
+	chain output		{ type filter hook output priority 0; }
 }
diff --git a/files/nftables/ipv4-mangle b/files/nftables/ipv4-mangle
index 339cace..27327d3 100644
--- a/files/nftables/ipv4-mangle
+++ b/files/nftables/ipv4-mangle
@@ -1,9 +1,5 @@
 #! nft -f
 
 table mangle {
-	chain prerouting	{ hook NF_INET_PRE_ROUTING	-150; }
-	chain input		{ hook NF_INET_LOCAL_IN		-150; }
-	chain forward		{ hook NF_INET_FORWARD		-150; }
-	chain output		{ hook NF_INET_LOCAL_OUT	-150; }
-	chain postrouting	{ hook NF_INET_POST_ROUTING	-150; }
+	chain output		{ type route hook output priority -150; }
 }
diff --git a/files/nftables/ipv4-nat b/files/nftables/ipv4-nat
new file mode 100644
index 0000000..99d6951
--- /dev/null
+++ b/files/nftables/ipv4-nat
@@ -0,0 +1,6 @@
+#! nft -f
+
+table nat {
+	chain prerouting	{ type nat hook prerouting priority -150; }
+	chain postrouting	{ type nat hook postrouting priority -150; }
+}
diff --git a/files/nftables/ipv6-filter b/files/nftables/ipv6-filter
index 9e41278..98fce02 100644
--- a/files/nftables/ipv6-filter
+++ b/files/nftables/ipv6-filter
@@ -1,7 +1,7 @@
 #! nft -f
 
 table ip6 filter {
-	chain input		{ hook NF_INET_LOCAL_IN		0; }
-	chain forward		{ hook NF_INET_FORWARD		0; }
-	chain output		{ hook NF_INET_LOCAL_OUT	0; }
+	chain input		{ type filter hook input priority 0; }
+	chain forward		{ type filter hook forward priority 0; }
+	chain output		{ type filter hook output priority 0; }
 }
diff --git a/files/nftables/ipv6-mangle b/files/nftables/ipv6-mangle
index dc18c7a..7274353 100644
--- a/files/nftables/ipv6-mangle
+++ b/files/nftables/ipv6-mangle
@@ -1,9 +1,5 @@
 #! nft -f
 
 table ip6 mangle {
-	chain prerouting	{ hook NF_INET_PRE_ROUTING	-150; }
-	chain input		{ hook NF_INET_LOCAL_IN		-150; }
-	chain forward		{ hook NF_INET_FORWARD		-150; }
-	chain output		{ hook NF_INET_LOCAL_OUT	-150; }
-	chain postrouting	{ hook NF_INET_POST_ROUTING	-150; }
+	chain output		{ type route hook output priority -150; }
 }
diff --git a/files/nftables/ipv6-nat b/files/nftables/ipv6-nat
new file mode 100644
index 0000000..33ecf9b
--- /dev/null
+++ b/files/nftables/ipv6-nat
@@ -0,0 +1,6 @@
+#! nft -f
+
+table ip6 nat {
+	chain prerouting	{ type nat hook prerouting priority -150; }
+	chain postrouting	{ type nat hook postrouting priority -150; }
+}
-- 
1.8.4.rc3

