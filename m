Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67E5C432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA5B610A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhHZEOr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 00:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhHZEOq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 00:14:46 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0392BC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 21:13:59 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id f2so2636801ljn.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 21:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ksfbqAO1y92zPCcjXG+Opb8Rq3ERc1NXCshXP19VqcY=;
        b=UrEErHrdypJw3eYwmjZfRfKL9T+0btZE4CZZDfPq+7W3JX9bpSXNDhiEkhlDvXk7C5
         Iq6m6M7gSUTFUkgdfYTD+rU9dUf6cVfzsbRno8lowcYBdHb2UC/tlQbzBKEEaX0+/H8D
         MgVHifduEtGH2T/lSEIqjx6KPdrQCDXycRsElQLkBV7VykvdsLWPE563oAER2kfuBb8X
         I4XL5ojtRK901b9UJEqNv8OplXirj3Tj2V1T5/uZiOd0PA1/be3YdM3eA+Qh8FHjJG0D
         /B6K3JrMnVfPSV6LJkMqJJ5c3j8sAnlWKfZ3x6UQcRHvzh8+QoEKbSzhWkZVgmvnUFkS
         i5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ksfbqAO1y92zPCcjXG+Opb8Rq3ERc1NXCshXP19VqcY=;
        b=PH4nfV8LCQkRDXQXm7++bIBbcZ23hnm4rS5KhrRMQ2dJ9MM6Jyn+zMvZxqdR58pnAq
         BoR4iFJAsm8G0mBEthOJC0HBDEQx01Vx5D8NLA8mi2GgYRGCQd6Kg4wNbJ2qFesnqCVn
         Kaqqgd1tm9ddPZhNIQ3JUesv15u/Yue7HzvgPnbNoBt/Gp3MJWxls/WUtR9FTL0Ms/er
         b9S/Fx/g6uvYLlw4lEXkUwKrfCZM10qys70ESfxVCRna6+Lgw+LYv32aaG97Yuj2RAMi
         OxjtYNeMc7FfRwgIwuQz3aQTwAxLcK+UW1I+GHYsErN9sZPP/x1tz43RnX6Npnxpiqdm
         xK9g==
X-Gm-Message-State: AOAM531W5IkSLP7n2oSMXZG98Iaq/UIycPSuTM4/cIK6b8Izv02oQRe4
        288kRBTJvL7g0Cb2WHP8Fqmd/Ah/g+6f5XGOy0zDBWRVeII=
X-Google-Smtp-Source: ABdhPJyIffQ6gb0gVSB7yKtlj+oG+Wl0NHJD3Jj5GToQS4H92LpN70AcI2Y35AzcnruhTdDwk7V4N+VtG7x4j+iXmvI=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr1287139ljo.87.1629951238220;
 Wed, 25 Aug 2021 21:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEmo1D2bCemVuCT-D2jdM8AmUgGKxZrq0RpXUMaLyQqjwA@mail.gmail.com>
In-Reply-To: <CAGnHSEmo1D2bCemVuCT-D2jdM8AmUgGKxZrq0RpXUMaLyQqjwA@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 26 Aug 2021 12:13:46 +0800
Message-ID: <CAGnHSE=d1DrtdxvM8h-SHa7fMZq1RzfxOcQxAxszf5-KhcuddA@mail.gmail.com>
Subject: Re: [Bug] Reverse translation skips "leading" meta protocol match
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Actually, rather than "leading", it's actually "non-trailing".

On Thu, 26 Aug 2021 at 12:10, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi,
>
> Please see the following for details:
>
> # nft --debug=netlink list table bridge meh
> bridge meh hmm 2
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000011 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00004300 ]
>   [ immediate reg 0 accept ]
>
> bridge meh hmm 3 2
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000011 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00004300 ]
>   [ immediate reg 0 accept ]
>
> bridge meh hmm 4 3
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000011 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00004300 ]
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ immediate reg 0 accept ]
>
> table bridge meh {
>     chain hmm {
>         udp dport 67 accept
>         udp dport 67 accept
>         udp dport 67 meta protocol ip accept
>     }
> }
>
> Regards,
> Tom
