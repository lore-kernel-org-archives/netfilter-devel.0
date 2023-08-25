Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913E4C3DA6F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjHYLcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244526AbjHYLcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66152690
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4lPNEJ5WO9iogdVTLuCsip/uZ7U2VKfiO8sT9BVuKk=;
        b=EkyZSMFrfelqf+QXjcqJu6KqtefX6mv3cKMBLlp7rauEeBjrtqe84Sw1EfoMukF1R8dEvP
        vIZ8MSTTmhor/taM7zfISF9y1Kwxw1et9WqVCjFOZKmmte5wkAK2ueaa3kMzy4WlFjfiUX
        rHzuImYGQztlNHPCz7eW3dvjzoAvo7I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-jIkMrNo5N5-yz11R6nwR5A-1; Fri, 25 Aug 2023 07:30:56 -0400
X-MC-Unique: jIkMrNo5N5-yz11R6nwR5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E021381AE60
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E18EB40C6F4C;
        Fri, 25 Aug 2023 11:30:55 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/6] build: drop recursive make for "src/Makefile.am"
Date:   Fri, 25 Aug 2023 13:27:36 +0200
Message-ID: <20230825113042.2607496-5-thaller@redhat.com>
In-Reply-To: <20230825113042.2607496-1-thaller@redhat.com>
References: <20230825113042.2607496-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Make_global.am  |  21 -----
 Makefile.am     | 209 +++++++++++++++++++++++++++++++++++++++++++++++-
 configure.ac    |   1 -
 src/Makefile.am | 122 ----------------------------
 4 files changed, 208 insertions(+), 145 deletions(-)
 delete mode 100644 Make_global.am
 delete mode 100644 src/Makefile.am

diff --git a/Make_global.am b/Make_global.am
deleted file mode 100644
index 5bb541f61388..000000000000
--- a/Make_global.am
+++ /dev/null
@@ -1,21 +0,0 @@
-# This is _NOT_ the library release version, it's an API version.
-# Extracted from Chapter 6 "Library interface versions" of the libtool docs.
-#
-# <snippet>
-# Here are a set of rules to help you update your library version information:
-#
-# 1. Start with version information of `0:0:0' for each libtool library.
-# 2. Update the version information only immediately before a public release
-# of your software. More frequent updates are unnecessary, and only guarantee
-# that the current interface number gets larger faster.
-# 3. If the library source code has changed at all since the last update,
-# then increment revision (`c:r:a' becomes `c:r+1:a').
-# 4. If any interfaces have been added, removed, or changed since the last
-# update, increment current, and set revision to 0.
-# 5. If any interfaces have been added since the last public release, then
-# increment age.
-# 6. If any interfaces have been removed since the last public release, then
-# set age to 0.
-# </snippet>
-#
-libnftables_LIBVERSION=2:0:1
diff --git a/Makefile.am b/Makefile.am
index 07d15938f479..2ad18f72dfd6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,34 @@
+# This is _NOT_ the library release version, it's an API version.
+# Extracted from Chapter 6 "Library interface versions" of the libtool docs.
+#
+# <snippet>
+# Here are a set of rules to help you update your library version information:
+#
+# 1. Start with version information of `0:0:0' for each libtool library.
+# 2. Update the version information only immediately before a public release
+# of your software. More frequent updates are unnecessary, and only guarantee
+# that the current interface number gets larger faster.
+# 3. If the library source code has changed at all since the last update,
+# then increment revision (`c:r:a' becomes `c:r+1:a').
+# 4. If any interfaces have been added, removed, or changed since the last
+# update, increment current, and set revision to 0.
+# 5. If any interfaces have been added since the last public release, then
+# increment age.
+# 6. If any interfaces have been removed since the last public release, then
+# set age to 0.
+# </snippet>
+#
+libnftables_LIBVERSION = 2:0:1
+
+###############################################################################
+
 ACLOCAL_AMFLAGS = -I m4
 
 EXTRA_DIST =
+BUILT_SOURCES =
+lib_LTLIBRARIES =
+noinst_LTLIBRARIES =
+sbin_PROGRAMS =
 
 ###############################################################################
 
@@ -75,7 +103,186 @@ noinst_HEADERS = \
 
 ###############################################################################
 
