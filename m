From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/11] build: remove -fPIC flag
Date: Sun, 31 Oct 2010 00:09:55 +0200
Message-ID: <1288476600-29859-8-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49915 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0J3WKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:10 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool automatically adds PIC flags as needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 65eedf5..5668473 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -21,7 +21,7 @@
 LIBVERSION=2:0:1
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -fPIC -Wall
+AM_CFLAGS = -Wall
 LIBS = @LIBNFLOG_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
-- 
1.7.1

