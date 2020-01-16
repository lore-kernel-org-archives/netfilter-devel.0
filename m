Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BDCC3F68F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 07:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680442075B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 07:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgAPHoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 02:44:19 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33046 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbgAPHoT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 02:44:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1irzpA-0003GY-6p; Thu, 16 Jan 2020 08:44:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nft_tunnel: fix null-attribute check
Date:   Thu, 16 Jan 2020 08:44:11 +0100
Message-Id: <20200116074411.19511-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000b62bda059c36db7c@google.com>
References: <000000000000b62bda059c36db7c@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

else we get null deref when one of the attributes is missing, both
must be non-null.

Reported-by: syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Fixes: aaecfdb5c5dd8ba ("netfilter: nf_tables: match on tunnel metadata")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae605a8..d89c7c553030 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -76,7 +76,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 	struct nft_tunnel *priv = nft_expr_priv(expr);
 	u32 len;
 
-	if (!tb[NFTA_TUNNEL_KEY] &&
+	if (!tb[NFTA_TUNNEL_KEY] ||
 	    !tb[NFTA_TUNNEL_DREG])
 		return -EINVAL;
 
-- 
2.24.1

