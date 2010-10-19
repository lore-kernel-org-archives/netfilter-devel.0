From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/10] build: automake options should be in AM_INIT_AUTOMAKE
Date: Tue, 19 Oct 2010 12:47:34 +0200
Message-ID: <1287485262-6562-4-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44395 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab0JSKrr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:47 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Automake options set in Makefile.am are not always propagated to
subdirecties.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    1 -
 configure.ac |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index baeae1a..35bfbe2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 ACLOCAL_AMFLAGS = -I m4
 
 SUBDIRS = src include examples
diff --git a/configure.ac b/configure.ac
index 5cbbdfd..dfdd098 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ dnl Process this file with autoconf to create configure.
 AC_INIT([libmnl], [1.0.0-beta0])
 AC_CANONICAL_SYSTEM
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6])
 
 AC_PROG_CC
 AC_EXEEXT
-- 
1.7.1

