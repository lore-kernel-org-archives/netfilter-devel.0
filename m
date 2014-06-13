From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] Makefile: fix static compilation of iptables-compat without shared libraries
Date: Fri, 13 Jun 2014 12:08:46 +0200
Message-ID: <1402654126-21098-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFMKI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:08:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix linking problems when this configuration is used:

 $ ./configure --prefix=/usr --enable-shared=no --enable-static=yes
 $ make
 ...
xtables_compat_multi-xtables-save.o: In function `xtables_save_main':
/home/pablo/devel/iptables/iptables/xtables-save.c:98: undefined reference to `init_extensions4'
xtables_compat_multi-xtables-restore.o: In function `xtables_restore_main':
/home/pablo/devel/iptables/iptables/xtables-restore.c:195: undefined reference to `init_extensions4'
xtables_compat_multi-xtables-standalone.o: In function `xtables_main':
/home/pablo/devel/iptables/iptables/xtables-standalone.c:61: undefined reference to `init_extensions4'
xtables_compat_multi-xtables-events.o: In function `xtables_events_main':
/home/pablo/devel/iptables/iptables/xtables-events.c:184: undefined reference to `init_extensions4'

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 41bca7c..aaaade8 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -40,7 +40,7 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-config.c xtables-events.c \
 				xtables-arp-standalone.c xtables-arp.c
-xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS}
+xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a
 # yacc and lex generate dirty code
 xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 xtables_compat_multi_SOURCES += xshared.c
-- 
1.7.10.4

