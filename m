Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3C8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F7061A53
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhKRRgp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 12:36:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50966 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhKRRgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 12:36:44 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AEDC064B07
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 18:31:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] configure: fall back to readline if libedit is not available
Date:   Thu, 18 Nov 2021 18:33:34 +0100
Message-Id: <20211118173334.301434-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By default, check for editline, if not present, fall back to readline.

Extend test coverage for readline.

Fixes: b4dded0ca78d ("configure: default to libedit for cli")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac             | 20 +++++++++++++-------
 tests/build/run-tests.sh |  2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index bb65f749691c..3c93fb2bf3cd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,26 +71,32 @@ AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
             [disable interactive CLI (libreadline, editline or linenoise support)])],
             [], [with_cli=editline])
 
+AS_IF([test "x$with_cli" = xeditline], [
+AC_CHECK_LIB([edit], [readline], ,
+	     [AC_MSG_WARN([No suitable version of libedit found, falling back to libreadline])
+	      with_cli=readline])
+])
 AS_IF([test "x$with_cli" = xreadline], [
 AC_CHECK_LIB([readline], [readline], ,
 	     AC_MSG_ERROR([No suitable version of libreadline found]))
-AC_DEFINE([HAVE_LIBREADLINE], [1], [])
 ],
       [test "x$with_cli" = xlinenoise], [
 AC_CHECK_LIB([linenoise], [linenoise], ,
 	     AC_MSG_ERROR([No suitable version of linenoise found]))
 AC_DEFINE([HAVE_LIBLINENOISE], [1], [])
 ],
-      [test "x$with_cli" = xeditline], [
-AC_CHECK_LIB([edit], [readline], ,
-	     AC_MSG_ERROR([No suitable version of libedit found]))
-AC_DEFINE([HAVE_LIBEDIT], [1], [])
-],
-      [test "x$with_cli" != xno], [
+      [test "x$with_cli" != xno && test "x$with_cli" != xeditline], [
 AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
+AS_IF([test "x$with_cli" = xeditline], [
+AC_DEFINE([HAVE_LIBEDIT], [1], [])
+],
+      [test "x$with_cli" = xreadline], [
+AC_DEFINE([HAVE_LIBREADLINE], [1], [])
+])
+
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
 	    [], [with_xtables=no])
diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index f78cc9019a30..c257eb008140 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -2,7 +2,7 @@
 
 log_file="`pwd`/tests.log"
 dir=../..
-argument=( --without-cli --with-cli=linenoise --with-cli=editline --enable-debug --with-mini-gmp
+argument=( --without-cli --with-cli=linenoise --with-cli=editline --with-cli=readline --enable-debug --with-mini-gmp
 	   --enable-man-doc --with-xtables --with-json)
 ok=0
 failed=0
-- 
2.30.2

