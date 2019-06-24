Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C664C4646B
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F37E20663
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 22:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFXWQu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:16:50 -0400
Received: from a3.inai.de ([88.198.85.195]:53232 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXWQu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 18:16:50 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id C6A392A3C57E; Tue, 25 Jun 2019 00:16:48 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id E572B3BAB5E9;
        Tue, 25 Jun 2019 00:16:45 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/3] build: avoid recursion into py/ if not selected
Date:   Tue, 25 Jun 2019 00:16:44 +0200
Message-Id: <20190624221645.28591-2-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624221645.28591-1-jengelh@inai.de>
References: <20190624221645.28591-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---
 Makefile.am    | 6 ++++--
 py/Makefile.am | 3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index e567d32..4a17424 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,8 +3,10 @@ ACLOCAL_AMFLAGS	= -I m4
 SUBDIRS = 	src	\
 		include	\
 		files	\
-		doc		\
-		py
+		doc
+if HAVE_PYTHON
+SUBDIRS += py
+endif
 
 EXTRA_DIST =	tests	\
 		files
diff --git a/py/Makefile.am b/py/Makefile.am
index 9fce7c9..5f4e1f6 100644
--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -1,7 +1,5 @@
 EXTRA_DIST = setup.py __init__.py nftables.py schema.json
 
-if HAVE_PYTHON
-
 all-local:
 	cd $(srcdir) && \
 		$(PYTHON_BIN) setup.py build --build-base $(abs_builddir)
@@ -28,4 +26,3 @@ clean-local:
 
 distclean-local:
 	rm -f version
-endif
-- 
2.21.0

