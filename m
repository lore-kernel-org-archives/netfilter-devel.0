Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C66BC32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 08:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2425A20693
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 08:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGaIMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:12:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50497 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfGaIMh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 04:12:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 707DF419F8;
        Wed, 31 Jul 2019 16:12:34 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6] flow_offload: add indr-block in nf_table_offload
Date:   Wed, 31 Jul 2019 16:12:27 +0800
Message-Id: <1564560753-32603-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0tCQkJDQkNCSktOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxA6NRw*HTgyFEgpLA9KHjIf
        OSswCzJVSlVKTk1PTk1LTE5PTkxOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlISU83Bg++
X-HM-Tid: 0a6c4716873a2086kuqy707df419f8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series patch make nftables offload support the vlan and
tunnel device offload through indr-block architecture.

The first four patches mv tc indr block to flow offload and
rename to flow-indr-block.
Because the new flow-indr-block can't get the tcf_block
directly. The fifthe patch provide a callback list to get 
flow_block of each subsystem immediately when the device
register and contain a block.
The last patch make nf_tables_offload support flow-indr-block.

wenxu (6):
  cls_api: modify the tc_indr_block_ing_cmd parameters.
  cls_api: replace block with flow_block in tc_indr_block_dev
  cls_api: add flow_indr_block_call function
  flow_offload: move tc indirect block to flow offload
  flow_offload: support get flow_block immediately
  netfilter: nf_tables_offload: support indr block call

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  11 +-
 include/net/flow_offload.h                         |  48 ++++
 include/net/netfilter/nf_tables_offload.h          |   2 +
 include/net/pkt_cls.h                              |  35 ---
 include/net/sch_generic.h                          |   3 -
 net/core/flow_offload.c                            | 251 ++++++++++++++++++++
 net/netfilter/nf_tables_api.c                      |   7 +
 net/netfilter/nf_tables_offload.c                  | 156 +++++++++++--
 net/sched/cls_api.c                                | 255 ++++-----------------
 10 files changed, 497 insertions(+), 281 deletions(-)

-- 
1.8.3.1

