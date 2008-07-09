From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 1/2] Suppress subversion specific dist-hook.
Date: Wed,  9 Jul 2008 22:56:44 +0200
Message-ID: <1215637005-3102-2-git-send-email-eric@inl.fr>
References: <>
 <1215637005-3102-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44149 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756973AbYGIU4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:47 -0400
In-Reply-To: <1215637005-3102-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch suppress a dist-hook in Makefile.am which was related
to the suppression of some subversion related files.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 Makefile.am |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 9f11dfb..46615c1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -20,5 +20,3 @@ $(OBJECTS): libtool
 libtool: $(LIBTOOL_DEPS)
 	$(SHELL) ./config.status --recheck
 
-dist-hook:
-	rm -rf `find $(distdir)/debian -name .svn`
-- 
1.5.5.1

