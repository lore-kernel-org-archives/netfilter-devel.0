Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34DAC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 21:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAE261073
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 21:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhJYVxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 17:53:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJYVxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 17:53:03 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C116063F4D
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Oct 2021 23:48:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] cache: honor filter in set listing commands
Date:   Mon, 25 Oct 2021 23:50:31 +0200
Message-Id: <20211025215032.1073625-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025215032.1073625-1-pablo@netfilter.org>
References: <20211025215032.1073625-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fetch table, set and set elements only for set listing commands, e.g.
nft list set inet filter ipv4_bogons.

Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 3cbf99e8e124..691e8131c494 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -146,6 +146,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		}
 		if (nft_output_terse(&nft->output))
 			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM);
+		else if (filter->table && filter->set)
+			flags |= NFT_CACHE_TABLE | NFT_CACHE_SET | NFT_CACHE_SETELEM;
 		else
 			flags |= NFT_CACHE_FULL;
 		break;
-- 
2.30.2

