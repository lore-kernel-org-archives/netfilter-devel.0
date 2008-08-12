From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: fix initext.c dependency
Date: Tue, 12 Aug 2008 19:34:27 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808121934060.22617@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40286 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYHLXe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:34:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 47777929489b616e219d10bdb2c3a299a8c0bc0f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Aug 12 19:33:21 2008 -0400

build: fix initext.c dependency

initext?.c is generated within the current directory, not in ${srcdir}.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 4a3bf4e..1f063c8 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -75,7 +75,7 @@ clean:
 distclean: clean
 	rm -f .*.d .*.dd;
 
-init%.o: ${srcdir}/init%.c
+init%.o: init%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
 
 -include .*.d

