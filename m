Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE5DC433ED
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780206105A
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhDJTUK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:20:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44974 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJTUJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 15:20:09 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A604262C0E;
        Sat, 10 Apr 2021 21:19:30 +0200 (CEST)
Date:   Sat, 10 Apr 2021 21:19:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     saeed@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: fix ingress_ifindex check in
 mlx5e_flower_parse_meta
Message-ID: <20210410191951.GC17033@salvia>
References: <1617946428-10944-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1617946428-10944-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 09, 2021 at 01:33:48PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the nft_offload there is the mate flow_dissector with no
> ingress_ifindex but with ingress_iftype that only be used
> in the software. So if the mask of ingress_ifindex in meta is
> 0, this meta check should be bypass.
> 
> Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index df2a0af..d675107d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1895,6 +1895,9 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
>  		return 0;
>  
>  	flow_rule_match_meta(rule, &match);
> +	if (!match.mask->ingress_ifindex)
> +		return 0;
> +
>  	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
>  		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
>  		return -EOPNOTSUPP;
> -- 
> 1.8.3.1
> 
