Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A45C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 01:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiCABPd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 20:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiCABPc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 20:15:32 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BB4102
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 17:14:52 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id 12so14904118oix.12
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 17:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vifRZK0bW++rNz4B+8r/HrVxAbx0MgB1JwlLhYR1Hyk=;
        b=HyeHgUhNNeWfTtLvttBdyCQtXz3B90Drrp87hcXpdbNPyxLvHgaV1S8WsxJov/vyOZ
         MiDCFrXFJkU/TkN97z/ZZTeSb3ny4tl2wwo00YlMIHFMei8ss5cP2VGce7yCk4qOw+TB
         9Cbdqc5DerTA2/KXpF3isuZE8CHgKAgFzfE+RK4QGPPWUX9Y/Q7nnou3sYSWkkUojdjK
         YWihlsUoU8W0jyhUAesGwcOOkbMNazgl2rKni5PdAIHipYvVne07Gbf0tiDuU119DDLs
         fltHqFVvG3eQGxw727KuS5i8KOlKoSMUzq9sTV7/znjLv23VPoMW/1kJD7RerfrYNvxe
         ZmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vifRZK0bW++rNz4B+8r/HrVxAbx0MgB1JwlLhYR1Hyk=;
        b=1XfkK5P7WpKzXHdcPOmUAjTsjAC8UHUoHDC86oFZzsRR/gHSfpdCWdwLdvYvX6mDWz
         YjudjgghWMVkRuT0vFLI9DhxKZxRCHPt5OBrwbKExhMRouPz74OzY1rXVkbZ4ffidSQA
         WmymwFtioRwA0/2dmhagH7XjwfWkl5KEAO1cd7w14D35kod1Us0HZOgLCuC2yJyaWUEU
         TNg2d3b0GfV6Ghd23PxYYs84P1ayWN+iyS5VwRxDsoeTo7dAzuM7WRg0EW0ktYlZijgg
         bZ2Y/Mfk5GzOpSioDg7fYIUIM+Fdb2WmPSwUhdQ/hX1QMCBpwj+iXajsAn0ywXf4CagL
         suXw==
X-Gm-Message-State: AOAM533XLIae8jVN7kJcCq8xkK9qog7O1P8GG0qPZ689ntWgjYVL3ZOT
        DeDHwvwNjjWHWNezeIXoy75Fg62IPidJF36Oh38/iQ==
X-Google-Smtp-Source: ABdhPJzksvlVX0iqUS5kyui7cJ1yFqWDpsddfIWLyfCGP1ZbZZJWRNLEn+eCF0dT7NWn1uXAcTKolZrragazj127XHc=
X-Received: by 2002:a05:6808:1247:b0:2d3:5181:449a with SMTP id
 o7-20020a056808124700b002d35181449amr10891079oiv.83.1646097291807; Mon, 28
 Feb 2022 17:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20220228162918.23327-1-fw@strlen.de> <CADa=Ryx0-A6TmXjSDUO0V-6arMjbOhO6MXV6emNhugAm+F_oLg@mail.gmail.com>
 <20220228234143.GB12167@breakpoint.cc>
In-Reply-To: <20220228234143.GB12167@breakpoint.cc>
From:   Joe Stringer <joe@cilium.io>
Date:   Mon, 28 Feb 2022 17:14:40 -0800
Message-ID: <CADa=RyzGKsayKFSX22qAVOaZ6Sq6akPvBxq32OUK6yvB_1+T=Q@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_queue: be more careful with sk refcounts
To:     Florian Westphal <fw@strlen.de>
Cc:     Joe Stringer <joe@cilium.io>, netfilter-devel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 28, 2022 at 3:41 PM Florian Westphal <fw@strlen.de> wrote:
>
> Joe Stringer <joe@cilium.io> wrote:
> > On Mon, Feb 28, 2022 at 8:29 AM Florian Westphal <fw@strlen.de> wrote:
> > > +       if (skb_sk_is_prefetched(skb)) {
> > > +               struct sock *sk = skb->sk;
> > > +
> > > +               if (!sk_is_refcounted(sk)) {
> > > +                       if (!refcount_inc_not_zero(&sk->sk_refcnt))
> > > +                               return -ENOTCONN;
> > > +
> > > +                       /* drop refcount on skb_orphan */
> > > +                       skb->destructor = sock_edemux;
> > > +               }
> > > +       }
> > > +
> > >         entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
> > >         if (!entry)
> > >                 return -ENOMEM;
> >
> > I've never heard of someone trying to use socket prefetch /
> > bpf_sk_assign in conjunction with nf_queue, bit of an unusual case.
>
> Me neither, but if someone does it, skb->sk leaves rcu protection.
>
> > Given that `skb_sk_is_prefetched()` relies on the skb->destructor
> > pointing towards sock_pfree, and this code would change that to
> > sock_edemux, the difference the patch would make is this: if the
> > packet is queued and then accepted, the socket prefetch selection
> > could be ignored.
>
> Hmmm, wait a second, is that because of orphan in input path, i.e.,
> that this preselect has to work even across veth/netns crossing?

Yes it's linked to the orphan in input path which otherwise breaks the
feature inside the same netns. I'm not sure I follow the question
about veth/netns crossing as this feature can only be used on TC
ingress today. It just prefetches the socket as the packet is received
up the stack from a device.
