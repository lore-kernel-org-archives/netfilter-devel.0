Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DC9C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 07:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 430DF22CBC
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 07:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbfGYHoB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 03:44:01 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59892 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388193AbfGYHoA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 03:44:00 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 885164134B;
        Thu, 25 Jul 2019 15:43:58 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2] netfilter: nft_tunnel: Fix don't convert tun id to host endian
Date:   Thu, 25 Jul 2019 15:43:53 +0800
Message-Id: <1564040633-25728-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVCTk9CQkJCSUhMS01LTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTY6Hio*Ezg4CFZPDxoLKj4M
        KD4aChRVSlVKTk1PS09LTUhDTUJIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKSk43Bg++
X-HM-Tid: 0a6c2816309b2086kuqy885164134b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the action store tun_id to reg in a host endian. But the
nft_cmp action get the user data in a net endian which lead
match failed.

nft --debug=netlink add rule netdev firewall aclin ip daddr 10.0.0.7
tunnel tun_id 1000 fwd to eth0

the expr tunnel tun_id 1000 --> [ cmp eq reg 1 0xe8030000 ]:
the cmp expr set the tun_id 1000 in network endian.

So the tun_id should be store as network endian. Which is the
same as nft_payload match. 

[ meta load protocol => reg 1 ]
[ cmp eq reg 1 0x00000008 ]
[ payload load 4b @ network header + 16 => reg 1 ]
[ cmp eq reg 1 0x0700000a ]
[ tunnel load id => reg 1 ]
[ cmp eq reg 1 0xe8030000 ]
[ immediate reg 1 0x0000000f ]
[ fwd sreg_dev 1 ]

Fixes: aaecfdb5c5dd ("netfilter: nf_tables: match on tunnel metadata")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae..c9f4585 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -53,7 +53,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
 		    (priv->mode == NFT_TUNNEL_MODE_TX &&
 		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
-			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+			*dest = tunnel_id_to_key32(tun_info->key.tun_id);
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
-- 
1.8.3.1

