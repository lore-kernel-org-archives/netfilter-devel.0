From: pablo@netfilter.org
Subject: [PATCH] build: make clean removes .*.d and *.d
Date: Mon, 10 Sep 2012 12:28:11 +0200
Message-ID: <1347272891-3015-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36199 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2IJK3W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:29:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

While changing from master to nf-nat branch, I hit this error:

make[2]: ***   CC       libipt_CLUSTERIP.oo
No hay ninguna regla para construir el objetivo `../include/net/netfilter/nf_nat.h', necesario para `libipt_DNAT.oo'.  Alto.

by removing *.d and .*.d I get it fixed. Add this to `make clean'
so I can avoid doing this by hand.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/GNUmakefile.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 218dc3a..88ab31d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -76,7 +76,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext.c initext4.c initext6.c;
+	rm -f *.o *.oo *.so *.a .*.d *.d {matches,targets}[46].man initext.c initext4.c initext6.c;
 
 distclean: clean
 	rm -f .*.d .*.dd;
-- 
1.7.10.4

