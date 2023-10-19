Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391ACCDB482
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjJSNDI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbjJSNC4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B4E5FE4
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1rIv6k5i7Iacy3WCcR0scODbf8AJxwp35J68BiaIYU=;
        b=eAVto0HjixJqmSA1L6E9DfUE2AW3/omNKrMT0t3sihuXUF6kk3P4cmDZs1+Od5u6bhzi/e
        vmLYk/l3ksGUOLCIBGQa6xYV8XuizNuaFGKVH8Zu04FgyXB7tgJd934NYhO3cExbnqhwGU
        eDGbvTBywArE+Q5Qc4AFGwDijI6BvQ4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-uFc9LrJMO1ClHzb-YbPIDg-1; Thu, 19 Oct 2023 09:01:12 -0400
X-MC-Unique: uFc9LrJMO1ClHzb-YbPIDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D06F1C06E11
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85594503B;
        Thu, 19 Oct 2023 13:01:11 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 5/7] build: no recursive make for "src/Makefile.am"
Date:   Thu, 19 Oct 2023 15:00:04 +0200
Message-ID: <20231019130057.2719096-6-thaller@redhat.com>
In-Reply-To: <20231019130057.2719096-1-thaller@redhat.com>
References: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the Makefile.am under "src/" into the toplevel Makefile.am. This
is a step in the effort of dropping recursive make.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Make_global.am  |  21 -----
 Makefile.am     | 214 +++++++++++++++++++++++++++++++++++++++++++++++-
 configure.ac    |   1 -
 src/Makefile.am | 123 ----------------------------
 4 files changed, 213 insertions(+), 146 deletions(-)
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
index 83f25dd8574b..b89d60e32d8c 100644
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
 
@@ -76,7 +104,191 @@ noinst_HEADERS = \
 
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
+	\
+	-Waggregate-return \
+	-Wbad-function-cast \
+	-Wcast-align \
+	-Wdeclaration-after-statement \
+	-Wformat-nonliteral \
+	-Wformat-security \
+	-Winit-self \
+	-Wmissing-declarations \
+	-Wmissing-format-attribute \
+	-Wmissing-prototypes \
+	-Wsign-compare \
+	-Wstrict-prototypes \
+	-Wundef \
+	-Wunused \
+	-Wwrite-strings \
+	\
+	$(GCC_FVISIBILITY_HIDDEN) \
+	\
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
+	-Wno-implicit-function-declaration \
+	-Wno-missing-declarations \
+	-Wno-missing-prototypes \
+	-Wno-nested-externs \
+	-Wno-redundant-decls \
+	-Wno-undef \
+	-Wno-unused-but-set-variable \
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
+	src/libnftables.map \
+	\
+	src/cache.c \
+	src/cmd.c \
+	src/ct.c \
+	src/datatype.c \
+	src/dccpopt.c \
+	src/erec.c \
+	src/evaluate.c \
+	src/expression.c \
+	src/exthdr.c \
+	src/fib.c \
+	src/gmputil.c \
+	src/hash.c \
+	src/iface.c \
+	src/intervals.c \
+	src/ipopt.c \
+	src/libnftables.c \
+	src/mergesort.c \
+	src/meta.c \
+	src/misspell.c \
+	src/mnl.c \
+	src/monitor.c \
+	src/netlink.c \
+	src/netlink_delinearize.c \
+	src/netlink_linearize.c \
+	src/nfnl_osf.c \
+	src/nftutils.c \
+	src/nftutils.h \
+	src/numgen.c \
+	src/optimize.c \
+	src/osf.c \
+	src/owner.c \
+	src/payload.c \
+	src/print.c \
+	src/proto.c \
+	src/rt.c \
+	src/rule.c \
+	src/sctp_chunk.c \
+	src/segtree.c \
+	src/socket.c \
+	src/statement.c \
+	src/tcpopt.c \
+	src/utils.c \
+	src/xfrm.c \
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
index 23581f91341d..79024e49ab28 100644
--- a/configure.ac
+++ b/configure.ac
@@ -117,7 +117,6 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
-		src/Makefile				\
 		doc/Makefile				\
 		examples/Makefile			\
 		])
diff --git a/src/Makefile.am b/src/Makefile.am
deleted file mode 100644
index 63a4ef43dae3..000000000000
--- a/src/Makefile.am
+++ /dev/null
@@ -1,123 +0,0 @@
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
-		      -Wno-unused-but-set-variable \
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

