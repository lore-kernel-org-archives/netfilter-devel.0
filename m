Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52252C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 22:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D93D20733
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 22:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfKOW4X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 17:56:23 -0500
Received: from correo.us.es ([193.147.175.20]:53764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfKOW4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 17:56:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5A03FF2C6
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 23:56:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9090D1DBB
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 23:56:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BEC0FDA3A9; Fri, 15 Nov 2019 23:56:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBC18DA8E8;
        Fri, 15 Nov 2019 23:56:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 23:56:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A7D80426CCBA;
        Fri, 15 Nov 2019 23:56:16 +0100 (CET)
Date:   Fri, 15 Nov 2019 23:56:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/5] netfilter: nft_tunnel: support
 NFT_TUNNEL_IPV6_SRC/DST match
Message-ID: <20191115225618.ldjjmd2c27vxoorw@salvia>
References: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
 <1571913336-13431-5-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571913336-13431-5-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 06:35:35PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add new two NFT_TUNNEL_IPV6_SRC/DST match in nft_tunnel
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_tunnel.c               | 28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 7f65019..584868d 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1777,6 +1777,8 @@ enum nft_tunnel_keys {
>  	NFT_TUNNEL_ID,
>  	NFT_TUNNEL_IPV4_SRC,
>  	NFT_TUNNEL_IPV4_DST,
> +	NFT_TUNNEL_IPV6_SRC,
> +	NFT_TUNNEL_IPV6_DST,
>  	__NFT_TUNNEL_MAX
>  };
>  #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 580b51b..0a3005d 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -96,6 +96,30 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  		else
>  			regs->verdict.code = NFT_BREAK;
>  		break;
> +	case NFT_TUNNEL_IPV6_SRC:
> +		if (!tun_info) {
> +			regs->verdict.code = NFT_BREAK;
> +			return;
> +		}
> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
> +					     NFT_INET_IPV6_TYPE))

And here, add nft_tunnel_mode_match_ip6().

> +			memcpy(dest, &tun_info->key.u.ipv6.src,
> +			       sizeof(struct in6_addr));
> +		else
> +			regs->verdict.code = NFT_BREAK;
> +		break;
> +	case NFT_TUNNEL_IPV6_DST:
> +		if (!tun_info) {
> +			regs->verdict.code = NFT_BREAK;
> +			return;
> +		}
> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode,
> +					     NFT_INET_IPV6_TYPE))
> +			memcpy(dest, &tun_info->key.u.ipv6.dst,
> +			       sizeof(struct in6_addr));
> +		else
> +			regs->verdict.code = NFT_BREAK;
> +		break;
>  	default:
>  		WARN_ON(1);
>  		regs->verdict.code = NFT_BREAK;
> @@ -129,6 +153,10 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
>  	case NFT_TUNNEL_IPV4_DST:
>  		len = sizeof(u32);
>  		break;
> +	case NFT_TUNNEL_IPV6_SRC:
> +	case NFT_TUNNEL_IPV6_DST:
> +		len = sizeof(struct in6_addr);
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 1.8.3.1
> 
