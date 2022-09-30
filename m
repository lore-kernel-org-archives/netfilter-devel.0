Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4835BC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 14:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiI3OLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 10:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiI3OLZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 10:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53375FE4
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 07:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664547054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZIrmRlHt6CUtM4OHrYqApHlFAK6CsAbUsM0EgTkkUx4=;
        b=e/MxN8HMGSy+LFh+qqtWOStlBt9cUDdj7qWlp3UxUfFE1pVb9r9BNtjz6OnSTO9tLYLfYi
        hBOTtwLbmdpXzoSZO8UeKaW9/WMhHxIWfX2kR/xQn6Uv6N9IUEvgYR75M2OIR+27dqQ8eQ
        7I3gayAthOgydoTesCC3M/H00swUChc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-MgSiumgGOiGK5hnIeNvcqw-1; Fri, 30 Sep 2022 10:10:53 -0400
X-MC-Unique: MgSiumgGOiGK5hnIeNvcqw-1
Received: by mail-wm1-f70.google.com with SMTP id 5-20020a05600c028500b003b4d2247d3eso3407176wmk.0
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 07:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZIrmRlHt6CUtM4OHrYqApHlFAK6CsAbUsM0EgTkkUx4=;
        b=N8G0jnR9SKpnONSHR3sIw5lsT/204udKsWprqHZViyEtdXYIdVo2MqmOGQu4A8fs/W
         l/5ysAicT+qBUqki+1ktgZG7hnVRhTQVJ7yYHBeIw4chfhK6ms2jZvor1arc8ogouJhD
         L/OHDAWK8oYf04SEByFPrtUkQhgQPTVVOhf3udclpZNu50+dfpM5uZh/zIYIcS8vHlpq
         zcEcQrY+Fwvsd/OF9OG/oAtYh0Gr02curmFFiiCxQxve8aPV16KaJUrHa3sMJ1WphPeU
         xiGjwCqikahU/DvOgUBbKodaBtYtrEAUWGBAX18Uo0t4blyTFnt8Ey034yZV02v8qjeF
         ODtw==
X-Gm-Message-State: ACrzQf3EY/i33f3hivuuYR4WuOE1RSN1yyWtenQoO91tU9V5ufdu3QKm
        qbeok+2a9H145l/gHG4tOttbmKEuGCc/ZLszMuOZou/qdkDQFqjxWCXjiSJmh9Z4dzZs6GKiOVZ
        PYaYmNKkeF64XifekWB+8S8VkzAEk
X-Received: by 2002:a05:600c:2c47:b0:3b4:fcdf:d783 with SMTP id r7-20020a05600c2c4700b003b4fcdfd783mr5948862wmg.157.1664547052178;
        Fri, 30 Sep 2022 07:10:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4JNxaVGxuvhLvu/AUBRD87vCu82rFFte6PnWHKFwh5YRTGDuxFe9rTAJmxoGcAI9utytfY5A==
X-Received: by 2002:a05:600c:2c47:b0:3b4:fcdf:d783 with SMTP id r7-20020a05600c2c4700b003b4fcdfd783mr5948851wmg.157.1664547051977;
        Fri, 30 Sep 2022 07:10:51 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id e14-20020adfdbce000000b0022b014fb0b7sm2001739wrj.110.2022.09.30.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:10:51 -0700 (PDT)
Date:   Fri, 30 Sep 2022 16:10:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220930141048.GA10057@localhost.localdomain>
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

I'm not very familiar with nft code, but it seems dev can be NULL here,
so netif_is_l3_master() can dereference a NULL pointer.

Shouldn't we test dev in the 'else if' condition?

