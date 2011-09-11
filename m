From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] build: sort file list before build
Date: Sun, 11 Sep 2011 12:38:43 +0200
Message-ID: <1315737527-19595-2-git-send-email-jengelh@medozas.de>
References: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56940 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1IKKiy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:38:54 -0400
In-Reply-To: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Manpage subsections are already sorted for obvious reasons. Since
$(wildcard) can actually return results unordered (just what the OS
can do) do the sorting with the .o file list too, for developer
comfort.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index a9edb1e..60f28c0 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -37,9 +37,9 @@ endif
 #
 #	Wildcard module list
 #
-pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}/libxt_*.c))
-@ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir}/libipt_*.c))
-@ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdir}/libip6t_*.c))
+pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
+@ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
+@ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
 pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
 pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
@@ -198,11 +198,11 @@ initext6.c: .initext6.dd
 #
 #	Manual pages
 #
-ex_matches = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:lower:][:digit:]_]+\b'))
-ex_targets = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:upper:][:digit:]_]+\b'))
+ex_matches = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:lower:][:digit:]_]+\b')
+ex_targets = $(shell echo ${1} | LC_ALL=POSIX grep -Eo '\b[[:upper:][:digit:]_]+\b')
 man_run    = \
 	${AM_VERBOSE_GEN} \
-	for ext in $(1); do \
+	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
 		cf="${srcdir}/libxt_$$ext.c"; \
 		if [ -f "$$f" ] && grep -Eq "$(3)|NFPROTO_UNSPEC" "$$cf"; then \
-- 
1.7.3.4

