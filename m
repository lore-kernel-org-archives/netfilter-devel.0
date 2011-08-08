From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] libxt_TCPMSS: restore build with IPv6-less libcs
Date: Mon,  8 Aug 2011 02:42:18 +0200
Message-ID: <1312764144-23849-3-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44405 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1HHAm3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:29 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.10-149-gea2a02f added an netinet/ip6.h include, which is
not available on systems without IPv6 header files.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac              |    1 +
 extensions/GNUmakefile.in |    2 +-
 extensions/libxt_TCPMSS.c |    6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5cb1b1b..6aa0b2a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,6 +68,7 @@ if test "$ac_cv_header_linux_ip_vs_h" != "yes"; then
 fi;
 
 AC_SUBST([blacklist_modules])
+AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
 
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index fbaf2ec..2b48d84 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS := @regular_CPPFLAGS@
 kinclude_CPPFLAGS := @kinclude_CPPFLAGS@
 
 AM_CFLAGS      := ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 48ab044..4b71e44 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -2,10 +2,10 @@
  *
  * Copyright (c) 2000 Marc Boucher
 */
+#include "config.h"
 #include <stdio.h>
 #include <xtables.h>
 #include <netinet/ip.h>
-#include <netinet/ip6.h>
 #include <linux/netfilter/xt_TCPMSS.h>
 
 enum {
@@ -34,7 +34,7 @@ static void TCPMSS_help(void)
 
 static void TCPMSS_help6(void)
 {
-	__TCPMSS_help(sizeof(struct ip6_hdr));
+	__TCPMSS_help(SIZEOF_STRUCT_IP6_HDR);
 }
 
 static const struct xt_option_entry TCPMSS4_opts[] = {
@@ -47,7 +47,7 @@ static const struct xt_option_entry TCPMSS4_opts[] = {
 
 static const struct xt_option_entry TCPMSS6_opts[] = {
 	{.name = "set-mss", .id = O_SET_MSS, .type = XTTYPE_UINT16,
-	 .min = 0, .max = UINT16_MAX - sizeof(struct ip6_hdr),
+	 .min = 0, .max = UINT16_MAX - SIZEOF_STRUCT_IP6_HDR,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_tcpmss_info, mss)},
 	{.name = "clamp-mss-to-pmtu", .id = O_CLAMP_MSS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
-- 
1.7.3.4

