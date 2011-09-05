From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] build: scan for unreferenced symbols
Date: Mon,  5 Sep 2011 20:22:51 +0200
Message-ID: <1315246974-11538-4-git-send-email-jengelh@medozas.de>
References: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33344 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab1IESXF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:23:05 -0400
In-Reply-To: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To be notified of occurrences where we are missing any libraries, run
some ldd checks post building.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 107c9d5..a9edb1e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -68,7 +68,16 @@ targets_install :=
 
 .PHONY: all install clean distclean FORCE
 
-all: ${targets}
+all: ${targets} check
+
+check: ${targets}
+	@echo "  CHECK    unknown symbols in .so files"; \
+	. ../iptables/libxtables.la; \
+	for i in "" lib*.so; do \
+		[ -z "$$i" ] && continue; \
+		LD_PRELOAD="$$dlname" LD_LIBRARY_PATH=../iptables/.libs \
+			ldd -r $$i 2>&1 >/dev/null; \
+	done;
 
 install: ${targets_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
-- 
1.7.3.4

