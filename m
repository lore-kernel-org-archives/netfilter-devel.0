From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] build: use -Wall across the entire source
Date: Fri, 31 Dec 2010 00:40:07 +0100
Message-ID: <1293752411-12923-3-git-send-email-jengelh@medozas.de>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50202 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0L3XkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:17 -0500
In-Reply-To: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
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
1.7.1

