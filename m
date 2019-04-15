Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C9CC10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F215020854
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfDOUnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:43:55 -0400
Received: from mail1.windriver.com ([147.11.146.13]:55428 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfDOUnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 16:43:55 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id x3FKhaEm029535
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 15 Apr 2019 13:43:36 -0700 (PDT)
Received: from yow-cube1.wrs.com (128.224.56.98) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Apr 2019
 13:43:36 -0700
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     <netdev@vger.kernel.org>
CC:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: [PATCH -next 1/3] netfilter: nf_tables: relocate header content to consumer
Date:   Mon, 15 Apr 2019 16:43:14 -0400
Message-ID: <1555360996-23684-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
References: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nf_tables.h header is used in a lot of files, but it turns out
that there is only one actual user of nft_expr_clone().

Hence we relocate that function to be with the one consumer of it
and avoid having to process it with CPP for all the other files.

This will also enable a reduction in the other headers that the
nf_tables.h itself has to include just to be stand-alone, hence
a pending further significant reduction in the CPP content that
needs to get processed for each netfilter file.

Note that the explicit "inline" has been dropped as part of this
relocation.  In similar changes to this, I believe Dave has asked
this be done, so we free up gcc to make the choice of whether to
inline or not.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/netfilter/nf_tables.h | 17 -----------------
 net/netfilter/nft_dynset.c        | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2d5a0a1a87b8..706f744f7308 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -806,23 +806,6 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
 
-static inline int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
-{
-	int err;
-
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
-
-	__module_get(src->ops->type->owner);
-	return 0;
-}
-
 /**
  *	struct nft_rule - nf_tables rule
  *
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e461007558e8..8394560aa695 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -28,6 +28,23 @@ struct nft_dynset {
 	struct nft_set_binding		binding;
 };
 
+static int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+{
+	int err;
+
+	if (src->ops->clone) {
+		dst->ops = src->ops;
+		err = src->ops->clone(dst, src);
+		if (err < 0)
+			return err;
+	} else {
+		memcpy(dst, src, src->ops->size);
+	}
+
+	__module_get(src->ops->type->owner);
+	return 0;
+}
+
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
-- 
2.7.4

