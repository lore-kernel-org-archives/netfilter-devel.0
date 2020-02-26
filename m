Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCA9C4BA24
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 18:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5360B20714
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 18:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBZSrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 13:47:41 -0500
Received: from correo.us.es ([193.147.175.20]:50454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbgBZSrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 13:47:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAC10F23AB
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 19:47:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EE14DA390
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 19:47:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 946AADA3C2; Wed, 26 Feb 2020 19:47:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8171DA8E6;
        Wed, 26 Feb 2020 19:47:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 19:47:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 717B742EF42A;
        Wed, 26 Feb 2020 19:47:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        johannes.berg@intel.com
Subject: [PATCH net] netlink: Use netlink header as base to calculate bad attribute offset
Date:   Wed, 26 Feb 2020 19:47:34 +0100
Message-Id: <20200226184734.1866-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userspace might send a batch that is composed of several netlink
messages. The netlink_ack() function must use the pointer to the netlink
header as base to calculate the bad attribute offset.

Fixes: 2d4bc93368f5 ("netlink: extended ACK reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index edf3e285e242..5313f1cec170 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2434,7 +2434,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 							       in_skb->len))
 				WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
 						    (u8 *)extack->bad_attr -
-						    in_skb->data));
+						    (u8 *)nlh));
 		} else {
 			if (extack->cookie_len)
 				WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
-- 
2.11.0

