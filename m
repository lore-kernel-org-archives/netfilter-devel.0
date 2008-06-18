From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/3] Fix compilation of input plugin when libnetfilter library are non globally available.
Date: Wed, 18 Jun 2008 17:30:11 +0200
Message-ID: <1213803013-19433-2-git-send-email-eric@inl.fr>
References: <1213803013-19433-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44493 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYFRPaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:17 -0400
In-Reply-To: <1213803013-19433-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes compilation of NFLOG and NFCT plugin when libnetfilter libraries
are installed under a non standard prefix. Include path and libs path for
libnetfilter_conntrack and libnetfilter_log were not correctly set even if
pkg-config found them.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/Makefile.am   |    3 ++-
 input/packet/Makefile.am |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 235dc9b..288d335 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -5,7 +5,8 @@ AM_CFLAGS=-fPIC -Wall
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
-ulogd_inpflow_NFCT_la_LDFLAGS = -module -lnetfilter_conntrack
+ulogd_inpflow_NFCT_la_LDFLAGS = -module $(LIBNETFILTER_CONNTRACK_LIBS)
+ulogd_inpflow_NFCT_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS = -module
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 1932a20..a07f724 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -6,7 +6,8 @@ LIBS=
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -module -lnetfilter_log
+ulogd_inppkt_NFLOG_la_LDFLAGS = -module $(LIBNETFILTER_LOG_LIBS)
+ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -module
-- 
1.5.5.3

