From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
Date: Sun, 31 Oct 2010 00:07:26 +0200
Message-ID: <1288476454-18451-3-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46285 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0J3WHj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:39 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

automake options also need to definitely go into configure.ac,
otherwise they only apply to a single directory.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    2 --
 configure.ac |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 91e2670..4c4400a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
-
 EXTRA_DIST = $(man_MANS)
 
 SUBDIRS = src include utils
diff --git a/configure.ac b/configure.ac
index 47f3551..cc86fe7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_INIT(libnfnetlink, 1.0.0)
 
 AC_CANONICAL_SYSTEM
 
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
 AC_EXEEXT
-- 
1.7.1

