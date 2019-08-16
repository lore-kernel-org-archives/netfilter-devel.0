Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F744C3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21666206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHPOou (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:44:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46168 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbfHPOou (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:44:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTF-0002na-I6; Fri, 16 Aug 2019 16:44:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 1/8] src: libnftnl: run single-initcalls only once
Date:   Fri, 16 Aug 2019 16:42:34 +0200
Message-Id: <20190816144241.11469-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---
 src/libnftables.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index a693c0c69075..b169dd2f2afe 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -90,11 +90,6 @@ static void nft_init(struct nft_ctx *ctx)
 	realm_table_rt_init(ctx);
 	devgroup_table_init(ctx);
 	ct_label_table_init(ctx);
-
-	gmp_init();
-#ifdef HAVE_LIBXTABLES
-	xt_init();
-#endif
 }
 
 static void nft_exit(struct nft_ctx *ctx)
@@ -142,8 +137,17 @@ static void nft_ctx_netlink_init(struct nft_ctx *ctx)
 EXPORT_SYMBOL(nft_ctx_new);
 struct nft_ctx *nft_ctx_new(uint32_t flags)
 {
+	static bool init_once;
 	struct nft_ctx *ctx;
 
+	if (!init_once) {
+		init_once = true;
+		gmp_init();
+#ifdef HAVE_LIBXTABLES
+		xt_init();
+#endif
+	}
+
 	ctx = xzalloc(sizeof(struct nft_ctx));
 	nft_init(ctx);
 
-- 
2.21.0

