From: Olivier Blin <dev@blino.org>
Subject: [PATCH] Fix link with libtool >= 2.4.4
Date: Thu,  7 Jan 2016 00:21:09 +0100
Message-ID: <1452122469-22209-2-git-send-email-dev@blino.org>
References: <1452122469-22209-1-git-send-email-dev@blino.org>
Cc: kadlec@sunserv.kfki.hu, Olivier Blin <dev@blino.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nan92-5-82-235-5-110.fbx.proxad.net ([82.235.5.110]:45414 "EHLO
	euphor.blino.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbcAFXb0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jan 2016 18:31:26 -0500
In-Reply-To: <1452122469-22209-1-git-send-email-dev@blino.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As of libtool-2.4.4, -ldl is no longer prepended to LIBS.
Since types.c needs dlopen() and dlerror(), use LIBADD_DLOPEN, as
suggested in libtool-2.4.4 release notes.
---
 lib/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 36f60b0..4a376ca 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -24,7 +24,7 @@ lib_LTLIBRARIES = libipset.la
 include $(top_srcdir)/lib/Make_extra.am
 
 libipset_la_LDFLAGS = -Wl,--version-script=$(top_srcdir)/lib/libipset.map -version-info $(LIBVERSION)
-libipset_la_LIBADD  = ${libmnl_LIBS} $(IPSET_SETTYPE_STATIC_OBJECTS)
+libipset_la_LIBADD  = ${libmnl_LIBS} $(IPSET_SETTYPE_STATIC_OBJECTS) $(LIBADD_DLOPEN)
 libipset_la_SOURCES = \
 	data.c \
 	errcode.c \
-- 
2.6.4

