Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868C4C43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Sep 2022 16:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI2QLF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Sep 2022 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiI2QLC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Sep 2022 12:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904DA1D1A72
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2022 09:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664467856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJaSAWw/xNJ7OYh/HNWkwx/0TWq1zWCdspTTIEaFs4I=;
        b=RmHBQtOPgPaHNG6YpVpnqSQn5sZjebPw8qZ2Lw9zTodiYXjpgQS1F/mzRybunteGtkKW7B
        TJqqKOii/FRUeouIeRpnEgbl7MUMXw9SAWx8WAn9vhuFcPJ0GdQWW5XmcuFZHZpnIXNTCw
        c0lV9AriZ+sp1MdU4eKUOnbHYtNc3f0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-4wQ6bLQTOpaRWDHMVIFshQ-1; Thu, 29 Sep 2022 12:10:55 -0400
X-MC-Unique: 4wQ6bLQTOpaRWDHMVIFshQ-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a1c3502000000b003b535aacc0bso3151738wma.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2022 09:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dJaSAWw/xNJ7OYh/HNWkwx/0TWq1zWCdspTTIEaFs4I=;
        b=BVcFVbuOFfMPA1xvtspT+BNX9h7wNtDikzH9VbdNn26FuruYquzDllvTceB6gCaQPI
         XSXHwlbMmqElhuAPfyCJV5QCYFVH+G210mP+fOCR+5vPuxKUlB9MAQDbhGYnHKPJ/JFn
         wFd+EF3I2TzG1/z05rPgbg3TmwagwpEseyCQj3HxDSo8VsxTNA3EA4+F59jcNeLFPAe4
         Gb2O/kiRBU1g8vgOzcgE3AucYFDNXX3jRswuM5ujw5dquhqaIzIwvYyeUDIfpwhr9PaP
         VlFIJx/v2fguVGCl9YJl2Mu8pN4hSjO+yfbSePqeB8FpS5/7Khw7yO72BaJo0A9oOVmY
         pyIQ==
X-Gm-Message-State: ACrzQf0fiswt1zM8Wnd78kmuIUOShZR2wAZvhDzT6hvzXsBWfj8kXtCU
        8HZ+R9eniA2lvSa2BewKWu9vSWVrcXdZYLcZ2nY6X+i4hMu5dtw5MvDC25rrEyT74Cy9FP8cjro
        Qia+aNhwKUS4zy42Ary2+m1eueTji
X-Received: by 2002:a5d:6dc1:0:b0:22b:1256:c3e5 with SMTP id d1-20020a5d6dc1000000b0022b1256c3e5mr3187063wrz.336.1664467838525;
        Thu, 29 Sep 2022 09:10:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46ehuCq4J2FU1B5vBBiYatH69Q1Fs+pef4X4qcT9Q3/rgpFi7IoYFkM43rs3XrautRi820lw==
X-Received: by 2002:a5d:6dc1:0:b0:22b:1256:c3e5 with SMTP id d1-20020a5d6dc1000000b0022b1256c3e5mr3187045wrz.336.1664467838356;
        Thu, 29 Sep 2022 09:10:38 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id q16-20020a7bce90000000b003b492b30822sm4700721wmj.2.2022.09.29.09.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 09:10:37 -0700 (PDT)
Date:   Thu, 29 Sep 2022 18:10:35 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220929161035.GE6761@localhost.localdomain>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928113908.4525-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> dropping vrf packets by mistake") but for nftables fib expression:
> Add special treatment of VRF devices so that typical reverse path
> filtering via 'fib saddr . iif oif' expression works as expected.
> 
> Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
>  net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index b75cac69bd7e..7ade04ff972d 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else
>  		oif = NULL;
>  
> +	if (priv->flags & NFTA_FIB_F_IIF)
> +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
> +

Shouldn't we set .flowi4_l3mdev instead of .flowi4_oif?

>  	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
>  	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
>  		nft_fib_store_result(dest, priv, nft_in(pkt));
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 8970d0b4faeb..1d7e520d9966 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> +		fl6->flowi6_oif = dev->ifindex;
>  	}
>  
>  	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
> @@ -197,7 +200,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
>  		goto put_rt_err;
>  
> -	if (oif && oif != rt->rt6i_idev->dev)
> +	if (oif && oif != rt->rt6i_idev->dev &&
> +	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
>  		goto put_rt_err;
>  
>  	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
> -- 
> 2.35.1
> 

