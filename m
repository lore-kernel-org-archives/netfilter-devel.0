From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] build: remove -fPIC flag
Date: Fri,  5 Nov 2010 19:36:17 +0100
Message-ID: <1288982184-23584-4-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44396 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KESg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:29 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool automatically adds PIC flags as needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 input/flow/Makefile.am   |    2 +-
 input/packet/Makefile.am |    2 +-
 libipulog/Makefile.am    |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 11bf217..c2b5f88 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -1,6 +1,6 @@
 
 AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
+AM_CFLAGS = -Wall
 
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 566b817..4dff308 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,6 +1,6 @@
 
 AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
+AM_CFLAGS = -Wall
 LIBS=
 
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
diff --git a/libipulog/Makefile.am b/libipulog/Makefile.am
index a205cc6..290f8ee 100644
--- a/libipulog/Makefile.am
+++ b/libipulog/Makefile.am
@@ -1,8 +1,6 @@
 
 AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
 
-AM_CFLAGS=-fPIC
-
 noinst_LTLIBRARIES = libipulog.la
 
 libipulog_la_SOURCES = libipulog.c
-- 
1.7.1

