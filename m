Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4840C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 08:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE4A2072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 08:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uMHRTHUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgE2IjL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 04:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2IjK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 04:39:10 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EF5C03E969
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 01:39:10 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id k3so1053533vsg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 01:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P0r6DovQNeXnaKtTl72G634wXmYQSwjwBkXtz/EdstU=;
        b=uMHRTHUOdVvUI+/S2zqmtJY5mNCOlHMd+UkF3mJqQ4wWvooSP6enfsW48a43VaCl+u
         O0ifBE7WztLCEHHRAtK5gh0DIKM8bYg0dgDOoMqSnl1dhCB8Ru+ktS4VEpl3kmt9vTId
         cOY/LQQjPdN/jch/Ig5J1V1hUm1rkqJdKIsvW3YytWQXNJ5mZ9luLd8SiK3npMYRNL/Y
         IkJw9VtNy82saD/uhkoRFOmt+SYBYgjoqz4x1HXa+Wc28Ox/AWX1/FhYI5kouJPMPHxA
         aD6jMFspir1ihpQkSiH4c9x/IRaLBvFKjCXuzzJgxwuJjuV99bzMOyhlbVfaG+UZy73q
         VvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P0r6DovQNeXnaKtTl72G634wXmYQSwjwBkXtz/EdstU=;
        b=dDizM8wNuEV4Iz0NKb5X+lWnDZ2F9wgvHuDfQffoXv2+xzDcOxmaWQ5a5rHExIJkHu
         tSzPmJZxRZDd2bl+GPdVV+zlmDBK3ZKu/UWiiuARnA+n7gYwBc4uj+DSX/fnlMrpyDQO
         EGcLc6z1eAckXgPImnLk5sdKptgR3nXHoTZHK7KNrXMs7JnPp33edeH8cO+Li+K2XUCF
         ySJPQoi315tlLXO2OKg2rIVsXmDZEJTgMZBgr2tECkWrbIEg7+V9QADCeyiUX44cqC68
         MEaFp8GzXzblVw+WL3bxGtvKPpilmUNJ//89VlD22Yx2NvuFiOQSu+dkR39eiWVX2Nhm
         GTCQ==
X-Gm-Message-State: AOAM532xst7YgIZE5gSWeZw/o89Hsuu52gKoI3kGpQFQ4NxBy66OI1zY
        d7r/lDJ50uD5/LafQdZEt92N69NEC3mComCJWHIOqHrr
X-Google-Smtp-Source: ABdhPJxzcrXczJrhAikOHtlzW+0s97kj5a/C3+dY+QjpMeqVPQMzYf8Gqfuhv9Z6s/5oZpNO3fZ3O0evb+jm/cX4gqo=
X-Received: by 2002:a67:1006:: with SMTP id 6mr5324893vsq.126.1590741549121;
 Fri, 29 May 2020 01:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200528171438.GA27622@nevthink> <20200528172434.GL2915@breakpoint.cc>
In-Reply-To: <20200528172434.GL2915@breakpoint.cc>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Fri, 29 May 2020 10:38:58 +0200
Message-ID: <CAF90-WhZP+srz=KTUxHsHWgJ-jVr5cPDCabgBcjipywCK=9krg@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: introduce support for reject at
 prerouting stage
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 28, 2020 at 7:24 PM Florian Westphal <fw@strlen.de> wrote:
>
> Laura Garcia Liebana <nevola@gmail.com> wrote:
> > +static void nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> > +{
> > +     struct dst_entry *dst = NULL;
> > +     struct flowi fl;
> > +     struct flowi4 *fl4 = &fl.u.ip4;
> > +
> > +     memset(fl4, 0, sizeof(*fl4));
> > +     fl4->daddr = ip_hdr(skb_in)->saddr;
> > +     nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET);
>
> Hmm, won't that need error handling for the case where we can't find
> a route?

Right. I'll send a v2.

Thanks.
