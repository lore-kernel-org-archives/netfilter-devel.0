Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276C4C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 07:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbiEPHMs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 03:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiEPHMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 03:12:47 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29C8E003
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 00:12:46 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id t2so6782898ilm.13
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 00:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oFdfmwKPdkzBywHOLOp/T09g5D75CWpPJX0rAdlBoDE=;
        b=LJSDjYWGiAr6maQYhKQwmG+K5nz8hV/re1Xiy8CFuOpacdL1Wv/5CvY4xp60aXujNc
         qWAB1mgK7JAkytdJcBm+rSo1li++9p//D7sWwywImcwYKdZWkoOJ8NYbpJubxNJDwhtO
         iyijS1TpA22ydv5C3WvPliNPxMsdUf3gmAO+MWjk54OeYbMPE9g4NweTmlERTKWI3dig
         Fs04tN/HdGGAiy2JkaWZ1LTyQo/E/XHa/Y8UWE4cI7F5vY8OBM2xBHgH4cgsDoH4+1LP
         /AYaRB/Tnm4WEOeaCQkA/IDpbPVFXG5wXrd75tNoEzaiL8QGe/Ex+YV/GMawpBwZfTuB
         IKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oFdfmwKPdkzBywHOLOp/T09g5D75CWpPJX0rAdlBoDE=;
        b=PxtMBYflhQ2h/aiEDywcdBkZoweOcUkKHD9dd/lFvv+33uIVf19JwGqP+GFgpVwwC3
         JVrd4ydwB0aM1YPAA86wUs4JVDLm+f323AkDjeKpITAzrxR3B8wnly/St/MX9PUIE4Kr
         iTk5RtfMirKmEE+xrSbpGLVXocAFCFa2iIbx0riz5Yyf4p5qI3PXppVxIkJMnfjZ3no1
         izbhrho3YSDvcjZqT1Pd64w9h1XncbI5TeFsYeYr1c08AJB2RGVfErvBjTvDzyMEM8x3
         E4kDqhlEmLYXFDOcvrO9oQi0/u+oDeQbX4CVWrwsgQtlFQ7ZohRS/eDwwlg7Tox8FqvM
         u+VQ==
X-Gm-Message-State: AOAM5328BMVJ22wbwdVIj21jvHiGZgtiBn5jhdXnecO6t0B+qo18jGmU
        oBjPiqNTEHdwj7Ch6D/xgaxBDVfYNLPdZ6KqkSW5/aOZqGfQ+g==
X-Google-Smtp-Source: ABdhPJxImXqz7FzMSlk5SdzxyWWzWBnuPpdWldIsD0Ozg9hMfYblKlrk0hNIJQfUdf9PST3KJomPmaJLDQUpc3Ij48A=
X-Received: by 2002:a92:cb0f:0:b0:2d1:1d34:7aad with SMTP id
 s15-20020a92cb0f000000b002d11d347aadmr2089527ilo.14.1652685166068; Mon, 16
 May 2022 00:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220514163325.54266-1-vincent@systemli.org> <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc> <1c529232-3219-2571-77df-84047f594178@systemli.org>
In-Reply-To: <1c529232-3219-2571-77df-84047f594178@systemli.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 16 May 2022 00:12:33 -0700
Message-ID: <CANP3RGfRcx-ykxVUMGE+Nw6vwC6OPQDq0R+BE36aJ=_MqTCHGQ@mail.gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
To:     Nick <vincent@systemli.org>
Cc:     Phil Sutter <phil@nwl.cc>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 15, 2022 at 11:53 PM Nick <vincent@systemli.org> wrote:
>
>
> >> Ultimately I find
> >> https://android.git.corp.google.com/platform/external/iptables/+/7608e136bd495fe734ad18a6897dd4425e1a633b%5E%21/
> >>
> >> +#ifdef __BIONIC__
> >> +#include <linux/if_ether.h> /* ETH_ALEN */
> >> +#endif
> > While I think musl not catching the "double" include is a bug, I'd
> > prefer the ifdef __BIONIC__ solution since it started the "but my libc
> > needs this" game.
> >
> > Nick, if the above change fixes musl builds for you, would you mind
> > submitting it formally along with a move of the netinet/ether.h include
> > from mid-file to top?
> I will test again. :) However, I can not open the
> "android.git.corp.google.com"? Can you maybe link (also for reference)
> to a freely available source?

Try https://cs.android.com/android/_/android/platform/external/iptables/+/7608e136bd495fe734ad18a6897dd4425e1a633b
