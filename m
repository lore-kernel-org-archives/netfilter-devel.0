From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/10] libiptc: split v4 and v6
Date: Fri, 26 Jun 2009 21:19:44 +0200
Message-ID: <1246043992-379-3-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39661 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761308AbZFZTUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:09 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The split can save some diskspace for constrained systems running
which are only running one protocol.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fd99098..445717e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,9 +14,14 @@ endif
 lib_LTLIBRARIES =
 
 # libiptc
-lib_LTLIBRARIES           += libiptc/libiptc.la
-libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
-libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0
+lib_LTLIBRARIES           += libiptc/libiptc.la libiptc/libip4tc.la libiptc/libip6tc.la
+libiptc_libiptc_la_SOURCES  =
+libiptc_libiptc_la_LIBADD   = libiptc/libip4tc.la libiptc/libip6tc.la
+libiptc_libiptc_la_LDFLAGS  = -version-info 0:0:0
+libiptc_libip4tc_la_SOURCES = libiptc/libip4tc.c
+libiptc_libip4tc_la_LDFLAGS = -version-info 0:0:0
+libiptc_libip6tc_la_SOURCES = libiptc/libip6tc.c
+libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0
 
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
@@ -26,7 +31,7 @@ libxtables_la_LIBADD  = -ldl
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
 iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = libiptc/libiptc.la extensions/libext4.a libxtables.la -lm
+iptables_LDADD            = libiptc/libip4tc.la extensions/libext4.a libxtables.la -lm
 
 iptables_xml_LDADD        = libxtables.la
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
@@ -47,14 +52,14 @@ iptables_save_LDADD       = ${iptables_LDADD}
 # iptables-multi, semi-static
 iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
 iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-iptables_static_LDADD     = libiptc/libiptc.la extensions/libext4.a -lm
+iptables_static_LDADD     = libiptc/libip4tc.la extensions/libext4.a -lm
 
 iptables_xml_SOURCES      = iptables-xml.c
 
 # ip6tables, dynamic
 ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
 ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = libiptc/libiptc.la extensions/libext6.a libxtables.la -lm
+ip6tables_LDADD           = libiptc/libip6tc.la extensions/libext6.a libxtables.la -lm
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
@@ -74,7 +79,7 @@ ip6tables_save_LDADD      = ${ip6tables_LDADD}
 # iptables-multi, semi-static
 ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
 ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-ip6tables_static_LDADD      = libiptc/libiptc.la extensions/libext6.a -lm
+ip6tables_static_LDADD      = libiptc/libip6tc.la extensions/libext6.a -lm
 
 bin_PROGRAMS     = iptables-xml
 sbin_PROGRAMS    =
-- 
1.6.3.2

