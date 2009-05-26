From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] manpages: do not include v4-only modules in ip6tables manpage
Date: Tue, 26 May 2009 13:26:27 +0200
Message-ID: <1243337187-18216-6-git-send-email-jengelh@medozas.de>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZEZL0b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:31 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/529954
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 66a4f46..8d7f21d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -161,7 +161,7 @@ man_run    = \
 	${AM_VERBOSE_GEN} \
 	for ext in $(1); do \
 		f="${srcdir}/libxt_$$ext.man"; \
-		if [ -f "$$f" ]; then \
+		if [ -f "$$f" ] && grep -q "$(3)" "$$f"; then \
 			echo ".SS $$ext"; \
 			cat "$$f"; \
 			continue; \
@@ -175,13 +175,13 @@ man_run    = \
 	done >$@;
 
 matches4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}),ip)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}),ip,NFPROTO_IPV4)
 
 matches6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}),ip6)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}),ip6,NFPROTO_IPV6)
 
 targets4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}),ip)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}),ip,NFPROTO_IPV4)
 
 targets6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}),ip6)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}),ip6,NFPROTO_IPV6)
-- 
1.6.3.1

