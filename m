Return-Path: <SRS0=uhap=AS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CD7C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jul 2020 14:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83BE20738
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jul 2020 14:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="LRCv8jnI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LnJciwxq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGGODY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:03:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57471 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgGGODX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 10:03:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DE4245C0256;
        Tue,  7 Jul 2020 10:03:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 10:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=u5rnb+jxQXfXVkt90qBC8av3Y/q
        g6Z3+WFIOWQDIuH8=; b=LRCv8jnIW2Rto88kdS1r1CoZfYWZChZ1e0Q8IMRl+6h
        HA1Jnpdoqhh8qccVgsQi06emcJYKmGeoJuJt0mi5RHMJ5xXy1gV77WNuSNZ9VYQ4
        jzhPcYFWEsB7lJFaP3eZ2PGvwRY0+QDbBoem400Gmrg5pr+XLLAEJwHFXv0EVZMU
        fFN4dU9n/63xkz17XuC0jmMTjwTAgio/USNfJrGEv/v3H8wQF1aNDtDLoQlEw9P/
        rOpuisqMdoGWVeI96ffzKl65eSIcpAns0A2YASwdLYhynIQCT3MAUtVqHA0EHPs9
        iuqn3J5KvApz8qBEKVEeQd0i5mhaXXcWxsb2y1Zk1hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u5rnb+
        jxQXfXVkt90qBC8av3Y/qg6Z3+WFIOWQDIuH8=; b=LnJciwxqxMpgk6/6VpvGMy
        qVFlMssWIYngv9Jf9W7v2UtJGH8L/xI37q3GW3bFdyGS4fdUqqMFDi2Bus11fePZ
        bQNecptoMP+68KZ4iOaT3gYK2svQx9a4vQG8QDAfqVcmknZ0TP9vg+de/aDmvmNz
        HhEUJcuPLOGvS8vzliklju0OwEXag+60QzIMOyJC4JNIn3KQAxa65Pk62dvttntC
        ZS+YaD5SG40XOwKaKXM3PVXsKeM6x97420Oel4ftoSTo/tpVRRaQpK5qWQ8Arl9q
        Fm/DVSfaS+SJJ8Bqx76mgGc4Ibw7o7HnFgnrwJz1ReHhGKVtHFQDLfxG/uekrHOA
        ==
X-ME-Sender: <xms:qoAEXxtV6Ca0IjdEKKofKsrx8gD9EDp8Hky5y8OrJYl2UyFneOhdXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qoAEX6eaPHTxJ2HCx8bH92Z4Rb1GaTsFozH6tqhF_XgwKzFpil5n1Q>
    <xmx:qoAEX0w7FEzYmIimUwMnBVhBRHDjC154aac_ejQdjUUVAODI1x1jww>
    <xmx:qoAEX4Pz1mj4yW7_tugtzHgUi_oBuZlewLi226WJXhwvGxyEf800HA>
    <xmx:qoAEXznMOa_VK937hs9u0oeyH06Q1_tmGEh12gRakvneKY6O6ebgwA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6A613060067;
        Tue,  7 Jul 2020 10:03:21 -0400 (EDT)
Date:   Tue, 7 Jul 2020 16:03:20 +0200
From:   Greg KH <greg@kroah.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Vasily Averin <vvs@virtuozzo.com>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4.10] netfilter: nf_conntrack_h323: lost .data_len
 definition for Q.931/ipv6
Message-ID: <20200707140320.GA4064836@kroah.com>
References: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
 <20200624121232.GA28150@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624121232.GA28150@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 24, 2020 at 02:12:32PM +0200, Pablo Neira Ayuso wrote:
> CC'ing stable@vger.kernel.org
> 
> On Tue, Jun 09, 2020 at 10:53:22AM +0300, Vasily Averin wrote:
> > Could you please push this patch into stable@?
> > it fixes memory corruption in kernels  v3.5 .. v4.10
> > 
> > Lost .data_len definition leads to write beyond end of
> > struct nf_ct_h323_master. Usually it corrupts following
> > struct nf_conn_nat, however if nat is not loaded it corrupts
> > following slab object.
> > 
> > In mainline this problem went away in v4.11,
> > after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
> > for inkernel helpers") however many stable kernels are still affected.
> 
> -stable maintainers of: 3.16, 4.4 and 4.9.

Now queued up to 4.4 and 4.9, thanks.  3.16 is end-of-life.

greg k-h
