From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: do not install ip{,6}tables.h
Date: Mon, 28 Jul 2008 18:51:34 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42912 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYG1Wvg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:51:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9fbe00d1a9c1977233011690e00bab26c9cd4798
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jul 28 18:50:28 2008 -0400

    build: do not install ip{,6}tables.h
    
    These files do not contain anything that 3rd party modules could
    reasonably use.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 49edbf8..48561b7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -72,7 +72,7 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
                     ip6tables-save.8
 CLEANFILES       := iptables.8 ip6tables.8
 if ENABLE_DEVEL
-include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
+include_HEADERS  := include/xtables.h
 iptcdir           = ${includedir}/libiptc
 iptc_HEADERS     := include/libiptc/libxtc.h \
                     include/libiptc/ipt_kernel_headers.h

