Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40A3C282E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09CB2075A
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pEpJ7+By"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfDVJvl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 05:51:41 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34119 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfDVJvk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 05:51:40 -0400
Received: by mail-vs1-f66.google.com with SMTP id t78so5931293vsc.1;
        Mon, 22 Apr 2019 02:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/8Ia0lr8SyGRhLNV/rp9b91j7HYQOCib8nOzsqqsR1w=;
        b=pEpJ7+BypWkwhgcSpVHj0qLYBolMmeAMuAtX5eJAEm2Wn3Qf381fMH5Troh49WspWb
         6kbK20Ha6eJQWH05TBiZbumKsJBsls3sfA9mKJXaabWvAvAUG+6nvSfhRCJjURjgvwoh
         Kv+RNVhctOqkmrruS5cPLg7QiLwzk9eKz5ghmtZO68/b9qOqkasAzJXWLK5jqzr6Qbiq
         cVrDkEhDtu+vMXDWOCiLvC44J4A7cQyqOZM5Be+wyDpXldYIm2KSg/JjKNqRHpxNgcMf
         YjH1DS8BM8yELgO98GJE7ocPDrQhUPElc2CId+orI+69tOS8/PtiOii03XR0OzEDNCeN
         DcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/8Ia0lr8SyGRhLNV/rp9b91j7HYQOCib8nOzsqqsR1w=;
        b=tA0arxJxjj44vHVgKf4mW6PvmLtvLtWBe7gbsAOtJAC5sVzZAvrRuzmAEJjlzw+0bE
         d4O9PjcX1Nucb6gShu1+2zDajiyr+mgtuuR294RIgLJGQrc+xWv4Veg2IBdzJCMqIIF7
         fXAY1sZnz3WRjq8ISF74miH5YZhDNLKNYtFvgekv4f+1eIFtjFrAz5zvWOv1+IBMU1TY
         gjmM5LTUpumJiYZBlVr+/w19YMQxyf2XRhr2onb1dCG8qACRJTsBPwZy3coFqWlR89wX
         y8yYU8MssM54zU/NyiExZ2nT2jaAleooqes5/c/dkiNAbCX3C22Ypmgzr7YpkENkHZMW
         Swvg==
X-Gm-Message-State: APjAAAUKqvqHYobo0nOKXa0M8uzth8On/mZeRlxPbQsdLJHzWLxMYnSq
        piAO+JgTznSn92lfYfylHbDiDb0I7hu5kjYXEQ==
X-Google-Smtp-Source: APXvYqyYHHYWIkx3qkizLK5MKUvD4HclK5p6vLE9Frv//DrrPdtcawUUnjDjV8gOf0uk7v5NEN9SZJ5P5w6X779nLQ8=
X-Received: by 2002:a67:e881:: with SMTP id x1mr9854243vsn.48.1555926699737;
 Mon, 22 Apr 2019 02:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190409065612.32652-1-rdong.ge@gmail.com> <20190422083339.ptkxqb66pombgy5g@salvia>
 <CAN1Lvyo1CVopsB7iV=e-dAN9JDFg-SmQ8g6H6RrgD7qACAd4hQ@mail.gmail.com> <20190422093502.36da6z3qf7zxpwny@breakpoint.cc>
In-Reply-To: <20190422093502.36da6z3qf7zxpwny@breakpoint.cc>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Mon, 22 Apr 2019 17:51:28 +0800
Message-ID: <CAN1LvyrSWPbNSvzLquQAeK9kYK=YyqyJEm7zodd3O-QWAVTC4Q@mail.gmail.com>
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

skb->dev is munged in setup_prerouting() to be bridge or vlan device on
top of bridge.
--Yes, but  br_nf_pre_routing_finish will set the skb->dev back to the phyi=
ndev.

Florian Westphal <fw@strlen.de> =E4=BA=8E2019=E5=B9=B44=E6=9C=8822=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:35=E5=86=99=E9=81=93=EF=BC=9A
>
> Rundong Ge <rdong.ge@gmail.com> wrote:
> > br_nf_pre_routing will call the NF_INET_PRE_ROUTING hooks, at this
> > time both entry->state.in and entry->state.out are not bridge device.
> >
> > NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > skb->dev, NULL,
> > br_nf_pre_routing_finish);
>
> skb->dev is munged in setup_prerouting() to be bridge or vlan device on
> top of bridge.
>
> That being said, I think we need this fix at least:
>
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -197,8 +197,15 @@ static int __nf_queue(struct sk_buff *skb, const str=
uct nf_hook_state *state,
>                 .size   =3D sizeof(*entry) + route_key_size,
>         };
>
> +       if (skb_dst(skb)) {
> +               skb_dst_force(skb);
> +               if (!skb_dst(skb)) {
> +                       status =3D -EHOSTUNREACH;
> +                       goto err;
> +               }
> +       }
> +
>         nf_queue_entry_get_refs(entry);
> -       skb_dst_force(skb);
>
>         switch (entry->state.pf) {
>         case AF_INET:
>
>
> Then, why not add, in dev_cmp:
>
>         dst =3D skb_dst(skb);
>         if (dst && dst->dev->index =3D=3D index ...
>
> ?
