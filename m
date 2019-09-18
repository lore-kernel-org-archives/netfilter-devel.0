Return-Path: <SRS0=T2b5=XN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC977C4CEC4
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 08:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AED420882
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 08:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfIRIDQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 04:03:16 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41672 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfIRIDQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 04:03:16 -0400
Received: from [192.168.1.4] (unknown [180.157.105.184])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A217641917;
        Wed, 18 Sep 2019 16:03:11 +0800 (CST)
Subject: Re: [PATCH nf-next v6 0/8] netfilter: nf_tables_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <ff59a395-b823-6e49-8241-8f2841523a87@ucloud.cn>
Date:   Wed, 18 Sep 2019 16:02:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhOS0tLSk5MSE5NSU1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OU06NTo4Kjg6FyoXDSs4AkxJ
        NCkaCixVSlVKTk1DTEJITEJKQkpKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktOVUpDT1lXWQgBWUFJSE1KNwY+
X-HM-Tid: 0a6d43658d2e2086kuqya217641917
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,

Any comments for this series?


BR

wenxu

在 2019/9/13 23:03, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This series add NFT_TUNNEL_IP/6_SRC/DST match and tunnel expr offload.
> Also add NFTA_TUNNEL_KEY_RELEASE actions adn objref, tunnel obj offload
>
> This version just rebase to master for patch 7 and make sure
> the new code doesn't go over the 80-chars per column boundary
>
> wenxu (8):
>   netfilter: nft_tunnel: add nft_tunnel_mode_validate function
>   netfilter: nft_tunnel: support NFT_TUNNEL_IP_SRC/DST match
>   netfilter: nft_tunnel: add ipv6 check in nft_tunnel_mode_validate
>   netfilter: nft_tunnel: support NFT_TUNNEL_IP6_SRC/DST match
>   netfilter: nft_tunnel: support tunnel meta match offload
>   netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
>   netfilter: nft_objref: add nft_objref_type offload
>   netfilter: nft_tunnel: support nft_tunnel_obj offload
>
>  include/net/netfilter/nf_tables.h         |   4 +
>  include/net/netfilter/nf_tables_offload.h |   5 +
>  include/uapi/linux/netfilter/nf_tables.h  |   5 +
>  net/netfilter/nft_objref.c                |  14 +++
>  net/netfilter/nft_tunnel.c                | 159 +++++++++++++++++++++++++++---
>  5 files changed, 174 insertions(+), 13 deletions(-)
>
