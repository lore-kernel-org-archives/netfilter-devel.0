From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] build: fix absence of xml translator in IPv6-only builds
Date: Mon, 30 May 2011 12:18:03 +0200
Message-ID: <1306750686-11595-4-git-send-email-jengelh@medozas.de>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49386 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1E3KSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 06:18:12 -0400
In-Reply-To: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Due to iptables-xml being listed under IPV4 only, its symlink was not
created on `./configure --disable-ipv4 && make install`.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 741729b..cc2b83b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -65,8 +65,8 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    ip6tables-save.8
 CLEANFILES       = iptables.8 ip6tables.8
 
+vx_bin_links   = iptables-xml
 if ENABLE_IPV4
-v4_bin_links   = iptables-xml
 v4_sbin_links  = iptables iptables-restore iptables-save
 endif
 if ENABLE_IPV6
@@ -96,6 +96,6 @@ config.status: extensions/GNUmakefile.in \
 install-exec-hook:
 	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
 	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
-	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
+	for i in ${vx_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
 	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
-- 
1.7.3.4

