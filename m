Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD081C43218
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98AB12087C
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u5whrO0C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfD0JV2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 05:21:28 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34352 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfD0JV2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 05:21:28 -0400
Received: by mail-ot1-f67.google.com with SMTP id n13so1352631otk.1
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 02:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyL/zScyuev+wSlc0/lsnXIGRkVxc2y8KKUZ0Ienmt4=;
        b=u5whrO0CevLIx/InCUgzmEqeooIbjB3sr3WKE4qOOqLheTKOb58Ns9Cq4g9Hb7KYyV
         Rw5EkZm6E524DCODgfxzhmaKPCun8mm1kFjt6fBfoWRVvWfQSsld8Dj28NTUWaBEAARL
         rsreWD64FmPthdxpP4LZDv2P/+C12gL13Rc8Tmc9qVf/6N+gicJZy+amwe44ZuYsbc2q
         DJo3YH+wkSfyfFwAKAGA8+XkkAUmh6PkeTEo6R8NgzUAeGPqJTHm3V3ceKeyqUf9RZiT
         21ROVveHWOwpdUfcxBeaaHOLVG+QPs3Yw3MPkg4y91wsAtz8Om4ops4iN7U3KWuTEOWd
         MwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyL/zScyuev+wSlc0/lsnXIGRkVxc2y8KKUZ0Ienmt4=;
        b=R9201o8Rzs/IYz18SkaQBZMbjuz/ge3aaMgj8n5WZwS3hQniV5XKcOpbdbejSX1lsy
         pQGoXCsPnnlxAa7/SBwO4xuY6/Pm5ORkGzaFUSKo1UPVpk6xn4foim1EZmNYacPdwyiL
         I4YVwbJv0IZOFZ6eYwS8u7DUIcMRYJQBSbpWiaJLLvK91psWyoYDBFfcZc+eZPOGzqNb
         ccHvFhW0QZyEtNn+4l/km2E7MODUfOVjXRmkFXwoF3/AbowUx099AzyOrfPXduXmbWcd
         4Tva7L2kIqV5GZrZyIpFSGDdFRjY2mDqL/pZIaG2hzua6jbI3x3udOb8mvxUow1k6im0
         eGjA==
X-Gm-Message-State: APjAAAVvzAZPfpPaViyQf8K8z59nK5ljjxs6KtJDuGtoIiCQZHu8p9ie
        ZcKen8GTYOBsZhVuw2o0GX8SO5VxuApWp/Arg0C/lg==
X-Google-Smtp-Source: APXvYqyxHBboDmeT8HNM8dIDXxNHl3Cyo2idJD9k/Bp7ykAXe1ZtZ03sia8ZKy4KKimPmRadzrEpXJ46/h90om1DrT8=
X-Received: by 2002:a9d:450a:: with SMTP id w10mr4939299ote.264.1556356887082;
 Sat, 27 Apr 2019 02:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190426165327.3533-1-ap420073@gmail.com> <20190426170346.yxkjrhgsh6snqzbs@salvia>
 <CAMArcTXA1-qXSWz7WNhqJ8=6bS-dxJ4KMBkgQD90pVDs1AP=RA@mail.gmail.com> <20190426190213.2xkitf7layyw7kyq@salvia>
In-Reply-To: <20190426190213.2xkitf7layyw7kyq@salvia>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 27 Apr 2019 18:21:16 +0900
Message-ID: <CAMArcTWN9pdHvrnJeW1qpCcUp86oisHQwYdQ4vsStq7vV733xQ@mail.gmail.com>
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

On Sat, 27 Apr 2019 at 04:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Sat, Apr 27, 2019 at 02:48:15AM +0900, Taehee Yoo wrote:
> > On Sat, 27 Apr 2019 at 02:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> >
> > Hi Pablo!
> > Thank you for the review!
> >
> > > On Sat, Apr 27, 2019 at 01:53:27AM +0900, Taehee Yoo wrote:
> > > > nft_flow_offload_eval() makes flow_offload session but it doesn't check
> > > > tcp state.
> > > > So, it can make un-ESTABLISHED tcp flow offload session such as SYN-RECV.
> > > > But, this is not a normal case.
> > > >
> > > > Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
> > > > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > > > ---
> > > >  net/netfilter/nft_flow_offload.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > > > index ff50bc1b144f..8538ddf9c6bf 100644
> > > > --- a/net/netfilter/nft_flow_offload.c
> > > > +++ b/net/netfilter/nft_flow_offload.c
> > > > @@ -84,6 +84,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> > > >
> > > >       switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> > > >       case IPPROTO_TCP:
> > > > +             if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
> > > > +                     goto out;
> > >
> > > You can restrict this via policy:
> > >
> > >         ct status assured flow add @x
> > >
> >
> > I think If we allow to make non-ESTABLISHED flow offload,
> > teardown code should be changed because teardown changes TCP status to
> > ESTABLISHED. How do you think about it?
>
> Hm, right, the teardown fixup routine cannot then bogusly assumes the
> TCP established state if we create a TCP entry from the first packet,
> ie. the SYN_SENT state...
>

Thank you for sharing opinion.

> [...]
> > > And this would fix the flowtable infrastructure UDP traffic that only
> > > goes in one direction.
> > >
> > > We can document in the manpage a few examples for this.
> >
> > I agree that flowtable infrastructure provides UDP one direction flow
> > offloading.
>
> OK, probably I can collapse your patch to mine. Let me think over the
> weekend.

Okay, I will wait for your response!
