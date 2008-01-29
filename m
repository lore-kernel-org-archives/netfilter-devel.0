From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 4/6] [IPTABLES]: fix static build
Date: Tue, 29 Jan 2008 18:32:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291832250.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801291828030.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46512 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYA2Rch (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:32:37 -0500
In-Reply-To: <Pine.LNX.4.64.0801291828030.14907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adjust the _INIT macro and thus fix the build/linking procedure
of the monolithic do-it-all binary (iptables-static).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/GNUmakefile.in |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: iptables/extensions/GNUmakefile.in
===================================================================
--- iptables.orig/extensions/GNUmakefile.in
+++ iptables/extensions/GNUmakefile.in
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
