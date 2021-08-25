Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0839C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 07:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B588C6127B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 07:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbhHYHhZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 03:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238651AbhHYHhY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 03:37:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B6C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 00:36:39 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q3so1976264plx.4
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 00:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=qRVH2KlSM9CN6UKI5HoI1lxubtutKTlm+15ry3fFblc=;
        b=UgaGPvZYLkBkT+l4Sono9HcXg9PMkehHCO+cEqpLlryw3EIk0KfuHA7LjeZH+eCarf
         N6qhr2QNqAUGUVbog+zCThLmUeG2lWBAyRPYHOZ5EH2vniNlD3n75u1y/V0JEc1VoDW8
         Vx6yhZ3Rvo5WJ2e0/aNjjdJUTUqok0kBWgSnD43ca047Qf2tzpTxi2jhdMagPG86tnM4
         2yjVA8a9j9UadlFzoEwI39vc32E8+HNXxhVSWWg7P/zVMQ4/VIXXVWV04urIrQ2pf50E
         wpEcjmmRI9Oavq7vRNiMwmYy97Ud2vIJiQ0oJ2etH9ZrAZO3MJfpTADYdcw48EseTQtS
         dnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=qRVH2KlSM9CN6UKI5HoI1lxubtutKTlm+15ry3fFblc=;
        b=D1UG2y0LG2ewJxcjOc4FCTtHsQSSWA4VDybHKy6dRc4N7roKCuMg9y65EzLIqkv6CV
         ObSeDdM6vCBM7FNzW3PnNjcw3g8qrZz5VmAKxiFRDghpfvAZa8yEfbb1aOe6R0ns7hEP
         togUwh4bQGZImeTDR+acWeSGcZxUC6/405JHsp/oAVhOL1lAMySboHwjhnpSDosd4eQ9
         e4PISCEuK1+C+AbPfX5/uC6EiYxxh7HjTEnJwU0Z4z1h6upT2OGn23+LKnal9JhUvOU2
         lc6kgfvH+56qz+HMl1Avqnms534g/IACp6D/C2AcWEBx/nNoqECfphK1tLml3b/1T3+Q
         wWLg==
X-Gm-Message-State: AOAM531oEBL66XpmVZ5S6v8WL+y/BcY11HnGshvijl91XQZ9Gi3hfupS
        pr3ez+Eu6svF8GoqaijKs1/ZdLsOjc4WOg==
X-Google-Smtp-Source: ABdhPJzvUClPjkL+boHvqYJXyWJHe4dKiQ4O7/nfGXlw29BqIzpm+P8tjUcE6mrsHQS+rSwHK4r6fQ==
X-Received: by 2002:a17:90b:390d:: with SMTP id ob13mr7886754pjb.129.1629876998865;
        Wed, 25 Aug 2021 00:36:38 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y13sm22137434pfq.147.2021.08.25.00.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 00:36:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 25 Aug 2021 17:36:33 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 4/4] build: doc: split off shell
 script from within doxygen/Makefile.am
Message-ID: <YSXzAeWYuNx4MPhg@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-4-duncan_roe@optusnet.com.au>
 <20210824103052.GC30322@salvia>
 <YSXDyR2RIKf675l6@slk1.local.net>
 <20210825060838.GA818@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825060838.GA818@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 25, 2021 at 08:08:38AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 25, 2021 at 02:15:05PM +1000, Duncan Roe wrote:
> > On Tue, Aug 24, 2021 at 12:30:52PM +0200, Pablo Neira Ayuso wrote:
[...]
> >
> > Time to wrap up the whole lot in a single patch.
> >
> > v5 was going to remove the make distcheck cruft in doxygen/Makefile.am,
> > which is adjacent to the now-removed embedded script.
> > So now there is juat 1 big block of red.
> >
> > I reverted some non-essential changes in configure.ac to reduce the diff.
> >
> > The new patch will be titled "Fix man pages".
>
> At least two patches would be the best way to go for traceability:
>
> #1 Move code to script.
> #2 Your updates
>
> The problem with code updates and moving code is that the diff patch
> format is not very good at catching those together, since it makes it
> look like code deleted plus new code.
>
> Thanks!

So... starting from master, move out the shell script and add EXTRA_DIST for it.
The script does change on being moved - un-double doubled-up $ signs, remove
traling ";/" and so on. That'd be the first patch.

Second patch could be upgrade shell script to latest.

Third patch would be everything else, unless I can manage to extract the bit
that fixes `make distcleancheck` then the rest would be a 4th patch.

Would you accept that?

Cheers ... Duncan.
