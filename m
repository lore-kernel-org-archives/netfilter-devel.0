From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 16/24] Install libiptc header files because xtables.h depends
 on it
Date: Tue, 4 Mar 2008 17:06:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041704560.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44023 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762461AbYCDQG3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:06:29 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


BTW, having xtables.h in /usr/include allows to build extensions (think 
POM or Xtables-addons) without having to patch iptables/xtables itself,
IMHO a really good thing.

===
commit 077ad64c9f3de90b94fb44964377cca77dc60400
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 15:48:51 2008 +0100

    Install libiptc header files because xtables.h depends on it
---
 Makefile.am |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 811eb62..80ef3a0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -75,6 +75,9 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
 CLEANFILES       := iptables.8 ip6tables.8
 if ENABLE_DEVEL
 include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
+iptcdir          := ${includedir}/libiptc
+iptc_HEADERS     := include/libiptc/libxtc.h \
+                    include/libiptc/ipt_kernel_headers.h
 endif
 
 if ENABLE_STATIC
