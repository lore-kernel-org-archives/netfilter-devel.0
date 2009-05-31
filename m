From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] fix "manpages: do not include v4-only modules in ip6tables manpage"
Date: Sun, 31 May 2009 18:50:16 +0200
Message-ID: <1243788616-375-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45895 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698AbZEaQpl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 12:45:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

previous commit tries to skip v4-only module manpages
by searching for NFPROTO_IPV(4|6) -- in the man page itself.

Searching the .c file instead is not sufficient:
- there is at least one page (libxt_policy) without a libxt_*c
- there are targets/modules which use family AF_UNSPEC.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/GNUmakefile.in |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 8d7f21d..44a6d02 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -161,10 +161,13 @@ man_run    = \
 	${AM_VERBOSE_GEN} \
 	for ext in $(1); do \
 		f="${srcdir}/libxt_$$ext.man"; \
-		if [ -f "$$f" ] && grep -q "$(3)" "$$f"; then \
-			echo ".SS $$ext"; \
-			cat "$$f"; \
-			continue; \
+		if [ -f "$$f" ] ; then \
+			cfile="${srcdir}/libxt_$$ext.c"; \
+			if [ ! -f "$$cfile" ] || grep -q "\(_UNSPEC\|$(3)\)" "$$cfile"; then \
+				echo ".SS $$ext"; \
+				cat "$$f"; \
+				continue; \
+			fi; \
 		fi; \
 		f="${srcdir}/lib$(2)t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
-- 
1.6.0.6