-SUBDIRS =	src	\
+AM_CPPFLAGS = \
+	"-I$(srcdir)/include" \
+	"-DDEFAULT_INCLUDE_PATH=\"${sysconfdir}\"" \
+	$(LIBMNL_CFLAGS) \
+	$(LIBNFTNL_CFLAGS) \
+	$(NULL)
+
+if BUILD_DEBUG
+AM_CPPFLAGS += -g -DDEBUG
+endif
+if BUILD_XTABLES
+AM_CPPFLAGS += $(XTABLES_CFLAGS)
+endif
+if BUILD_MINIGMP
+AM_CPPFLAGS += -DHAVE_MINIGMP
+endif
+if BUILD_JSON
+AM_CPPFLAGS += -DHAVE_JSON
+endif
+if BUILD_XTABLES
+AM_CPPFLAGS += -DHAVE_XTABLES
+endif
+
+AM_CFLAGS = \
+	-Wall \
+	-Wstrict-prototypes \
+	-Wmissing-prototypes \
+	-Wmissing-declarations	\
+	-Wdeclaration-after-statement \
+	-Wsign-compare \
+	-Winit-self \
+	-Wformat-nonliteral \
+	-Wformat-security \
+	-Wmissing-format-attribute \
+	-Wcast-align \
+	-Wundef \
+	-Wbad-function-cast \
+	-Waggregate-return \
+	-Wunused \
+	-Wwrite-strings \
+	$(GCC_FVISIBILITY_HIDDEN) \
+	$(NULL)
+
+AM_YFLAGS = -d -Wno-yacc
+
+###############################################################################
+
+BUILT_SOURCES += src/parser_bison.h
+
+# yacc and lex generate dirty code
+noinst_LTLIBRARIES += src/libparser.la
+
+src_libparser_la_SOURCES = \
+	src/parser_bison.y \
+	src/scanner.l \
+	$(NULL)
+
+src_libparser_la_CFLAGS = \
+	$(AM_CFLAGS) \
+	-Wno-missing-prototypes \
+	-Wno-missing-declarations \
+	-Wno-implicit-function-declaration \
+	-Wno-nested-externs \
+	-Wno-undef \
+	-Wno-redundant-decls \
+	$(NULL)
+
+###############################################################################
+
+if BUILD_MINIGMP
+
+noinst_LTLIBRARIES += src/libminigmp.la
+
+src_libminigmp_la_SOURCES = src/mini-gmp.c
+
+src_libminigmp_la_CFLAGS = \
+	$(AM_CFLAGS) \
+	-Wno-sign-compare \
+	$(NULL)
+
+endif
+
+###############################################################################
+
+lib_LTLIBRARIES += src/libnftables.la
+
+src_libnftables_la_SOURCES = \
+	src/rule.c \
+	src/statement.c \
+	src/cache.c \
+	src/cmd.c \
+	src/datatype.c \
+	src/expression.c \
+	src/evaluate.c \
+	src/proto.c \
+	src/payload.c \
+	src/exthdr.c \
+	src/fib.c \
+	src/hash.c \
+	src/intervals.c \
+	src/ipopt.c \
+	src/meta.c \
+	src/rt.c \
+	src/numgen.c \
+	src/ct.c \
+	src/xfrm.c \
+	src/netlink.c \
+	src/netlink_linearize.c \
+	src/netlink_delinearize.c \
+	src/misspell.c \
+	src/monitor.c \
+	src/owner.c \
+	src/segtree.c \
+	src/gmputil.c \
+	src/utils.c \
+	src/nftutils.c \
+	src/nftutils.h \
+	src/erec.c \
+	src/mnl.c \
+	src/iface.c \
+	src/mergesort.c \
+	src/optimize.c \
+	src/osf.c \
+	src/nfnl_osf.c \
+	src/tcpopt.c \
+	src/socket.c \
+	src/print.c \
+	src/sctp_chunk.c \
+	src/dccpopt.c \
+	src/libnftables.c \
+	src/libnftables.map \
+	$(NULL)
+
+src_libnftables_la_SOURCES += src/xt.c
+
+if BUILD_JSON
+src_libnftables_la_SOURCES += \
+	src/json.c \
+	src/parser_json.c \
+	$(NULL)
+endif
+
+src_libnftables_la_LDFLAGS = \
+	-version-info "${libnftables_LIBVERSION}" \
+	-Wl,--version-script="$(srcdir)/src//libnftables.map" \
+	$(NULL)
+
+src_libnftables_la_LIBADD = \
+	$(LIBMNL_LIBS) \
+	$(LIBNFTNL_LIBS) \
+	src/libparser.la \
+	$(NULL)
+
+if BUILD_MINIGMP
+src_libnftables_la_LIBADD += src/libminigmp.la
+endif
+
+if BUILD_XTABLES
+src_libnftables_la_LIBADD += $(XTABLES_LIBS)
+endif
+
+if BUILD_JSON
+src_libnftables_la_LIBADD += $(JANSSON_LIBS)
+endif
+
+###############################################################################
+
+sbin_PROGRAMS += src/nft
+
+src_nft_SOURCES = src/main.c
+
+if BUILD_CLI
+src_nft_SOURCES += src/cli.c
+endif
+
+src_nft_LDADD = src/libnftables.la
+
+###############################################################################
+
+SUBDIRS = \
 		doc	\
 		examples
 
