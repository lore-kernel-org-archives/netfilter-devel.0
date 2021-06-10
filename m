Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC28C48BE0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DAFF613E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFJS4M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 14:56:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35098 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhFJS4M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 14:56:12 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C7ADE6423B
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jun 2021 20:53:00 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/2] expr: missing netlink attribute in last expression
Date:   Thu, 10 Jun 2021 20:54:10 +0200
Message-Id: <20210610185410.13834-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210610185410.13834-1-pablo@netfilter.org>
References: <20210610185410.13834-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFTA_LAST_SET is missing, add it.

Fixes: ed7c442c2d04 ("expr: add last match time support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Already applied, I accidentally pushed it out, just for the record.

 include/linux/netfilter/nf_tables.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5beb5a807687..e94d1fa554cb 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1198,10 +1198,12 @@ enum nft_counter_attributes {
 /**
  * enum nft_last_attributes - nf_tables last expression netlink attributes
  *
+ * @NFTA_LAST_SET: last update has been set, zero means never updated (NLA_U32)
  * @NFTA_LAST_MSECS: milliseconds since last update (NLA_U64)
  */
 enum nft_last_attributes {
 	NFTA_LAST_UNSPEC,
+	NFTA_LAST_SET,
 	NFTA_LAST_MSECS,
 	NFTA_LAST_PAD,
 	__NFTA_LAST_MAX
-- 
2.30.2

