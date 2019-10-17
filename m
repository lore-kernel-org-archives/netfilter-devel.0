Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D07CA9EC8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9541221A49
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441584AbfJQWta (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 18:49:30 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42648 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438306AbfJQWta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 18:49:30 -0400
Received: from localhost ([::1]:55738 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLEaG-00046C-Sb; Fri, 18 Oct 2019 00:49:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/8] xtables-restore: Treat struct nft_xt_restore_parse as const
Date:   Fri, 18 Oct 2019 00:48:29 +0200
Message-Id: <20191017224836.8261-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191017224836.8261-1-phil@nwl.cc>
References: <20191017224836.8261-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This structure contains restore parser configuration, parser is not
supposed to alter it.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h      | 2 +-
 iptables/xtables-restore.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 9d62913461fa4..a330aceb9785c 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -261,7 +261,7 @@ struct nft_xt_restore_cb {
 };
 
 void xtables_restore_parse(struct nft_handle *h,
-			   struct nft_xt_restore_parse *p,
+			   const struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb,
 			   int argc, char *argv[]);
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 4f6d324bdafe9..cb03104e91a7b 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -86,7 +86,7 @@ static const struct xtc_ops xtc_ops = {
 };
 
 void xtables_restore_parse(struct nft_handle *h,
-			   struct nft_xt_restore_parse *p,
+			   const struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb,
 			   int argc, char *argv[])
 {
-- 
2.23.0

