Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F4CC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 13:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 839AA206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 13:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfL3N0L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 08:26:11 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:49084 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfL3N0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 08:26:10 -0500
Received: from [192.168.1.8] (unknown [116.226.202.48])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id DAECC5C16CA;
        Mon, 30 Dec 2019 21:26:06 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: fix unnecessary use
 counter decrease in destory
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <c9e07a82-ea38-d0bc-3ffa-cb0b5bc7ff95@ucloud.cn>
Date:   Mon, 30 Dec 2019 21:25:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01NS0tLSUJPTUNOSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NU06TSo*MTgwSzkZLBAqAipI
        LxQwFBZVSlVKTkxMTEpJSE1MSklCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SU1VSUtJVU9DWVdZCAFZQUlNS0I3Bg++
X-HM-Tid: 0a6f56fc35a82087kuqydaecc5c16ca
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


How about this patch?


BR

wenxu

在 2019/12/20 17:08, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> create a flowtable:
> nft add table firewall
> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1,
> mlx_pf0vf0 } \; }
> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy
> accept \; }
> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1
>
> delete the related rule:
> nft delete chain firewall ftb-all
>
> The flowtable can be deleted
> nft delete flowtable firewall fb1
>
> But failed with: Device is busy
>
> The nf_flowtable->use is not zero and overflow for unnecessary use counter
> decrease..
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>   net/netfilter/nft_flow_offload.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index dd82ff2..b70b489 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -200,9 +200,6 @@ static void nft_flow_offload_activate(const struct nft_ctx *ctx,
>   static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
>   				     const struct nft_expr *expr)
>   {
> -	struct nft_flow_offload *priv = nft_expr_priv(expr);
> -
> -	priv->flowtable->use--;
>   	nf_ct_netns_put(ctx->net, ctx->family);
>   }
>   
