Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC64FC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 03:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B238360EB2
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 03:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGZDQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jul 2021 23:16:57 -0400
Received: from out0.migadu.com ([94.23.1.103]:26221 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbhGZDQz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jul 2021 23:16:55 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627271839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=42/x3cunuNFrK5WXYNzv0PumgHH417h+iX4VfozjEqg=;
        b=TTEDvxwLws0uMFv8PMZ4WRAA59G66FCBFtiLFTvnsFeltMxFuQk7l7cp4tACqzT9nHNY5g
        M2zbbPyGukGSDcBtLh3VIHQ8lk+cSHfB5YjoJ9enWMDamCcWT0AnAWDS7+WhLFcSTcjQg0
        5KGfiyhcz2rKOta51MylqUExs8RZlTY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] netfilter: nf_conntrack_bridge: Fix not free when error
Date:   Mon, 26 Jul 2021 11:57:02 +0800
Message-Id: <20210726035702.11964-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It should be added kfree_skb_list() when err is not equal to zero
in nf_br_ip_fragment().

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..059f53903eda 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -83,12 +83,16 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
-			if (err || !iter.frag)
-				break;
-
+			if (err) {
+				kfree_skb_list(iter.frag);
+				return err;
+			}
+
+			if (!iter.frag)
+				return 0;
+
 			skb = ip_fraglist_next(&iter);
 		}
-		return err;
 	}
 slow_path:
 	/* This is a linearized skbuff, the original geometry is lost for us.
-- 
2.32.0

