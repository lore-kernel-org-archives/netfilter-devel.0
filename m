From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/11] build: remove statements without effect
Date: Sun, 31 Oct 2010 00:09:54 +0200
Message-ID: <1288476600-29859-7-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49911 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0J3WKJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:09 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index c6e1154..d001fba 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,7 +10,3 @@ man_MANS = #nfnetlink_log.3 nfnetlink_log.7
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_log.pc
-
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-- 
1.7.1

