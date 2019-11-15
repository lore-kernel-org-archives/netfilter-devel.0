Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF966C43215
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 22:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B8920732
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 22:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKOWwY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 17:52:24 -0500
Received: from correo.us.es ([193.147.175.20]:52262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfKOWwX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 17:52:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D690DFC5EB
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 23:52:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA453B8004
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 23:52:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BFFCEB7FFE; Fri, 15 Nov 2019 23:52:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE64CB7FF2;
        Fri, 15 Nov 2019 23:52:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 23:52:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A90E5426CCBA;
        Fri, 15 Nov 2019 23:52:17 +0100 (CET)
Date:   Fri, 15 Nov 2019 23:52:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/5] netfilter: nft_tunnel: add
 nft_tunnel_mode_validate function
Message-ID: <20191115225219.igynm3jy34cz2pzc@salvia>
References: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
 <1571913336-13431-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571913336-13431-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 06:35:32PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Move mode validate  common code to nft_tunnel_mode_validate
> function.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nft_tunnel.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 3d4c2ae..78b6e8f 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -18,6 +18,19 @@ struct nft_tunnel {
>  	enum nft_tunnel_mode	mode:8;
>  };
>  
> +static bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode,
> +				     u8 tun_mode)
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
> +
>  static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  				struct nft_regs *regs,
>  				const struct nft_pktinfo *pkt)
> @@ -34,11 +47,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
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

Probably simplify this?

        nft_reg_store8(dest, nft_tunnel_mode_match(priv->mode, tun_info->mode));

The idea is that nft_tunnel_mode_match() returns u8 to store 0 / 1 on
the register.

> @@ -48,11 +57,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  			regs->verdict.code = NFT_BREAK;
>  			return;
>  		}
> -		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
> -		    (priv->mode == NFT_TUNNEL_MODE_RX &&
> -		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
> -		    (priv->mode == NFT_TUNNEL_MODE_TX &&
> -		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
>  			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
>  		else
>  			regs->verdict.code = NFT_BREAK;
> -- 
> 1.8.3.1
> 
