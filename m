Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFDDC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9AC12084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfCAN2d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:28:33 -0500
Received: from mail.us.es ([193.147.175.20]:51140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbfCAN2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:28:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7769B191910
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:28:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66DC4DA846
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:28:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C652DA85D; Fri,  1 Mar 2019 14:28:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73DC5DA846;
        Fri,  1 Mar 2019 14:28:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:28:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 48B084265A2F;
        Fri,  1 Mar 2019 14:28:29 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:28:28 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nft_tunnel: Add dst_cache support
Message-ID: <20190301132828.bccqpoyg4azqafww@salvia>
References: <1550826043-21278-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550826043-21278-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 05:00:43PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The metadata_dst is not init the dst_cache which make the
> ip_md_tunnel_xmit can't use the dst_cache. It will lookup
> route table every packets.

Applied, thanks.

One comment below:

> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nft_tunnel.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index ea28588..b113fca 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -406,6 +406,13 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
>  		return -ENOMEM;
>  
>  	memcpy(&md->u.tun_info, &info, sizeof(info));
> +#ifdef CONFIG_DST_CACHE

To reduce ifdef pollution, it would be good to turn dst_cache_init()
into noop via static inline trick in case CONFIG_DST_CACHE=n.

BTW, I suspect net/sched/act_tunnel_key.c also needs a similar update.

> +	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL);
> +	if (err < 0) {
> +		metadata_dst_free(md);
> +		return err;
> +	}
> +#endif
>  	ip_tunnel_info_opts_set(&md->u.tun_info, &priv->opts.u, priv->opts.len,
>  				priv->opts.flags);
>  	priv->md = md;
> -- 
> 1.8.3.1
> 
