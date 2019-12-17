Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD3AC2D0C8
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702DA2072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 08:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfLQIw5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 03:52:57 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:20005 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfLQIw5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 03:52:57 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0E41541A20;
        Tue, 17 Dec 2019 16:52:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf v2 0/3] netfilter: nf_flow_table_offload: something fixes
Date:   Tue, 17 Dec 2019 16:52:44 +0800
Message-Id: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOTkJCQkJCT0lMTEJOT1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OQw6DSo*QzgxH00#Lxg#PDgP
        KzNPCh5VSlVKTkxNTkxJTE1DSkxJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJDQjcG
X-HM-Tid: 0a6f130f4f472086kuqy0e41541a20
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This version fix a release neigh problem in the v1 for patch2

wenxu (3):
  netfilter: nf_flow_table_offload: fix dst_neigh lookup
  netfilter: nf_flow_table_offload: check the status of dst_neigh
  netfilter: nf_flow_table_offload: fix the nat port mangle.

 net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

-- 
1.8.3.1

