Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5C4CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 08:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjILI4x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjILI4k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 04:56:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03B01715
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 01:56:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qfzC8-0003Gz-HC; Tue, 12 Sep 2023 10:56:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: fix extension size table
Date:   Tue, 12 Sep 2023 10:56:07 +0200
Message-ID: <20230912085615.89333-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The size table is incorrect due to copypaste error,
this reserves more size than needed.

TSTAMP reserved 32 instead of 16 bytes.
TIMEOUT reserved 16 instead of 8 bytes.

Fixes: 5f31edc0676b ("netfilter: conntrack: move extension sizes into core")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_extend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 0b513f7bf9f3..dd62cc12e775 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -40,10 +40,10 @@ static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
 	[NF_CT_EXT_ECACHE] = sizeof(struct nf_conntrack_ecache),
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-	[NF_CT_EXT_TSTAMP] = sizeof(struct nf_conn_acct),
+	[NF_CT_EXT_TSTAMP] = sizeof(struct nf_conn_tstamp),
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	[NF_CT_EXT_TIMEOUT] = sizeof(struct nf_conn_tstamp),
+	[NF_CT_EXT_TIMEOUT] = sizeof(struct nf_conn_timeout),
 #endif
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	[NF_CT_EXT_LABELS] = sizeof(struct nf_conn_labels),
-- 
2.41.0

