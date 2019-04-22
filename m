Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D8DC10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 10:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2769D20811
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 10:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lY+mBgoE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfDVKKU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 06:10:20 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45456 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfDVKKT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 06:10:19 -0400
Received: by mail-vs1-f65.google.com with SMTP id o10so5923414vsp.12;
        Mon, 22 Apr 2019 03:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GS8Z05FvTre7FCsFIiOVI1Bi+GxPI+23vAvfcOwLHNA=;
        b=lY+mBgoE0p20JUSjcnD2UwgZE20ZrDbCZf6O5w7lOAbhpm5BUENGlPM0HFVx+DU8cq
         cfoVoNdDMn7QTYZDxT6AZVg28SUrzwSEj74YQeyjLsdH8hs7UPFBT20l4VAsJCaBmU/i
         GDjEkH6pbciPLrRtek9sSFcHnCyM8F+FM/5JpVPCEYyjpFflVKqEMMUYZbsznystj9bK
         TQQN0lC3qRLPZ0dkbfaAV0VTPHoopNwPC7I18P16NLZ9bbj3FHT3itsWQg774E2iiN9V
         Irgw0N6/0ZXV41Fmk73I54txNNBN0ll1WjnF1Muz9YYrytInP7U1fude8vkCzQbRGRYo
         M88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GS8Z05FvTre7FCsFIiOVI1Bi+GxPI+23vAvfcOwLHNA=;
        b=o1FEZsvTz0xjmtY5iFlet2y77G0X/MLUMdyUIZcpkJVX5V9yTfQDsnYHiAXtD5iYPU
         Sb35LPJYbT9WfSmX35r2xzNfBcTG3WZ4fEaF+G1siRWMsrSvJ+r1eGOFhbuPHDuIfaQz
         xhyAzAp2JhfrO81mMLxKNzdFqr2tOiRVNSXSzwxJfJxCMrqzcO45tYEKLzxxknCQ93j9
         D6wPMWvNAanmCTFz8vCN8HmDKw6nfY3ShMHzsi00nI2wXzRgmN7QAhuYo4Gk5UOXSwsK
         FBN1yAIroO/TryZKQm5PHLSvb8CbLSaf/EkPCh74NGKhIOrJQzvFQnfJQOzy+lJhKuts
         i/Tw==
X-Gm-Message-State: APjAAAW/GxAXc9jOvtgDYO4PDSSUhanGyVNXRofHe2CuhVzWRuP7c2mj
        5Yi5MwAckZ1Zw9U4kmmUE38HC3PvL1v4bRF3Ug==
X-Google-Smtp-Source: APXvYqyUBvKmIpnklOC846LWZrG3ZdSAmI5roLRGvV1X2Dr9Nt9FTnC6TzgqUL/VQt+rczhBvcVz/0wU+saMAlGI8/w=
X-Received: by 2002:a67:fad8:: with SMTP id g24mr9471060vsq.231.1555927817631;
 Mon, 22 Apr 2019 03:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190409065612.32652-1-rdong.ge@gmail.com> <20190422083339.ptkxqb66pombgy5g@salvia>
 <CAN1Lvyo1CVopsB7iV=e-dAN9JDFg-SmQ8g6H6RrgD7qACAd4hQ@mail.gmail.com>
 <20190422093502.36da6z3qf7zxpwny@breakpoint.cc> <CAN1LvyrSWPbNSvzLquQAeK9kYK=YyqyJEm7zodd3O-QWAVTC4Q@mail.gmail.com>
In-Reply-To: <CAN1LvyrSWPbNSvzLquQAeK9kYK=YyqyJEm7zodd3O-QWAVTC4Q@mail.gmail.com>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Mon, 22 Apr 2019 18:10:06 +0800
Message-ID: <CAN1Lvyq_6ee3Rwmg8VKR0NW54HABqL9n4L2Tiw9YXs=pSu9sYw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: fix dangling pointer access of fake_rtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@blackhole.kfki.hu,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The hook in my testcase is at NF_BR_FORWARD, and priority is -2.
And at this hook point both the entry->out  and entry->in  are not
bridge device.
But the dst was set to the bridge's fake_rtable.

Rundong Ge <rdong.ge@gmail.com> =E4=BA=8E2019=E5=B9=B44=E6=9C=8822=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:51=E5=86=99=E9=81=93=EF=BC=9A
>
> skb->dev is munged in setup_prerouting() to be bridge or vlan device on
> top of bridge.
> --Yes, but  br_nf_pre_routing_finish will set the skb->dev back to the ph=
yindev.
>
> Florian Westphal <fw@strlen.de> =E4=BA=8E2019=E5=B9=B44=E6=9C=8822=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:35=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Rundong Ge <rdong.ge@gmail.com> wrote:
> > > br_nf_pre_routing will call the NF_INET_PRE_ROUTING hooks, at this
> > > time both entry->state.in and entry->state.out are not bridge device.
> > >
> > > NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb=
,
> > > skb->dev, NULL,
> > > br_nf_pre_routing_finish);
> >
> > skb->dev is munged in setup_prerouting() to be bridge or vlan device on
> > top of bridge.
> >
> > That being said, I think we need this fix at least:
> >
> > diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> > --- a/net/netfilter/nf_queue.c
> > +++ b/net/netfilter/nf_queue.c
> > @@ -197,8 +197,15 @@ static int __nf_queue(struct sk_buff *skb, const s=
truct nf_hook_state *state,
> >                 .size   =3D sizeof(*entry) + route_key_size,
> >         };
> >
> > +       if (skb_dst(skb)) {
> > +               skb_dst_force(skb);
> > +               if (!skb_dst(skb)) {
> > +                       status =3D -EHOSTUNREACH;
> > +                       goto err;
> > +               }
> > +       }
> > +
> >         nf_queue_entry_get_refs(entry);
> > -       skb_dst_force(skb);
> >
> >         switch (entry->state.pf) {
> >         case AF_INET:
> >
> >
> > Then, why not add, in dev_cmp:
> >
> >         dst =3D skb_dst(skb);
> >         if (dst && dst->dev->index =3D=3D index ...
> >
> > ?
