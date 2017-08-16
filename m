From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 01/16] libnftables: introduce library
Date: Wed, 16 Aug 2017 22:42:55 +0200
Message-ID: <20170816204310.3371-2-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40702 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752353AbdHPVZf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:35 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add global init and deinit functions.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 configure.ac                 |  4 ++++
 include/Makefile.am          |  2 +-
 include/nftables/Makefile.am |  2 ++
 include/nftables/nftables.h  | 20 +++++++++++++++++
 src/Makefile.am              | 26 +++++++++++++---------
 src/libnftables.c            | 53 ++++++++++++++++++++++++++++++++++++++++++++
 src/main.c                   | 27 +++-------------------
 7 files changed, 99 insertions(+), 35 deletions(-)
 create mode 100644 include/nftables/Makefile.am
 create mode 100644 include/nftables/nftables.h
 create mode 100644 src/libnftables.c

diff --git a/configure.ac b/configure.ac
index bef6c0b..91273ce 100644
--- a/configure.ac
+++ b/configure.ac
@@ -56,6 +56,9 @@ then
         exit 1
 fi
 
+AM_PROG_AR
+AM_PROG_LIBTOOL
+
 AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [docbook2x-man], [no])
 AC_CHECK_PROG(DOCBOOK2MAN, [docbook2man], [docbook2man], [no])
 AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [db2x_docbook2man], [no])
@@ -146,6 +149,7 @@ AC_CONFIG_FILES([					\
 		include/linux/netfilter_bridge/Makefile	\
 		include/linux/netfilter_ipv4/Makefile	\
 		include/linux/netfilter_ipv6/Makefile	\
+		include/nftables/Makefile		\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
diff --git a/include/Makefile.am b/include/Makefile.am
index 5dd73d8..caa6961 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS = linux
+SUBDIRS = linux nftables
 
 noinst_HEADERS = 	cli.h		\
 			datatype.h	\
diff --git a/include/nftables/Makefile.am b/include/nftables/Makefile.am
new file mode 100644
index 0000000..a14b188
--- /dev/null
+++ b/include/nftables/Makefile.am
@@ -0,0 +1,2 @@
+pkginclude_HEADERS =	nftables.h
+
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
new file mode 100644
index 0000000..4ba16f0
--- /dev/null
+++ b/include/nftables/nftables.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef LIB_NFTABLES_H
+#define LIB_NFTABLES_H
+
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+
+void nft_global_init(void);
+void nft_global_deinit(void);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 99eef7b..a340d39 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -27,8 +27,9 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
 
 BUILT_SOURCES = parser_bison.h
 
-nft_SOURCES =	main.c				\
-		rule.c				\
+lib_LTLIBRARIES = libnftables.la
+
+libnftables_la_SOURCES =	rule.c				\
 		statement.c			\
 		datatype.c			\
 		expression.c			\
@@ -54,23 +55,28 @@ nft_SOURCES =	main.c				\
 		iface.c				\
 		services.c			\
 		mergesort.c			\
+		libnftables.c			\
 		scanner.l			\
 		tcpopt.c			\
 		parser_bison.y
 
-if BUILD_CLI
-nft_SOURCES +=	cli.c
-endif
-
 if BUILD_MINIGMP
 mini-gmp.o: AM_CFLAGS += -Wno-sign-compare
 
-nft_SOURCES +=	mini-gmp.c
+libnftables_la_SOURCES +=	mini-gmp.c
 endif
 
-nft_LDADD	= ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
+nft_SOURCES = main.c
+
+if BUILD_CLI
+nft_SOURCES +=	cli.c
+endif
+
+libnftables_la_LIBADD	= ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
 
 if BUILD_XTABLES
-nft_SOURCES +=	xt.c
-nft_LDADD   +=  ${XTABLES_LIBS}
+libnftables_la_SOURCES  +=	xt.c
+libnftables_la_LIBADD   +=  ${XTABLES_LIBS}
 endif
+
+nft_LDADD		= libnftables.la
diff --git a/src/libnftables.c b/src/libnftables.c
new file mode 100644
index 0000000..215179a
--- /dev/null
+++ b/src/libnftables.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <nftables/nftables.h>
+#include <string.h>
+#include <errno.h>
+#include <nftables.h>
+#include <parser.h>
+#include <iface.h>
+#include <netlink.h>
+#include <erec.h>
+#include <libmnl/libmnl.h>
+#include <mnl.h>
+
+#include <unistd.h>
+#include <fcntl.h>
+
+
+unsigned int max_errors = 10;
+unsigned int numeric_output;
+unsigned int ip2name_output;
+unsigned int handle_output;
+#ifdef DEBUG
+unsigned int debug_level;
+#endif
+
+void nft_global_init(void)
+{
+	mark_table_init();
+	realm_table_rt_init();
+	devgroup_table_init();
+	realm_table_meta_init();
+	ct_label_table_init();
+	gmp_init();
+#ifdef HAVE_LIBXTABLES
+	xt_init();
+#endif
+}
+
+void nft_global_deinit(void)
+{
+	ct_label_table_exit();
+	realm_table_rt_exit();
+	devgroup_table_exit();
+	realm_table_meta_exit();
+	mark_table_exit();
+}
diff --git a/src/main.c b/src/main.c
index 8883959..dde3104 100644
--- a/src/main.c
+++ b/src/main.c
@@ -18,6 +18,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 
+#include <nftables/nftables.h>
 #include <nftables.h>
 #include <utils.h>
 #include <parser.h>
@@ -272,28 +273,6 @@ err1:
 	return ret;
 }
 
-void nft_init(void)
-{
-	mark_table_init();
-	realm_table_rt_init();
-	devgroup_table_init();
-	realm_table_meta_init();
-	ct_label_table_init();
-	gmp_init();
-#ifdef HAVE_LIBXTABLES
-	xt_init();
-#endif
-}
-
-void nft_exit(void)
-{
-	ct_label_table_exit();
-	realm_table_rt_exit();
-	devgroup_table_exit();
-	realm_table_meta_exit();
-	mark_table_exit();
-}
-
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -309,7 +288,7 @@ int main(int argc, char * const *argv)
 	memset(&cache, 0, sizeof(cache));
 	init_list_head(&cache.list);
 
-	nft_init();
+	nft_global_init();
 	nf_sock = netlink_open_sock();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
@@ -440,7 +419,7 @@ out:
 	cache_release(&cache);
 	iface_cache_release();
 	netlink_close_sock(nf_sock);
-	nft_exit();
+	nft_global_deinit();
 
 	return rc;
 }
-- 
2.14.1

