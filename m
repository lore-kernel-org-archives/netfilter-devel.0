Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19490CD13D2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 12:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbjIRMHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 08:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241749AbjIRMHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 08:07:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF8C61AB;
        Mon, 18 Sep 2023 05:07:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.19 2/2] netfilter: nf_tables: missing NFT_TRANS_PREPARE_ERROR in flowtable deactivatation
Date:   Mon, 18 Sep 2023 14:06:56 +0200
Message-Id: <20230918120656.218135-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230918120656.218135-1-pablo@netfilter.org>
References: <20230918120656.218135-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit 26b5a5712eb85e253724e56a54c17f8519bd8e4e upstream.

Missing NFT_TRANS_PREPARE_ERROR in 1df28fde1270 ("netfilter: nf_tables: add
NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19.

Fixes: 1df28fde1270 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eeadb638f448..0ff8f1006c6b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5555,6 +5555,7 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 				    enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
-- 
2.30.2

