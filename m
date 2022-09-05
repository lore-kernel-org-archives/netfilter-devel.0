Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED73AECAAD5
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Sep 2022 10:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiIEKKD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Sep 2022 06:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbiIEKKA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2022 06:10:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11967192A2;
        Mon,  5 Sep 2022 03:09:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oV93E-0003iH-Bt; Mon, 05 Sep 2022 12:09:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/2] netfilter: nft_payload: reject out-of-range attributes via policy
Date:   Mon,  5 Sep 2022 12:09:37 +0200
Message-Id: <20220905100937.11459-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220905100937.11459-1-fw@strlen.de>
References: <20220905100937.11459-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that nla_policy allows range checks for bigendian data make use of
this to reject such attributes.  At this time, reject happens later
from the init or select_ops callbacks, but its prone to errors.

In the future, new attributes can be handled via NLA_POLICY_MAX_BE
and exiting ones can be converted one by one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index eb0e40c29712..088244f9d838 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -173,10 +173,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX_BE(NLA_U32, 255),
 	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
-- 
2.35.1

