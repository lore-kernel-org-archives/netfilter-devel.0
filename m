Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2928EE0213
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjIMV6Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjIMV6X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C841B1739;
        Wed, 13 Sep 2023 14:58:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 7/9] netfilter: conntrack: fix extension size table
Date:   Wed, 13 Sep 2023 23:57:58 +0200
Message-Id: <20230913215800.107269-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230913215800.107269-1-pablo@netfilter.org>
References: <20230913215800.107269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The size table is incorrect due to copypaste error,
this reserves more size than needed.

TSTAMP reserved 32 instead of 16 bytes.
TIMEOUT reserved 16 instead of 8 bytes.

Fixes: 5f31edc0676b ("netfilter: conntrack: move extension sizes into core")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

