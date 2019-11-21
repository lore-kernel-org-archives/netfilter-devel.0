Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F95C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB29E20714
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKULZE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:25:04 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40976 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKULZE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 06:25:04 -0500
Received: from localhost ([::1]:54066 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXka7-0001Lf-GK; Thu, 21 Nov 2019 12:25:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] utils: Define __visible even if not supported by compiler
Date:   Thu, 21 Nov 2019 12:24:56 +0100
Message-Id: <20191121112456.28274-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since __visible is now used directly, provide a fallback empty
definition if HAVE_VISIBILITY_HIDDEN is not defined.

Fixes: 7349a70634fa0 ("Deprecate untyped data setters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/utils.h b/include/utils.h
index 91fbebb1956fd..8af5a8e973fa8 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -12,6 +12,7 @@
 #	define __visible	__attribute__((visibility("default")))
 #	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible;
 #else
+#	define __visible
 #	define EXPORT_SYMBOL
 #endif
 
-- 
2.24.0

