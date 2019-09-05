Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11A0C3A5A5
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4A68206BB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfIEEIY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:08:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41174 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIEEIY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 00:08:24 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BAA6A4160F;
        Thu,  5 Sep 2019 12:08:21 +0800 (CST)
Subject: Re: [PATCH nf-next v5 0/8] netfilter: nf_tables_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1566364193-31330-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <e78d3b61-0e89-97aa-0008-c3cad2c9ac5d@ucloud.cn>
Date:   Thu, 5 Sep 2019 12:08:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566364193-31330-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTkJIS0tLSkxITk1DTEhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngw6STo4DTg1SDctEBIBVi5P
        KDBPCxNVSlVKTk1MTU5NTktKQk9DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUhDSTcG
X-HM-Tid: 0a6cff9be2752086kuqybaa6a4160f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Any comments for this series?

BR

wenxu

On 8/21/2019 1:09 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This series add NFT_TUNNEL_IP/6_SRC/DST match and tunnel expr offload.
> Also add NFTA_TUNNEL_KEY_RELEASE actions adn objref, tunnel obj offload
>
> This version just split from the orignal big seriese without dependency
> with each other
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
>  include/net/netfilter/nf_tables.h         |   3 +
>  include/net/netfilter/nf_tables_offload.h |   5 +
>  include/uapi/linux/netfilter/nf_tables.h  |   5 +
>  net/netfilter/nft_objref.c                |  14 +++
>  net/netfilter/nft_tunnel.c                | 159 +++++++++++++++++++++++++++---
>  5 files changed, 173 insertions(+), 13 deletions(-)
>
