From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/10] build: run AC_CANONICAL_HOST only
Date: Sun, 31 Oct 2010 00:11:10 +0200
Message-ID: <1288476676-32749-6-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49971 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab0J3WLY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:24 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no need to call AC_CANONICAL_SYSTEM when only
AC_CANONICAL_HOST is needed. Also, checking for $target is factually
incorrect, since we do not produce object code like a compiler. Use
$host, which specifies the triple/quadrople where the compiled program
is supposed to run.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3bd3e1c..7c3468b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libnetfilter_queue], [1.0.0])
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
@@ -13,7 +13,7 @@ AC_PROG_INSTALL
 
 AC_SUBST(LIBTOOL_DEPS)
 
-case $target in 
+case "$host" in
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
-- 
1.7.1

