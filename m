From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] build: run AC_CANONICAL_HOST only
Date: Sun, 31 Oct 2010 00:07:30 +0200
Message-ID: <1288476454-18451-7-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46293 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:42 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no need to call AC_CANONICAL_SYSTEM when only
AC_CANONICAL_HOST is needed. Also, checking for $target is factually
incorrect, since we do not produce object code like a compiler. Use
$host, which specifies the triple/quadruple where the compiled program
is supposed to run.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index b05c7f3..91fd6d7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ dnl Process this file with autoconf to create configure.
 
 AC_INIT(libnfnetlink, 1.0.0)
 AC_CONFIG_MACRO_DIR([m4])
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_HOST
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
@@ -11,7 +11,7 @@ AC_EXEEXT
 AM_PROG_LIBTOOL
 AC_SUBST(LIBTOOL_DEPS)
 
-case $target in 
+case "$host" in 
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
-- 
1.7.1

