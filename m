From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 3/3] autotools conversion: added autotools support for the 'files' subdir.
Date: Wed, 12 Nov 2014 17:41:06 +0100
Message-ID: <1415810466-9410-4-git-send-email-giorgio.nicole@arcor.de>
References: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:58461 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbaKLQlS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:41:18 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id DF9CB35A2C0
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2014 17:41:16 +0100 (CET)
In-Reply-To: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added support to install some 'nft' scripts under '${sysconfdir}/nftables',
typically '/etc/nftables'.

Signed-off-by: Giorgio Dal Molin <giorgio.nicole@arcor.de>
---
 Makefile.am                  |  3 ++-
 configure.ac                 |  2 ++
 files/Makefile.am            |  1 +
 files/Makefile.in            |  5 -----
 files/nftables/Makefile.am   | 13 +++++++++++++
 files/nftables/bridge-filter |  2 +-
 files/nftables/inet-filter   |  2 +-
 files/nftables/ipv4-filter   |  2 +-
 files/nftables/ipv4-mangle   |  2 +-
 files/nftables/ipv4-nat      |  2 +-
 files/nftables/ipv6-filter   |  2 +-
 files/nftables/ipv6-mangle   |  2 +-
 files/nftables/ipv6-nat      |  2 +-
 13 files changed, 26 insertions(+), 14 deletions(-)
 create mode 100644 files/Makefile.am
 delete mode 100644 files/Makefile.in
 create mode 100644 files/nftables/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index b7fdc42..068009b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,4 +2,5 @@ ACLOCAL_AMFLAGS	= -I m4
 
 SUBDIRS = 	src	\
 		include	\
-		doc
+		doc	\
+		files
diff --git a/configure.ac b/configure.ac
index 7bbd86e..1525ac4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -121,6 +121,8 @@ AC_CONFIG_FILES([					\
 		include/linux/Makefile			\
 		include/linux/netfilter/Makefile	\
 		doc/Makefile				\
+		files/Makefile				\
+		files/nftables/Makefile			\
 		])
 AC_OUTPUT
 
diff --git a/files/Makefile.am b/files/Makefile.am
new file mode 100644
index 0000000..a8394c0
--- /dev/null
+++ b/files/Makefile.am
@@ -0,0 +1 @@
+SUBDIRS = nftables
diff --git a/files/Makefile.in b/files/Makefile.in
deleted file mode 100644
index dc237e2..0000000
--- a/files/Makefile.in
+++ /dev/null
@@ -1,5 +0,0 @@
-install:
-	@echo -e "  INSTALL\tfiles"
-	$(MKDIR_P) $(DESTDIR)/$(confdir)
-	$(INSTALL) -m 755 -p $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
-	$(SED) -i "s~#\! nft~#\!@sbindir@/nft~" $(DESTDIR)/$(confdir)/*
diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
new file mode 100644
index 0000000..1378e2b
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
+	${SED} -i 's|@sbindir[@]|${sbindir}/|g' ${DESTDIR}${pkgsysconfdir}/*
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
2.1.3

