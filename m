From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] src: put include files into their own directory
Date: Mon,  3 Oct 2011 22:10:09 +0200
Message-ID: <1317672610-29855-4-git-send-email-jengelh@medozas.de>
References: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48176 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1JCUKp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:10:45 -0400
In-Reply-To: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is better when include files get their own directory, i.e. in this
case, utils.h will go to /usr/include/libsnet, where it is less prone
to clashes than in /usr/include.
---
 Makefile.am                      |    3 ++-
 include/{ => libsnet}/snet.h     |    0
 include/{ => libsnet}/snet_lib.h |    2 +-
 include/{ => libsnet}/sql.h      |    0
 include/{ => libsnet}/utils.h    |    0
 snet.c                           |    4 ++--
 snet_lib.c                       |    6 +++---
 utils.c                          |    4 ++--
 8 files changed, 10 insertions(+), 9 deletions(-)
 rename include/{ => libsnet}/snet.h (100%)
 rename include/{ => libsnet}/snet_lib.h (95%)
 rename include/{ => libsnet}/sql.h (100%)
 rename include/{ => libsnet}/utils.h (100%)

diff --git a/Makefile.am b/Makefile.am
index 143390a..81ac2d3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -12,7 +12,8 @@ lib_LTLIBRARIES = libsnet.la
 libsnet_la_SOURCES = snet.c snet_lib.c utils.c
 libsnet_la_LIBADD  = ${libnl_LIBS}
 
-include_HEADERS = include/snet.h include/snet_lib.h include/utils.h
+pkginclude_HEADERS = include/libsnet/snet.h include/libsnet/snet_lib.h \
+                     include/libsnet/utils.h
 
 pkgconfig_DATA = libsnet.pc
 
diff --git a/include/snet.h b/include/libsnet/snet.h
similarity index 100%
rename from include/snet.h
rename to include/libsnet/snet.h
diff --git a/include/snet_lib.h b/include/libsnet/snet_lib.h
similarity index 95%
rename from include/snet_lib.h
rename to include/libsnet/snet_lib.h
index b01fffd..61ee09f 100644
--- a/include/snet_lib.h
+++ b/include/libsnet/snet_lib.h
@@ -1,7 +1,7 @@
 #ifndef _SNET_LIB_H
 #define _SNET_LIB_H
 
-#include <snet.h>
+#include <libsnet/snet.h>
 #include <netlink/netlink.h>
 
 struct snet_lib {
diff --git a/include/sql.h b/include/libsnet/sql.h
similarity index 100%
rename from include/sql.h
rename to include/libsnet/sql.h
diff --git a/include/utils.h b/include/libsnet/utils.h
similarity index 100%
rename from include/utils.h
rename to include/libsnet/utils.h
diff --git a/snet.c b/snet.c
index ff5267a..5a4e4f0 100644
--- a/snet.c
+++ b/snet.c
@@ -20,12 +20,12 @@
 #include <netlink/genl/ctrl.h>
 #include <netlink/netlink.h>
 #include <netlink/utils.h>
-#include <snet.h>
+#include <libsnet/snet.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <netdb.h>
-#include <utils.h>
+#include <libsnet/utils.h>
 
 extern int nl_debug;
 extern FILE *fout;
diff --git a/snet_lib.c b/snet_lib.c
index 97fd44c..5b5a6e9 100644
--- a/snet_lib.c
+++ b/snet_lib.c
@@ -1,7 +1,7 @@
 #include <stdio.h>
-#include <snet.h>
-#include <snet_lib.h>
-#include <utils.h>
+#include <libsnet/snet.h>
+#include <libsnet/snet_lib.h>
+#include <libsnet/utils.h>
 
 int snet_attach(struct snet_lib *sl,
 		unsigned int (*snet_cb)(uint32_t, uint8_t, uint8_t,
diff --git a/utils.c b/utils.c
index 87572f6..cfca08f 100644
--- a/utils.c
+++ b/utils.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
-#include <utils.h>
-#include <snet.h>
+#include <libsnet/utils.h>
+#include <libsnet/snet.h>
 #include <fcntl.h>
 #include <unistd.h>
 
-- 
1.7.3.4

