From: jengelh@medozas.de
Subject: [PATCH 2/8] build: move -ldl to proper LDADD
Date: Wed, 11 Feb 2009 16:03:30 +0100
Message-ID: <1234364616-19974-3-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48689 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbZBKPDj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:39 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

libxtables uses dlopen, so *it* has to use -ldl, not the main program.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0ffb978..2348976 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,11 +15,12 @@ libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_la_LIBADD  = -ldl
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
 iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
+iptables_LDADD            = -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
 
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
@@ -46,7 +47,7 @@ iptables_xml_SOURCES      = iptables-xml.c
 # ip6tables, dynamic
 ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
 ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = -ldl -lm libiptc/libiptc.a extensions/libext6.a libxtables.la
+ip6tables_LDADD           = -lm libiptc/libiptc.a extensions/libext6.a libxtables.la
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
-- 
1.6.1.2

