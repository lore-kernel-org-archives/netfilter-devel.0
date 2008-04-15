From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 11] configure.ac: remove already-defined variables
Date: Tue, 15 Apr 2008 13:19:59 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804151318300.13202@fbirervta.pbzchgretzou.qr>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58994 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbYDOLUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:20:00 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit e1fea6c3f73ce6f376240bd308dea45c88cfb2e1
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Apr 15 13:17:47 2008 +0200

    configure.ac: remove already-defined variables
    
    This also fixes the inadvertent expansion of ${xtlibdir}.
---
 Makefile.am |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index bb7dc4f..dc45b66 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,8 +2,6 @@
 
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
-regular_CFLAGS  := @regular_CFLAGS@
-kinclude_CFLAGS := @kinclude_CFLAGS@
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
 if ENABLE_LIBIPQ
@@ -75,7 +73,7 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
 CLEANFILES       := iptables.8 ip6tables.8
 if ENABLE_DEVEL
 include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
-iptcdir          := ${includedir}/libiptc
+iptcdir           = ${includedir}/libiptc
 iptc_HEADERS     := include/libiptc/libxtc.h \
                     include/libiptc/ipt_kernel_headers.h
 endif
