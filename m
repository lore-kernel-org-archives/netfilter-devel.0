From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/24] Update .gitignore
Date: Tue, 4 Mar 2008 16:52:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041651080.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58842 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYCDPwd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:52:33 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


[ What I noticed during svn->git conversion is that [PATCH] prefixes 
  were not removed :(  -- anyway, I fixed that up in the git repo. ]

===

commit 6615605552d60c9f4c39b68a151804b8824f32fc
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 02:12:55 2008 +0100

    Update .gitignore
---
 .gitignore |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..ec15363
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,43 @@
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
+/iptables
+/iptables.8
+/iptables-multi
+/iptables-save
+/iptables-restore
+/iptables-xml
