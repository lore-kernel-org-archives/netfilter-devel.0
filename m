Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED214C35679
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C96E820661
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgBXF32 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 00:29:28 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:43323 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXF32 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 00:29:28 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id A5D905C17F4;
        Mon, 24 Feb 2020 13:22:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 0/4] netfilter: flowtable: add indr-block offload
Date:   Mon, 24 Feb 2020 13:22:51 +0800
Message-Id: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOTkxCQkJDT0JISkJPTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PCI6KAw6Qzg5KCxIUSJOHU81
        KkowChBVSlVKTkNJTklKTExOTExIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpISk43Bg++
X-HM-Tid: 0a7075a5f6492087kuqya5d905c17f4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide tunnel offload based on route lwtunnel. 
The first two patches support indr callback setup
Then add tunnel match and action offload.

This version modify the second patch: make the dev can bind with different 
flowtable and check the NF_FLOWTABLE_HW_OFFLOAD flags in 
nf_flow_table_indr_block_cb_cmd. 

wenxu (4):
  netfilter: flowtable: add nf_flow_table_block_offload_init()
  netfilter: flowtable: add indr block setup support
  netfilter: flowtable: add tunnel match offload support
  netfilter: flowtable: add tunnel encap/decap action offload support

 net/netfilter/nf_flow_table_offload.c | 233 ++++++++++++++++++++++++++++++++--
 1 file changed, 219 insertions(+), 14 deletions(-)

-- 
1.8.3.1

