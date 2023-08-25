Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE8BEE49AD
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbjHYLct (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244527AbjHYLcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E0226B8
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwRuykNJKoeT6QGi9QJmVNorD8JcvB3rqPU5htEtThc=;
        b=DwHjnfKT0u+VWZ136ENdwK6PUULEubTYWE7w791GRshE8yDhTT4TcUwL0MO/uwR6GfnuI/
        eyxqjPpCFuwApguaPJ1Cy+ymHSV+trebpHbhhYpI70f/DASDJdpnnYj3I2e+69oRpmSJu9
        PKkLwCBhgyW75KAl6B6FXRg5Le9sd1I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-684-hMfp6OIsOmaNTrIbnMGbxQ-1; Fri, 25 Aug 2023 07:30:54 -0400
X-MC-Unique: hMfp6OIsOmaNTrIbnMGbxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1746B1C0725A
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 886AE40D2839;
        Fri, 25 Aug 2023 11:30:53 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/6] build: drop recursive make for "include/**/Makefile.am"
Date:   Fri, 25 Aug 2023 13:27:33 +0200
Message-ID: <20230825113042.2607496-2-thaller@redhat.com>
In-Reply-To: <20230825113042.2607496-1-thaller@redhat.com>
References: <20230825113042.2607496-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Switch from recursive make to a single toplevel Makefile. This is the
first step, the following patches will complete this.

Unlike meson's subdir() or C's #include, automake's SUBDIRS= does not
include a Makefile. Instead, it calls `make -C $dir`.

  https://www.gnu.org/software/make/manual/html_node/Recursion.html
  https://www.gnu.org/software/automake/manual/html_node/Subdirectories.html

This has several problems, which we an avoid with a single Makefile:

- recursive make is harder to maintain and understand as a whole.
  Recursive make makes sense, when there are truly independent
  sub-projects. Which is not the case here. The project needs to be
  considered as a whole and not one directory at a time. When
  we add unit tests (which we should), those would reside in separate
  directories but have dependencies between directories. With a single
  Makefile, we see all at once. There is a certain complexity to the build
  setup, that complexity is not automatically reduced by splitting it into
  more files. On the contrary it helps to have it all at once place,
  provided that it's still sensibly structured, named and organized.

- typing `make` prints irrelevant "Entering directory" messages. So much
  so, that at the end of the build, the terminal is filled with such
  messages and we have to scroll to see what happened.

- with recursive make, during build we see:

    make[3]: Entering directory '.../nftables/src'
      CC       meta.lo
    meta.c:13:2: error: #warning hello test [-Werror=cpp]
       13 | #warning hello test
          |  ^~~~~~~

  With a single Makefile we get

      CC       src/meta.lo
    src/meta.c:13:2: error: #warning hello test [-Werror=cpp]
       13 | #warning hello test
          |  ^~~~~~~

  This shows the full filename, assuming that the developer works from
  the top level directory. The full name is useful, for example to
  copy+paste into the terminal.

- single Makefile is also faster:

    $ make && perf stat -r 200 -B make -j

  I measure 35msec vs. 80msec.

- recursive make limits parallel make. You have to craft the SUBDIRS= in
  the correct order. The dependencies between directories are limited,
  as make only sees "LDADD = $(top_builddir)/src/libnftables.la" and
  not the deeper dependencies for the library.

