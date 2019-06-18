Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D05BC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EF820863
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:36:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EV0Ub6cL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfFRIgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 04:36:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35725 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRIgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 04:36:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so14270515qto.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 01:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJFVu05BnWEMp57pHlRt2tuR+s1oXDQLc9bHnFQEHjM=;
        b=EV0Ub6cLbf3DslAmFXH+WEHThX3TBhFEKYmm2q24xwLYMoYChkLGcuqFZsmLL+eU2Z
         KRlSA5/oJH7Gq7UzTV1Z1TJXNO+1/floA59YVyIg8qYV4ooSi7pyFVHEt2tuocwT5ctr
         Sl+SIcjBSrCUCrCYOc5zk/n6MIZSClMBUxQUYney7an+CUf7x4MijklXJwStA/MLuftk
         c9Bs5j5AyYQ/wfycPkPUWeFsQLHwAqoWAmP8KUrVY5vB3Z551x0s+4TQPVRMKGQyLFwk
         vmbb+/4neZvVEu7olXtTtxUPtvdOErsvvIr3rUc81Ky3+810oKRZ0IyyhjXiZVUeX9rP
         0K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJFVu05BnWEMp57pHlRt2tuR+s1oXDQLc9bHnFQEHjM=;
        b=sildDwta4Cr5Jp1stGvEfm4y4Vnoy/t9g0GV6ZC3ooB2BcxY9gLOk4puRk+b7LAZfw
         iKhx1bj8m5ImbqoQmAjLHDhLBa64MFSyPjr31TSS+loRt1URxaO6LQBB4hGKeWAuz6oo
         TMxMjXM13O9j8Vk9MQhzuupzOhurDtuWBa3W6GzQMXdzTljitu6/0dqssBjSRwCFb3Ok
         zDr6Tvc/+krNJn1Q1bzum9qmqjAx4M8E+j6Df8gBYDBPx9HVJylxNynIZBHLoX4BeM9/
         FT4sIvVv552oH+1FytuPNEfvlsEigY+OVCeZshItyzsUUdOLMarkXDy56x0sczFxs4Bk
         dH6Q==
X-Gm-Message-State: APjAAAVMh5NmmFuukgMzrspg9OScbwpsGjXkRvUXfICrWFN9bZrl1C8e
        y5yCpfEXGKG8pNN/RUpYLPRPkJnimteNY2RIK7cj/p5ZLoQ=
X-Google-Smtp-Source: APXvYqzatuAHjXDxKIECnSUi0YX3jeq7V68R4WEXB6jQDkVbOFJCUWM6wQfScAiNYZMkNiTkSzv+wo/VY2X8CeolOAk=
X-Received: by 2002:a0c:d013:: with SMTP id u19mr25612428qvg.136.1560846982926;
 Tue, 18 Jun 2019 01:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190617161424.gc46x7z5nv24m6pz@nevthink> <20190617220926.rgt5x5gsrzcxsa7l@salvia>
In-Reply-To: <20190617220926.rgt5x5gsrzcxsa7l@salvia>
From:   Laura Garcia <nevola@gmail.com>
Date:   Tue, 18 Jun 2019 10:36:11 +0200
Message-ID: <CAF90-WhFAP4gbykW90xYFQc60TKO6G8YoP+cnwwT_xD3YdJ2LQ@mail.gmail.com>
Subject: Re: [PATCH nf-next] src: enable set expiration date for set elements
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jun 18, 2019 at 12:09 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Laura,
>
> On Mon, Jun 17, 2019 at 06:14:24PM +0200, Laura Garcia Liebana wrote:
> [...]
> > diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> > index 8394560aa695..df19844e994f 100644
> > --- a/net/netfilter/nft_dynset.c
> > +++ b/net/netfilter/nft_dynset.c
> > @@ -24,6 +24,7 @@ struct nft_dynset {
> >       enum nft_registers              sreg_data:8;
> >       bool                            invert;
> >       u64                             timeout;
> > +     u64                             expiration;
> >       struct nft_expr                 *expr;
> >       struct nft_set_binding          binding;
> >  };
> > @@ -51,16 +52,18 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
> >       const struct nft_dynset *priv = nft_expr_priv(expr);
> >       struct nft_set_ext *ext;
> >       u64 timeout;
> > +     u64 expiration;
> >       void *elem;
> >
> >       if (!atomic_add_unless(&set->nelems, 1, set->size))
> >               return NULL;
> >
> >       timeout = priv->timeout ? : set->timeout;
> > +     expiration = priv->expiration;
> >       elem = nft_set_elem_init(set, &priv->tmpl,
> >                                &regs->data[priv->sreg_key],
> >                                &regs->data[priv->sreg_data],
> > -                              timeout, GFP_ATOMIC);
> > +                              timeout, expiration, GFP_ATOMIC);
>                                           ^^^^^^^^^^
>
> Probably better to replace 'expiration' by 0? priv->expiration is
> never used / always set to zero, right?
>

That's right, in this case could be always set to 0. Will send an v2.

Thank you.
