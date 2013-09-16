From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/4] Suppress non working examples.
Date: Mon, 16 Sep 2013 18:27:36 +0200
Message-ID: <1379348858-29187-3-git-send-email-eric@regit.org>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37450 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3IPRHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:07:43 -0400
In-Reply-To: <1379348858-29187-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 files/nftables/ipv4-raw      | 6 ------
 files/nftables/ipv4-security | 7 -------
 files/nftables/ipv6-raw      | 6 ------
 files/nftables/ipv6-security | 7 -------
 4 files changed, 26 deletions(-)
 delete mode 100644 files/nftables/ipv4-raw
 delete mode 100644 files/nftables/ipv4-security
 delete mode 100644 files/nftables/ipv6-raw
 delete mode 100644 files/nftables/ipv6-security

diff --git a/files/nftables/ipv4-raw b/files/nftables/ipv4-raw
deleted file mode 100644
index 6bc2181..0000000
--- a/files/nftables/ipv4-raw
+++ /dev/null
@@ -1,6 +0,0 @@
-#! nft -f
-
-table raw {
-	chain prerouting	{ hook NF_INET_PRE_ROUTING	-300; }
-	chain output		{ hook NF_INET_LOCAL_OUT	-300; }
-}
diff --git a/files/nftables/ipv4-security b/files/nftables/ipv4-security
deleted file mode 100644
index 3ac5bd2..0000000
--- a/files/nftables/ipv4-security
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-table security {
-	chain input		{ hook NF_INET_LOCAL_IN		50; }
-	chain forward		{ hook NF_INET_FORWARD		50; }
-	chain output		{ hook NF_INET_LOCAL_OUT	50; }
-}
diff --git a/files/nftables/ipv6-raw b/files/nftables/ipv6-raw
deleted file mode 100644
index 54940ca..0000000
--- a/files/nftables/ipv6-raw
+++ /dev/null
@@ -1,6 +0,0 @@
-#! nft -f
-
-table ip6 raw {
-	chain prerouting	{ hook NF_INET_PRE_ROUTING	-2147483647; }
-	chain output		{ hook NF_INET_LOCAL_OUT	-2147483647; }
-}
diff --git a/files/nftables/ipv6-security b/files/nftables/ipv6-security
deleted file mode 100644
index f379bfd..0000000
--- a/files/nftables/ipv6-security
+++ /dev/null
@@ -1,7 +0,0 @@
-#! nft -f
-
-table ip6 security {
-	chain input		{ hook NF_INET_LOCAL_IN		50; }
-	chain forward		{ hook NF_INET_FORWARD		50; }
-	chain output		{ hook NF_INET_LOCAL_OUT	50; }
-}
-- 
1.8.4.rc3

