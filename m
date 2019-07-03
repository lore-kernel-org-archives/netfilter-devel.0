Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310FFC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 13:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E49C218A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 13:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCNx6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:53:58 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43752 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCNx6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 09:53:58 -0400
Received: from [192.168.1.5] (unknown [116.234.0.230])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3FEEA4169D;
        Wed,  3 Jul 2019 21:53:52 +0800 (CST)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ecb6d9e8-7923-07ba-8940-c69fc251f4c3@ucloud.cn>
Date:   Wed, 3 Jul 2019 21:53:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190703124040.19279-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01MS0tLSUlJSUtNSklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PAw6CCo4LzgrIglNCk8vSikX
        CR8wCSxVSlVKTk1JSk1JS0hJT05DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VS1VJSEtZV1kIAVlBT0tISTcG
X-HM-Tid: 0a6bb81cef0c2086kuqy3feea4169d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/7/3 20:40, Pablo Neira Ayuso 写道:
> Use br_vlan_enabled() and br_vlan_get_pvid() helpers as Nikolay
> suggests.
>
> Rename NFT_META_BRI_PVID to NFT_META_BRI_IIFPVID before this patch hits
> the 5.3 release cycle, to leave room for matching for the output bridge
> port in the future.
>
> Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Fixes: da4f10a4265b ("netfilter: nft_meta: add NFT_META_BRI_PVID support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++--
>  net/netfilter/nft_meta.c                 | 17 ++++++++++-------
>  2 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 8859535031e2..8a1bd0b1ec8c 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -795,7 +795,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> - * @NFT_META_BRI_PVID: packet input bridge port pvid
> + * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -826,7 +826,7 @@ enum nft_meta_keys {
>  	NFT_META_SECPATH,
>  	NFT_META_IIFKIND,
>  	NFT_META_OIFKIND,
> -	NFT_META_BRI_PVID,
> +	NFT_META_BRI_IIFPVID,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 4f8116de70f8..b8d8adc0852e 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -240,14 +240,17 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  			goto err;
>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>  		return;
> -	case NFT_META_BRI_PVID:
> +	case NFT_META_BRI_IIFPVID: {
> +		u16 p_pvid;
> +
>  		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
>  			goto err;
> -		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
> -			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
> -			return;
> -		}
> -		goto err;
> +		if (!br_vlan_enabled(in))
> +			goto err;
> +		br_vlan_get_pvid(in, &p_pvid);
I find the function br_vlan_get_pvid is ASSERT_RTNL();. But in this senario is under packet path.
> +		nft_reg_store16(dest, p_pvid);
> +		return;
> +	}
>  #endif
>  	case NFT_META_IIFKIND:
>  		if (in == NULL || in->rtnl_link_ops == NULL)
> @@ -375,7 +378,7 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>  			return -EOPNOTSUPP;
>  		len = IFNAMSIZ;
>  		break;
> -	case NFT_META_BRI_PVID:
> +	case NFT_META_BRI_IIFPVID:
>  		if (ctx->family != NFPROTO_BRIDGE)
>  			return -EOPNOTSUPP;
>  		len = sizeof(u16);
