From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] build: fix manpage collection
Date: Mon,  1 Jun 2009 12:06:32 +0200
Message-ID: <1243850793-9526-5-git-send-email-jengelh@medozas.de>
References: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53167 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbZFAKGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:06:33 -0400
In-Reply-To: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal points out that v1.4.3.2-9-gc304d77 greps for the
keyword in the wrong file, and that files with NFPROTO_UNSPEC are
skipped.

This patch corrects that part, and makes `make` now output the
manpages it collected.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 8d7f21d..e1f1f49 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -161,13 +161,16 @@ man_run    = \
 	${AM_VERBOSE_GEN} \
 	for ext in $(1); do \
 		f="${srcdir}/libxt_$$ext.man"; \
-		if [ -f "$$f" ] && grep -q "$(3)" "$$f"; then \
+		cf="${srcdir}/libxt_$$ext.c"; \
+		if [ -f "$$f" ] && grep -Eq "$(3)|NFPROTO_UNSPEC" "$$cf"; then \
+			echo -e "\t+ $$f" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f"; \
 			continue; \
 		fi; \
 		f="${srcdir}/lib$(2)t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
+			echo -e "\t+ $$f" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f"; \
 			continue; \
-- 
1.6.3.1

