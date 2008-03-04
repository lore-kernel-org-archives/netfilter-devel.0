From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/24] Fix compilation of iptables-static build
Date: Tue, 4 Mar 2008 16:52:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041652360.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58844 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbYCDPw4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:52:56 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit bd5b0f3157ebbf607971d170508748d76ef6c39c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 00:29:36 2008 +0100

    Fix compilation of iptables-static build
    
    Adjust the _INIT macro and thus fix the build/linking procedure of
    the monolithic do-it-all binary (iptables-static).
---
 extensions/GNUmakefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 155703d..3d9eb24 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -104,7 +104,7 @@ lib%.so: lib%.oo
 	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $<;
 
 lib%.oo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 
 #
@@ -115,7 +115,7 @@ lib%.oo: ${srcdir}/lib%.c
 #	handling code in the Makefiles.
 #
 lib%.o: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=1 -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=1 -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<;
 
 libext4.a: initext4.o ${libext4_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
