Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18570C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 09:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhKXJVF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 04:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhKXJVE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 04:21:04 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C842C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 01:17:55 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gt5so2017614pjb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 01:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maxtel-cz.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9OeqPDxfCkgzNpmKuV+9nDZ1U5l+EGLhslSlNR9viTo=;
        b=imD+8v7DtX190OEgyxWMdkpMqhGZkAAlFwfjSqtreMUvf70MryHLj2IIRkHJfrcDmM
         X5G8IpQnv9aVWFFQPzBWsz5bKF+eIKWMF8xuPQvBeGmtMMrKrSO5MURqNOoPHfmGQicY
         +L1f+rbipoNHlpILXnUGkyGp8qImBXwRNrQ0b1ne5NiuOBQ2dt8BRVwYHrMPZG3nrPm6
         P8hxxHJmu5Z7kqWcRQ5jcOs5qUASqPq6/hCZ6i4bQJZ7LeAdOu6bfNcbOGeGVPX3z/Vh
         Z3LIxc7DCFhnVavECcrucYNOKU7iv1E+dGR/XTi8lPPccOsYu+684/KBGQH9nKZbqVD8
         FZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9OeqPDxfCkgzNpmKuV+9nDZ1U5l+EGLhslSlNR9viTo=;
        b=19lD3C5GzQ3Y+KU8+L/q++klhx9OjzH2zTcuB+YddcJV2jw+vzhACOXrD2lvQ+kSRV
         iibPKIkyBI0VbTc5/WiXBRQ0Uws3kszVg4uGzODP4+zaSstT6JYr02s5q0BMOegyT8h/
         FbSUI47mYYSSqpF+REFFhzgahBpJgXM+LN9TwgJSGPBU+jut3sn3YmwM0j9CKLAGhLbL
         cBJf3ku3qkd9JKFKjjLwR8bAG1MIYJz7CX57mfVG/yrsDleqHLvIro6KNabGzymml/or
         jNBU2/7/s5iJkmJQiyPwAIyhBYQf2XF7nsFI/bC5RNhDaQTxty3nILu8D7meBMd7XSIq
         zXzA==
X-Gm-Message-State: AOAM531MF+A+WTjf4DVNX9S1+AFJVl9K66G1JtkBh+dPDIv9Fwnk1HyI
        o6pclr0uMdSx9I4esom7ukCo0EPZplQcXk8iRKKRnQ==
X-Google-Smtp-Source: ABdhPJy+/ADwizxbc3KF2B97qaOVGZz6pbXQ9Ka0yEYyuT5Akm4znIXp897J2cN5VVHv/CFZjItGWYNKGNDJGwkcdOI=
X-Received: by 2002:a17:90b:3848:: with SMTP id nl8mr13029262pjb.221.1637745474855;
 Wed, 24 Nov 2021 01:17:54 -0800 (PST)
MIME-Version: 1.0
References: <20211121170514.2595-1-fw@strlen.de> <YZzrgVYskeXzLuM5@salvia> <CAHsH6GvEWVTOxNGU1b3U5gcaZ=0oXSrANroaD_ZnrCOBr+37nQ@mail.gmail.com>
In-Reply-To: <CAHsH6GvEWVTOxNGU1b3U5gcaZ=0oXSrANroaD_ZnrCOBr+37nQ@mail.gmail.com>
From:   Karel Rericha <karel@maxtel.cz>
Date:   Wed, 24 Nov 2021 10:17:43 +0100
Message-ID: <CAN==1Rq26zfjpOAATj7qnSEoo7OF=cpMnpTYkqLzAw9UC+y7nA@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If I may add myself to discussion:

Florian's tunable solution is good enough for both worlds: setting
high gc interval will make idle VMs not waking up unnecessarily often
and low gc interval will prevent dropping conntrack events for systems
with busy very large conntrack tables which acquire conntrack events
through netlink.

I'm not sure about the default value though. Two minutes means
dropping events for some systems, i.e. breaking functionality compared
to previous gc solution. For VMs a few more waking ups don't break
anything I would guess (except for a little higher load). So a good
default would be returning back to hundreds of milliseconds or at
least to seconds. Two minutes are causing dropping conntrack events
even for 100MB netlink socket buffer here (several thousands events
per second, conntrack max 1M, hash table size 1M).

Karel

=C3=BAt 23. 11. 2021 v 15:01 odes=C3=ADlatel Eyal Birger <eyal.birger@gmail=
.com> napsal:
>
> Hi Pablo,
>
> On Tue, Nov 23, 2021 at 3:24 PM Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> >
> > Hi,
> >
> > On Sun, Nov 21, 2021 at 06:05:14PM +0100, Florian Westphal wrote:
> > > as of commit 4608fdfc07e1
> > > ("netfilter: conntrack: collect all entries in one cycle")
> > > conntrack gc was changed to run periodically every 2 minutes.
> > >
> > > On systems where conntrack hash table is set to large value,
> > > almost all evictions happen from gc worker rather than the packet
> > > path due to hash table distribution.
> > >
> > > This causes netlink event overflows when the events are collected.
> >
> > If the issue is netlink, it should be possible to batch netlink
> > events.
> >
> > > This change exposes two sysctls:
> > >
> > > 1. gc interval (milliseconds, default: 2 minutes)
> > > 2. buckets per cycle (default: UINT_MAX / all)
> > >
> > > This allows to increase the scan intervals but also to reduce bustine=
ss
> > > by switching to partial scans of the table for each cycle.
> >
> > Is there a way to apply autotuning? I know, this question might be
> > hard, but when does the user has update this new toggle? And do we
> > know what value should be placed here?
> >
> > @Eyal: What gc interval you selected for your setup to address this
> > issue? You mentioned a lot of UDP short-lived flows, correct?
>
> Yes, we have a lot of short lived UDP flows related to a DNS server servi=
ce.
>
> We collect flow termination events using ulogd and forward them as JSON
> messages over UDP to fluentd. Since these flows are reaped every 2 minute=
s,
> we see spikes in UDP rx drops due to fluentd not keeping up with the burs=
ts.
>
> We planned to configure this to run every 10s or so, which should be
> sufficient for our workloads, and monitor these spikes in order to tune
> further as needed.
>
> Eyal.
