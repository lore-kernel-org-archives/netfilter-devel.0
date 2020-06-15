Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F39C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DECA20663
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592240244;
	bh=t+Gq9rDmIsS9imeSgEfOfwJ3RU8rVMc5vfiLN8LDl6g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=eCvmxNF9wp2dEjt+7nl+awh74TzN2xwQ1aDpwJCFmSYSv2cnGrNMiJLhl+1NFo1Za
	 RqMUHXId/pI2CqiDGSHNZ1QoVIxiayapI6/s9QIxmJyrGRtBtkw3SuDuj0OnoVE5HJ
	 zH4roDFes0D9vPb3M00RvukUxdBaj4Z10S3rDO4w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgFOQ5X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbgFOQ5U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 12:57:20 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D6C08C5C2
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 09:57:19 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c12so9960582lfc.10
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 09:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIkal8pUfONI4oNrGMEW7FJGnsyPgxFx6nFiYlCav8Q=;
        b=BOdfnS1nQ1loTAy3XfZG4v2ypfE6UrK/J+Zd6u9ARxAU0HozZqAjdnCtxoLxulSvq0
         7PoDNtEz3pdUYnk9jHe+VKu0KTcBji19fekNHUB4EqiWzTIqAhfzI/qVn548WkWINsOo
         G2cfvtd1eBk/jMWvfGGb0/G2cdASiBLrgA7w0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIkal8pUfONI4oNrGMEW7FJGnsyPgxFx6nFiYlCav8Q=;
        b=WACV/nLEk6Aj05rh1VBjMybuv9V7TscCBw3BlEoMfvbuFK8Rn0C58c3fVoigOyXq9s
         HYWxzrJubpdncUh+gzeSQZuhPJEPs3tMEBEQK+1J0DGP0dsDk/FNVprsp82ON4IClzwf
         gEJE1pXA8I8gjnyLSBdlX9I74KmLiAksUXoRUhJGVRwJH9W1pJL2wx7Yps8x6qVk0avb
         LoHsjp185bPpsC2kCYuU0muUiylXagf1keV4dLsmqJtAEg6Gr3O8yo3EHOorFGly2nX1
         nphRpc894G41Gqk2z2Ve+rkn5df1mhecImr1ljwqwieMC3fDfWpiR9cBHtuyg9yN1A59
         bN3Q==
X-Gm-Message-State: AOAM532HJxPWoJOs6YThzgUJh9hvfzmjlIwtQzbTvlnYE/RH1hYmHSEP
        g2yOOQEpO+W6X8u/mPYE22bENAk6Duw=
X-Google-Smtp-Source: ABdhPJxQYq4kIp6fUf09JS31NU8oOMO9C6PiNQ69HGWpLHiSaqMqf+zKewLPTzlbkS6irakL47AK0w==
X-Received: by 2002:a05:6512:104c:: with SMTP id c12mr14210011lfb.200.1592240237353;
        Mon, 15 Jun 2020 09:57:17 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id t19sm4651929lft.47.2020.06.15.09.57.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 09:57:16 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id z9so20046051ljh.13
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 09:57:16 -0700 (PDT)
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr12503482ljn.70.1592240235665;
 Mon, 15 Jun 2020 09:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200615121257.798894-1-hch@lst.de> <20200615121257.798894-11-hch@lst.de>
 <CAHk-=wiBJjjV4NuKr_z2Q3vWEXSoGtAmkH=jZ0SkBJ=wZh4=hw@mail.gmail.com>
In-Reply-To: <CAHk-=wiBJjjV4NuKr_z2Q3vWEXSoGtAmkH=jZ0SkBJ=wZh4=hw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Jun 2020 09:56:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVjH4C+PzyHfsR0+GzFUf_2XX5H_tQoHGqp+pMGuec7Q@mail.gmail.com>
Message-ID: <CAHk-=wiVjH4C+PzyHfsR0+GzFUf_2XX5H_tQoHGqp+pMGuec7Q@mail.gmail.com>
Subject: Re: [PATCH 10/13] integrity/ima: switch to using __kernel_read
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 15, 2020 at 9:46 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It worries me that you're making these kinds of transformations where
> the comments imply it's a no-op, but the actual code doesn't agree.

Note that it's not that I think the FMODE_READ check is necessarily
_needed_. It's more the discrepancy between the commit message and the
code change that I don't like.

The commit message implies that __kernel_read() has _more_ checks than
the checks done by integrity_kernel_read(). But it looks like they
aren't so much "more" as they are just "different".

                Linus
