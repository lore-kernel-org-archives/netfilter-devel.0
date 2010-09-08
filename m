From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
Date: Thu,  9 Sep 2010 01:32:37 +0200
Message-ID: <1283988763-1577-3-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0IHXcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:47 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
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
index 80294cc..3878a8d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
-
 ACLOCAL_AMFLAGS = -I m4
 
 SUBDIRS	= include src utils qa
diff --git a/configure.ac b/configure.ac
index ae61ba0..eda4c14 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,10 +1,10 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT
+AC_INIT([libnetfilter_conntrack], [0.9.0])
 AC_CANONICAL_SYSTEM
 AC_CONFIG_MACRO_DIR([m4])
 
-AM_INIT_AUTOMAKE(libnetfilter_conntrack, 0.9.0)
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
 AM_PROG_LIBTOOL
-- 
1.7.1

