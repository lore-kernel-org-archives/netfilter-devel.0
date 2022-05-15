Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC39C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 May 2022 14:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiEOONm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 May 2022 10:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiEOONl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 May 2022 10:13:41 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B29326110
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 07:13:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a10so13498366ioe.9
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 07:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TCyr9GhpwmuH+ud2lSYLhFUlCwMlK2eoDkXSKoXwmUg=;
        b=LQYTvNHgcJxWxCiW8zu7RIuGrQLPPK8RBiOmzpuvkv/cRB94ahQ45g10noO/M5VHxX
         68ZGoHhFcafCUOX2Xhf/LzYJWNqm8RgeUv9xFMCVThih7mKmvdBm+FpCiGJIoN8FcKM1
         OnNMpMMd+/5i7+jyQMcfi/6DS/RULakVWBvQfkKjMhejWjq/95RVL0z86dFxRMgCCTts
         UvQcVJp2898g1Uy7u+HrHf/IXU8FNj2bBTYI58Vx639/xSI/zC3+W99TIEYECJ62jkQ7
         Knc0Lu2OZOjW/oSgt0m2fqjYZiS8DuhEcOG09iIE40oUKiilZz9+cpHH9Z1ItbhFJLPD
         Y6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TCyr9GhpwmuH+ud2lSYLhFUlCwMlK2eoDkXSKoXwmUg=;
        b=71rw8pBCdcf/VXQVibDO3/zhd/OxzzvY+sCeshxHeYori5ExlmHR9XlnPDNHgWupCj
         e/K1V7bkUANbR4LorkFsKGIMoxVlyP9C31syuvWYwiyxsAuHN1nm6ck7QyIsdCHX1ao/
         OTFTxYr96Xp9E0EtTF1j/5TUxJm+jq5tUr5lMYPAH/3r/Y2vQisIdqRy7nBM9ez9TQW0
         lF1y7du/XHO2MqAeLZicB6XPWWqnbCAz6mADG2gJZS2QGrkBvvHdoSBrBhU7SSky2e0f
         BIAtbvyrUF3c1vYCBC2IgQlDxsKu0dSNCulaSkzzUNWByi8nzVbSO+vUZMrvca3mNld4
         TeaQ==
X-Gm-Message-State: AOAM533XyA6iK4MA5ff5LfzOFCbkV84H7XFPDkECO6XXj0+UbA/xTyQO
        XhTFpEjWR5gcWABV+g+SYi2pHM72RvgTcvlWrZU1BNm76B2xHoH1
X-Google-Smtp-Source: ABdhPJwp/QOgoulH0N7YvMAtp2T16dMDm9dojLm5wPtfmmtauxOsK0+NNO5fty0ZMAss0bs9EUHv4DY7hWIXLyEItI0=
X-Received: by 2002:a05:6638:25d3:b0:32b:7413:a64f with SMTP id
 u19-20020a05663825d300b0032b7413a64fmr7144579jat.268.1652624019596; Sun, 15
 May 2022 07:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220514163325.54266-1-vincent@systemli.org> <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc> <20220515140917.GA2812@breakpoint.cc>
In-Reply-To: <20220515140917.GA2812@breakpoint.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sun, 15 May 2022 07:13:27 -0700
Message-ID: <CANP3RGfoEu5dKV83bO0LYnWYLoJMrvaMaCAx4sYaDNn6-14Z-Q@mail.gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 15, 2022 at 7:09 AM Florian Westphal <fw@strlen.de> wrote:
>
> Phil Sutter <phil@nwl.cc> wrote:
> > > fix build for missing ETH_ALEN definition
> > > (this is needed at least with bionic)
> > >
> > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > >
> > > Based on the above, clearly adding an 'if defined GLIBC' wrapper will
> > > break bionic...
> > > and presumably glibc doesn't care whether the #include is done one way
> > > or the other?
> >
> > With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> > includes linux/if_ether.h where finally ETH_ALEN is defined.
> >
> > In xtables.c we definitely need netinet/ether.h for ether_aton()
> > declaration.
>
> Or we hand-roll a xt_ether_aton and add XT_ETH_ALEN to avoid
> this include.
>
> Probably easier to maintain than to add all these ifdefs?

or even simply replace both the #include's with
#ifndef ETH_ALEN
#define ETH_ALEN 6
#endif
