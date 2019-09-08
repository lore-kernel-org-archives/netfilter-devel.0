Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A75EC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB612082C
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfIHOT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 10:19:59 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3237 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfIHOT7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 10:19:59 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id D29995C16C6;
        Sun,  8 Sep 2019 22:18:57 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 0/4] netfilter: nf_tables_offload: clean offload things when the device unregister
Date:   Sun,  8 Sep 2019 22:18:52 +0800
Message-Id: <1567952336-23669-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSkhCQkJMQk5CSkhMWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kyo6LQw4Qjg5HzUoExMyOTwB
        PzYKC1FVSlVKTk1MQk5JSEhMQkhPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpITUs3Bg++
X-HM-Tid: 0a6d113dfbce2087kuqyd29995c16c6
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This series clean the offload things for both chain and rules when the
related device unregister

This version add a __nft_offload_get_chain common function

wenxu (4):
  netfilter: nf_offload: refactor the nft_flow_offload_chain function
  netfilter: nf_offload: refactor the nft_flow_offload_rule function
  netfilter: nf_tables_offload: add __nft_offload_get_chain function
  netfilter: nf_offload: clean offload things when the device unregister

 include/net/netfilter/nf_tables_offload.h |   2 +-
 net/netfilter/nf_tables_api.c             |   9 ++-
 net/netfilter/nf_tables_offload.c         | 122 ++++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 28 deletions(-)

-- 
1.8.3.1

