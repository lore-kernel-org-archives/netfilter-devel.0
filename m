Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D3EC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Feb 2022 06:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbiBCGKa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbiBCGK3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 01:10:29 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEABC061714
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Feb 2022 22:10:29 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id l13so1296348plg.9
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Feb 2022 22:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r742eiwVhdZJwif0NqEPB+SnmlIGoGm/PfFIVNZtz4k=;
        b=gbocCN/vR+8lVtHwoXd8HLdeJrcD8Srv8ptoGQL7cuvkjQSyBJQedSRDQSQUZh/AeZ
         gormEyyGLrpB98n3HQqf86IPwEtdtgIslDLcFNutE4mNMN+ZX2oEZ7uTHRKrTgIkpLQ1
         +ymw/QkQMS2syv+gDbYZ5xgliMCSqo+iBrytmj6Hlh7ym9cRXqwb9DM7RPLkPgI3QRvA
         /3uKTQcirfthghL4S7ZqNvqHaQbtrOEPDFEZtuQnI9SXq5vA44NbFPUq02nU6OVJg1OE
         A/RerOW8wRSNcBLpI3vQ1UT9F0CgHxtGWondEnGQm0ZzvU9XKI+K266QHXbJvIvDSruP
         J8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r742eiwVhdZJwif0NqEPB+SnmlIGoGm/PfFIVNZtz4k=;
        b=F6TL4wcsOdxs1nNOs19uBScwVEj8VTOTFpmgqL0XRE9kk5Vsjx8l1KjQkD4kzijbUJ
         urNOVfhmK7iA7QXs2KMPrb7xANFsbSTug3VhSCl6ZJ3yre9rM9qNybhpfAF3UXgrsgFB
         5Ni7BBiqA5P9bqMpZlbHjupfTOh0KGJAZQ8yEew2BEz6VRELg3zKi6KrrFBcM8nDd+QA
         xWUmMlQ/+Y/WCAYCS0GKeBBCeRitW5SpXkbqHVucutbRLMtVuE/gBGSwuOpGqVh3H7Pl
         dnr0SZAgDmSIaeaSHmhoBsTL1m09xwx7arAC3wmV8aHj+NqI7/pGdYThlPUyerEoRKBR
         iQEw==
X-Gm-Message-State: AOAM531CPVaiaK9A16hE5j+YqDFlS+I44meXsSdc9KTGbTPL9ksqMwz4
        57mBQ70P8LzGarod8MnKY2QhdzQ/wikZt4JDvvUJkCwW
X-Google-Smtp-Source: ABdhPJwFH+1XSaIjb6zcBeAwfKuoA5F+kcmNtI23qUjLGOGR/UCX1cvLBV4RlxW5AISlCyrn+usZayxTatyP5Xpt/5s=
X-Received: by 2002:a17:90a:640e:: with SMTP id g14mr12156903pjj.8.1643868628715;
 Wed, 02 Feb 2022 22:10:28 -0800 (PST)
MIME-Version: 1.0
References: <20220203051329.118778-1-vimal.agrawal@sophos.com>
In-Reply-To: <20220203051329.118778-1-vimal.agrawal@sophos.com>
From:   Vimal Agrawal <avimalin@gmail.com>
Date:   Thu, 3 Feb 2022 11:40:17 +0530
Message-ID: <CALkUMdQO5=TfeaacNSxd74RXnJJPapvpL3MVP8L3mz4k46tcng@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nat: limit port clash resolution attempts
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
Cc:     Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

corrected a typo in one id in the mailing list.

Vimal

On Thu, Feb 3, 2022 at 10:44 AM Vimal Agrawal <avimalin@gmail.com> wrote:
>
> commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 ("netfilter: nat:
> limit port clash resolution attempts")
>
> In case almost or all available ports are taken, clash resolution can
> take a very long time, resulting in soft lockup.
>
> This can happen when many to-be-natted hosts connect to same
> destination:port (e.g. a proxy) and all connections pass the same SNAT.
>
> Pick a random offset in the acceptable range, then try ever smaller
> number of adjacent port numbers, until either the limit is reached or a
> useable port was found.  This results in at most 248 attempts
> (128 + 64 + 32 + 16 + 8, i.e. 4 restarts with new search offset)
> instead of 64000+,
>
> Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
> ---
>  net/netfilter/nf_nat_proto_common.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
> index 7d7466dbf663..d0d9747f68a9 100644
> --- a/net/netfilter/nf_nat_proto_common.c
> +++ b/net/netfilter/nf_nat_proto_common.c
> @@ -41,9 +41,10 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
>                                  const struct nf_conn *ct,
>                                  u16 *rover)
>  {
> -       unsigned int range_size, min, max, i;
> +       unsigned int range_size, min, max, i, attempts;
>         __be16 *portptr;
> -       u_int16_t off;
> +       u16 off;
> +       static const unsigned int max_attempts = 128;
>
>         if (maniptype == NF_NAT_MANIP_SRC)
>                 portptr = &tuple->src.u.all;
> @@ -87,14 +88,30 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
>                 off = *rover;
>         }
>
> -       for (i = 0; ; ++off) {
> +       attempts = range_size;
> +       if (attempts > max_attempts)
> +               attempts = max_attempts;
> +
> +       /* We are in softirq; doing a search of the entire range risks
> +        * soft lockup when all tuples are already used.
> +        *
> +        * If we can't find any free port from first offset, pick a new
> +        * one and try again, with ever smaller search window.
> +        */
> +another_round:
> +       for (i = 0; i < attempts; i++, off++) {
>                 *portptr = htons(min + off % range_size);
> -               if (++i != range_size && nf_nat_used_tuple(tuple, ct))
> +               if (nf_nat_used_tuple(tuple, ct))
>                         continue;
>                 if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
>                         *rover = off;
>                 return;
>         }
> +       if (attempts >= range_size || attempts < 16)
> +               return;
> +       attempts /= 2;
> +       off = prandom_u32();
> +       goto another_round;
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
>
> --
> 2.32.0
>
