From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use -Wall across the entire source
Date: Sat, 30 Jul 2011 21:11:02 +0200
Message-ID: <1312053064-2153-3-git-send-email-jengelh@medozas.de>
References: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36865 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1G3TLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:11:08 -0400
In-Reply-To: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am  |    1 +
 src/Makefile.am |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 8b406a9..f091860 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -5,3 +5,4 @@
 LIBVERSION=2:0:2
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = -Wall
diff --git a/src/Makefile.am b/src/Makefile.am
index e6bc7c4..d0098cc 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -Wall
-
 lib_LTLIBRARIES = libnfnetlink.la
 
 libnfnetlink_la_LDFLAGS = -Wc,-nostartfiles	\
-- 
1.7.3.4

