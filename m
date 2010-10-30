From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] build: remove statements without effect
Date: Sun, 31 Oct 2010 00:11:13 +0200
Message-ID: <1288476676-32749-9-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49983 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab0J3WL2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:28 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index b4e604b..576a69b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,7 +8,3 @@ man_MANS = #nfnetlink_queue.3 nfnetlink_queue.7
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_queue.pc
-
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-- 
1.7.1

