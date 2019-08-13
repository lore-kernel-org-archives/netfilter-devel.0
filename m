Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B9CC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E2D20578
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfHMSxD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:53:03 -0400
Received: from vxsys-smtpclusterma-01.srv.cat ([46.16.60.189]:43023 "EHLO
        vxsys-smtpclusterma-01.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbfHMSxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:53:03 -0400
Received: from localhost.localdomain (static-79-171-230-77.ipcom.comunitel.net [77.230.171.79])
        by vxsys-smtpclusterma-01.srv.cat (Postfix) with ESMTPA id 6F862213DD
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:53:00 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] Introduce new conditions 'time', 'day' and 'hour'
Date:   Tue, 13 Aug 2019 20:52:30 +0200
Message-Id: <20190813185231.7545-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/linux/netfilter/nf_tables.h | 6 ++++++
 src/expr/meta.c                     | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1bf4346..0a6bc7f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -794,6 +794,9 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_TIME: a UNIX timestamp
+ * @NFT_META_TIME_DAY: day of week
+ * @NFT_META_TIME_HOUR: hour of day
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -824,6 +827,9 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_TIME,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index f1984f6..c2ac72e 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -22,7 +22,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_OIFKIND + 1)
+#define NFT_META_MAX (NFT_META_TIME_HOUR + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -161,6 +161,9 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECPATH]	= "secpath",
 	[NFT_META_IIFKIND]	= "iifkind",
 	[NFT_META_OIFKIND]	= "oifkind",
+	[NFT_META_TIME]		= "time",
+	[NFT_META_TIME_DAY]	= "day",
+	[NFT_META_TIME_HOUR]	= "hour",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.17.1

