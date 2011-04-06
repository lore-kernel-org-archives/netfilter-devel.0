From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] doc: avoid duplicate entries in manpage
Date: Wed,  6 Apr 2011 13:24:50 +0200
Message-ID: <1302089091-14260-2-git-send-email-jengelh@medozas.de>
References: <1302089091-14260-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50482 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1DFLYx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:24:53 -0400
In-Reply-To: <1302089091-14260-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.9-35-gd4105ad changed from [A-Z] and [a-z] to use
[[:alnum:]], which unfortunately drew matches into the target section,
and targets into the match section. [[:upper:]] and [[:lower:]] should
have been used instead, of course.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 1419d76..0e562fb 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -155,8 +155,8 @@ initext6.c: .initext6.dd
 #
 #	Manual pages
 #
-ex_matches = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:alnum:]_]+\b'))
-ex_targets = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:alnum:]_]+\b'))
+ex_matches = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:lower:][:digit:]_]+\b'))
+ex_targets = $(sort $(shell echo $(1) | LC_ALL=POSIX grep -Eo '\b[[:upper:][:digit:]_]+\b'))
 man_run    = \
 	${AM_VERBOSE_GEN} \
 	for ext in $(1); do \
-- 
1.7.1

