Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26C3C761AA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B92DA21901
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403849AbfGYLNA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 07:13:00 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19846 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391607AbfGYLNA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:13:00 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E22F941C9E;
        Thu, 25 Jul 2019 19:12:56 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 0/8] netfilter: nf_flow_offload: support bridge family offload for both ipv4 and ipv6
Date:   Thu, 25 Jul 2019 19:12:48 +0800
Message-Id: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVLT0NLS0tLQkxJTE9MQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KxA6Txw5ITg4TVYzHQgzPxYX
        Ak4aCQxVSlVKTk1PS05ISkxNQk1IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLSEs3Bg++
X-HM-Tid: 0a6c28d582692086kuqye22f941c9e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series only rebase to matser for the last patch 
netfilter: Support the bridge family in flow table

wenxu (8):
  netfilter:nf_flow_table: Refactor flow_offload_tuple to destination
  netfilter:nf_flow_table_core: Separate inet operation to single
    function
  netfilter:nf_flow_table_ip: Separate inet operation to single function
  bridge: add br_vlan_get_info_rcu()
  netfilter:nf_flow_table_core: Support bridge family flow offload
  netfilter:nf_flow_table_ip: Support bridge family flow offload
  netfilter:nft_flow_offload: Support bridge family flow offload
  netfilter: Support the bridge family in flow table

 include/linux/if_bridge.h                   |   7 ++
 include/net/netfilter/nf_flow_table.h       |  39 +++++++-
 net/bridge/br_vlan.c                        |  25 +++++
 net/bridge/netfilter/Kconfig                |   8 ++
 net/bridge/netfilter/Makefile               |   1 +
 net/bridge/netfilter/nf_flow_table_bridge.c |  48 ++++++++++
 net/netfilter/nf_flow_table_core.c          | 102 ++++++++++++++++----
 net/netfilter/nf_flow_table_ip.c            | 127 +++++++++++++++++++------
 net/netfilter/nft_flow_offload.c            | 142 ++++++++++++++++++++++++++--
 9 files changed, 440 insertions(+), 59 deletions(-)
 create mode 100644 net/bridge/netfilter/nf_flow_table_bridge.c

-- 
1.8.3.1

