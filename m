From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] build: use modern call syntax for AM_INIT_AUTOMAKE
Date: Sun, 31 Oct 2010 00:49:36 +0200
Message-ID: <1288478982-6758-3-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0J3Wtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:47 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

automake options also need to definitely go into configure.ac,
otherwise they only apply to a single directory.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    3 ---
 configure.ac |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 70c1bd0..23f646c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,9 +1,6 @@
 include Make_global.am
 
-# not a GNU package. You can remove this line, if
-# have all needed files, that a GNU package needs
 ACLOCAL_AMFLAGS  = -I m4
-AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 man_MANS = conntrack.8 conntrackd.8
 EXTRA_DIST = $(man_MANS) Make_global.am doc m4
diff --git a/configure.ac b/configure.ac
index 88faede..f840a00 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT(conntrack-tools, 0.9.15, pablo@netfilter.org)
 AC_CANONICAL_SYSTEM
 
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([-Wall])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
 AM_PROG_LIBTOOL
-- 
1.7.1

