Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE675C4CEC5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8798020830
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbfIMPDY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:03:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47439 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390374AbfIMPDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 11:03:23 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 881E141170;
        Fri, 13 Sep 2019 23:03:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 0/8]  netfilter: nf_tables_offload: support tunnel offload
Date:   Fri, 13 Sep 2019 23:03:02 +0800
Message-Id: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNS0hCQkJDTkhKSE9KTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRQ6Tgw4MDg2KSsxPzECDyIP
        CglPCzFVSlVKTk1DSENNQkJKTkJPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMSEo3Bg++
X-HM-Tid: 0a6d2b2645ce2086kuqy881e141170
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series add NFT_TUNNEL_IP/6_SRC/DST match and tunnel expr offload.
Also add NFTA_TUNNEL_KEY_RELEASE actions adn objref, tunnel obj offload

This version just rebase to master for patch 7 and make sure
the new code doesn't go over the 80-chars per column boundary

wenxu (8):
  netfilter: nft_tunnel: add nft_tunnel_mode_validate function
  netfilter: nft_tunnel: support NFT_TUNNEL_IP_SRC/DST match
  netfilter: nft_tunnel: add ipv6 check in nft_tunnel_mode_validate
  netfilter: nft_tunnel: support NFT_TUNNEL_IP6_SRC/DST match
  netfilter: nft_tunnel: support tunnel meta match offload
  netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
  netfilter: nft_objref: add nft_objref_type offload
  netfilter: nft_tunnel: support nft_tunnel_obj offload

 include/net/netfilter/nf_tables.h         |   4 +
 include/net/netfilter/nf_tables_offload.h |   5 +
 include/uapi/linux/netfilter/nf_tables.h  |   5 +
 net/netfilter/nft_objref.c                |  14 +++
 net/netfilter/nft_tunnel.c                | 159 +++++++++++++++++++++++++++---
 5 files changed, 174 insertions(+), 13 deletions(-)

-- 
1.8.3.1

