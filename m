From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] build: fix installation of symlinks
Date: Mon, 30 May 2011 12:18:02 +0200
Message-ID: <1306750686-11595-3-git-send-email-jengelh@medozas.de>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49385 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1E3KSL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 06:18:11 -0400
In-Reply-To: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.11~20 forgot to change the symlink target names to the new
executable name.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 13e144e..741729b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -96,6 +96,6 @@ config.status: extensions/GNUmakefile.in \
 install-exec-hook:
 	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
 	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
-	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/iptables-multi" "${DESTDIR}${bindir}/$$i"; done;
-	for i in ${v4_sbin_links}; do ${LN_S} -f iptables-multi "${DESTDIR}${sbindir}/$$i"; done;
-	for i in ${v6_sbin_links}; do ${LN_S} -f ip6tables-multi "${DESTDIR}${sbindir}/$$i"; done;
+	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
+	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
+	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
-- 
1.7.3.4

