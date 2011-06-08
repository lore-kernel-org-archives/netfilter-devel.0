From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] build: re-add missing CPPFLAGS for libiptc
Date: Wed,  8 Jun 2011 12:33:49 +0200
Message-ID: <1307529230-20173-2-git-send-email-jengelh@medozas.de>
References: <1307529230-20173-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50136 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1FHKdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:33:53 -0400
In-Reply-To: <1307529230-20173-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These got lost on commit v1.4.11-12-g5c8f5b6.

Note: When /usr/include/libiptc/libiptc.h exists, this error is
masked away :-/  (IMO, #include-with-quotes "foo.h" should not
search system dirs...)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/Makefile.am |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index a7d0ea2..22c920f 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -1,5 +1,8 @@
 # -*- Makefile -*-
 
+AM_CFLAGS        = ${regular_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+
 pkgconfig_DATA      = libiptc.pc
 
 lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
-- 
1.7.3.4

