From: Jan Engelhardt <jengelh@medozas.de>
Subject: Only use libdl when shared builds are enabled (was: Only build
 iptables-xml)
Date: Mon, 20 Jul 2009 11:10:04 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39420 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZGTJKF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:10:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Philip,


try this one instead.


parent efebafa0021f36f4547b7fcc47620274f333e001 (v1.4.4-2-gefebafa)
commit 906025e7be97f760cd11cc0f93f769f827bf6f70
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jul 20 11:08:14 2009 +0200

build: only use libdl when shared builds are enabled

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fd99098..5608bde 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -21,7 +21,10 @@ libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
-libxtables_la_LIBADD  = -ldl
+libxtables_la_LIBADD  =
+if ENABLE_SHARED
+libxtables_la_LIBADD += -ldl
+endif
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
-- 
# Created with git-export-patch

