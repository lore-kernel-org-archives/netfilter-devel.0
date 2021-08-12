Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4F6C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 18:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A351460E78
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 18:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhHLSZz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhHLSZz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 14:25:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BFCC061756
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 11:25:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n12so7706313plf.4
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 11:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=a89X3x6nrqGsOe37YUXty7qztIXiu6WomHt7PsfCUOw=;
        b=TFJv5LbjFXzn/UZ70MyBNQ5f8yzXJLfM09ovfrWdQLelS25ZA4k8DgdkTKCxVeupFT
         etD/Ar+VBWOT1GIzjlWjt6sePNy1CFgy9MNIDaa2R2GyUi5n36Ss8LwZGtZUPa/hbB7B
         qbSp4hN5hhrncqs7uUw2cBTBQJ4sRTukilYf8XeiU8BW6JuNRNV/R4tP9nJSMSsFLo+o
         HQHDbal/yP1gZcvqtmg87ZVuyhYPAuaKDpyGaFeQTBNn+bMuTjNVmdo0cUDOP/TwYVJq
         G3bzdRc2dCndnQAi+v3IqqaKKK3aVhtJX2K95euDDlLVA/x3wAQIzRc0nLZq9XclWhVd
         MpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=a89X3x6nrqGsOe37YUXty7qztIXiu6WomHt7PsfCUOw=;
        b=XrKM+DkzkQh4S78t9v8iw4TWMXrsf+pllNJt/bNimcUGjNBfEehRE2Zxft8aRoVNKE
         ov/CAWyKQ9IQHmvvykgnOpSMRM01MUczSfjhwgOYCS4JSaOMzxJ3oHxiiKCZmpeGEPvd
         Z7pgbOg/XDQcbMbwJQIYWm+xxG+P99XnJMLf5mnTUxTPKosXWzOwJAqUAKoPLaGIS3Wb
         hUXtzer9TdXYJ06kmpLmivQkCx93Cwo0N9/kX7JYeoEA87AuGeajzA/HVdodGdNc0hT4
         HbCwWBpGZlWYCPFtbeLmvLaVXXL8FixZVm67ZpWyvAJRsddWY5wqj59i1u7hBwUzstsQ
         Wc7w==
X-Gm-Message-State: AOAM530xIGy3Y25FBilgY/ZjqiXSaDEI8UtWbhnl+dVzj0EtfryzMcDA
        cre/Lg4c3XUzNRRfmt17WPPgCnDxQbGpKw==
X-Google-Smtp-Source: ABdhPJwAqw43Xnkn+udkK++eNs0R68KXvuHiZmr6Goj+Yo7WRO8vrA2stZvVnsqnTRDGvRlo4GxLbg==
X-Received: by 2002:a17:90b:104b:: with SMTP id gq11mr10870533pjb.64.1628792728959;
        Thu, 12 Aug 2021 11:25:28 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y3sm852662pgc.67.2021.08.12.11.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 11:25:28 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 13 Aug 2021 04:25:23 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] include: deprecate
 libnetfilter_queue/linux_nfnetlink_queue.h
Message-ID: <YRVnk97MgWzKogGO@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810160813.26984-1-pablo@netfilter.org>
 <YRNsdKcEl0z3a2ox@slk1.local.net>
 <20210811090203.GA23374@salvia>
 <YRQfo6YISjO7z6gH@slk1.local.net>
 <20210812082055.GA1284@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812082055.GA1284@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 12, 2021 at 10:20:55AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 12, 2021 at 05:06:11AM +1000, Duncan Roe wrote:
> > On Wed, Aug 11, 2021 at 11:02:03AM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Aug 11, 2021 at 04:21:40PM +1000, Duncan Roe wrote:
> > > [...]
> > > > Suggest you leave include/libnetfilter_queue/libnetfilter_queue.h unaltered.
> > > >
> > > > That way, if a user fails to insert linux/netfilter/nfnetlink_queue.h at all, he
> > > > will get the warning. With the patched libnetfilter_queue.h, he will get
> > > > compilation errors where previously he did not.
> > >
> > > OK, done and pushed it out. Thanks.
> >
> > You really didn't need all these extra #include lines. The only source that
> > doesn't compile with "#include <libnetfilter_queue/linux_nfnetlink_queue.h>"
> > removed from libnetfilter_queue.h is libnetfilter_queue.c.
>
> Those are needed, otherwise libnetfilter_queue emits warnings all over
> the place.

Of course, thank you. I'll send a v3 of "Insert SYNOPSIS sections for man pages"

Cheers ... Duncan.
