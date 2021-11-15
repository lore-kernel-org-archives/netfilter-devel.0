Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7665C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE3063219
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhKOQae (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 11:30:34 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:34626 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhKOQaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 11:30:24 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4HtF312jgSz9vCCR
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2021 16:27:25 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rxV-vKoZjjpx for <netfilter-devel@vger.kernel.org>;
        Mon, 15 Nov 2021 10:27:25 -0600 (CST)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 4HtF310npjz9vCD8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2021 10:27:25 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p8.oit.umn.edu 4HtF310npjz9vCD8
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p8.oit.umn.edu 4HtF310npjz9vCD8
Received: by mail-qv1-f71.google.com with SMTP id q9-20020ad45749000000b003bdeb0612c5so16455537qvx.8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2021 08:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=d.umn.edu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTGswesGEqFwCMp4agZyb+wm1vtS2vFw28Jdwadispk=;
        b=KHnBv55Rh+kIfABOYfAk8vuzMn+yxvEvDabei7V2Ta9b3h4M9z9AwAschajCK9qG8G
         yCr2r62vcm3RfBv33DjnwiQXdqdTfOZiw+wEkjhVAPzkivT9uDoYM1eQ2I0iIwTc0TR5
         G9h1HcV8Bqop8g1QCmgbbG1rFUES/leP+HMLo2U67s60sMnhc0u7sR/TELfxBd9Pk4Ak
         2/fmYrEJBzp+VD5xUxCvhPZlb+ktiu05rU3VMCgPSKp1IFcPbSiSiyM4mjsS5eP4sBIC
         OWsUynYVrY3vZZKWrwgITUcD2AoXhHdXfkeo8Nd7VISR92Yvw1gNVw5/zEgoGXbziAka
         pcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTGswesGEqFwCMp4agZyb+wm1vtS2vFw28Jdwadispk=;
        b=XmP3R4eeR5EaAUNwIzZgPUeS7+8O/Y77dgJCAWy5fjlWOqIwhxUARtbEB231iBNqcl
         ZcjZVK0sY9XXc8sPTuD8o/nshcKaqhIstCOm+iAJx7zydKSdW9icdTta0F7E8516Z1rG
         DEIOy2gO82XXmxIQSi88uarNVu5N/17UeBI71hT1Jz4poSDLp8XVKlcIfCiuv1Gxb9BN
         eAOoKrrLWEWnbhp5WSYfhp4W/J0dsQljN5EzjGYAOy85QDYS9J63jpADv5P965pCDGxp
         3UOo4u7+bxqm1/5b2VgZZiznWpsjizktvy4fAdxroF9D0a6YWiijpdC7t0yqwEwLeHTT
         +rmQ==
X-Gm-Message-State: AOAM533SZkGnmBr0uTZSIYTN7meRnREIYYA/Uq16AelCmfFn8wRFFvcX
        URGHPyFX6NpP9tYsF9zQ17j2ziDu1T3qnkN9pmy0O38VD5s7hEM4bHKN7E9Xo75CNIfBWPQtmXb
        dyvWFYTVpWt+y2Olh726H1mwjxjQfGPp90PnEwyKh85wwpFaF
X-Received: by 2002:a05:622a:198a:: with SMTP id u10mr303605qtc.36.1636993644272;
        Mon, 15 Nov 2021 08:27:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx88Gub1JmntKmSI49CdG/+zPlxvy+5qPlan1fVxOiR9CMmmLUEhqoJo9KMLHTv0kAAYof/QiFu8+6S4JbNXYQ=
X-Received: by 2002:a05:622a:198a:: with SMTP id u10mr303565qtc.36.1636993643951;
 Mon, 15 Nov 2021 08:27:23 -0800 (PST)
MIME-Version: 1.0
References: <CAOLfK3Xq-vre2+vG6k4shjKnEJ+Dq=-z1isVCsgqNLjh=xxfXg@mail.gmail.com>
 <20211114110434.GA6326@breakpoint.cc>
In-Reply-To: <20211114110434.GA6326@breakpoint.cc>
From:   Matt Zagrabelny <mzagrabe@d.umn.edu>
Date:   Mon, 15 Nov 2021 10:27:13 -0600
Message-ID: <CAOLfK3X=nnZ_-kKiEVRBUrH41DxdM=5wuwLH7brEtS_Pp72YLg@mail.gmail.com>
Subject: Re: redefining a variable
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Florian,

Thanks for the reply!

On Sun, Nov 14, 2021 at 5:04 AM Florian Westphal <fw@strlen.de> wrote:
>
> Matt Zagrabelny <mzagrabe@d.umn.edu> wrote:
> > Greetings,
> >
> > I would like to be able to redefine variables in nft.
> >
> > Would you folks consider a switch or a new keyword to achieve something like:
> >
> > define ints = eth0
> >
> > define --redefine-ok ints = { $ints, eth1 }
> >
> > define_or_redefine ints = { $ints, eth2 }
> >
> > Thanks for your help and support.
>
> nft has undefine & redefine keywords.

That's perfect. Perhaps add a snippet to the man page?

Thanks again for the reply and help!

-m
