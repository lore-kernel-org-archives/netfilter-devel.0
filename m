From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] build: use delayed expansion on the user-settable variables
Date: Fri, 30 Dec 2011 02:34:59 +0100
Message-ID: <1325208902-2014-5-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40846 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1L3BfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:10 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index b088684..84c85de 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -1,26 +1,26 @@
 # -*- Makefile -*-
 
-top_builddir := @top_builddir@
-builddir     := @builddir@
-top_srcdir  := @top_srcdir@
-srcdir      := @srcdir@
-ksourcedir  := @ksourcedir@
-prefix      := @prefix@
-exec_prefix := @exec_prefix@
-libdir      := @libdir@
-libexecdir  := @libexecdir@
-xtlibdir    := @xtlibdir@
-
-CC             := @CC@
-CCLD           := ${CC}
-CFLAGS         := @CFLAGS@
-CPPFLAGS       := @CPPFLAGS@
-LDFLAGS        := @LDFLAGS@
-regular_CFLAGS := @regular_CFLAGS@
-regular_CPPFLAGS := @regular_CPPFLAGS@
-kinclude_CPPFLAGS := @kinclude_CPPFLAGS@
-
-AM_CFLAGS      := ${regular_CFLAGS}
+top_builddir = @top_builddir@
+builddir     = @builddir@
+top_srcdir   = @top_srcdir@
+srcdir       = @srcdir@
+ksourcedir   = @ksourcedir@
+prefix       = @prefix@
+exec_prefix  = @exec_prefix@
+libdir       = @libdir@
+libexecdir   = @libexecdir@
+xtlibdir     = @xtlibdir@
+
+CC                 = @CC@
+CCLD               = ${CC}
+CFLAGS             = @CFLAGS@
+CPPFLAGS           = @CPPFLAGS@
+LDFLAGS            = @LDFLAGS@
+regular_CFLAGS     = @regular_CFLAGS@
+regular_CPPFLAGS   = @regular_CPPFLAGS@
+kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
+
+AM_CFLAGS       = ${regular_CFLAGS}
 AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
-- 
1.7.3.4

