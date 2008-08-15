From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: fix iptables-static build
Date: Thu, 14 Aug 2008 21:21:18 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808142120510.24200@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYHOBVT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:21:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1c9158d35e415d6983b3e9b0c67345d566940425
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Aug 14 20:59:49 2008 -0400

build: fix iptables-static build

Commit 126c1361ad5201973e6ebc761b3e38a67915de29 unfortunately broke
building iptables-static due to listing iptables.c twice. Fix this.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0355e2e..066dc56 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -36,7 +36,7 @@ iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
 iptables_save_LDADD       = ${iptables_LDADD}
 
 # iptables-multi, semi-static
-iptables_static_SOURCES   = ${iptables_multi_SOURCES} iptables.c xtables.c
+iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
 iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 iptables_static_LDADD     = -lm libiptc/libiptc.a extensions/libext4.a
 
@@ -63,7 +63,7 @@ ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
 ip6tables_save_LDADD      = ${ip6tables_LDADD}
 
 # iptables-multi, semi-static
-ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} ip6tables.c xtables.c
+ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
 ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 ip6tables_static_LDADD      = -lm libiptc/libiptc.a extensions/libext6.a
 

