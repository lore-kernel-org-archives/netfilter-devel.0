From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/10] build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
Date: Sun, 31 Oct 2010 00:11:07 +0200
Message-ID: <1288476676-32749-3-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49958 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab0J3WLU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:20 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

automake options also need to definitely go into configure.ac, otherwise
they only apply to a single directory.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    2 --
 configure.ac |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 28641f8..b4e604b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,3 @@
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
-
 ACLOCAL_AMFLAGS = -I m4
 
 EXTRA_DIST = $(man_MANS) 
diff --git a/configure.ac b/configure.ac
index a82c9f1..3bd3e1c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,10 +1,10 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT
+AC_INIT([libnetfilter_queue], [1.0.0])
 AC_CANONICAL_SYSTEM
 AC_CONFIG_MACRO_DIR([m4])
 
-AM_INIT_AUTOMAKE(libnetfilter_queue, 1.0.0)
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
 AC_EXEEXT
-- 
1.7.1

