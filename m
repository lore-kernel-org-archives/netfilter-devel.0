Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90BBC04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8526720C01
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfELSms (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 14:42:48 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57498 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbfELSms (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 14:42:48 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hPtQr-0004tm-Vi; Sun, 12 May 2019 20:42:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value
Date:   Sun, 12 May 2019 20:42:37 +0200
Message-Id: <20190512184237.8139-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

should be same as NFT_LOGLEVEL_AUDIT, so use -, not +.

Fixes: 7eced5ab5a73 ("netfilter: nf_tables: add NFT_LOGLEVEL_* enumeration and use it")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 92bb1e2b2425..7bdb234f3d8c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1134,7 +1134,7 @@ enum nft_log_level {
 	NFT_LOGLEVEL_AUDIT,
 	__NFT_LOGLEVEL_MAX
 };
-#define NFT_LOGLEVEL_MAX	(__NFT_LOGLEVEL_MAX + 1)
+#define NFT_LOGLEVEL_MAX	(__NFT_LOGLEVEL_MAX - 1)
 
 /**
  * enum nft_queue_attributes - nf_tables queue expression netlink attributes
-- 
2.21.0

