Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2278C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiAZWtl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiAZWtk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:49:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F99C06161C
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 14:49:40 -0800 (PST)
Received: from localhost ([::1]:59150 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nCr6f-0002Ra-Ge; Wed, 26 Jan 2022 23:49:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] Merge nfct tool into conntrackd
Date:   Wed, 26 Jan 2022 23:49:30 +0100
Message-Id: <20220126224930.31730-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both programs dynamically load ct_helper libraries but since conntrackd
provides symbols some libraries need and nfct does not, the latter must
rely on lazy binding. This in turn is problematic with some
distributions' security policies.

One could export those symbols into a library and link nfct against it
and what else is missing, but this solution is much simpler.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac    |  3 ---
 include/nfct.h  |  2 ++
 src/Makefile.am | 42 +++++++++++++++---------------------------
 src/main.c      |  5 +++++
 src/nfct.c      |  2 +-
 5 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/configure.ac b/configure.ac
index b12b722a3396d..58d90da740a34 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,9 +77,6 @@ AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabib
 AC_CHECK_HEADERS(arpa/inet.h)
 AC_CHECK_FUNCS(inet_pton)
 
-# Let nfct use dlopen() on helper libraries without resolving all symbols.
-AX_CHECK_LINK_FLAG([-Wl,-z,lazy], [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
-
 if test ! -z "$libdir"; then
 	MODULE_DIR="\\\"$libdir/conntrack-tools/\\\""
 	CFLAGS="$CFLAGS -DCONNTRACKD_LIB_DIR=$MODULE_DIR"
diff --git a/include/nfct.h b/include/nfct.h
index bfffdd6fa909f..103fcfab9f954 100644
--- a/include/nfct.h
+++ b/include/nfct.h
@@ -43,4 +43,6 @@ int nfct_mnl_talk(struct mnl_socket *nl, struct nlmsghdr *nlh,
 		  int (*cb)(const struct nlmsghdr *nlh, void *data),
 		  void *data);
 
+int nfct_main(int argc, char *argv[]);
+
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 1d56394698a68..1f49f9e0f74f3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,35 +8,11 @@ AM_YFLAGS = -d
 
 BUILT_SOURCES = read_config_yy.h
 
-sbin_PROGRAMS = conntrack conntrackd nfct
+sbin_PROGRAMS = conntrack conntrackd
 
 conntrack_SOURCES = conntrack.c
 conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS} ${LIBMNL_LIBS} ${LIBNFNETLINK_LIBS}
 
-nfct_SOURCES = nfct.c
-
-if HAVE_CTHELPER
-nfct_SOURCES += helpers.c			\
-		nfct-extensions/helper.c
-endif
-
-if HAVE_CTTIMEOUT
-nfct_SOURCES += nfct-extensions/timeout.c
-endif
-
-nfct_LDADD = ${LIBMNL_LIBS} 			\
-	     ${libdl_LIBS}
-
-if HAVE_CTTIMEOUT
-nfct_LDADD += ${LIBNETFILTER_CTTIMEOUT_LIBS}
-endif
-
-if HAVE_CTHELPER
-nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
-endif
-
-nfct_LDFLAGS = -export-dynamic ${LAZY_LDFLAGS}
-
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
 		    filter.c fds.c event.c process.c origin.c date.c \
@@ -52,10 +28,15 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    external_cache.c external_inject.c \
 		    internal_cache.c internal_bypass.c \
 		    read_config_yy.y read_config_lex.l \
-		    stack.c resync.c
+		    stack.c resync.c nfct.c
 
 if HAVE_CTHELPER
-conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c
+conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c \
+		      nfct-extensions/helper.c
+endif
+
+if HAVE_CTTIMEOUT
+conntrackd_SOURCES += nfct-extensions/timeout.c
 endif
 
 if HAVE_SYSTEMD
@@ -72,8 +53,15 @@ if HAVE_CTHELPER
 conntrackd_LDADD += ${LIBNETFILTER_CTHELPER_LIBS} ${LIBNETFILTER_QUEUE_LIBS}
 endif
 
+if HAVE_CTTIMEOUT
+conntrackd_LDADD += ${LIBNETFILTER_CTTIMEOUT_LIBS}
+endif
+
 if HAVE_SYSTEMD
 conntrackd_LDADD += ${LIBSYSTEMD_LIBS}
 endif
 
 conntrackd_LDFLAGS = -export-dynamic
+
+install-exec-hook:
+	ln -s -f conntrackd "${DESTDIR}${sbindir}/nfct"
diff --git a/src/main.c b/src/main.c
index 31e0eed950b48..63e2a8c51c3fd 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,6 +20,7 @@
 #include "conntrackd.h"
 #include "log.h"
 #include "helper.h"
+#include "nfct.h"
 #include "systemd.h"
 #include "resync.h"
 
@@ -32,6 +33,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <libgen.h>
 
 struct ct_general_state st;
 struct ct_state state;
@@ -126,6 +128,9 @@ int main(int argc, char *argv[])
 	struct utsname u;
 	int version, major, minor;
 
+	if (!strcmp(basename(argv[0]), "nfct"))
+		return nfct_main(argc, argv);
+
 	/* Check kernel version: it must be >= 2.6.18 */
 	if (uname(&u) == -1) {
 		dlog(LOG_ERR, "Can't retrieve kernel version via uname()");
diff --git a/src/nfct.c b/src/nfct.c
index 27841be38e961..09527a8dede9a 100644
--- a/src/nfct.c
+++ b/src/nfct.c
@@ -119,7 +119,7 @@ static int nfct_subsys_error(char *argv[])
 	return EXIT_FAILURE;
 }
 
-int main(int argc, char *argv[])
+int nfct_main(int argc, char *argv[])
 {
 	int subsys, cmd, ret = 0;
 	struct nfct_extension *ext;
-- 
2.34.1

