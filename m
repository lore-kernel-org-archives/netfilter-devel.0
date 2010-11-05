From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] Remove distro-specific parts
Date: Fri,  5 Nov 2010 18:34:15 +0100
Message-ID: <1288978456-15380-4-git-send-email-jengelh@medozas.de>
References: <1288978456-15380-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58456 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0KEReU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:34:20 -0400
In-Reply-To: <1288978456-15380-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Distributions keep their own versions anyway.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 debian/changelog                |   17 -----------------
 debian/control                  |   23 -----------------------
 debian/copyright                |    9 ---------
 debian/libnfnetlink-dev.install |    2 --
 debian/libnfnetlink0.install    |    1 -
 debian/rules                    |   17 -----------------
 6 files changed, 0 insertions(+), 69 deletions(-)
 delete mode 100644 debian/changelog
 delete mode 100644 debian/control
 delete mode 100644 debian/copyright
 delete mode 100644 debian/libnfnetlink-dev.install
 delete mode 100644 debian/libnfnetlink0.install
 delete mode 100755 debian/rules

diff --git a/debian/changelog b/debian/changelog
deleted file mode 100644
index e5e8b58..0000000
--- a/debian/changelog
+++ /dev/null
@@ -1,17 +0,0 @@
-libnfnetlink (0.0.25-1) unstable; urgency=low
-
-  * new upstream release
-
- -- Harald Welte <laforge@netfilter.org>  Thu,  8 Mar 2007 14:02:37 +0100
-
-libnfnetlink (0.0.14) unstable; urgency=low
-
-  * new upstream release
-
- -- Harald Welte <laforge@netfilter.org>  Sat, 07 Jan 2006 16:04:38 +0100
-
-libnfnetlink (0.0.13-0+pre2) unstable; urgency=low
-
-  * initial debian release
-
- -- Max Kellermann <max@duempel.org>  Sun, 27 Nov 2005 18:10:02 +0100
diff --git a/debian/control b/debian/control
deleted file mode 100644
index b3ed95a..0000000
--- a/debian/control
+++ /dev/null
@@ -1,23 +0,0 @@
-Source: libnfnetlink
-Section: libs
-Priority: optional
-Maintainer: Max Kellermann <max@duempel.org>
-Build-Depends: cdbs (>= 0.4), debhelper (>= 4.2), gcc (>= 3.4)
-Standards-Version: 3.6.2
-
-Package: libnfnetlink0
-Architecture: any
-Depends: ${shlibs:Depends}
-Description: Netfilter netlink library
- libnfnetlink is a lowlevel C library which helps accessing the
- netfilter netlink layer in the kernel.
-
-Package: libnfnetlink-dev
-Architecture: any
-Section: libdevel
-Depends: libnfnetlink0 (= ${Source-Version})
-Description: Netfilter netlink library
- libnfnetlink is a lowlevel C library which helps accessing the
- netfilter netlink layer in the kernel.
- .
- This package provides the development files.
diff --git a/debian/copyright b/debian/copyright
deleted file mode 100644
index b4bac2e..0000000
--- a/debian/copyright
+++ /dev/null
@@ -1,9 +0,0 @@
-This Debian package was created by Max Kellermann <max@duempel.org>.
-
-The upstream sources were downloaded from:
- http://ftp.netfilter.org/pub/libnfnetlink/
-
-The GNU General Public License version 2 applies to the upstream
-sources.  On Debian systems, the complete text of the GNU General
-Public License version 2 can be found in the
-/usr/share/common-licenses/GPL-2 file.
diff --git a/debian/libnfnetlink-dev.install b/debian/libnfnetlink-dev.install
deleted file mode 100644
index 5cc336f..0000000
--- a/debian/libnfnetlink-dev.install
+++ /dev/null
@@ -1,2 +0,0 @@
-usr/lib/*.{so,a,la}
-usr/include
diff --git a/debian/libnfnetlink0.install b/debian/libnfnetlink0.install
deleted file mode 100644
index 093956b..0000000
--- a/debian/libnfnetlink0.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/*.so.*
diff --git a/debian/rules b/debian/rules
deleted file mode 100755
index 54719e8..0000000
--- a/debian/rules
+++ /dev/null
@@ -1,17 +0,0 @@
-#!/usr/bin/make -f
-# -*- mode: makefile; coding: utf-8 -*-
-
-VERSION := $(shell dpkg-parsechangelog | egrep '^Version:' | cut -f2 -d' ')
-UPSTREAM_VERSION := $(shell dpkg-parsechangelog | egrep '^Version:' | cut -f2 -d' ' | cut -f1 -d-)
-DEB_TARBALL := libnfnetlink-$(UPSTREAM_VERSION).tar.bz2
-DEB_TAR_SRCDIR := libnfnetlink-$(UPSTREAM_VERSION)
-
-include /usr/share/cdbs/1/rules/debhelper.mk
-#include /usr/share/cdbs/1/rules/tarball.mk
-include /usr/share/cdbs/1/class/autotools.mk
-
-DEB_DH_INSTALL_SOURCEDIR := debian/tmp
-
-binary-install/libnfnetlink-dev::
-	mkdir -p debian/libnfnetlink-dev/usr/lib/pkgconfig/; \
-	install -m 644 libnfnetlink.pc debian/libnfnetlink-dev/usr/lib/pkgconfig/
-- 
1.7.1

