Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51021C33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30256207E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgANKAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:00:43 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:56969 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgANKAm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 05:00:42 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7DC0541881;
        Tue, 14 Jan 2020 18:00:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 0/4] netfilter: flowtable: add indr-block offload
Date:   Tue, 14 Jan 2020 18:00:36 +0800
Message-Id: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJTEJCQkJCTEpIQ0JMTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxg6MAw4Fzg0TzI#PDdLGEoD
        QhZPFENVSlVKTkxDQkJNS09LTUtKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpJQ0o3Bg++
X-HM-Tid: 0a6fa37f834e2086kuqy7dc0541881
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide tunnel offload based on route lwtunnel. 
The first two patches support indr callback setup
Then add tunnel match and action offload.

This version just rebase to the nf-next.

Pablo, please give me some feedback. If you feel this series is ok, please
apply it. Thanks.

wenxu (4):
  netfilter: flowtable: add nf_flow_table_block_offload_init()
  netfilter: flowtable: add indr block setup support
  netfilter: flowtable: add tunnel match offload support
  netfilter: flowtable: add tunnel encap/decap action offload support

 net/netfilter/nf_flow_table_offload.c | 239 +++++++++++++++++++++++++++++++---
 1 file changed, 222 insertions(+), 17 deletions(-)

-- 
1.8.3.1

