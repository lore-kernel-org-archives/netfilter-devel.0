From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: drop libiptc from installation
Date: Wed, 30 Jul 2008 09:20:52 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807300920001.28509@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33914 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYG3NUx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:20:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ef5d689411a64356ef26e56d7c82835e113b6d87
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jul 30 08:38:37 2008 -0400

src: drop libiptc from installation

libiptc is for iptables only, and was only previously exported because 
of the xt_chainlabel typedef. This is resolved by this patch.

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

