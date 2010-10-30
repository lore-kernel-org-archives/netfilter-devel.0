From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] build: remove statements without effect
Date: Sun, 31 Oct 2010 00:08:17 +0200
Message-ID: <1288476502-18721-4-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46346 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0J3WJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:05 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 3878a8d..ac90888 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,7 +10,3 @@ pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_conntrack.pc
 
 EXTRA_DIST = Make_global.am
-
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-- 
1.7.1

