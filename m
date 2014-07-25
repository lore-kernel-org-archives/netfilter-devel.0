From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 2/8] autotool conversion: autotools support for the subdir. 'files/nftables'.
Date: Fri, 25 Jul 2014 23:52:53 +0159
Message-ID: <1406325204-23648-3-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
 <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:33415 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbaGYVyk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:54:40 -0400
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id 9969B35AEA2
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:54:38 +0200 (CEST)
In-Reply-To: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We added the marker @sbindir@ to the first line of the scripts so it
can be replaced once the scripts are installed.
---
 files/nftables/Makefile.am   | 13 +++++++++++++
 files/nftables/bridge-filter |  2 +-
 files/nftables/inet-filter   |  2 +-
 files/nftables/ipv4-filter   |  2 +-
 files/nftables/ipv4-mangle   |  2 +-
 files/nftables/ipv4-nat      |  2 +-
 files/nftables/ipv6-filter   |  2 +-
 files/nftables/ipv6-mangle   |  2 +-
 files/nftables/ipv6-nat      |  2 +-
 9 files changed, 21 insertions(+), 8 deletions(-)
 create mode 100644 files/nftables/Makefile.am

diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
new file mode 100644
index 0000000..32dced3
--- /dev/null
+++ b/files/nftables/Makefile.am
@@ -0,0 +1,13 @@
+
+pkgsysconfdir = ${sysconfdir}/nftables
+dist_pkgsysconf_DATA =	bridge-filter	\
+			inet-filter	\
+			ipv4-filter	\
+			ipv4-mangle	\
+			ipv4-nat	\
+			ipv6-filter	\
+			ipv6-mangle	\
+			ipv6-nat
+
+install-data-hook:
+	${SED} -i 's|@sbindir[@]|${sbindir}|g' ${DESTDIR}${pkgsysconfdir}/*
diff --git a/files/nftables/bridge-filter b/files/nftables/bridge-filter
index 54779c4..2add455 100644
--- a/files/nftables/bridge-filter
+++ b/files/nftables/bridge-filter
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table bridge filter {
 	chain input		{ type filter hook input priority -200; }
diff --git a/files/nftables/inet-filter b/files/nftables/inet-filter
index 9f3108f..f572db5 100644
--- a/files/nftables/inet-filter
+++ b/files/nftables/inet-filter
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table inet filter {
 	chain input		{ type filter hook input priority 0; }
diff --git a/files/nftables/ipv4-filter b/files/nftables/ipv4-filter
index 3174e7a..a4ca7f2 100644
--- a/files/nftables/ipv4-filter
+++ b/files/nftables/ipv4-filter
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table filter {
 	chain input		{ type filter hook input priority 0; }
diff --git a/files/nftables/ipv4-mangle b/files/nftables/ipv4-mangle
index 27327d3..be564a5 100644
--- a/files/nftables/ipv4-mangle
+++ b/files/nftables/ipv4-mangle
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table mangle {
 	chain output		{ type route hook output priority -150; }
diff --git a/files/nftables/ipv4-nat b/files/nftables/ipv4-nat
index 99d6951..01c6c3d 100644
--- a/files/nftables/ipv4-nat
+++ b/files/nftables/ipv4-nat
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table nat {
 	chain prerouting	{ type nat hook prerouting priority -150; }
diff --git a/files/nftables/ipv6-filter b/files/nftables/ipv6-filter
index 98fce02..ce4d7de 100644
--- a/files/nftables/ipv6-filter
+++ b/files/nftables/ipv6-filter
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table ip6 filter {
 	chain input		{ type filter hook input priority 0; }
diff --git a/files/nftables/ipv6-mangle b/files/nftables/ipv6-mangle
index 7274353..fa32402 100644
--- a/files/nftables/ipv6-mangle
+++ b/files/nftables/ipv6-mangle
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table ip6 mangle {
 	chain output		{ type route hook output priority -150; }
diff --git a/files/nftables/ipv6-nat b/files/nftables/ipv6-nat
index 33ecf9b..3f57c56 100644
--- a/files/nftables/ipv6-nat
+++ b/files/nftables/ipv6-nat
@@ -1,4 +1,4 @@
-#! nft -f
+#! @sbindir@nft -f
 
 table ip6 nat {
 	chain prerouting	{ type nat hook prerouting priority -150; }
-- 
2.0.3

