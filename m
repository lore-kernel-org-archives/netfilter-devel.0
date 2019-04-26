Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03648C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B13208CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t/IeRfZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfDZRs1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:48:27 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33261 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfDZRs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:48:27 -0400
Received: by mail-oi1-f195.google.com with SMTP id l1so1753753oib.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 10:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQhD/900kCk95mGRE8iQj3qC0TT6dfPF6mZ0YNWLzDs=;
        b=t/IeRfZZkEX5YZAcfHl0bmyG/PjXC7UNUKDwuvswSBRDIxRKtkFDYlUpVbiPD2Ttk+
         AzR3L+EpXrQkLGUa2jn3061HGOxap4Htg769uUVxczLLx6Azm+CVym54itGdVFVt9dZU
         GSnVKHSryCtn74vnaIdwX55FXRV/EVM7viYHykEWK0ECG5SdR92MFlX0zo96xt46XXnw
         8e8jya0IwvRisHz4VmN3Ewb187ZbAsS0kJJU/cxiKraBVgrcj2+xwhBB4Jd187qf0Vcs
         ZlgCvCKhIqxkBPqspi42GevpLdzncoTOIBhTc6i2/WrWLbEJ+P727RGeEbvSFXjNBV9c
         dgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQhD/900kCk95mGRE8iQj3qC0TT6dfPF6mZ0YNWLzDs=;
        b=gTDXJxqP5NB9nuqTspTSri3TriVk/o/AhChNv6QWwCDAQTZHKiKjwJM0U29YAKua4R
         LOzJjuCJCorXdz5LMYburqsRHK8mt0wnVfSSFaSyJoC3yXXPtuz2XdaLr6blGDhJnsQ0
         KbJocnqG3nDDy+gIiuvb8hb8fWLmZZIcxL4WUlBefzg2GdUDUYoG9PHWYY78jcezeEwB
         lmsi90P1B598LaFQzU2Uj03OfbnTkC1faStRvl7+6pSNCsgycThWknRuFGm18m113rIL
         V1Ul1l8qWre1wcTFNSFOLtRKUrh9l0B8Z2VrV6fsPxcpNWRwg6TA1jGiUtzh/UlZrY5q
         1fZQ==
X-Gm-Message-State: APjAAAWrYlEV8s6N2prq/Q1Bf6drgc3yiC8zQ5hMcBeDg6Gj2Ug0fMnJ
        yge/9ZYlSjtBi+fxcNYS7PiQHPv4ROh9+bDnIfA=
X-Google-Smtp-Source: APXvYqwzHK/1WTqyIhudxgPda+l8msU5TwFsxvCqFGjR8jUpFgVSZeX5arXKldWko0+LhEtRhRviby/ntLh0MCnOnL8=
X-Received: by 2002:aca:130d:: with SMTP id e13mr5800134oii.33.1556300906649;
 Fri, 26 Apr 2019 10:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190426165327.3533-1-ap420073@gmail.com> <20190426170346.yxkjrhgsh6snqzbs@salvia>
In-Reply-To: <20190426170346.yxkjrhgsh6snqzbs@salvia>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 27 Apr 2019 02:48:15 +0900
Message-ID: <CAMArcTXA1-qXSWz7WNhqJ8=6bS-dxJ4KMBkgQD90pVDs1AP=RA@mail.gmail.com>
Subject: Re: [PATCH nf 2/4] netfilter: nft_flow_offload: do not make
 un-established tcp flow_offload session.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 27 Apr 2019 at 02:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>

Hi Pablo!
Thank you for the review!

> On Sat, Apr 27, 2019 at 01:53:27AM +0900, Taehee Yoo wrote:
> > nft_flow_offload_eval() makes flow_offload session but it doesn't check
> > tcp state.
> > So, it can make un-ESTABLISHED tcp flow offload session such as SYN-RECV.
> > But, this is not a normal case.
> >
> > Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  net/netfilter/nft_flow_offload.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > index ff50bc1b144f..8538ddf9c6bf 100644
> > --- a/net/netfilter/nft_flow_offload.c
> > +++ b/net/netfilter/nft_flow_offload.c
> > @@ -84,6 +84,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> >
> >       switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> >       case IPPROTO_TCP:
> > +             if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> > +                     goto out;
>
> You can restrict this via policy:
>
>         ct status assured flow add @x
>

I think If we allow to make non-ESTABLISHED flow offload,
teardown code should be changed because teardown changes TCP status to
ESTABLISHED.
How do you think about it?

> I've been considering to remove this defensive check
>
> diff --git a/net/netfilter/nft_flow_offload.c
> b/net/netfilter/nft_flow_offload.c
> index 6e6b9adf7d38..bb8ea4cefc34 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -94,10 +94,6 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>         if (help)
>                 goto out;
>
> -       if (ctinfo == IP_CT_NEW ||
> -           ctinfo == IP_CT_RELATED)
> -               goto out;
> -
>         if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
>                 goto out;
>
> Given that we can restrict this via policy, ie.
>
>         ct state established flow add @x
>
> And this would fix the flowtable infrastructure UDP traffic that only
> goes in one direction.
>
> We can document in the manpage a few examples for this.

I agree that flowtable infrastructure provides UDP one direction flow
offloading.

Thanks!
