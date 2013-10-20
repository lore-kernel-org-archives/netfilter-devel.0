From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: fix incorrect library versioning
Date: Sun, 20 Oct 2013 15:17:24 +0200
Message-ID: <1382275044-11654-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38466 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3JTNR0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 09:17:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v6.20~12 caused libipset to shift from libipset.so.3 to
.so.2. That is the wrong thing to do. Set it back to 3+2, as
intended.
---
 Make_global.am   | 2 +-
 lib/libipset.map | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Make_global.am b/Make_global.am
index 9c228cc..33645da 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface. 
 
 #            curr:rev:age
-LIBVERSION = 4:1:2
+LIBVERSION = 5:0:2
 
 AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
 	-I/usr/local/include
diff --git a/lib/libipset.map b/lib/libipset.map
index ab0b96f..1080f0d 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -1,3 +1,7 @@
+/*
+ * These are library version numbers in here - not to be confused
+ * with the API numbers used with libtool's -version-info string.
+ */
 LIBIPSET_1.0 {
 global:
   ipset_strlcpy;
-- 
1.8.2

