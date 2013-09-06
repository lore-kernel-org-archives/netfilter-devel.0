From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [iptables PATCH] build: add DESTDIR to vx_bin_links
Date: Fri,  6 Sep 2013 17:39:00 -0400
Message-ID: <1378503540-16134-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:46596 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3IFVjr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:39:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes dangling symlinks when using DESTDIR.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 iptables/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index a4246eb..ec53443 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -49,6 +49,6 @@ pkgconfig_DATA = xtables.pc
 install-exec-hook:
 	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
 	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
-	for i in ${vx_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
+	for i in ${vx_bin_links}; do ${LN_S} -f "${DESTDIR}${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
 	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
-- 
1.8.4.rc3

