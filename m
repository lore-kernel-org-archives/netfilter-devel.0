Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4254C31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 19:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E08D20848
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 19:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oWNU0KB6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfGMT0O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 15:26:14 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:41234 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfGMT0O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 15:26:14 -0400
Received: by mail-ed1-f47.google.com with SMTP id p15so11943871eds.8
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2019 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kCxRdDgJzao4P4ibCYslsZF616uoUl1Mh0dT6oL4Lpk=;
        b=oWNU0KB6n/D1dCeN5yKJEW2x1mNnUAfzhBrWq6yV05VWGzRvvoWvZnCRZ/ESyp8fKg
         ZDB2I+Te4N6UTTdXc8uTVDksOkpzCx+NRRMjdHrPo+fBgKk/yeSCiYTmCm3bqL/S0SA3
         hrJvPqIG8EXJRb0SQSoveZJpOY6cg9MJQamRdHLIMUQk5qgnTq/geW/Po2+7F3EOAxMz
         4ynuRGMj0ZUhLxMEKE8Z8joGF5ToGijffWCmZ9wcOpiHQ+Lm3hSJ6xzh/oN/HlfMdBY7
         ccmTMXzkzl4Q7g16/tTM+R9YJatbxUXm1/F28WQzdR2YQL1FejE6I2w8DqAABnTTsNxn
         LPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kCxRdDgJzao4P4ibCYslsZF616uoUl1Mh0dT6oL4Lpk=;
        b=cvN/xyn3OxpzuIffkilT2dtb+AtVzL+wBrnCNZJ5oiQvFK0ql5d6a/Nvy3oA6wu6BL
         NP51L3PhEEwjrHfTMLPuh6uLVZaNx0xJIjBSFvNzcFNbtnXVUfLHudFuG2RxyNj5b+1c
         JzA0U/rUfm4IGbnorMFpZzBIcRxqt9DceM1yaubyIUkuMj99gaXVouk0SykRlr0QcJxP
         sOPW8Xm6Df0Kl871j8ofEQtJHf3nXGGCfnQTpnJyDHXCxjWbl3fWBXlydJ3eQZq67Bbc
         Dhf9UaGuuUjvpVSCHmrYWoQGgBVelEI8f/mqWSHT8q5JAHCNaw6Chelv72U8JyHliBYs
         VQ3g==
X-Gm-Message-State: APjAAAUEU2mA190kmgUnuIOYNagFPlxspD+PvGc+yM94qh2wnyww2/XE
        bomHVChhY11fFj8Br92ENcyaJwOT5eZWGEUFPfU=
X-Google-Smtp-Source: APXvYqx8jBbilzYOJdrBkydFSpFC8RNQ9T4GC5l+7jCr9qJt/77IPoxs2AjaiBK9i9iinna35uG6mB6aScZM3XyJWGI=
X-Received: by 2002:a50:89a6:: with SMTP id g35mr16076117edg.145.1563045972721;
 Sat, 13 Jul 2019 12:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <CADxRZqwxBCV6G2OMjuv3S49MsDeSuAHfN8vnVSFm_Uvv1BD1Og@mail.gmail.com>
 <20190713190320.pmu33mx2lm75fihd@breakpoint.cc>
In-Reply-To: <20190713190320.pmu33mx2lm75fihd@breakpoint.cc>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Sat, 13 Jul 2019 22:26:02 +0300
Message-ID: <CADxRZqw+MrtQhQF1_AZ2Gr_Sm5xmWjH0ZwjKXKdZ_rQqOvSrhw@mail.gmail.com>
Subject: Re: [sparc64] nft bus error
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 13, 2019 at 10:03 PM Florian Westphal <fw@strlen.de> wrote:
> Anatoly Pugachev <matorola@gmail.com> wrote:
> > Program received signal SIGBUS, Bus error.
> > 0xfff8000100946490 in nftnl_udata_get_u32 (attr=0x10000106e30) at udata.c:127
> > 127             return *data;
>
> struct nftnl_udata {
>        uint8_t         type;
>        uint8_t         len;
>        unsigned char   value[];
> } __attribute__((__packed__));
>
> Sparc doesn't like doing:
>
> uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
> {
>         uint32_t *data = (uint32_t *)attr->value;
>
>         return *data;
> }
>
> Anatoly, does this help?
>
> diff --git a/src/udata.c b/src/udata.c
> --- a/src/udata.c
> +++ b/src/udata.c
> @@ -122,9 +122,11 @@ void *nftnl_udata_get(const struct nftnl_udata *attr)
>  EXPORT_SYMBOL(nftnl_udata_get_u32);
>  uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
>  {
> -       uint32_t *data = (uint32_t *)attr->value;
> +       uint32_t data;
>
> -       return *data;
> +       memcpy(&data, attr->value, sizeof(data));
> +
> +       return data;
>  }
>
>  EXPORT_SYMBOL(nftnl_udata_next);

Florian,

yes, works beautifully!

Thanks!

PS: missed CC list
