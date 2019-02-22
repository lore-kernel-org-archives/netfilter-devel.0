Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8146C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 08:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EB712077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 08:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfBVI66 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:58:58 -0500
Received: from mx137-tc.baidu.com ([61.135.168.137]:27558 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbfBVI66 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 03:58:58 -0500
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2019 03:58:57 EST
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id E4EF911C0034
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Feb 2019 16:58:44 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][nf-next] netfilter: remove unneeded switch fall-through
Date:   Fri, 22 Feb 2019 16:58:44 +0800
Message-Id: <1550825924-18063-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Empty case is fine and does not switch fall-through 

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/netfilter/nf_nat_core.c    | 2 +-
 net/netfilter/nf_tables_core.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 35e61038ae96..d4dd60a85328 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -182,7 +182,7 @@ static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 	__be16 port;
 
 	switch (tuple->dst.protonum) {
-	case IPPROTO_ICMP: /* fallthrough */
+	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
 		return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
 		       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2a00aef7b6d4..e56a94dff34e 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -221,7 +221,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
-		/* fall through */
 	case NFT_RETURN:
 		nft_trace_packet(&info, chain, rule,
 				 NFT_TRACETYPE_RETURN);
-- 
2.16.2

