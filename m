From: Jan Engelhardt <jengelh@medozas.de>
Subject: Update .gitignore
Date: Thu, 5 Jun 2008 16:54:38 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806051649230.29055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35835 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYFEOyj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:54:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Please pull  git://dev.medozas.de/xtables master  to receive:

commit 9e986688873d18b652f0e6116a9629f3639bac2f
parent 5a2208c3e62a150e6f6297abbfa63056ab4a8066
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 02:12:55 2008 +0100

    Update .gitignore

    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..9ebe15c
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,47 @@
+.*.d
+.*.dd
+*.a
+*.oo
+*.so
+*.o
+.deps
+.dirstamp
+Makefile
+Makefile.in
+
+/extensions/GNUmakefile
+/extensions/initext?.c
+/extensions/matches?.man
+/extensions/targets?.man
+
+/include/xtables.h
+
+/aclocal.m4
+/autom4te*.cache
+/compile
+/config.guess
+/config.h*
+/config.log
+/config.status
+/config.sub
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/stamp-h1
+
+/ip6tables
+/ip6tables.8
+/ip6tables-multi
+/ip6tables-save
+/ip6tables-restore
+/ip6tables-static
+/iptables
+/iptables.8
+/iptables-multi
+/iptables-save
+/iptables-restore
+/iptables-static
+/iptables-xml

