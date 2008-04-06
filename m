From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/24] Fix compilation of iptables-static build
Date: Sun,  6 Apr 2008 17:26:58 +0200
Message-ID: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56463 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYDFP1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:23 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adjust the _INIT macro and thus fix the build/linking procedure of
the monolithic do-it-all binary (iptables-static).

Also fix the Makefile since unfortunately, lib%.o does not seem to
have a higher precedence than %.o
---
 extensions/GNUmakefile.in |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 155703d..4892409 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -91,7 +91,7 @@ clean:
 distclean: clean
 	rm -f .*.d .*.dd;
 
-%.o: %.c
+init%.o: ${srcdir}/init%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
 
 -include .*.d
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
-- 
1.5.5.rc3

