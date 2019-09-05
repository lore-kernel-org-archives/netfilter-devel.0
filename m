Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C303EC3A5AB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A377420820
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfIEEAW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:00:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26714 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIEEAV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 00:00:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C99A141623;
        Thu,  5 Sep 2019 12:00:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 0/4] netfilter: nf_tables_offload: clean offload things when the device unregister
Date:   Thu,  5 Sep 2019 12:00:15 +0800
Message-Id: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ01LS0tLSkhITkpPT1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M006Nxw6Ljg2AzcWEB4zATE1
        HBUaFDVVSlVKTk1MTU5NS0pCQkNMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPS0s3Bg++
X-HM-Tid: 0a6cff9487802086kuqyc99a141623
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series clean the offload things for both chain and rules when the
related device unregister

This version add a nft_offload_netdev_iterate common function

wenxu (4):
  netfilter: nf_tables_offload: refactor the nft_flow_offload_chain
    function
  netfilter: nf_tables_offload: refactor the nft_flow_offload_rule
    function
  netfilter: nf_tables_offload: add nft_offload_netdev_iterate function
  netfilter: nf_tables_offload: clean offload things when the device
    unregister

 include/net/netfilter/nf_tables_offload.h |   2 +-
 net/netfilter/nf_tables_api.c             |   9 ++-
 net/netfilter/nf_tables_offload.c         | 122 ++++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 28 deletions(-)

-- 
1.8.3.1

