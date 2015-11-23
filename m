From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH] iptables: Link libext_arpt to static build
Date: Mon, 23 Nov 2015 11:18:47 +0100
Message-ID: <1448273927-24853-1-git-send-email-daniel.wagner@bmw-carit.de>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:46184 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852AbbKWKXw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 05:23:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libext_arpt is not included when linking the static version of
iptables.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
Hi,

I had some troubles getting a static version of iptables. Not sure
if I fixed it correctly. Anyway I am able to proceed with testing.

cheers,
daniel

iptables/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 132fe5f..29e7fe1 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -41,7 +41,7 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-arp-standalone.c xtables-arp.c \
 				getethertype.c nft-bridge.c \
 				xtables-eb-standalone.c xtables-eb.c
-xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a
+xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a ../extensions/libext_arpt.a
 # yacc and lex generate dirty code
 xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 xtables_compat_multi_SOURCES += xshared.c
-- 
2.4.3

