From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: use only AC_CANONICAL_HOST
Date: Fri, 31 Dec 2010 00:43:26 +0100
Message-ID: <1293752607-13822-3-git-send-email-jengelh@medozas.de>
References: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43848 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xnb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:43:31 -0500
In-Reply-To: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Calculating AC_CANONICAL_TARGET is superfluous, because libmnl
is not a code generator.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 819cbf7..82a6ce4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libmnl], [1.0.1])
-AC_CANONICAL_TARGET
+AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
@@ -12,7 +12,7 @@ AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
-case $target in 
+case "$host" in
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
-- 
1.7.1

