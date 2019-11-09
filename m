Return-Path: <SRS0=VjVr=ZB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62143C43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Nov 2019 07:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 365D721882
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Nov 2019 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfKIH5W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Nov 2019 02:57:22 -0500
Received: from mx139-tc.baidu.com ([61.135.168.139]:40919 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbfKIH5W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Nov 2019 02:57:22 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Nov 2019 02:57:21 EST
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 59FF52040041
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Nov 2019 15:50:17 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: only call csum_tcpudp_magic for TCP/UDP packets
Date:   Sat,  9 Nov 2019 15:50:17 +0800
Message-Id: <1573285817-32651-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

csum_tcpudp_magic should not be called to compute checksum
for non-TCP/UDP packets, like ICMP with wrong checksum

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/netfilter/utils.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 51b454d8fa9c..72eace52874e 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -17,9 +17,12 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
 			break;
-		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
-		    !csum_fold(skb->csum)) ||
-		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
+		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
+			if (!csum_fold(skb->csum)) {
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				break;
+			}
+		} else if (!csum_tcpudp_magic(iph->saddr, iph->daddr,
 				       skb->len - dataoff, protocol,
 				       skb->csum)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.16.2

