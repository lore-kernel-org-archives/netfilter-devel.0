Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422FCC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 00:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D33B61247
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 00:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344876AbhJRAsG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 20:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbhJRAsG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 20:48:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E12FC06161C
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 17:45:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so11310396pjb.3
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 17:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=CkK9jHACG5pbtgLm4UlEiBzradaF5fZ1WWhyNpO4ON4=;
        b=MtxPTm6NcdDylSPh6n3GQTguWJ6MtwKaNKOgwfNxqR+F1icEf3KYKdU0ITYEamLCm9
         LRbb0kwrxYx43Xh1BgK6n+rh7Fv3IRaZOEXbyrLPpdZPrSvDDccUO/dOmSLhi5Wr8Jy/
         7d1NBUUZ74EvTP0iBC1mpTuiUY5Xi7qjXUNxowqrVLItefAkabjWr8T73qy9io40T5Lb
         5VogcAQkUMRooXD4e+sjIFrHAgcY3QGXSheObtfHFvu8BaKuhY1uxPlUb3EATc5MumWY
         N658ds61irgFXTRQOy4dqPIR8Pedb+yak7sm33oBjd7jURuaHvmEyXBKGWFOEt9qFfvP
         VHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=CkK9jHACG5pbtgLm4UlEiBzradaF5fZ1WWhyNpO4ON4=;
        b=CE4+V2oHYosmUH7mz1f5QmrBIpBbxA3EHuDqldWCE4651NwBGiF7DtJIQtz9gjapLV
         O71ljA/+xvSxRPXvxsY1tJo6nuE/EmEE6b6/qbu90mBOkvgnHQv8uhdPh6CcQ3Ve/SwT
         SXznq9NolOIkq2c0riAPL6Vm9mAHJNtrsgki4K/I4mWck49U3rcFPoV3Si1wZB22Q8Ex
         i9gOdyCVcBZ/7N7s/rlkKAMqOSPE3eOluSdqIU0Z1JEb/Fs5+LhWjpm+oPqT9D0iNVOe
         Bf69icWvbCcftm7Bx40N7smlepuZkSdvftC3C+LPd459n/sJQ42YUrNeBmNkKSIJKauV
         bDkg==
X-Gm-Message-State: AOAM531+c1ecBz7i5yB95RUXwQE7NIN58WcV8RUCMDSN2lFLCQZtKeTN
        zSjwwiC1Dsnl+bveKD0LF5hP9M/gD/E=
X-Google-Smtp-Source: ABdhPJy/VFqPmqR+yD4j7+A2gdcmTbknK8GtY7NZhQs3ThhBk0/FWBrmFfIQ2Rv6aZ+OA3isOUQi1g==
X-Received: by 2002:a17:90b:2247:: with SMTP id hk7mr29680094pjb.72.1634517954660;
        Sun, 17 Oct 2021 17:45:54 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id d23sm570863pjx.4.2021.10.17.17.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:45:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 18 Oct 2021 11:45:50 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: You dropped the wrong patvh from patchwork
Message-ID: <YWzDvhmmX2pw+cWx@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
 <YWp+/MO6jhvgUdGM@slk1.local.net>
 <YWuCt8cFd3k5YcXz@slk1.local.net>
 <YWwoGrraZHIaPqIx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWwoGrraZHIaPqIx@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 17, 2021 at 03:41:46PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Oct 17, 2021 at 12:56:07PM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Sat, Oct 16, 2021 at 06:27:56PM +1100, Duncan Roe wrote:
> > > On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> > > > - configure --help lists non-default documentation options.
> > > >   Looking around the web, this seemed to me to be what most projects do.
> > > >   Listed options are --enable-html-doc & --disable-man-pages.
> > > > - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
> > > >   --enable-html-doc is asserted.
> > > > If html is requested, `make install` installs it in htmldir.
> > > >
> > > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > > ---
> > > > v2: broken out from 0001-build-doc-Fix-man-pages.patch
> > > > v3: no change (still part of a series)
> > > > v4: remove --without-doxygen since -disable-man-pages does that
> > > > v5: - update .gitignore for clean `git status` after in-tree build
> > > >     - in configure.ac:
> > > >       - ensure all variables are always set (avoid leakage from environment)
> > > >       - provide helpful warning if HTML enabled but dot not found
> > > [...]
> > > Sorry Pablo, this is for libnetfilter_queue.
> > > I don't see it in patchwork - did you get rid of it already?
> > > Will re-send with correct Sj.
> > >
> > Sorry again for the confusion but you dropped the good libnetfilter_log patch
> > that was Tested-by: Jeremy Sowden and left the bad libnetfilter_log patch that
> > actually applies to libnetfilter_queue.
>
> Are you refering to this patch?
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211017013951.12584-1-duncan_roe@optusnet.com.au/
>
> This is the one that Jeremy added the Tested-by: tag, correct?

Yes that's the one. I re-sent it
