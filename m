Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57444C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 328A72146E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfCTHGL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:06:11 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36628 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfCTHGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 03:06:11 -0400
Received: from localhost ([::1]:49718 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h6VIf-00025v-Cy; Wed, 20 Mar 2019 08:06:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH 2/3] Allow customizing lockfile location at configure time
Date:   Tue, 19 Mar 2019 20:09:37 +0100
Message-Id: <20190319190938.20751-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190319190938.20751-1-phil@nwl.cc>
References: <20190319190938.20751-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Users may pass LOCKFILE=/some/path/to/file when calling configure to
make libebtc use that path for its lockfile.

To simplify things, drop LOCKDIR completely and instead call dirname()
when trying to create the parent directory.

Given that we always define LOCKFILE via compiler flag, drop the
fallback define from libebtc.c.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am  | 4 +---
 configure.ac | 3 +++
 libebtc.c    | 7 ++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 59ae595ee16de..53fcbadbca7b4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,8 +5,6 @@
 PROGNAME = ${PACKAGE_NAME}
 PROGVERSION = ${PACKAGE_VERSION}
 PROGDATE = December\ 2011
-LOCKDIR = /var/lib/ebtables
-LOCKFILE = ${LOCKDIR}/lock
 INITDIR = /etc/rc.d/init.d
 initddir = ${INITDIR}
 sysconfigdir = ${sysconfdir}/sysconfig
@@ -21,7 +19,7 @@ AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include \
 	-DPROGVERSION=\"${PACKAGE_VERSION}\" -DPROGNAME=\"${PACKAGE_NAME}\" \
 	-DPROGDATE=\"${PROGDATE}\" \
 	-D_PATH_ETHERTYPES=\"${sysconfdir}/ethertypes\" \
-	-DLOCKFILE=\"${LOCKFILE}\" -DLOCKDIR=\"${LOCKDIR}\" \
+	-DLOCKFILE=\"${LOCKFILE}\" \
 	-DEBTD_ARGC_MAX=${EBTD_ARGC_MAX} -DEBTD_CMDLINE_MAXLN=${EBTD_CMDLINE_MAXLN} \
 	-DEBTD_PIPE=\"${PIPE}\" -DEBTD_PIPE_DIR=\"${PIPE_DIR}\"
 AM_CFLAGS = ${regular_CFLAGS}
diff --git a/configure.ac b/configure.ac
index a3bc3c93a279f..00d97734ff9a9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,6 +10,9 @@ AC_DISABLE_STATIC
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 AM_PROG_LIBTOOL
 
+AC_ARG_VAR([LOCKFILE], [Custom libebtc lockfile path (default: /var/lib/ebtables/lock)])
+AS_IF([test "x$LOCKFILE" = x], [LOCKFILE="/var/lib/ebtables/lock"])
+
 regular_CFLAGS="-Wall -Wunused"
 regular_CPPFLAGS=""
 case "$host" in
diff --git a/libebtc.c b/libebtc.c
index 92fd76485c723..f2a2b500ea751 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -36,6 +36,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <errno.h>
+#include <libgen.h>
 
 static void decrease_chain_jumps(struct ebt_u_replace *replace);
 static int iterate_entries(struct ebt_u_replace *replace, int type);
@@ -134,10 +135,6 @@ void ebt_list_extensions()
 	}
 }
 
-#ifndef LOCKFILE
-#define LOCKDIR "/var/lib/ebtables"
-#define LOCKFILE LOCKDIR"/lock"
-#endif
 int use_lockfd;
 /* Returns 0 on success, -1 when the file is locked by another process
  * or -2 on any other error. */
@@ -148,7 +145,7 @@ static int lock_file()
 retry:
 	fd = open(LOCKFILE, O_CREAT, 00600);
 	if (fd < 0) {
-		if (try == 1 || mkdir(LOCKDIR, 00700))
+		if (try == 1 || mkdir(dirname(LOCKFILE), 00700))
 			return -2;
 		try = 1;
 		goto retry;
-- 
2.21.0

