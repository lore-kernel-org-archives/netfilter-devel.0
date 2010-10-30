From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/11] build: avoid use of deprecated INCLUDES
Date: Sun, 31 Oct 2010 00:09:51 +0200
Message-ID: <1288476600-29859-4-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49902 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0J3WKF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:05 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

And remove unused $(all_includes).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am       |    2 +-
 src/Makefile.am   |    2 +-
 utils/Makefile.am |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index eb7d586..c6e1154 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-INCLUDES =$(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 SUBDIRS	= include src utils
 LINKOPTS = -lnfnetlink
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 62e877b..65eedf5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,7 +20,7 @@
 #
 LIBVERSION=2:0:1
 
-INCLUDES = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = -fPIC -Wall
 LIBS = @LIBNFLOG_LIBS@
 
diff --git a/utils/Makefile.am b/utils/Makefile.am
index f405dbf..b6c333b 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,4 +1,4 @@
-INCLUDES = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 
 check_PROGRAMS = nfulnl_test ulog_test
 
-- 
1.7.1

