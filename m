From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] iptables: add xtables-config-parser.h to BUILT_SOURCES
Date: Wed, 30 Dec 2015 14:51:30 -0300
Message-ID: <1451497890-23629-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([176.9.42.171]:59015 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbL3SFN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Dec 2015 13:05:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise other sources that use it might be built before it's ready leading
to build failure, for example by iptables/nft.c

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 iptables/Makefile.am | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 3c0faa5..c3eb8a8 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -4,6 +4,8 @@ AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
 AM_YFLAGS = -d
 
+BUILT_SOURCES =
+
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
 xtables_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_multi_LDADD    = ../extensions/libext.a
@@ -27,6 +29,7 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 
 # nftables compatibility layer
 if ENABLE_NFTABLES
+BUILT_SOURCES += xtables-config-parser.h
 xtables_compat_multi_SOURCES  = xtables-compat-multi.c iptables-xml.c
 xtables_compat_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_compat_multi_LDADD    = ../extensions/libext.a ../extensions/libext_ebt.a
-- 
2.4.10

