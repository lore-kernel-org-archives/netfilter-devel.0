Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C767C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB70C212F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PURID8xo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfDZRSF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:18:05 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35464 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfDZRSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:18:04 -0400
Received: by mail-oi1-f195.google.com with SMTP id w197so3545811oia.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 10:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ch0cvLCg9Yeo0Sg61aSDiAd0b47b9WNyRXFC83ptbwc=;
        b=PURID8xoEvXkXR/raUZhiA7q7H7aITpUet1AQCZoqVjlIWMKtqMTSDdIb5OklGtzn6
         EcRFJmOJxgc1Qj1W76NskoIVqT70z2S6jYKZsZfjiS6fqZGRmE/rAOK5f9AIuklvuWgE
         SEs3VtLRMeeYMGlqIJs85+woEiobmYfa1tIHEWSP1i6A255d77/8rTpOEejZOTd3dzXD
         0apaBpRGgFpPFBmMRm6I1K6o06dxCA+VjQJn3cx5By629+Yw4xzuGN9QxE5jL8587x0u
         R6qMBpo0BQQ1XvxwD4bwd60PmltB956bH85fW8jG+OYzQi2ScL8rxztasSp8GIy/NYkv
         7dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ch0cvLCg9Yeo0Sg61aSDiAd0b47b9WNyRXFC83ptbwc=;
        b=ihJE6dwxml8VpaVbpGM7HEOsFIU5ycutZQE2G/yW/NSko9XH9FqTUMXUclI+qi0rNp
         xLpyhJzWk7A14WS+Kjvtk80exkUcDYw71iGaCyJc5CCYFiMeO4sfeFCvJ8WEaJaptzOY
         vWEv0T6eA7I1jTIHkkU2CJWOMxHGNHA4aFXixshqLtctz0+YxVfmP7xdMXhcWXXi6jVw
         tc9PSoTZy3p/Knk3bsqEmxpMKJB7N4MO7AU9NXVvFU7y8wzjELpg+zkd24ZpRc8RY4x4
         yEo/t2d06Ebqwc6DUCEn56/zDmcv5zLtX0SQRljhcpagNTZYgq69Fa64TVqLYh+5WBgL
         mVpw==
X-Gm-Message-State: APjAAAWbKCeum9WhV+Je60ZoE9hpI75tbB0bkfYXESz3po02gTwbhuOr
        csRs18d4un01pXWHpD98Q/ncqlwSxkeatgFBLOY=
X-Google-Smtp-Source: APXvYqywfppMfRb6Soh0MQPwStDA2yyLhDJLTW/E5nJXv1pTTXSz9ONcm5E/FCIoGd2GR/piE3TWkinWXmJXEWS9ieQ=
X-Received: by 2002:aca:c647:: with SMTP id w68mr8121648oif.173.1556299083526;
 Fri, 26 Apr 2019 10:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190426165454.3943-1-ap420073@gmail.com> <20190426170028.ssosw4kg3pl4bicc@salvia>
In-Reply-To: <20190426170028.ssosw4kg3pl4bicc@salvia>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 27 Apr 2019 02:17:52 +0900
Message-ID: <CAMArcTWdMDWqG9gqoi2LGeE-RRgoWeLPPEUyzWHX3iVDFYr48A@mail.gmail.com>
Subject: Re: [PATCH nf 4/4] netfilter: nf_flow_table: do not use deleted CT's
 flow offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 27 Apr 2019 at 02:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>

Hi Pablo,
Thank you for the review!

> On Sat, Apr 27, 2019 at 01:54:54AM +0900, Taehee Yoo wrote:
> > flow offload of CT can be deleted by the masquerade module. then,
> > flow offload should be deleted too. but GC and data-path of flow offload
> > do not check CT's status. hence they will be removed only by the timeout.
> >
> > GC and data-path routine will check ct_general.use value.
> > If that value is 1, it means that CT is removed from the list.
> > So, GC will delete this and data-path do not use this.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  net/netfilter/nf_flow_table_core.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 7aabfd4b1e50..334eb561ae48 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -232,6 +232,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
> >  {
> >       struct flow_offload_tuple_rhash *tuplehash;
> >       struct flow_offload *flow;
> > +     struct flow_offload_entry *e;
> >       int dir;
> >
> >       tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
> > @@ -244,6 +245,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
> >       if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
> >               return NULL;
> >
> > +     e = container_of(flow, struct flow_offload_entry, flow);
> > +     if (unlikely(atomic_read(&e->ct->ct_general.use) == 1))
>
> Could we use the IPS_DYING_BIT instead?

Oh, it looks better.
I will test and send v2 patch!
Thanks!
