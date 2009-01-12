From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:10:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120709540.21692@fbirervta.pbzchgretzou.qr>
References: <496AD8C7.2020208@trash.net> <496AD922.7050909@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57281 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZALGKF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:10:05 -0500
In-Reply-To: <496AD922.7050909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 06:46, Patrick McHardy wrote:
>

parent de2a83cb5022c429ccf1b852688481a0d8ad95e5 (v1.4.3-rc1-17-gde2a83c)
commit f38ae2530b523f2b293e19021fab8ddae9f8435b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 07:09:53 2009 +0100

build: use regular = assignments in Makefile

Resolves warnings:
Makefile.am:7: `:='-style assignments are not portable
Makefile.am:71: `:='-style assignments are not portable
etc.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fd4d93f..d5f8875 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
-SUBDIRS         := extensions
+SUBDIRS          = extensions
 if ENABLE_LIBIPQ
 SUBDIRS         += libipq
 endif
@@ -68,16 +68,16 @@ ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
 ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 ip6tables_static_LDADD      = -lm libiptc/libiptc.a extensions/libext6.a
 
-noinst_LIBRARIES := libiptc/libiptc.a
-bin_PROGRAMS     := iptables-xml
-sbin_PROGRAMS    :=
-noinst_PROGRAMS  :=
-man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
-                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
-                    ip6tables-save.8
-CLEANFILES       := iptables.8 ip6tables.8
+noinst_LIBRARIES = libiptc/libiptc.a
+bin_PROGRAMS     = iptables-xml
+sbin_PROGRAMS    =
+noinst_PROGRAMS  =
+man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
+                   iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
+                   ip6tables-save.8
+CLEANFILES       = iptables.8 ip6tables.8
 if ENABLE_DEVEL
-include_HEADERS  := include/xtables.h
+include_HEADERS  = include/xtables.h
 endif
 
 if ENABLE_STATIC
-- 
# Created with git-export-patch
