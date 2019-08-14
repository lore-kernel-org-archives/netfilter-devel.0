Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49930C0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2171A2067D
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfHNHMO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:12:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41334 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfHNHMO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:12:14 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8A36B4191E;
        Wed, 14 Aug 2019 15:12:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: meta: Make NFT_META_BRI_IIF{VPROTO,PVID} known
Date:   Wed, 14 Aug 2019 15:12:07 +0800
Message-Id: <1565766727-25830-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0xLS0tKSUlLTEtISllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTI6Qyo*Vjg#ITkPKhQTHkwo
        FCgwFB5VSlVKTk1OTE1NTElMTElKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPTU03Bg++
X-HM-Tid: 0a6c8ef837b82086kuqy8a36b4191e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This makes debug output to support bri_iifvproto/pvid.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 src/expr/meta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index f1984f6..73f6efa 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -22,7 +22,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_OIFKIND + 1)
+#define NFT_META_MAX (NFT_META_BRI_IIFVPROTO + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -161,6 +161,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECPATH]	= "secpath",
 	[NFT_META_IIFKIND]	= "iifkind",
 	[NFT_META_OIFKIND]	= "oifkind",
+	[NFT_META_BRI_IIFPVID]	 = "bri_iifpvid",
+	[NFT_META_BRI_IIFVPROTO] = "bri_iifvproto",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.15.1

