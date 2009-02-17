From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] doc: do not put IPv4 doc into ip6tables.8
Date: Tue, 17 Feb 2009 15:08:32 +0100
Message-ID: <1234879712-24566-3-git-send-email-jengelh@medozas.de>
References: <1234879712-24566-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41274 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZBQOIe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:08:34 -0500
In-Reply-To: <1234879712-24566-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reference: http://bugs.debian.org/515752
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 1f063c8..256ac08 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -166,13 +166,7 @@ man_run    = \
 			cat "$$f"; \
 			continue; \
 		fi; \
-		f="${srcdir}/libipt_$$ext.man"; \
-		if [ -f "$$f" ]; then \
-			echo ".SS $$ext"; \
-			cat "$$f"; \
-			continue; \
-		fi; \
-		f="${srcdir}/libip6t_$$ext.man"; \
+		f="${srcdir}/lib$(2)t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
 			echo ".SS $$ext"; \
 			cat "$$f"; \
@@ -181,13 +175,13 @@ man_run    = \
 	done >$@;
 
 matches4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}))
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}),ip)
 
 matches6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}))
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}),ip6)
 
 targets4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}))
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}),ip)
 
 targets6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}))
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}),ip6)
-- 
1.6.1.3

