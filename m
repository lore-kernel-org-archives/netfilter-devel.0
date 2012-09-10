From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: have `make clean` remove dep files too
Date: Mon, 10 Sep 2012 15:10:05 +0200
Message-ID: <1347282605-20781-1-git-send-email-jengelh@inai.de>
References: <1347272891-3015-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58070 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2IJNKJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:10:09 -0400
In-Reply-To: <1347272891-3015-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While changing branches, one can hit errors like:

make[2]: ***   CC       libipt_CLUSTERIP.oo
No hay ninguna regla para construir el objetivo
`../include/net/netfilter/nf_nat.h', necesario para
`libipt_DNAT.oo'. Alto.

Pablo thinks dep files should be removed on `make clean`, and I
concur. (JFI, Note that native automake would not clear its ".deps"
directory.) Keep the "distclean: clean" line to keep invocations by
automake from the parent directory working.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

This patch is fetchable on
	git://git.inai.de/iptables master

 extensions/GNUmakefile.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 218dc3a..4a8ff49 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -77,9 +77,9 @@ install: ${targets_install}
 
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext.c initext4.c initext6.c;
+	rm -f .*.d .*.dd;
 
 distclean: clean
-	rm -f .*.d .*.dd;
 
 init%.o: init%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
-- 
1.7.10.4

