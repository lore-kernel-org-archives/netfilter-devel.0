Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F6AEB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 12:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjGRMBs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 08:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjGRMBr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 08:01:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAF331AC
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 05:01:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     arturo@netfilter.org, jengelh@inai.de
Subject: [PATCH nft 2/2] py: remove setup.py integration with autotools
Date:   Tue, 18 Jul 2023 14:01:19 +0200
Message-Id: <20230718120119.172757-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230718120119.172757-1-pablo@netfilter.org>
References: <20230718120119.172757-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With Python distutils and setuptools going deprecated, remove
integration with autotools. This integration is causing issues
in modern environments.

Note that setup.py is still left in place under the py/ folder.

Update INSTALL file to refer to Python support and setup.py.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 INSTALL        |  7 +++++++
 Makefile.am    |  6 ++----
 configure.ac   | 26 --------------------------
 py/Makefile.am | 27 ---------------------------
 4 files changed, 9 insertions(+), 57 deletions(-)

diff --git a/INSTALL b/INSTALL
index 9a597057ae3e..9b626745d7a4 100644
--- a/INSTALL
+++ b/INSTALL
@@ -81,6 +81,13 @@ Installation instructions for nftables
  Run "make" to compile nftables, "make install" to install it in the
  configured paths.
 
+ Python support
+ ==============
+
+ CPython bindings are available for nftables under the py/ folder.
+
+ setup.py is provided to install it.
+
  Source code
  ===========
 
diff --git a/Makefile.am b/Makefile.am
index 72fb4e88012d..84c3c366b86a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,10 +4,8 @@ SUBDIRS = 	src	\
 		include	\
 		files	\
 		doc	\
-		examples
-if HAVE_PYTHON
-SUBDIRS += py
-endif
+		examples\
+		py
 
 EXTRA_DIST =	tests	\
 		files
diff --git a/configure.ac b/configure.ac
index adb782667438..b0201ac3528e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -108,25 +108,6 @@ AC_DEFINE([HAVE_LIBJANSSON], [1], [Define if you have libjansson])
 ])
 AM_CONDITIONAL([BUILD_JSON], [test "x$with_json" != xno])
 
-AC_ARG_ENABLE(python,
-       AS_HELP_STRING([--enable-python], [Enable python]),,[enable_python=check]
-       )
-
-AC_ARG_WITH([python_bin],
-            [AS_HELP_STRING([--with-python-bin], [Specify Python binary to use])],
-	    [PYTHON_BIN="$withval"], [AC_PATH_PROGS(PYTHON_BIN, python python2 python2.7 python3)]
-	   )
-
-AS_IF([test "x$PYTHON_BIN" = "x"], [
-	AS_IF([test "x$enable_python" = "xyes"], [AC_MSG_ERROR([Python asked but not found])],
-	[test "x$enable_python" = "xcheck"], [
-		AC_MSG_WARN([Python not found, continuing anyway])
-		enable_python=no
-	])
-])
-
-AM_CONDITIONAL([HAVE_PYTHON], [test "$enable_python" != "no"])
-
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
@@ -157,10 +138,3 @@ nft configuration:
   enable man page:              ${enable_man_doc}
   libxtables support:		${with_xtables}
   json output support:          ${with_json}"
-
-AS_IF([test "$enable_python" != "no"], [
-	echo "  enable Python:		yes (with $PYTHON_BIN)"
-	], [
-	echo "  enable Python:		no"
-	]
-	)
diff --git a/py/Makefile.am b/py/Makefile.am
index 215ecd9e4751..f10ae360599f 100644
--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -1,28 +1 @@
 EXTRA_DIST = setup.py __init__.py nftables.py schema.json
-
-all-local:
-	cd $(srcdir) && \
-		$(PYTHON_BIN) setup.py build --build-base $(abs_builddir)
-
-install-exec-local:
-	cd $(srcdir) && \
-		$(PYTHON_BIN) setup.py build --build-base $(abs_builddir) \
-		install --prefix $(DESTDIR)$(prefix)
-
-uninstall-local:
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/site-packages/nftables
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/dist-packages/nftables
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/site-packages/nftables-[0-9]*.egg-info
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/dist-packages/nftables-[0-9]*.egg-info
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/site-packages/nftables-[0-9]*.egg
-	rm -rf $(DESTDIR)$(prefix)/lib*/python*/dist-packages/nftables-[0-9]*.egg
-
-clean-local:
-	cd $(srcdir) && \
-		$(PYTHON_BIN) setup.py clean \
-		--build-base $(abs_builddir)
-	rm -rf scripts-* lib* build dist bdist.* nftables.egg-info
-	find . -name \*.pyc -delete
-
-distclean-local:
-	rm -f version
-- 
2.30.2

