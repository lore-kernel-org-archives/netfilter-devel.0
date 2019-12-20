Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C17C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32BF52073D
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTEOl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 23:14:41 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:27199 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfLTEOk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 23:14:40 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id EFC895C0F5C;
        Fri, 20 Dec 2019 12:14:38 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v3 0/3] netfilter: nf_flow_table_offload: something fixes
Date:   Fri, 20 Dec 2019 12:14:35 +0800
Message-Id: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOTUlCQkJCTUhMTUtIQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nz46AQw6UTgwVkwRHwJNI0IX
        Th4KCSxVSlVKTkxNQ0pOSUxCS0JIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJCQjcG
X-HM-Tid: 0a6f2183bb9a2087kuqyefc895c0f5c
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This version just modify the description of  patch 1 and 3 

wenxu (3):
  netfilter: nf_flow_table_offload: fix incorrect ethernet dst address
  netfilter: nf_flow_table_offload: check the status of dst_neigh
  netfilter: nf_flow_table_offload: fix the nat port mangle.

 net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

-- 
1.8.3.1