diff --git a/configure.ac b/configure.ac
index d86be5e3fd24..739434b7f474 100644
--- a/configure.ac
+++ b/configure.ac
@@ -115,7 +115,6 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
-		src/Makefile				\
 		doc/Makefile				\
 		examples/Makefile			\
 		])
diff --git a/src/Makefile.am b/src/Makefile.am
deleted file mode 100644
index ad22a918c120..000000000000
--- a/src/Makefile.am
+++ /dev/null
@@ -1,122 +0,0 @@
-include $(top_srcdir)/Make_global.am
-
-sbin_PROGRAMS = nft
-
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" \
-		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
-if BUILD_DEBUG
-AM_CPPFLAGS += -g -DDEBUG
-endif
-if BUILD_XTABLES
-AM_CPPFLAGS += ${XTABLES_CFLAGS}
-endif
-if BUILD_MINIGMP
-AM_CPPFLAGS += -DHAVE_MINIGMP
-endif
-if BUILD_JSON
-AM_CPPFLAGS += -DHAVE_JSON
-endif
-if BUILD_XTABLES
-AM_CPPFLAGS += -DHAVE_XTABLES
-endif
-
-AM_CFLAGS = -Wall								\
-	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
-	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
-	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
-	    -Wcast-align -Wundef -Wbad-function-cast				\
-	    -Waggregate-return -Wunused -Wwrite-strings ${GCC_FVISIBILITY_HIDDEN}
-
-
-AM_YFLAGS = -d -Wno-yacc
-
-BUILT_SOURCES = parser_bison.h
-
-lib_LTLIBRARIES = libnftables.la
-
-libnftables_la_SOURCES =			\
-		rule.c				\
-		statement.c			\
-		cache.c				\
-		cmd.c				\
-		datatype.c			\
-		expression.c			\
-		evaluate.c			\
-		proto.c				\
-		payload.c			\
-		exthdr.c			\
-		fib.c				\
-		hash.c				\
-		intervals.c			\
-		ipopt.c				\
-		meta.c				\
-		rt.c				\
-		numgen.c			\
-		ct.c				\
-		xfrm.c				\
-		netlink.c			\
-		netlink_linearize.c		\
-		netlink_delinearize.c		\
-		misspell.c			\
-		monitor.c			\
-		owner.c				\
-		segtree.c			\
-		gmputil.c			\
-		utils.c				\
-		nftutils.c			\
-		nftutils.h			\
-		erec.c				\
-		mnl.c				\
-		iface.c				\
-		mergesort.c			\
-		optimize.c			\
-		osf.c				\
-		nfnl_osf.c			\
-		tcpopt.c			\
-		socket.c			\
-		print.c				\
-		sctp_chunk.c			\
-		dccpopt.c			\
-		libnftables.c			\
-		libnftables.map
-
-# yacc and lex generate dirty code
-noinst_LTLIBRARIES = libparser.la
-libparser_la_SOURCES = parser_bison.y scanner.l
-libparser_la_CFLAGS = ${AM_CFLAGS} \
-		      -Wno-missing-prototypes \
-		      -Wno-missing-declarations \
-		      -Wno-implicit-function-declaration \
-		      -Wno-nested-externs \
-		      -Wno-undef \
-		      -Wno-redundant-decls
-
-libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} libparser.la
-libnftables_la_LDFLAGS = -version-info ${libnftables_LIBVERSION} \
-			 -Wl,--version-script=$(srcdir)/libnftables.map
-
-if BUILD_MINIGMP
-noinst_LTLIBRARIES += libminigmp.la
-libminigmp_la_SOURCES = mini-gmp.c
-libminigmp_la_CFLAGS = ${AM_CFLAGS} -Wno-sign-compare
-libnftables_la_LIBADD += libminigmp.la
-endif
-
-libnftables_la_SOURCES += xt.c
-if BUILD_XTABLES
-libnftables_la_LIBADD += ${XTABLES_LIBS}
-endif
-
-nft_SOURCES = main.c
-
-if BUILD_CLI
-nft_SOURCES += cli.c
-endif
-
-if BUILD_JSON
-libnftables_la_SOURCES += json.c parser_json.c
-libnftables_la_LIBADD += ${JANSSON_LIBS}
-endif
-
-nft_LDADD = libnftables.la
-- 
2.41.0