- I presume, some people like recursive make because of `make -C $subdir`
  to only rebuild one directory. Rebuilding the entire tree is very
  fast, so this feature seems not relevant. Also, as dependency handling
  is limited, we might wrongly not rebuild a target. For example,

        make check
        touch src/meta.c
        make -C examples check

  does not rebuild "examples/nft-json-file".
  What we now can do with single Makefile (and better than before), is
  `make examples/nft-json-file`, which works as desired.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am                                | 74 +++++++++++++++++++++-
 configure.ac                               |  8 ---
 include/Makefile.am                        | 42 ------------
 include/linux/Makefile.am                  | 12 ----
 include/linux/netfilter/Makefile.am        | 10 ---
 include/linux/netfilter_arp/Makefile.am    |  1 -
 include/linux/netfilter_bridge/Makefile.am |  1 -
 include/linux/netfilter_ipv4/Makefile.am   |  1 -
 include/linux/netfilter_ipv6/Makefile.am   |  1 -
 include/nftables/Makefile.am               |  1 -
 10 files changed, 71 insertions(+), 80 deletions(-)
 delete mode 100644 include/Makefile.am
 delete mode 100644 include/linux/Makefile.am
 delete mode 100644 include/linux/netfilter/Makefile.am
 delete mode 100644 include/linux/netfilter_arp/Makefile.am
 delete mode 100644 include/linux/netfilter_bridge/Makefile.am
 delete mode 100644 include/linux/netfilter_ipv4/Makefile.am
 delete mode 100644 include/linux/netfilter_ipv6/Makefile.am
 delete mode 100644 include/nftables/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 84c3c366b86a..2be6329275e0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,75 @@
-ACLOCAL_AMFLAGS	= -I m4
+ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = 	src	\
-		include	\
+pkginclude_HEADERS = \
+	include/nftables/libnftables.h \
+	$(NULL)
+
+noinst_HEADERS = \
+	\
+	include/linux/netfilter.h \
+	include/linux/netfilter/nf_conntrack_common.h \
+	include/linux/netfilter/nf_conntrack_tuple_common.h \
+	include/linux/netfilter/nf_log.h \
+	include/linux/netfilter/nf_nat.h \
+	include/linux/netfilter/nf_synproxy.h \
+	include/linux/netfilter/nf_tables.h \
+	include/linux/netfilter/nf_tables_compat.h \
+	include/linux/netfilter/nfnetlink.h \
+	include/linux/netfilter/nfnetlink_hook.h \
+	include/linux/netfilter/nfnetlink_osf.h \
+	include/linux/netfilter_arp.h \
+	include/linux/netfilter_arp/arp_tables.h \
+	include/linux/netfilter_bridge.h \
+	include/linux/netfilter_bridge/ebtables.h \
+	include/linux/netfilter_decnet.h \
+	include/linux/netfilter_ipv4.h \
+	include/linux/netfilter_ipv4/ip_tables.h \
+	include/linux/netfilter_ipv6.h \
+	include/linux/netfilter_ipv6/ip6_tables.h \
+	\
+	include/cache.h \
+	include/cli.h \
+	include/cmd.h \
+	include/ct.h \
+	include/datatype.h \
+	include/dccpopt.h \
+	include/erec.h \
+	include/expression.h \
+	include/exthdr.h \
+	include/fib.h \
+	include/gmputil.h \
+	include/hash.h \
+	include/headers.h \
+	include/iface.h \
+	include/intervals.h \
+	include/ipopt.h \
+	include/json.h \
+	include/list.h \
+	include/meta.h \
+	include/mini-gmp.h \
+	include/misspell.h \
+	include/mnl.h \
+	include/netlink.h \
+	include/nftables.h \
+	include/numgen.h \
+	include/osf.h \
+	include/owner.h \
+	include/parser.h \
+	include/payload.h \
+	include/proto.h \
+	include/rt.h \
+	include/rule.h \
+	include/sctp_chunk.h \
+	include/socket.h \
+	include/statement.h \
+	include/tcpopt.h \
+	include/utils.h \
+	include/xfrm.h \
+	include/xt.h \
+	\
+	$(NULL)
+
+SUBDIRS =	src	\
 		files	\
 		doc	\
 		examples\
diff --git a/configure.ac b/configure.ac
index 42f0dc4cf392..ca2eaca09869 100644
--- a/configure.ac
+++ b/configure.ac
@@ -116,14 +116,6 @@ AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
 		src/Makefile				\
