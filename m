Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5890C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 23:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A859A60F8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 23:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhJSXrU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 19:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhJSXrT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 19:47:19 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66A9C06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Oct 2021 16:45:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so1358649pfi.5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Oct 2021 16:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=WnVXfMpoV6SiqOwAt+9HKh2QfjEOJExNgkzGbcOM8vM=;
        b=HXKv4iJrRdxuelwSy+Upn+spGp6nh6JCtazvCt6STrjlQYchDHNCGAYiZZN9xAnRCn
         qhJLKi5upFHrKYksKzQp0JL9fi9v2RQJqEfIA+7XAfMOT7pbY9XbIab330OaHoEHdC0h
         cpf/ZFhOcTL0oufJB3SOThwDmcCQ+x+LSb1MP0gVWiD2u1olYNhbvCYLm/fUuFK8LsTE
         Vt6sd9s/BOMVIFuglO4KsE8mh4obAQWlYpAxZNo50dOqS27evxTpc7XEdFIALm2Xdj7L
         nbbU9V1pSGKS0VVShLp2jVISJhbXdWY/uGi1qW+wCDTQNGYmt59kxbd09dXUs4AI4grz
         DYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=WnVXfMpoV6SiqOwAt+9HKh2QfjEOJExNgkzGbcOM8vM=;
        b=YZi45EZOC0yi7oK04Xcnes6vSdIHB9alrcxSTxyi869NWwP2rFKvu19Kd7v0HGgPRA
         OikdzLscbFqxewEXZ30Edqh+dSbeAf9ZgZwbGNELmdDrBvYuh0JA7dIp5uwFUImlMQET
         +pEEEf67fsAtYTPRBv1YME6HzC9U7saoxvM1qnVDhpdG9mYNkmbncumD2dJFfZGuH6ZW
         J7lIjb894SwVuOFqO/B4NpBqCIxRuKgc/K1gBmCa7AvInvJPjea6ZyJfkPrIWGhUaz8r
         bSJgIXdFfPz0kVLSZuUDutSVHV3BqtcpktIbu9GfSqfqWQW9xD+CFjwWmq7Q4fgK8tVt
         z+Hg==
X-Gm-Message-State: AOAM5311wFFwVFFaFGa8iieBWUH04KT742+hr+CCqJaNLYoTB6uwxgIm
        HSJbLyV2kaEfFYxdmayF22tPs1LrXcY=
X-Google-Smtp-Source: ABdhPJyiiD5T7GvLLrs2sdRw3N900s9dOSYJoV1VpwT4A9H7bdgmLTpOaEEMTxqtEA2zF82i+zN6mQ==
X-Received: by 2002:a63:7542:: with SMTP id f2mr23852394pgn.147.1634687105289;
        Tue, 19 Oct 2021 16:45:05 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id t2sm3766770pjf.1.2021.10.19.16.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 16:45:04 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 20 Oct 2021 10:45:00 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: You dropped the wrong patvh from patchwork
Message-ID: <YW9YfFJjFLPtgJjU@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
 <YWp+/MO6jhvgUdGM@slk1.local.net>
 <YWuCt8cFd3k5YcXz@slk1.local.net>
 <YWwoGrraZHIaPqIx@salvia>
 <YWzDvhmmX2pw+cWx@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWzDvhmmX2pw+cWx@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 11:45:50AM +1100, Duncan Roe wrote:
> On Sun, Oct 17, 2021 at 03:41:46PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Oct 17, 2021 at 12:56:07PM +1100, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > On Sat, Oct 16, 2021 at 06:27:56PM +1100, Duncan Roe wrote:
> > > > On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> > > > > - configure --help lists non-default documentation options.
> > > > >   Looking around the web, this seemed to me to be what most projects do.
> > > > >   Listed options are --enable-html-doc & --disable-man-pages.
> > > > > - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
> > > > >   --enable-html-doc is asserted.
> > > > > If html is requested, `make install` installs it in htmldir.
> > > > >
> > > > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > > > ---
> > > > > v2: broken out from 0001-build-doc-Fix-man-pages.patch
> > > > > v3: no change (still part of a series)
> > > > > v4: remove --without-doxygen since -disable-man-pages does that
> > > > > v5: - update .gitignore for clean `git status` after in-tree build
> > > > >     - in configure.ac:
> > > > >       - ensure all variables are always set (avoid leakage from environment)
> > > > >       - provide helpful warning if HTML enabled but dot not found
> > > > [...]
> > > > Sorry Pablo, this is for libnetfilter_queue.
> > > > I don't see it in patchwork - did you get rid of it already?
> > > > Will re-send with correct Sj.
> > > >
> > > Sorry again for the confusion but you dropped the good libnetfilter_log patch
> > > that was Tested-by: Jeremy Sowden and left the bad libnetfilter_log patch that
> > > actually applies to libnetfilter_queue.
> >
> > Are you refering to this patch?
> >
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211017013951.12584-1-duncan_roe@optusnet.com.au/
> >
> > This is the one that Jeremy added the Tested-by: tag, correct?
>
> Yes that's the one. I re-sent it

To be unambiguous, the bad patch is

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211016043948.2422-1-duncan_roe@optusnet.com.au/

If you would remove that, then patchwork will be all good.

Cheers ... Duncan.
