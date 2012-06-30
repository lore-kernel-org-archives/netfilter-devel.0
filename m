From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: restore -version-info
Date: Sat, 30 Jun 2012 20:47:23 +0200
Message-ID: <1341082043-26584-2-git-send-email-jengelh@inai.de>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
 <1341082043-26584-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:48301 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2F3Sr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:47:26 -0400
In-Reply-To: <1341082043-26584-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was no noticable reason to switch to -version-number;
version-number would have also seen the use of 3:0:0, not 3:0:1.

3:0:1 only makes sense with -version-info, so put "-version-info"
back. However, since ipset-6.13 already released libipset.so.3, going
back to .so.2 might not be such a good idea, so continue using .so.3
by means of 3:0:0.

Also note that the version names in libipset.map generally are not
supposed to follow SO versions, but the program version):
IPSET_6.13 {...}.
---
 Make_global.am  |    2 +-
 lib/Makefile.am |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 4a8f61a..446c4de 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface. 
 
 #            curr:rev:age
-LIBVERSION = 3:0:1
+LIBVERSION = 3:0:0
 
 AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
 	-I/usr/local/include
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 392b5f9..fd853dd 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -19,7 +19,7 @@ lib_LTLIBRARIES = libipset.la
 
 include $(top_srcdir)/lib/Make_extra.am
 
-libipset_la_LDFLAGS = -Wl,--version-script=$(top_srcdir)/lib/libipset.map -version-number $(LIBVERSION)
+libipset_la_LDFLAGS = -Wl,--version-script=$(top_srcdir)/lib/libipset.map -version-info $(LIBVERSION)
 libipset_la_LIBADD  = ${libmnl_LIBS} $(IPSET_SETTYPE_STATIC_OBJECTS)
 libipset_la_SOURCES = \
 	data.c \
-- 
1.7.7

