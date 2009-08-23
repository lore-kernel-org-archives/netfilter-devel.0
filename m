From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 1/3] Remove debian directory
Date: Sun, 23 Aug 2009 21:36:06 +0200
Message-ID: <1251056168-7073-2-git-send-email-chifflier@inl.fr>
References: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45402 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933868AbZHWTgd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:36:33 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 38073940128
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:29 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 50120940152
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2009 21:36:27 +0200 (CEST)
In-Reply-To: <1251056168-7073-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove Debian packaging files, it is easier to maintain the packaging
files outside of the sources.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 debian/changelog                    |    5 ---
 debian/control                      |   54 -----------------------------------
 debian/rules                        |   11 -------
 debian/ulogd-input-nfct.install     |    1 -
 debian/ulogd-input-nflog.install    |    1 -
 debian/ulogd-output-mysql.install   |    1 -
 debian/ulogd-output-pcap.install    |    1 -
 debian/ulogd-output-pgsql.install   |    1 -
 debian/ulogd-output-sqlite3.install |    1 -
 debian/ulogd.install                |   10 ------
 10 files changed, 0 insertions(+), 86 deletions(-)
 delete mode 100644 debian/changelog
 delete mode 100644 debian/control
 delete mode 100755 debian/rules
 delete mode 100644 debian/ulogd-input-nfct.install
 delete mode 100644 debian/ulogd-input-nflog.install
 delete mode 100644 debian/ulogd-output-mysql.install
 delete mode 100644 debian/ulogd-output-pcap.install
 delete mode 100644 debian/ulogd-output-pgsql.install
 delete mode 100644 debian/ulogd-output-sqlite3.install
 delete mode 100644 debian/ulogd.install

diff --git a/debian/changelog b/debian/changelog
deleted file mode 100644
index d71ceba..0000000
--- a/debian/changelog
+++ /dev/null
@@ -1,5 +0,0 @@
-ulogd (2.00beta1) unstable; urgency=low
-
-  * initial debian release
-
- -- Harald Welte <laforge@netfilter.org>  Sat, 07 Jan 2006 15:55:51 +0100
diff --git a/debian/control b/debian/control
deleted file mode 100644
index 0118862..0000000
--- a/debian/control
+++ /dev/null
@@ -1,54 +0,0 @@
-Source: ulogd
-Section: net
-Priority: optional
-Maintainer: Harald Welte <laforge@netfilter.org>
-Build-Depends: cdbs (>= 0.4), debhelper (>= 4.2), gcc (>= 3.4), libnfnetlink-dev (>= 0.0.13), libnetfilter-conntrack-dev (>= 0.0.28), libnetfilter-log-dev (>= 0.0.12), libmysqlclient-dev, libpq-dev, libpcap-dev, libsqlite-dev
-Standards-Version: 3.6.2
-
-Package: ulogd
-Architecture: any
-Depends: ${shlibs:Depends}
-Description: Userspace logging daemon for netfilter/iptables
-
-Package: ulogd-output-pgsql
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- The userspace connection tracking table administration program.
- .
- This package provides the PostgreSQL output plugin.
-
-Package: ulogd-output-mysql
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- .
- This package provides the MySQL output plugin.
-
-Package: ulogd-output-pcap
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- .
- This package provides the PCAP output plugin.
-
-Package: ulogd-output-sqlite3
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- .
- This package provides the SQLITE3 output plugin.
-
-Package: ulogd-input-nflog
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- .
- This package provides the NFLOG input plugin.
-
-Package: ulogd-input-nfct
-Architecture: any
-Depends: ${shlibs:Depends}, ulogd (= ${Source-Version})
-Description: Userspace logging daemon for netfilter/iptables
- .
- This package provides the conntrack_netlink input plugin.
diff --git a/debian/rules b/debian/rules
deleted file mode 100755
index 138a976..0000000
--- a/debian/rules
+++ /dev/null
@@ -1,11 +0,0 @@
-#!/usr/bin/make -f
-# -*- mode: makefile; coding: utf-8 -*-
-
-UPSTREAM_VERSION := $(shell dpkg-parsechangelog | egrep '^Version:' | cut -f2 -d' ' | cut -f1 -d-)
-DEB_TARBALL := ulogd-$(UPSTREAM_VERSION).tar.bz2
-DEB_TAR_SRCDIR := ulogd-$(UPSTREAM_VERSION)
-
-include /usr/share/cdbs/1/rules/debhelper.mk
-include /usr/share/cdbs/1/class/autotools.mk
-
-DEB_DH_INSTALL_SOURCEDIR := debian/tmp
diff --git a/debian/ulogd-input-nfct.install b/debian/ulogd-input-nfct.install
deleted file mode 100644
index 4fa02c3..0000000
--- a/debian/ulogd-input-nfct.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_input_NFCT.so*
diff --git a/debian/ulogd-input-nflog.install b/debian/ulogd-input-nflog.install
deleted file mode 100644
index e99af30..0000000
--- a/debian/ulogd-input-nflog.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_input_NFLOG.so*
diff --git a/debian/ulogd-output-mysql.install b/debian/ulogd-output-mysql.install
deleted file mode 100644
index 19eb379..0000000
--- a/debian/ulogd-output-mysql.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_output_MYSQL.so*
diff --git a/debian/ulogd-output-pcap.install b/debian/ulogd-output-pcap.install
deleted file mode 100644
index de25c45..0000000
--- a/debian/ulogd-output-pcap.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_output_PCAP.so*
diff --git a/debian/ulogd-output-pgsql.install b/debian/ulogd-output-pgsql.install
deleted file mode 100644
index eddd68b..0000000
--- a/debian/ulogd-output-pgsql.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_output_PGSQL.so*
diff --git a/debian/ulogd-output-sqlite3.install b/debian/ulogd-output-sqlite3.install
deleted file mode 100644
index 9ea3344..0000000
--- a/debian/ulogd-output-sqlite3.install
+++ /dev/null
@@ -1 +0,0 @@
-usr/lib/ulogd/ulogd_output_SQLITE3.so*
diff --git a/debian/ulogd.install b/debian/ulogd.install
deleted file mode 100644
index dec8583..0000000
--- a/debian/ulogd.install
+++ /dev/null
@@ -1,10 +0,0 @@
-usr/sbin
-usr/share/man
-usr/lib/ulogd/ulogd_filter_IFINDEX.so*
-usr/lib/ulogd/ulogd_filter_PWSNIFF.so*
-usr/lib/ulogd/ulogd_inppkt_ULOG.so*
-usr/lib/ulogd/ulogd_output_IPFIX.so*
-usr/lib/ulogd/ulogd_output_LOGEMU.so*
-usr/lib/ulogd/ulogd_output_OPRINT.so*
-usr/lib/ulogd/ulogd_output_SYSLOG.so*
-usr/lib/ulogd/ulogd_raw2packet_BASE.so*
-- 
1.6.3.3

