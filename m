Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8785FC48BD6
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BCD4204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfFYG6h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:58:37 -0400
Received: from a3.inai.de ([88.198.85.195]:40158 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbfFYG6h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 02:58:37 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id F0FA33BAC08A; Tue, 25 Jun 2019 08:58:35 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 21C5F2AFD3F6;
        Tue, 25 Jun 2019 08:58:35 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/3] build: avoid unnecessary call to xargs
Date:   Tue, 25 Jun 2019 08:58:35 +0200
Message-Id: <20190625065835.31188-3-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625065835.31188-1-jengelh@inai.de>
References: <20190625065835.31188-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 py/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/py/Makefile.am b/py/Makefile.am
index 5f4e1f6..215ecd9 100644
--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -22,7 +22,7 @@ clean-local:
 		$(PYTHON_BIN) setup.py clean \
 		--build-base $(abs_builddir)
 	rm -rf scripts-* lib* build dist bdist.* nftables.egg-info
-	find . -name \*.pyc -print0 | xargs -0 rm -f
+	find . -name \*.pyc -delete
 
 distclean-local:
 	rm -f version
-- 
2.21.0

