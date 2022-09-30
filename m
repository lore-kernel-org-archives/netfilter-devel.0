Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDEAC43217
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 15:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiI3PI2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 11:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiI3PI1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 11:08:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2CC123862
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664550506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ThgIMG5jXzsQN6twWFk4fVY0qmWrtHR2kq3lK3VY7c=;
        b=CwrcPKxNUicJxFVtPHTeZneHa+AFtsg2PZ1m4a49ERIPeYh3hnBzAt817lUJQ8x0jdb+xM
        XYKmeNpbuOFFJR687WZP3KqACWQSxJxC2pP7yTP0wV4c+ReyGYfC+ue8PwzNP3peHfeu9u
        LPUswT+5RBy/dhBnUYbmCgs82SRqnkg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-94-i1yr8nnjMeKGc8cl3TzddA-1; Fri, 30 Sep 2022 11:08:22 -0400
X-MC-Unique: i1yr8nnjMeKGc8cl3TzddA-1
Received: by mail-wm1-f72.google.com with SMTP id n7-20020a1c2707000000b003a638356355so2201857wmn.2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 08:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1ThgIMG5jXzsQN6twWFk4fVY0qmWrtHR2kq3lK3VY7c=;
        b=AQn8+KtpN+TiixXQICKuV28ADtwQZNpYOM1TaRqlrRM1j8fFubDjsbVpzyByH/NLYT
         +q/wpAhjLmOG3UbYhPXzYNIheTAIr2bXvx3T8bP40gso/QICAxc0RcNJd9MFBpQvnbbH
         F9g4P4+ByFoN8HWbxO7K9NEMgag0t6pCa27JYrCiP9p4xoy6LMpIgb/BbVw6ezl32ic0
         UDghjlyZB1DmPvXPTHbY+WUyOUyy7MtStEbmL/PfMDjAFvSiFQErn3bZZ6sIIcKqgJAx
         Aw5Y8WL2XKvLOur6mMqbD1h62rIbFWf8lvDSu3nFwVwUfOL/OvKDURBtSGlyoc2Up0va
         uxJg==
X-Gm-Message-State: ACrzQf2Belu/Pees53rbEbRj58ZY5bHSuSRyFeAJ2HUJxHt291n82zTu
        P9hqWAALseMNvC5RAsefBA07jljsR+q7F4WhHAmXRdyRpM6HunzU1/Nnns+BUs7kocVzMEcTd0F
        Kg9nixntpyyUr9+z/uNlXGg1oNRib
X-Received: by 2002:adf:eb83:0:b0:22c:f295:19a5 with SMTP id t3-20020adfeb83000000b0022cf29519a5mr2641085wrn.457.1664550501572;
        Fri, 30 Sep 2022 08:08:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5BtSGsnizcOAB9rv7VtThs8g0EBWhTN2l0qiqwUhqzDeB7hdtfsgspZw4zPNevNAoKLojONw==
X-Received: by 2002:adf:eb83:0:b0:22c:f295:19a5 with SMTP id t3-20020adfeb83000000b0022cf29519a5mr2641064wrn.457.1664550501363;
        Fri, 30 Sep 2022 08:08:21 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bv7-20020a0560001f0700b0022cdbc76b1bsm2123278wrb.82.2022.09.30.08.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:08:20 -0700 (PDT)
Date:   Fri, 30 Sep 2022 17:08:18 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220930150818.GC10057@localhost.localdomain>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
 <20220930141048.GA10057@localhost.localdomain>
 <20220930144752.GA8349@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930144752.GA8349@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 30, 2022 at 04:47:52PM +0200, Florian Westphal wrote:
> Guillaume Nault <gnault@redhat.com> wrote:
> > On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> > > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> > > index 8970d0b4faeb..1d7e520d9966 100644
> > > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > > @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
> > >  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
> > >  		lookup_flags |= RT6_LOOKUP_F_IFACE;
> > >  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> > > +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> > > +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> > > +		fl6->flowi6_oif = dev->ifindex;
> > >  	}
> > 
> > I'm not very familiar with nft code, but it seems dev can be NULL here,
> > so netif_is_l3_master() can dereference a NULL pointer.
> 
> No, this should never be NULL, NFTA_FIB_F_IIF is restricted to
> input/prerouting chains.

Thanks, I didn't realise that.

> > Shouldn't we test dev in the 'else if' condition?
> 
> We could do that in case it makes review easier.

Then if it's just to help reviewers, a small comment should be enough.

