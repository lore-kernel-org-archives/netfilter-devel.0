Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3C1C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Feb 2022 16:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbiBHQBO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiBHQBO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Feb 2022 11:01:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398C8C061576
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Feb 2022 08:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N3SeH6aAQj3gfBHiaqBK/ak55Mdh8FXCx7SBoW8Vy0o=; b=Wuko0OkG3DDLUY2ZaAkPBLhy37
        GUFghKMRR8AWUC36WeG0q0PotnI/Q6HcrYtfrhpY5H8i/uwBnd0W+3/OhY+yGdIqMxmUGP4/ZcF43
        ZTeTvQXNkAgFSTY+JRY+ezoQZ20n4IRzTaVvT3+2njZ5JHmEng3PAMN179ImCfiDTaebO8lZ322Iv
        qkP3jyzZud4KJp7j+oyk2sdSmTingYZlIJ9Kya2NL3AIktZYA5ydA5Lvg6SfTM5Z3jPOT8kesupxo
        l9LO5daI1Kwml30SVlOIXb6nIMuEZ3iQ72+k4LZPHctNz/Z4smPpZg0QL5xXDiFQOuZUzIcQpzfxy
        mLLavasw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nHSvT-0006Va-9F; Tue, 08 Feb 2022 17:01:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] nfct: Support for non-lazy binding
Date:   Tue,  8 Feb 2022 17:01:00 +0100
Message-Id: <20220208160100.27527-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For security purposes, distributions might want to pass -Wl,-z,now
linker flags to all builds, thereby disabling lazy binding globally.

In the past, nfct relied upon lazy binding: It uses the helper objects'
parsing functions without but doesn't provide all symbols the objects
use.

Add a --disable-lazy configure option to add those missing symbols to
nfct so it may be used in those environments.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This patch supersedes the previously submitted "Merge nfct tool into
conntrackd", providing a solution which is a) optional and b) doesn't
bloat nfct-only use-cases that much.
---
 configure.ac    | 12 ++++++++++--
 src/Makefile.am |  7 +++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index b12b722a3396d..43baf8244ad64 100644
--- a/configure.ac
+++ b/configure.ac
@@ -48,6 +48,9 @@ AC_ARG_ENABLE([cttimeout],
 AC_ARG_ENABLE([systemd],
         AS_HELP_STRING([--enable-systemd], [Build systemd support]),
         [enable_systemd="$enableval"], [enable_systemd="no"])
+AC_ARG_ENABLE([lazy],
+        AS_HELP_STRING([--disable-lazy], [Disable lazy binding in nfct]),
+        [enable_lazy="$enableval"], [enable_lazy="yes"])
 
 AC_CHECK_HEADER([rpc/rpc_msg.h], [AC_SUBST([LIBTIRPC_CFLAGS],'')], [PKG_CHECK_MODULES([LIBTIRPC], [libtirpc])])
 
@@ -78,7 +81,11 @@ AC_CHECK_HEADERS(arpa/inet.h)
 AC_CHECK_FUNCS(inet_pton)
 
 # Let nfct use dlopen() on helper libraries without resolving all symbols.
-AX_CHECK_LINK_FLAG([-Wl,-z,lazy], [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
+AS_IF([test "x$enable_lazy" = "xyes"], [
+	AX_CHECK_LINK_FLAG([-Wl,-z,lazy],
+			   [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
+])
+AM_CONDITIONAL([HAVE_LAZY], [test "x$enable_lazy" = "xyes"])
 
 if test ! -z "$libdir"; then
 	MODULE_DIR="\\\"$libdir/conntrack-tools/\\\""
@@ -92,4 +99,5 @@ echo "
 conntrack-tools configuration:
   userspace conntrack helper support:	${enable_cthelper}
   conntrack timeout support:		${enable_cttimeout}
-  systemd support:			${enable_systemd}"
+  systemd support:			${enable_systemd}
+  use lazy binding:                     ${enable_lazy}"
diff --git a/src/Makefile.am b/src/Makefile.am
index 1d56394698a68..95cff7d528d44 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -18,6 +18,9 @@ nfct_SOURCES = nfct.c
 if HAVE_CTHELPER
 nfct_SOURCES += helpers.c			\
 		nfct-extensions/helper.c
+if !HAVE_LAZY
+nfct_SOURCES += expect.c utils.c
+endif
 endif
 
 if HAVE_CTTIMEOUT
@@ -33,6 +36,10 @@ endif
 
 if HAVE_CTHELPER
 nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
+if !HAVE_LAZY
+nfct_LDADD += ${LIBNETFILTER_CONNTRACK_LIBS} \
+	      ${LIBNETFILTER_QUEUE_LIBS}
+endif
 endif
 
 nfct_LDFLAGS = -export-dynamic ${LAZY_LDFLAGS}
-- 
2.34.1

