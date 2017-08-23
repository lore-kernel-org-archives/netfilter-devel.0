From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] files: add arp filter and add in/output to nat skeleton
Date: Wed, 23 Aug 2017 17:56:12 +0200
Message-ID: <20170823155612.23331-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58298 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932103AbdHWPzy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 11:55:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 files/nftables/Makefile.am | 3 ++-
 files/nftables/ipv4-nat    | 6 ++++--
 files/nftables/ipv6-nat    | 6 ++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
index a4c7ac7c980b..77d5c2a66e8f 100644
--- a/files/nftables/Makefile.am
+++ b/files/nftables/Makefile.am
@@ -1,6 +1,7 @@
 
 pkgsysconfdir = ${sysconfdir}/nftables
-dist_pkgsysconf_DATA =	bridge-filter	\
+dist_pkgsysconf_DATA =	arp-filter	\
+			bridge-filter	\
 			inet-filter	\
 			ipv4-filter	\
 			ipv4-mangle	\
diff --git a/files/nftables/ipv4-nat b/files/nftables/ipv4-nat
index 01c6c3d8d6a1..130a729b1d36 100644
--- a/files/nftables/ipv4-nat
+++ b/files/nftables/ipv4-nat
@@ -1,6 +1,8 @@
 #! @sbindir@nft -f
 
 table nat {
-	chain prerouting	{ type nat hook prerouting priority -150; }
-	chain postrouting	{ type nat hook postrouting priority -150; }
+	chain prerouting	{ type nat hook prerouting priority -100; }
+	chain input		{ type nat hook input priority 100; }
+	chain output		{ type nat hook output priority -100; }
+	chain postrouting	{ type nat hook postrouting priority 100; }
 }
diff --git a/files/nftables/ipv6-nat b/files/nftables/ipv6-nat
index 3f57c56dea78..e7816860f4a7 100644
--- a/files/nftables/ipv6-nat
+++ b/files/nftables/ipv6-nat
@@ -1,6 +1,8 @@
 #! @sbindir@nft -f
 
 table ip6 nat {
-	chain prerouting	{ type nat hook prerouting priority -150; }
-	chain postrouting	{ type nat hook postrouting priority -150; }
+	chain prerouting	{ type nat hook prerouting priority -100; }
+	chain input 		{ type nat hook input priority 100; }
+	chain output  		{ type nat hook output priority -100; }
+	chain postrouting	{ type nat hook postrouting priority 100; }
 }
-- 
2.13.0

