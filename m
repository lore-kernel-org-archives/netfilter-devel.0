From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] build: remove statements without effect
Date: Sun, 31 Oct 2010 00:07:31 +0200
Message-ID: <1288476454-18451-8-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46306 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WHo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:44 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 95d1df8..d38da7d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -12,9 +12,5 @@ man_MANS = #nfnetlink.3
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnfnetlink.pc
 
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-
 dist-hook:
 	rm -rf `find $(distdir)/debian -name .svn`
-- 
1.7.1

