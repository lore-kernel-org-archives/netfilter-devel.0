Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686C8C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 07:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C68061434
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 07:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhEMHJp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 03:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhEMHJm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 03:09:42 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04835C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 00:08:32 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id o59so146474qva.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 00:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tyi0hLLwsaVhIG2kqmVitJUhgVmvI4jXmKcfvvz6ltQ=;
        b=DMKgdD30W8LrgmvfpHDsR7IBySr1EWTLYntNbEtJmrf3V1efZECo7cxiPIsjccFdFK
         Pwge9iZFRLHQQTTrolhcizYFv5v6E5A2cIHs6Xjv63q1WSBZPoEvJiWcI0EfgOwmrAgH
         /jU2TynityAh+A1/ps1fqD0sqcGnENKG+6TnsnNP3wkLjU5swNJ3saqudGTw5H5AlnEM
         At0TDCqmp+uvsGDLnZFX7gra2pb4lFj+cBwp+mbqAkHbtC1YgBzlakRPeMRTPqGlm73w
         ijPFLcntMhcQTTEHTAOq3y+H9LeoL0fG9Euzcb2yYV/9wKiB4K18Y6dA+MFwAcrYYd1o
         lWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyi0hLLwsaVhIG2kqmVitJUhgVmvI4jXmKcfvvz6ltQ=;
        b=tgLPj1Zg187clOSNuMo+V5kqSJX5mRkbvOewMdqwKdGBxrlnjAFWNiZZW5MCed6twM
         /C45qxX/KqEPWN/fyKn3YNywAm0J2eMhUGw56eUHh/3nFmRYCVko4lNePP0SRXK1/I1R
         MxZrbAya+Fn2pXpr9qiPFAyf9EPoZ1gx2G/L3NfoNe9QDt3zh5rDlzejALbNfUoKh03Z
         qH/a6sN5nb2luVy9gAPqKMSOxpmcHY8doRv2p1dlvLW2bFgXDyOmxFn68R6J5aKVxrY9
         Ecsqmo70nV0NCgmikPUaUepgVZVJZNJfrQgilOte9fFZ96Nu7CVl4GkJNzo9hVYdFhb3
         AyHQ==
X-Gm-Message-State: AOAM532+hUtuIm0JVsSACrOeUpPkEeKVzfqYndtUDdXCZzPAoHgx2Uwz
        RB9N3jAEnmwZYNcXs9oVaKDmrv5PxhFglf+FYDAQhw==
X-Google-Smtp-Source: ABdhPJwB5oBJDYa+2C6xAdzfdJaOrzDsf8e7Xe2qHkkkwaeHaLAwZZdqU8kHm4BmIXqsMqWWpj/nXVM8IVAKDdmrTiM=
X-Received: by 2002:a0c:d786:: with SMTP id z6mr39155641qvi.18.1620889711884;
 Thu, 13 May 2021 00:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ce91e05bf9f62bc@google.com> <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
 <20210508144657.GC4038@breakpoint.cc> <20210513005608.GA23780@salvia>
In-Reply-To: <20210513005608.GA23780@salvia>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 13 May 2021 09:08:20 +0200
Message-ID: <CACT4Y+YhQQtHBErLYRDqHyw16Bxu9FCMQymviMBR-ywiKf3VQw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 13, 2021 at 2:56 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Sat, May 08, 2021 at 04:46:57PM +0200, Florian Westphal wrote:
> > Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
> > >
> > > Is this also fixed by "netfilter: arptables: use pernet ops struct
> > > during unregister"?
> > > The warning is the same, but the stack is different...
> >
> > No, this is a different bug.
> >
> > In both cases the caller attempts to unregister a hook that the core
> > can't find, but in this case the caller is nftables, not arptables.
>
> I see no reproducer for this bug. Maybe I broke the dormant flag handling?
>
> Or maybe syzbot got here after the arptables bug has been hitted?

syzbot always stops after the first bug to give you perfect "Not
tainted" oopses.
