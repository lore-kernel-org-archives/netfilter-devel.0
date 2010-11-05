From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/9] build: move global automake options into configure.ac
Date: Fri,  5 Nov 2010 19:36:15 +0100
Message-ID: <1288982184-23584-2-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44390 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab0KESga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:30 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    1 -
 configure.ac |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 5965387..cf74fca 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,5 @@
 
 ACLOCAL_AMFLAGS  = -I m4
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 man_MANS = ulogd.8
 
diff --git a/configure.ac b/configure.ac
index e5a64fe..370b4b3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ dnl Process this file with autoconf to produce a configure script.
 AC_PREREQ([2.50])
 AC_INIT([ulogd], [2.0.0beta4])
 
-AM_INIT_AUTOMAKE([-Wall])
+AM_INIT_AUTOMAKE([-Wall foreign dist-bzip2 1.6])
 AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
-- 
1.7.1

