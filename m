From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] files: add arp filter and add in/output to nat skeleton
Date: Wed, 23 Aug 2017 23:41:02 +0200
Message-ID: <20170823214102.22233-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751026AbdHWVko (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 17:40:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: forgot to git-add arp-filter...

 files/nftables/Makefile.am | 3 ++-
 files/nftables/arp-filter  | 6 ++++++
 files/nftables/ipv4-nat    | 6 ++++--
 files/nftables/ipv6-nat    | 6 ++++--
 4 files changed, 16 insertions(+), 5 deletions(-)
 create mode 100644 files/nftables/arp-filter

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
diff --git a/files/nftables/arp-filter b/files/nftables/arp-filter
new file mode 100644
index 000000000000..bcabf28ad99c
--- /dev/null
+++ b/files/nftables/arp-filter
@@ -0,0 +1,6 @@
+#! @sbindir@nft -f
+
+table arp filter {
+	chain input		{ type filter hook input priority 0; }
+	chain output		{ type filter hook output priority 0; }
+}
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

