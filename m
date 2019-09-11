Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4D1C4740A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B850E21D79
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfIKEx2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 00:53:28 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59564 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfIKEx2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 00:53:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3FBA04170C;
        Wed, 11 Sep 2019 12:53:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 0/4] netfilter: nf_tables_offload: clean offload things when the device unregister
Date:   Wed, 11 Sep 2019 12:53:20 +0800
Message-Id: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVOTUpCQkJOTkJPS0lPTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MC46Tww*PTg3LTQRFjEQMEoj
        SU0KCy9VSlVKTk1DSkxMTUtOSE9CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPSU83Bg++
X-HM-Tid: 0a6d1eab4a9a2086kuqy3fba04170c
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series clean the offload things for both chain and rules when the
related device unregister

this version modify the 2/4 and 3/4 and only refactor the
nft_flow_offload_chain/rule function with no add other functions

wenxu (4):
  netfilter: nf_tables_offload: add __nft_offload_get_chain function
  netfilter: nf_offload: refactor the nft_flow_offload_chain function
  netfilter: nf_offload: refactor the nft_flow_offload_rule function
  netfilter: nf_offload: clean offload things when the device unregister

 include/net/netfilter/nf_tables_offload.h |   2 +-
 net/netfilter/nf_tables_api.c             |   9 +-
 net/netfilter/nf_tables_offload.c         | 135 ++++++++++++++++++++++--------
 3 files changed, 110 insertions(+), 36 deletions(-)

-- 
1.8.3.1

