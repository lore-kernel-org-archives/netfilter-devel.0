Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55E7C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 959AF613BC
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbhD0Uoj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 16:44:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbhD0Uoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 16:44:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C53F464124;
        Tue, 27 Apr 2021 22:43:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/7] netfilter: nftables: add helper function to validate set element data
Date:   Tue, 27 Apr 2021 22:43:42 +0200
Message-Id: <20210427204345.22043-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When binding sets to rule, validate set element data according to
set definition. This patch adds a helper function to be reused by
the catch-all set element support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3342f260d534..faf0424375e8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4499,10 +4499,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_data_types type,
 				       unsigned int len);
 
-static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
-					struct nft_set *set,
-					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+static int nft_setelem_data_validate(const struct nft_ctx *ctx,
+				     struct nft_set *set,
+				     struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	enum nft_registers dreg;
@@ -4514,6 +4513,14 @@ static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					   set->dlen);
 }
 
+static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
+					struct nft_set *set,
+					const struct nft_set_iter *iter,
+					struct nft_set_elem *elem)
+{
+	return nft_setelem_data_validate(ctx, set, elem);
+}
+
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
-- 
2.30.2

