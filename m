Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4427ECA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F54720684
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbfJXJks (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:40:48 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:31746 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfJXJks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 05:40:48 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id A4EA95C1876;
        Thu, 24 Oct 2019 17:40:45 +0800 (CST)
Subject: Re: [PATCH nf-next v6 0/8] netfilter: nf_tables_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <735a49cd-ce6f-8915-fa62-c23a730db822@ucloud.cn>
Date:   Thu, 24 Oct 2019 17:40:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pJS0tLS01LS0NKT0NZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mjo6PSo*NDg3Dx4qOREwTQ1L
        AzMaFDhVSlVKTkxKQkpLS09OQ0hPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU5KSzcG
X-HM-Tid: 0a6dfd23d03d2087kuqya4ea95c1876
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

please drop this series.  NFTA_TUNNEL_KEY_RELEASE patch don't need after the encap/decap infra add in.

I will repost the tunnel match expr offload patches separetely

Thx!

On 9/13/2019 11:03 PM, wenxu@ucloud.cn wrote:
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