-		include/Makefile			\
-		include/nftables/Makefile		\
-		include/linux/Makefile			\
-		include/linux/netfilter/Makefile	\
-		include/linux/netfilter_arp/Makefile	\
-		include/linux/netfilter_bridge/Makefile	\
-		include/linux/netfilter_ipv4/Makefile	\
-		include/linux/netfilter_ipv6/Makefile	\
 		files/Makefile				\
 		files/examples/Makefile			\
 		files/nftables/Makefile			\
diff --git a/include/Makefile.am b/include/Makefile.am
deleted file mode 100644
index 1d20f404dbfe..000000000000
--- a/include/Makefile.am
+++ /dev/null
@@ -1,42 +0,0 @@
-SUBDIRS =		linux		\
-			nftables
-
-noinst_HEADERS = 	cli.h		\
-			cache.h		\
-			cmd.h		\
-			datatype.h	\
-			dccpopt.h	\
-			expression.h	\
-			fib.h		\
-			hash.h		\
-			intervals.h	\
-			ipopt.h		\
-			json.h		\
-			mini-gmp.h	\
-			gmputil.h	\
-			iface.h		\
-			mnl.h		\
-			nftables.h	\
-			payload.h	\
-			tcpopt.h	\
-			statement.h	\
-			ct.h		\
-			erec.h		\
-			exthdr.h	\
-			headers.h	\
-			list.h		\
-			meta.h		\
-			misspell.h	\
-			numgen.h	\
-			netlink.h	\
-			osf.h		\
-			owner.h		\
-			parser.h	\
-			proto.h		\
-			sctp_chunk.h	\
-			socket.h	\
-			rule.h		\
-			rt.h		\
-			utils.h		\
-			xfrm.h		\
-			xt.h
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
deleted file mode 100644
index eb9fc4e4a6bd..000000000000
--- a/include/linux/Makefile.am
+++ /dev/null
@@ -1,12 +0,0 @@
-SUBDIRS =		netfilter		\
-			netfilter_arp		\
-			netfilter_bridge	\
-			netfilter_ipv4		\
-			netfilter_ipv6
-
-noinst_HEADERS =	netfilter_arp.h		\
-			netfilter_bridge.h	\
-			netfilter_decnet.h	\
-			netfilter.h		\
-			netfilter_ipv4.h	\
-			netfilter_ipv6.h
diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
deleted file mode 100644
index 22f66a7e1ebf..000000000000
--- a/include/linux/netfilter/Makefile.am
+++ /dev/null
@@ -1,10 +0,0 @@
-noinst_HEADERS = 	nf_conntrack_common.h		\
-			nf_conntrack_tuple_common.h	\
-			nf_log.h			\
-			nf_nat.h			\
-			nf_tables.h			\
-			nf_tables_compat.h		\
-			nf_synproxy.h			\
-			nfnetlink_osf.h			\
-			nfnetlink_hook.h		\
-			nfnetlink.h
diff --git a/include/linux/netfilter_arp/Makefile.am b/include/linux/netfilter_arp/Makefile.am
deleted file mode 100644
index 0a16c1abd072..000000000000
--- a/include/linux/netfilter_arp/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =	arp_tables.h
diff --git a/include/linux/netfilter_bridge/Makefile.am b/include/linux/netfilter_bridge/Makefile.am
deleted file mode 100644
index d2e8b38b196e..000000000000
--- a/include/linux/netfilter_bridge/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =	ebtables.h
diff --git a/include/linux/netfilter_ipv4/Makefile.am b/include/linux/netfilter_ipv4/Makefile.am
deleted file mode 100644
index fec42533ab81..000000000000
--- a/include/linux/netfilter_ipv4/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =	ip_tables.h
diff --git a/include/linux/netfilter_ipv6/Makefile.am b/include/linux/netfilter_ipv6/Makefile.am
deleted file mode 100644
index bec6c3f16694..000000000000
--- a/include/linux/netfilter_ipv6/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =	ip6_tables.h
diff --git a/include/nftables/Makefile.am b/include/nftables/Makefile.am
deleted file mode 100644
index 5cfb0c6c5a92..000000000000
--- a/include/nftables/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-pkginclude_HEADERS = libnftables.h
-- 
2.41.0

