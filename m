Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9AFC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 09:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346272AbiCOJQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiCOJQd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 05:16:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4039249CAB;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9110F6300F;
        Tue, 15 Mar 2022 10:13:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 1/6] Revert "netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY"
Date:   Tue, 15 Mar 2022 10:15:08 +0100
Message-Id: <20220315091513.66544-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315091513.66544-1-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This reverts commit 5bed9f3f63f8f9d2b1758c24640cbf77b5377511.

Gal Presman says:
 this patch broke geneve tunnels, or possibly all udp tunnels?
 A simple test that creates two geneve tunnels and runs tcp iperf fails
 and results in checksum errors (TcpInCsumErrors).

Original commit wanted to fix nf_reject with zero checksum,
so it appears better to change nf reject infra instead.

Fixes: 5bed9f3f63f8f ("netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY")
Reported-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 12f793d8fe0c..3b516cffc779 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -63,10 +63,8 @@ static bool udp_error(struct sk_buff *skb,
 	}
 
 	/* Packet with no checksum */
-	if (!hdr->check) {
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (!hdr->check)
 		return false;
-	}
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
-- 
2.30.2

