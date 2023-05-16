Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736D8C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 01:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjEPBDT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 May 2023 21:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245593AbjEPBDS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2023 21:03:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEF04ED8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 May 2023 18:03:12 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-643995a47f7so13990217b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 May 2023 18:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684198992; x=1686790992;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1bkhLatCHxNc/1EUMpHiB/QocbYuZFxDANMz12T+tWM=;
        b=nn6SXNOP/cMZ0OFD4CIGSJLpnl2X029eBZOrAfwDbrPX9jCsOOzp+0IHzDSZtnmDQJ
         kYMcY93UMPl/Xu/R18CjfkfmF/hh3TzvITP5uNqHv/uK0kks6MO9Flr4Pxd5mZsxIuXR
         6Ma9dhfdA6veNVOc8ISSDe+Fg5Y3Zq21SkQ1oHahclSgxW+QZ9ncGE0/79Cn6/rYZaG5
         rEobNJstQQMNBl4Y/g2EiAd6vdWU5S6uI58jXIrvfuu+xDKbSR4/M0mS455mmkCOPaQA
         MGrbbZoXmk2a4BDdWWTwdAStS61PVnrFbkDKAvXiU3p27TAySva6nDbfdmqN3w/iPfeb
         IiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684198992; x=1686790992;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1bkhLatCHxNc/1EUMpHiB/QocbYuZFxDANMz12T+tWM=;
        b=h7wN9l2H6KrvEkayfz8wcEHhIjJfXrRN20ge6ak7YcJLjaBLyN98m/4YznYXuhowZG
         v1MAgaJjwz4bftv+MVI0fGRinZ1YNg2CvSNli4y7/IVcLhN9BGRDcIrhD0Pcn9aoegDw
         8PSid1pv3A0U+GmNQ/AsgOlwiqyCXTFDNMlfoGk9mMn5SQzZUQY21fXC/DLLxqNGN3Zk
         xO1gIVf32rFxshM+OvGA9UoszB4I51uB+O2sak64ZgI/nTkycPMdWxQ+cL4p6nAjxIuH
         MzSOaki13taB6zJgS/X9LafhdS5UxCDsGTiGAXf9PvkK0r+w5cHaVwFUOYd1sMGjQZYO
         3P4g==
X-Gm-Message-State: AC+VfDyD+s27QS62gs7tdYR5UZ42496uEmCNNkLzxY8FiD93Wag1PSOE
        6llOURsfWDY/MIIXq/sjW59F0QnzEmc=
X-Google-Smtp-Source: ACHHUZ6l0j/LjYhh4R5RJZj8nrUPNztreHRoSvNZXfLfswcJ5qXP/PqImVKjUAzLXrEYLa69JWiEYw==
X-Received: by 2002:a05:6a20:9389:b0:106:bb67:d674 with SMTP id x9-20020a056a20938900b00106bb67d674mr2375633pzh.45.1684198991571;
        Mon, 15 May 2023 18:03:11 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78250000000b0064cb1fe7e44sm1607855pfn.219.2023.05.15.18.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 18:03:10 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Tue, 16 May 2023 11:03:07 +1000
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: ct state vmap no longer works on 6.3 kernel
Message-ID: <ZGLWS4mWN0KeGbr1@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <a2c6386f-d339-9774-387a-f20fa8aa28e6@rvf6.com>
 <ZFH86op04R2rWPbi@calendula>
 <03175e31-29bd-1588-1042-5931af102348@rvf6.com>
 <20230503081920.GA9674@breakpoint.cc>
 <9252665d-7d18-099f-dad2-e3ee882591fd@rvf6.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9252665d-7d18-099f-dad2-e3ee882591fd@rvf6.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 03, 2023 at 07:33:35PM +0800, Rvfg wrote:
>
>
> On 5/3/23 16:19, Florian Westphal wrote:
> > Thanks, the BREAK in the referenced patch is the problem.
> >
> > Please give this fix a try:
> >
> > diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
> > --- a/net/netfilter/nft_ct_fast.c
> > +++ b/net/netfilter/nft_ct_fast.c
> > @@ -15,10 +15,6 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
> >   	unsigned int state;
> >   	ct = nf_ct_get(pkt->skb, &ctinfo);
> > -	if (!ct) {
> > -		regs->verdict.code = NFT_BREAK;
> > -		return;
> > -	}
> >   	switch (priv->key) {
> >   	case NFT_CT_STATE:
> > @@ -30,6 +26,16 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
> >   			state = NF_CT_STATE_INVALID_BIT;
> >   		*dest = state;
> >   		return;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	if (!ct) {
> > +		regs->verdict.code = NFT_BREAK;
> > +		return;
> > +	}
> > +
> > +	switch (priv->key) {
> >   	case NFT_CT_DIRECTION:
> >   		nft_reg_store8(dest, CTINFO2DIR(ctinfo));
> >   		return;
>
> This patch fixed my problem on 6.3.0 kernel. Thank you!

I don't see this patch in 6.3.2. Is it in the queue anywhere?

Cheers ... Duncan.
