Return-Path: <SRS0=Ebef=7M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7995AC433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 May 2020 20:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53E3F2074D
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 May 2020 20:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sw7/zr0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgE3Uvc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 May 2020 16:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Uvb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 May 2020 16:51:31 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C52C03E969
        for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2020 13:51:30 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y123so3517405vsb.6
        for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2020 13:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCAh9z+bzLoX5PE/DwioZrO5UunT1sLC3wu9+rFnros=;
        b=Sw7/zr0klzeqtvYrcuRx3g9BGYTN1oLzcImAylYu8rPUcxzEfZlI9JADsAQySWr/Te
         kMZae8yacLpfpyhAUKCTTU3nPSUwtbWcznWy2g0aGmE7Hw+g3Z/+MdLAWof6Wd3WLr7W
         i72xQf01u6mKa4WnxoLQX1LIwzjgchVFKGWf+Z+YBjRowQeQedXVIDcXw3S3Nc6u1xY9
         kC0s5HVZTkZIPJPH1y/SOZy8dMIaXwOeQoRrw8cQ7b3dx8WwIMLxCniNxpguqJMfes8n
         6uFyaSV3JPpYSP5htABXE87+Hk2yBDe+SXC6ebgIVxY4KUX2KyKq/z1j/jlPvgmYtRzZ
         MEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCAh9z+bzLoX5PE/DwioZrO5UunT1sLC3wu9+rFnros=;
        b=U6O64cn73twusQtXlCu/at5zOK0Vv1yOiP/da5CiP9bnKkPPDmOHbN6F6PfzDw5baU
         pjGfEUwQOAmfU7xQX8MzcX4v1D7xxfVVE7ImINtK8jLa0eMirk7w9USU/wS+ZLnWCrUn
         hGBe41cjAPS9YGFOfDe2s+BNztYTb+B2GFzuJ3c8xlBr4PPQKPELu972gNNn5Gzo8UES
         C9HL2BRhftzwMZCmMNK73StetS2oIqjSTuHTrMUpKz0HnTR1wNtZ7nI7F8uchj3bqJWp
         5rSGfG5jm3QTsencGU5d0RSAQL5xAcCIliQHzRS6jamKnXcydlyz4Iq+F1l2pRnKv+bV
         JoPQ==
X-Gm-Message-State: AOAM531DgliF2aHjj0CiGIlKW0r4WmNzI7EjXXNMpWypEkZM+nJtO+Ip
        M6niEQHjuh99lh6IOL2t3fdUMFYAAD7pI+8nEWXV6naW
X-Google-Smtp-Source: ABdhPJxYq4JxAW4NtvH2mXGAmDSEJD9kFNfDrlT+N8sGNxid3Yw2OJUTAqCAh8ouxbEmtC7SSNs7qjg+LLo9TMvFpIw=
X-Received: by 2002:a67:ff89:: with SMTP id v9mr10240622vsq.55.1590871889678;
 Sat, 30 May 2020 13:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200529110328.GA20367@nevthink> <20200529191519.GA32761@salvia>
In-Reply-To: <20200529191519.GA32761@salvia>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Sat, 30 May 2020 22:51:18 +0200
Message-ID: <CAF90-WgbH6iU_EZioCUOp4wBSz1SQzJy3N058JhGBbwy2MceXQ@mail.gmail.com>
Subject: Re: [PATCH v2 nf-next] netfilter: introduce support for reject at
 prerouting stage
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 29, 2020 at 9:15 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, May 29, 2020 at 01:03:28PM +0200, Laura Garcia Liebana wrote:
> [...]
> > diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> > index 2361fdac2c43..b5b7633d9433 100644
> > --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> > +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> > @@ -96,6 +96,22 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
> >  }
> >  EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
> >
> > +static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> > +{
> > +     struct dst_entry *dst = NULL;
> > +     struct flowi fl;
> > +     struct flowi4 *fl4 = &fl.u.ip4;
> > +
> > +     memset(fl4, 0, sizeof(*fl4));
> > +     fl4->daddr = ip_hdr(skb_in)->saddr;
> > +     nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET);
> > +     if (!dst)
> > +             return -1;
> > +
> > +     skb_dst_set(skb_in, dst);
> > +     return 0;
> > +}
>
> Probably slightly simplify this? I'd suggest:
>
> * make calls to nf_ip_route() and nf_ip6_route() instead of the nf_route()
>   wrapper.
>
> * use flowi structure, no need to add struct flowi4 ? Probably:
>
> static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> {
>         struct dst_entry *dst = NULL;
>         struct flowi fl;
>
>         memset(fl, 0, sizeof(*fl));
>         fl.u.ip4 = ip_hdr(skb_in)->saddr;
>         nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
>         if (!dst)
>                 return -1;
>
>         skb_dst_set(skb_in, dst);
>         return 0;
> }
>
> Another possibility would be to use C99 structure initialization. But
> I think the code above should be fine.
>
> Thanks.

It looks better, I'll apply the changes.

Thanks.
