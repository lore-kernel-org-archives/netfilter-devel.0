Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F78FC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D895B2238C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbfGYNjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:39:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:6281 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389517AbfGYNjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 09:39:55 -0400
Received: from [192.168.1.4] (unknown [222.68.25.235])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8F005417C0;
        Thu, 25 Jul 2019 21:39:50 +0800 (CST)
Subject: Re: [PATCH nf-next v6 0/8] netfilter: nf_flow_offload: support bridge
 family offload for both ipv4 and ipv6
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <7917546c-3acf-1e6b-6703-728d041502f0@ucloud.cn>
Date:   Thu, 25 Jul 2019 21:39:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTU1CS0tLSENMSkJKTExZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pz46KBw*HDg*FEsUDBIQHAk0
        HyNPCh5VSlVKTk1PS01KQkJLQ0JIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUlJSVVN
        Q1VJTlVJSE5ZV1kIAVlBSU1MTjcG
X-HM-Tid: 0a6c295bff932086kuqy8f005417c0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


The series patches are any problem?


BR

wenxu

在 2019/7/25 19:12, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This series only rebase to matser for the last patch 
> netfilter: Support the bridge family in flow table
>
> wenxu (8):
>   netfilter:nf_flow_table: Refactor flow_offload_tuple to destination
>   netfilter:nf_flow_table_core: Separate inet operation to single
>     function
>   netfilter:nf_flow_table_ip: Separate inet operation to single function
>   bridge: add br_vlan_get_info_rcu()
>   netfilter:nf_flow_table_core: Support bridge family flow offload
>   netfilter:nf_flow_table_ip: Support bridge family flow offload
>   netfilter:nft_flow_offload: Support bridge family flow offload
>   netfilter: Support the bridge family in flow table
>
>  include/linux/if_bridge.h                   |   7 ++
>  include/net/netfilter/nf_flow_table.h       |  39 +++++++-
>  net/bridge/br_vlan.c                        |  25 +++++
>  net/bridge/netfilter/Kconfig                |   8 ++
>  net/bridge/netfilter/Makefile               |   1 +
>  net/bridge/netfilter/nf_flow_table_bridge.c |  48 ++++++++++
>  net/netfilter/nf_flow_table_core.c          | 102 ++++++++++++++++----
>  net/netfilter/nf_flow_table_ip.c            | 127 +++++++++++++++++++------
>  net/netfilter/nft_flow_offload.c            | 142 ++++++++++++++++++++++++++--
>  9 files changed, 440 insertions(+), 59 deletions(-)
>  create mode 100644 net/bridge/netfilter/nf_flow_table_bridge.c
>
