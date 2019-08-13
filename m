Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF1FC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6057B20665
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfHMSTg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:19:36 -0400
Received: from correo.us.es ([193.147.175.20]:56310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbfHMSTf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:19:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63DF1DA738
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:19:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55C39ADE9
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:19:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B556DA704; Tue, 13 Aug 2019 20:19:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 086AEDA730;
        Tue, 13 Aug 2019 20:19:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:19:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CA7FE4265A2F;
        Tue, 13 Aug 2019 20:19:30 +0200 (CEST)
Date:   Tue, 13 Aug 2019 20:19:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 5/9] netfilter: nft_tunnel: support
 NFT_TUNNEL_SRC/DST_IP match
Message-ID: <20190813181930.ljrisiq2iszcddlk@salvia>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
 <1564668086-16260-6-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564668086-16260-6-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 01, 2019 at 10:01:22PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add new two NFT_TUNNEL_SRC/DST_IP match in nft_tunnel
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: no change
> 
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_tunnel.c               | 46 +++++++++++++++++++++++++-------
>  2 files changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 82abaa1..173690a 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1765,6 +1765,8 @@ enum nft_tunnel_key_attributes {
>  enum nft_tunnel_keys {
>  	NFT_TUNNEL_PATH,
>  	NFT_TUNNEL_ID,
> +	NFT_TUNNEL_SRC_IP,
> +	NFT_TUNNEL_DST_IP,
>  	__NFT_TUNNEL_MAX
>  };
>  #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 3d4c2ae..e218163 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -18,6 +18,18 @@ struct nft_tunnel {
>  	enum nft_tunnel_mode	mode:8;
>  };
>  
> +bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode, u8 tun_mode)
> +{
> +	if (priv_mode == NFT_TUNNEL_MODE_NONE ||
> +	    (priv_mode == NFT_TUNNEL_MODE_RX &&
> +	     !(tun_mode & IP_TUNNEL_INFO_TX)) ||
> +	    (priv_mode == NFT_TUNNEL_MODE_TX &&
> +	     (tun_mode & IP_TUNNEL_INFO_TX)))
> +		return true;
> +
> +	return false;
> +}

Make an initial patch to add nft_tunnel_mode_validate().

>  static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  				struct nft_regs *regs,
>  				const struct nft_pktinfo *pkt)
> @@ -34,11 +46,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  			nft_reg_store8(dest, false);
>  			return;
>  		}
> -		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
> -		    (priv->mode == NFT_TUNNEL_MODE_RX &&
> -		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
> -		    (priv->mode == NFT_TUNNEL_MODE_TX &&
> -		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
>  			nft_reg_store8(dest, true);
>  		else
>  			nft_reg_store8(dest, false);
[...]
> +	case NFT_TUNNEL_DST_IP:
> +		if (!tun_info) {
> +			regs->verdict.code = NFT_BREAK;
> +			return;
> +		}
> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
> +			*dest = ntohl(tun_info->key.u.ipv4.dst);

No need to convert this from network to host endianess.

> +		else
> +			regs->verdict.code = NFT_BREAK;
> +		break;
>  	default:
>  		WARN_ON(1);
>  		regs->verdict.code = NFT_BREAK;
> @@ -86,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
>  		len = sizeof(u8);
>  		break;
>  	case NFT_TUNNEL_ID:
> +	case NFT_TUNNEL_SRC_IP:
> +	case NFT_TUNNEL_DST_IP:

Missing policy updates, ie. nft_tunnel_key_policy.

I would take an initial patchset with two patches to add support for
this to the tunnel extension.

IPv6 is missing though, you could add it too to this patchset so this
becomes a patchset compose of three patches, I'd suggest.
