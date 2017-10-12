From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nfnl_cthelper: Replace kzalloc with kcalloc
Date: Fri, 13 Oct 2017 03:52:18 +0530
Message-ID: <20171012222218.1220-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:48853 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbdJLWYp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 18:24:45 -0400
Received: by mail-pf0-f193.google.com with SMTP id b79so6927695pfk.5
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2017 15:24:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kcalloc is preferred to allocate an array instead of kzalloc.
This patch fixes checkpatch isssue.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 41628b393673..f1ce335b9158 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -189,7 +189,7 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	if (class_max > NF_CT_MAX_EXPECT_CLASSES)
 		return -EOVERFLOW;
 
-	expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
+	expect_policy = kcalloc(sizeof(struct nf_conntrack_expect_policy) *
 				class_max, GFP_KERNEL);
 	if (expect_policy == NULL)
 		return -ENOMEM;
-- 
2.11.0

