From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 5/5] tests: Update bate chain creation according to latest syntax changes
Date: Wed, 28 Aug 2013 11:33:11 +0300
Message-ID: <1377678791-7616-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab3H1IdX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:23 -0400
In-Reply-To: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adding type, plain hook's name and priority keyword.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 tests/dictionary    | 2 +-
 tests/expr-ct       | 2 +-
 tests/expr-meta     | 2 +-
 tests/family-bridge | 2 +-
 tests/family-ipv4   | 2 +-
 tests/family-ipv6   | 2 +-
 tests/obj-chain     | 2 +-
 tests/payload-ll    | 2 +-
 tests/set           | 2 +-
 tests/stmt-log      | 2 +-
 tests/verdict-maps  | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tests/dictionary b/tests/dictionary
index aad9ebe..4193529 100644
--- a/tests/dictionary
+++ b/tests/dictionary
@@ -1,7 +1,7 @@
 #! nft -f
 #
 add table ip filter
-add chain ip filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain ip filter output { type filter hook output priority 0 ; }
 
 add chain ip filter chain1
 add rule ip filter chain1 counter
diff --git a/tests/expr-ct b/tests/expr-ct
index 39f1777..1dfc7ac 100644
--- a/tests/expr-ct
+++ b/tests/expr-ct
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table ip filter
-add chain ip filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain ip filter output { type filter hook output priority 0 ; }
 
 # ct: state
 add rule ip filter output ct state new,established counter
diff --git a/tests/expr-meta b/tests/expr-meta
index da16ae4..360caa7 100644
--- a/tests/expr-meta
+++ b/tests/expr-meta
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table ip filter
-add chain ip filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain ip filter output { type filter hook output priority 0 ; }
 
 # meta: skb len
 add rule ip filter output meta length 1000 counter
diff --git a/tests/family-bridge b/tests/family-bridge
index 98b7885..c87c832 100644
--- a/tests/family-bridge
+++ b/tests/family-bridge
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table bridge filter
-add chain bridge filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain bridge filter output { type filter hook output priority 0 ; }
 
 # LL protocol
 add rule bridge filter output eth type 0x0800 counter
diff --git a/tests/family-ipv4 b/tests/family-ipv4
index e744f02..0700e16 100644
--- a/tests/family-ipv4
+++ b/tests/family-ipv4
@@ -5,7 +5,7 @@ delete chain ip filter output
 delete table filter
 
 add table ip filter
-add chain ip filter output { hook NF_INET_LOCAL_IN 0; }
+add chain ip filter output { type filter hook input priority 0; }
 
 # IP address
 add rule ip filter output ip daddr 192.168.0.1 counter
diff --git a/tests/family-ipv6 b/tests/family-ipv6
index e76b2ce..cfc740c 100644
--- a/tests/family-ipv6
+++ b/tests/family-ipv6
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table ip6 filter
-add chain ip6 filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain ip6 filter output { type filter hook output priority 0 ; }
 
 # IP address
 add rule ip6 filter output ip6 daddr 2001:6f8:974::1 counter
diff --git a/tests/obj-chain b/tests/obj-chain
index f5094bb..2bce026 100644
--- a/tests/obj-chain
+++ b/tests/obj-chain
@@ -7,7 +7,7 @@ add chain filter testchain
 delete chain filter testchain
 
 # chains: add and delete base chain
-add chain filter input { hook NF_INET_LOCAL_OUT 0 ; }
+add chain filter input { type filter hook input priority 0 ; }
 delete chain filter input
 
 # chains: can not delete chain while referenced
diff --git a/tests/payload-ll b/tests/payload-ll
index feaf587..7f5660b 100644
--- a/tests/payload-ll
+++ b/tests/payload-ll
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table ip filter
-add chain ip filter input NF_INET_LOCAL_IN 0
+add chain ip filter input { type filter hook input priority 0; }
 
 # mac source
 add rule ip filter input @ll,48,48 00:15:e9:f0:10:f8 counter
diff --git a/tests/set b/tests/set
index e2d8e49..3c040b0 100644
--- a/tests/set
+++ b/tests/set
@@ -1,7 +1,7 @@
 #! nft -f
 
 add table filter
-add chain filter output { hook NF_INET_LOCAL_OUT 0 ; }
+add chain filter output { type filter hook output priority 0 ; }
 
 # set: IP addresses
 add rule filter output ip daddr { \
diff --git a/tests/stmt-log b/tests/stmt-log
index 2153772..2ae7aae 100644
--- a/tests/stmt-log
+++ b/tests/stmt-log
@@ -1,6 +1,6 @@
 #! nft -f
 
 add table ip filter
-add chain ip filter output NF_INET_LOCAL_OUT 0
+add chain ip filter output { type filter hook output priority 0; }
 
 add rule ip filter output log saddr "prefix" group 0 counter
diff --git a/tests/verdict-maps b/tests/verdict-maps
index 25b60d1..72ef98f 100644
--- a/tests/verdict-maps
+++ b/tests/verdict-maps
@@ -2,7 +2,7 @@
 #
 
 add table ip filter
-add chain ip filter input { hook NF_INET_LOCAL_IN 0; }
+add chain ip filter input { type filter hook input priority 0; }
 
 add chain ip filter chain1
 add filter chain1 counter
-- 
1.8.3.2

