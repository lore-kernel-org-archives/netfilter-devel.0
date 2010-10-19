From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] build: rebuild .pc files when configure status changed
Date: Tue, 19 Oct 2010 12:47:37 +0200
Message-ID: <1287485262-6562-7-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44406 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257Ab0JSKru (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:50 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 35bfbe2..6d5b8dd 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,6 +8,8 @@ DIST_SUBDIRS = src include examples
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libmnl.pc
 
+${pkgconfig_DATA}: ${top_builddir}/config.status
+
 $(OBJECTS): libtool
 libtool: $(LIBTOOL_DEPS)
 	$(SHELL) ./config.status --recheck
-- 
1.7.1

