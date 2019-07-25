Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76F7C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 06:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869DA21871
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 06:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfGYGyK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 02:54:10 -0400
Received: from mail.us.es ([193.147.175.20]:35274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfGYGyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 02:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FAD0C3301
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 08:54:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DDD5115104
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 08:54:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 33503DA732; Thu, 25 Jul 2019 08:54:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDAEA115104;
        Thu, 25 Jul 2019 08:54:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 08:54:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9685D40705C5;
        Thu, 25 Jul 2019 08:54:04 +0200 (CEST)
Date:   Thu, 25 Jul 2019 08:54:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_tunnel: Fix convert tunnel id to host
 endian
Message-ID: <20190725065401.bla2zttaadr4lzzz@salvia>
References: <1563960729-17767-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563960729-17767-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 24, 2019 at 05:32:09PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the action store tun_id to reg in a host endian. But the
> nft_cmp action get the user data in a net endian which lead
> match failed.
> 
> nft --debug=netlink add rule netdev firewall aclin ip daddr 10.0.0.7
> tunnel key 1000 fwd to eth0
> 
> [ meta load protocol => reg 1 ]
> [ cmp eq reg 1 0x00000008 ]
> [ payload load 4b @ network header + 16 => reg 1 ]
> [ cmp eq reg 1 0x0700000a ]
> [ tunnel load id => reg 1 ]
> [ cmp eq reg 1 0xe8030000 ]
> [ immediate reg 1 0x0000000f ]
> [ fwd sreg_dev 1 ]
> 
> Fixes: aaecfdb5c5dd ("netfilter: nf_tables: match on tunnel metadata")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nft_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 3d4c2ae..c9f4585 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -53,7 +53,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>  		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
>  		    (priv->mode == NFT_TUNNEL_MODE_TX &&
>  		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
> -			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
> +			*dest = tunnel_id_to_key32(tun_info->key.tun_id);

Something is wrong here:

__be32 tunnel_id_to_key32(...)

This function returns __be32 and you are now storing this in big
endian, while description refers to "host endian".

>  		else
>  			regs->verdict.code = NFT_BREAK;
>  		break;
> -- 
> 1.8.3.1
> 
