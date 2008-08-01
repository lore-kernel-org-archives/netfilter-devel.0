From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: drop libiptc from installation
Date: Fri, 1 Aug 2008 09:04:54 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808010904340.31124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38577 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYHANEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:04:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(patch 2/2)
commit 2457d8f06e9e6f9929379494240e4ec503962590
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 1 09:02:42 2008 -0400

src: drop libiptc from installation

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 48561b7..b714b97 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -73,9 +73,6 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
 CLEANFILES       := iptables.8 ip6tables.8
 if ENABLE_DEVEL
 include_HEADERS  := include/xtables.h
-iptcdir           = ${includedir}/libiptc
-iptc_HEADERS     := include/libiptc/libxtc.h \
-                    include/libiptc/ipt_kernel_headers.h
 endif
 
 if ENABLE_STATIC

