Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C04C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 03:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 405EC206B8
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 03:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfHADD6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 23:03:58 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:39593 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfHADD5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 23:03:57 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 012E4417BA;
        Thu,  1 Aug 2019 11:03:47 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        jakub.kicinski@netronome.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 0/6] flow_offload: add indr-block in nf_table_offload
Date:   Thu,  1 Aug 2019 11:03:41 +0800
Message-Id: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIS0hCQkJCS0tDSkxDTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pi46ERw5Lzg0OkgLDTIQEDhC
        SQMwC0JVSlVKTk1PTUlDTUlDSUpJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlISEs3Bg++
X-HM-Tid: 0a6c4b2232a52086kuqy012e4417ba
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

