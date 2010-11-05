From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] build: remove statements without obvious effect
Date: Fri,  5 Nov 2010 19:36:16 +0100
Message-ID: <1288982184-23584-3-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44393 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KESg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:28 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index cf74fca..20822c2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,10 +16,6 @@ edit = sed \
 ulogd.conf: Makefile $(srcdir)/ulogd.conf.in
 	$(edit) $(srcdir)/ulogd.conf.in >ulogd.conf
 
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-
 dist-hook:
 	rm -f ulogd.conf
 
-- 
1.7.1

