Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023DFC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 12:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E382E613CE
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 12:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349591AbhI3Mte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351044AbhI3Mtd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 08:49:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B0C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 05:47:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k26so4887467pfi.5
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 05:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=qubercomm.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fgZ2J6LtoLWfo42oDifUWWvoTpoqTdFA1IL6vNajMjk=;
        b=AuibbfbuKpQKczhPQ4ZRK/4RLrYuWAuI0D78IftjLBK4Jm0uq+/b+2ijsx6kN57sTD
         LPV5+vcR8rYht6m7OBVAQ6lnAeo8kUdiDK6qpyCitblSsszjMo5N+eKziiturjUJPvQJ
         GnbkjyLGP6dD0boPFG1ebyE0d9a4zgiNUIvPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fgZ2J6LtoLWfo42oDifUWWvoTpoqTdFA1IL6vNajMjk=;
        b=FOtWfqPDpFoSmMNzTmOB6OkVgudQfBrq9mY31NqB2sxzj6R3KGB4dnDM3q50b/ebdf
         e8B2VgxCl6l185FPAHKHFUfb8x8gphQ4spC85ejxQWrrk8jPPFwKLVLg4puukr3rmbC1
         3EhJ0cjRefJNsEhudbiWmI+uwPlkO08sqXNIJstLFFiCZOGWp4CnGGeU8Tu+A44/LZyH
         hZ+D8YdtsOXf2efhK/A2g9traGWnGYfcg0pZcQXdqoSaj3LBR2+6kdydyZaVS65oV6wV
         X23u+jpQAIEfyweVSi1weAMJiOqnMdk/3VmmPEYxFQVw/9EnHkGQtmMCLUENFsSl/Qn4
         8wRg==
X-Gm-Message-State: AOAM532taArafPPcGi4c77HQRkWNTWQGnFH+EfJpXm7RNVG9fBdKCsZw
        g4Syo5Ww2jsHZ4XM/aLmKFuXJA==
X-Google-Smtp-Source: ABdhPJxISqYqHsg73kqQCwa0mnheh1OltNL2v9soOV7Oyy7EaEHwewg4a5b8dlPSjhhTlZEn1wkG2A==
X-Received: by 2002:aa7:943a:0:b0:44b:e771:c7d1 with SMTP id y26-20020aa7943a000000b0044be771c7d1mr4659262pfo.42.1633006070843;
        Thu, 30 Sep 2021 05:47:50 -0700 (PDT)
Received: from QBC-Ruckus ([49.207.178.111])
        by smtp.gmail.com with ESMTPSA id s188sm2801631pfb.44.2021.09.30.05.47.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Sep 2021 05:47:50 -0700 (PDT)
Date:   Thu, 30 Sep 2021 18:17:46 +0530
From:   Senthil Kumar Balasubramanian <senthilb@qubercomm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: ebtables behaving weirdly on MIPS platform
Message-ID: <20210930123927.GA82795@QBC-Ruckus>
References: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
 <20210930103840.GP32194@orbyte.nwl.cc>
 <20210930105223.GD2935@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930105223.GD2935@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 30, 2021 at 12:52:23PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Sep 30, 2021 at 11:53:32AM +0530, Senthil Kumar Balasubramanian wrote:
> > > However, dumping the data that goes to the kernel, we see a huge
> > > difference between MIPS and ARM..
> > > 
> > > in ARM platform
> > >  w_l->w:
> > >   0000  6e 66 6c 6f 67 00 ff b6 00 00 00 00 00 00 00 00  nflog...........
> > >   0010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   0020  50 00 00 00 00 00 00 00 01 00 01 00 00 00 00 00  P...............
> > >   0030  45 4e 54 52 59 31 00 00 00 00 00 00 00 00 00 00  ENTRY1..........
> > >   0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   0070  00 00 00 00
> > > 
> > > in tplink a6 (MIPS platform)
> > > 
> > >  w_l->w:
> > >   0000  6e 66 6c 6f 67 00 b2 e0 69 6d 69 74 20 65 78 63    nflog...imit exc
> > >   0010  65 65 64 65 64 00 56 69 72 74 75 61 6c 20 74 69    eeded.Virtual ti
> > >   0020  00 00 00 50 65 78 70 69 00 01 00 01 50 72 6f 66     ...Pexpi....Prof
> > >   0030  45 4e 54 52 59 31 00 69 6d 65 72 20 65 78 70 69    ENTRY1.imer expi
> > >   0040  72 65 64 00 57 69 6e 64 6f 77 20 63 68 61 6e 67     red.Window chang
> > >   0050  65 64 00 49 2f 4f 20 70 6f 73 73 69 62 6c 65 00        ed.I/O possible.
> > >   0060  50 6f 77 65 72 20 66 61 69 6c 75 72 65 00 42 61       Power failure.Ba
> > >   0070  64 20 73 79
> > >               d sy
> > > 
> > > Can you please let me know what's going wrong with this?
> > 
> > Looks like the data structure contains garbage. Looking at ebtables
> > code, that seems likely as extension data structures are allocated using
> > malloc() and never set zero. init() function in ebt_nflog.c only
> > initializes prefix, group and threshold fields (which seem to be set
> > correctly in your MIPS dump).
> 
> Yes, probably pure luck (libc differences and the like).
> 
> Senthil, can you try this patch (compile tested only)?

Yes. this patch work... Good and quick catch..

