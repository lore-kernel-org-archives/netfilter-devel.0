Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C47C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 07:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A210A2087E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 07:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfIDHHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 03:07:36 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:45443 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDHHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 03:07:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 18DFD41960;
        Wed,  4 Sep 2019 15:07:32 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 0/3] netfilter: nf_tables_offload: clean offload things when the device unregister
Date:   Wed,  4 Sep 2019 15:07:28 +0800
Message-Id: <1567580851-15042-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0lLS0tLS0xNSUJIQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MzY6Nio4KDg9HzA1Nx0rGSIB
        HDowCw1VSlVKTk1MTkNLQ05JSU5MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpIS0I3Bg++
X-HM-Tid: 0a6cfb198f8d2086kuqy18dfd41960
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series clean the offload things for both chain and rules when the
related device unregister

This version add a netdev notify to clean this things in the nft_offload_init

wenxu (3):
  netfilter: nf_offload: refactor the nft_flow_offload_chain function
  netfilter: nf_offload: refactor the nft_flow_offload_rule function
  netfilter: nf_offload: clean offload things when the device unregister

 include/net/netfilter/nf_tables_offload.h |   2 +-
 net/netfilter/nf_tables_api.c             |   9 ++-
 net/netfilter/nf_tables_offload.c         | 110 +++++++++++++++++++++++++-----
 3 files changed, 102 insertions(+), 19 deletions(-)

-- 
1.8.3.1

