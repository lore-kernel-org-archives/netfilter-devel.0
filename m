Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C53C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D87F62238E
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389984AbfGWMwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:52:47 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26591 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbfGWMwr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id AE65741C2D;
        Tue, 23 Jul 2019 20:52:45 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/7] netfilter: nf_tables_offload: support more actions
Date:   Tue, 23 Jul 2019 20:52:37 +0800
Message-Id: <1563886364-11164-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0hCQkJCSkJDQkpITVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6Phw*ETgzSVEjIi4RTiET
        Tw8KFDpVSlVKTk1IQ0NNSE1OTE5LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDS0g3Bg++
X-HM-Tid: 0a6c1ee42c1e2086kuqyae65741c2d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series patch support fw_nedev and set payload offload. Keep action data in
reg  through immedidate offload

wenxu (7):
  netfilter: nf_flow_offload: add net in offload_ctx
  netfilter: nf_tables_offload: add offload_actions callback
  netfilter: nft_table_offload: Add rtnl for chain and rule operations
  netfilter: nf_tables_offload: split nft_offload_reg to match and
    action type
  netfilter: nft_immediate: add offload support for actions
  netfilter: nft_fwd_netdev: add fw_netdev action support
  netfilter: nft_payload: add nft_set_payload offload support

 include/net/netfilter/nf_tables.h         |  7 ++-
 include/net/netfilter/nf_tables_offload.h | 25 +++++++--
 net/netfilter/nf_tables_api.c             |  2 +-
 net/netfilter/nf_tables_offload.c         | 23 +++++---
 net/netfilter/nft_cmp.c                   | 10 ++--
 net/netfilter/nft_fwd_netdev.c            | 30 +++++++++++
 net/netfilter/nft_immediate.c             | 47 ++++++++++------
 net/netfilter/nft_meta.c                  |  6 ++-
 net/netfilter/nft_payload.c               | 90 ++++++++++++++++++++++++++-----
 9 files changed, 191 insertions(+), 49 deletions(-)

-- 
1.8.3.1

