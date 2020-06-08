Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426AEC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 00:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217B42072F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 00:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591661305;
	bh=t5rn6fY5B4NyTjQ2KSeHHu3RSksnL7IFn/C9JbijWds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KkSNASMfhNaww/zrkk6RLdC42thZQiPzFZJR+EGrvS98/hfCBoBc1gOmXuv0BKHVA
	 lLmo22B+n4n2vsuh7ph8I2E6B3U8/xOPRmXqwmEx5wCudlnkHOiPn0A7g7dPLqyuyR
	 SmpLhC9gx2NS8GOchrON8i+fqqiXKwuX147fEtjo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbgFIAIQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731003AbgFHXUj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E1A2074B;
        Mon,  8 Jun 2020 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658439;
        bh=t5rn6fY5B4NyTjQ2KSeHHu3RSksnL7IFn/C9JbijWds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAwU0nKjApHrdwDy7QGnITRm4qekuM+07I+A1NgsGWKCsg0VumnuotGy9r2N+E0mE
         kghZk5s3KAsRUwwQjxS/tXNIIzHqWfoudxnvuyRUr5gLQ8CRX7X1uRxsZar+HTGU0K
         SsQua7nR72sjJ2afBdJhvflNA3zjlzgTTNdmYOvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 082/175] netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported
Date:   Mon,  8 Jun 2020 19:17:15 -0400
Message-Id: <20200608231848.3366970-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d7c83463fdf7841350f37960a7abadd3e650b41 ]

Instead of EINVAL which should be used for malformed netlink messages.

Fixes: eb31628e37a0 ("netfilter: nf_tables: Add support for IPv6 NAT")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index c3c93e95b46e..243e8107f456 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -129,7 +129,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->type = NF_NAT_MANIP_DST;
 		break;
 	default:
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	if (tb[NFTA_NAT_FAMILY] == NULL)
@@ -196,7 +196,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (tb[NFTA_NAT_FLAGS]) {
 		priv->flags = ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
 		if (priv->flags & ~NF_NAT_RANGE_MASK)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 	}
 
 	return nf_ct_netns_get(ctx->net, family);
-- 
2.25.1

