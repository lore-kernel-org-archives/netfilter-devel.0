From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] build: remove -fPIC flag
Date: Sun, 31 Oct 2010 00:08:19 +0200
Message-ID: <1288476502-18721-6-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46355 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:08 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool automatically adds PIC flags as needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am           |    2 +-
 src/conntrack/Makefile.am |    2 +-
 src/expect/Makefile.am    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 96446fb..7816f07 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,7 +6,7 @@ include $(top_srcdir)/Make_global.am
 
 SUBDIRS=conntrack expect
 
-AM_CFLAGS = -fPIC -Wall
+AM_CFLAGS = -Wall
 LIBS = @LIBNFCONNTRACK_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_conntrack.la 
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index d989d10..51d03c0 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -fPIC -Wall
+AM_CFLAGS = -Wall
 LIBS = @LIBNFCONNTRACK_LIBS@
 
 noinst_LTLIBRARIES = libnfconntrack.la 
diff --git a/src/expect/Makefile.am b/src/expect/Makefile.am
index b54e564..719ed23 100644
--- a/src/expect/Makefile.am
+++ b/src/expect/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -fPIC -Wall
+AM_CFLAGS = -Wall
 LIBS = @LIBNFCONNTRACK_LIBS@
 
 noinst_LTLIBRARIES = libnfexpect.la 
-- 
1.7.1

