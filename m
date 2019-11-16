Return-Path: <SRS0=YpW3=ZI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A160C33C8C
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 07:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0592072D
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 07:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfKPHt2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 02:49:28 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57388 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfKPHt2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 02:49:28 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 594C641223;
        Sat, 16 Nov 2019 15:49:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 0/4] netfilter: nft_tunnel: support tunnel match expr offload
Date:   Sat, 16 Nov 2019 15:49:20 +0800
Message-Id: <1573890564-16500-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0hCQkJDTUlNTEtCWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDY6Fxw6Hzg9TApCTAMaPysj
        HUsaCxlVSlVKTkxIQ0JLTk1PT0hDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpKQk83Bg++
X-HM-Tid: 0a6e733021152086kuqy594c641223
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series add NFT_TUNNEL_IPV4/6_SRC/DST match and tunnel expr offload.

wenxu (4):
  netfilter: nft_tunnel: add nft_tunnel_mode_match function
  netfilter: nft_tunnel: support NFT_TUNNEL_IPV4_SRC/DST match
  netfilter: nft_tunnel: support NFT_TUNNEL_IPV6_SRC/DST match
  netfilter: nft_tunnel: add nft_tunnel_get_offload support

 include/net/netfilter/nf_tables_offload.h |   5 ++
 include/uapi/linux/netfilter/nf_tables.h  |   4 +
 net/netfilter/nft_tunnel.c                | 138 +++++++++++++++++++++++++++---
 3 files changed, 134 insertions(+), 13 deletions(-)

-- 
1.8.3.1

