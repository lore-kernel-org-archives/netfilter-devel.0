Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E71C76192
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C368B2077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389258AbfGRDie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 23:38:34 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33890 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732313AbfGRDie (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 23:38:34 -0400
Received: from localhost ([::1]:46980 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hnxFZ-0008Pj-76; Thu, 18 Jul 2019 05:38:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] expr: meta: Make NFT_META_{I,O}IFKIND known
Date:   Thu, 18 Jul 2019 05:38:29 +0200
Message-Id: <20190718033829.12647-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This only affects debug output, the key was properly handled in
productive code paths already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nf_tables.h | 4 ++++
 src/expr/meta.c                     | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index df6c706ccf093..8a9cd4cb3fa05 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -793,6 +793,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
+ * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -821,6 +823,8 @@ enum nft_meta_keys {
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
 	NFT_META_SECPATH,
+	NFT_META_IIFKIND,
+	NFT_META_OIFKIND,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index ffcc8967b109d..f1984f6eb5c5b 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -22,7 +22,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_SECPATH + 1)
+#define NFT_META_MAX (NFT_META_OIFKIND + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -159,6 +159,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_CGROUP]	= "cgroup",
 	[NFT_META_PRANDOM]	= "prandom",
 	[NFT_META_SECPATH]	= "secpath",
+	[NFT_META_IIFKIND]	= "iifkind",
+	[NFT_META_OIFKIND]	= "oifkind",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.22.0

