Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96654C43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 07:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60D2A21A49
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 07:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfKMHeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 02:34:14 -0500
Received: from mx132-tc.baidu.com ([61.135.168.132]:51730 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725858AbfKMHeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 02:34:14 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 78B97204005E
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2019 15:34:01 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][v2] netfilter: only call csum_tcpudp_magic for TCP/UDP packets
Date:   Wed, 13 Nov 2019 15:34:01 +0800
Message-Id: <1573630441-13937-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

csum_tcpudp_magic should not be called to compute checksum
for non-TCP/UDP packets, like ICMP with wrong checksum

Fixes: 5d1549847c76 ("netfilter: Fix remainder of pseudo-header protocol 0")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1:
rewrite the code as suggested
add fixes tag

 net/netfilter/utils.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 51b454d8fa9c..0f78416566fa 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -17,12 +17,21 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
 			break;
-		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
-		    !csum_fold(skb->csum)) ||
-		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
-				       skb->len - dataoff, protocol,
-				       skb->csum)) {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		switch (protocol) {
+		case IPPROTO_TCP:
+		case IPPROTO_UDP:
+			if (!csum_tcpudp_magic(iph->saddr, iph->daddr,
+					    skb->len - dataoff,
+					    protocol, skb->csum)) {
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				return 0;
+			}
+			break;
+		default:
+			if (!csum_fold(skb->csum)) {
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				return 0;
+			}
 			break;
 		}
 		/* fall through */
-- 
2.16.2

