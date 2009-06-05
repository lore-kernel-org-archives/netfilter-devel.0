From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc: split libiptc linkage
Date: Fri, 5 Jun 2009 21:33:54 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906052127170.28126@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFETdx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:33:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


as a result of a user inquiry thread posted to nf-dev earlier I 
produced this patch, but I am looking for some more justification to 
merge it. With it, ip(4)tables would only load ip4tc, and ip6tables 
only load ip6tc instead of both tools loading the current combined 
file libiptc.so. Since the combo file is just 47 KB I wonder whether the 
split is really worth the trouble.
Opinions please.


parent 42979363f3958b4436c6d2503753c182c58e55ea (v1.4.3.2-14-g4297936)
commit cbf54cddf95848a883d2b9476f3cfc758c32964a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jun 1 13:36:30 2009 +0200

libiptc: split v4 and v6

It does not affect the -static build at all. So what is it good for?

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
# Created with git-export-patch
