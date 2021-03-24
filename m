Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C86FC433C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 14:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0E5619FB
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 14:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhCXO2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhCXO2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 10:28:23 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B83C061763
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2021 07:28:22 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id m12so32273497lfq.10
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2021 07:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i9a8xMlvpMMKBA/32qlJ70vyIUZJkR/tLnbrp6TJ5Kg=;
        b=Y2n1cNLyIQaDUuQ12r76Llhckks+mIZ66vY6zUmhF9QXCVhWNPqix8NwNKuHRa57hi
         UsT69AZ6tgOYRHAA7/DmLgkGCrJ4gqADThLxfpiKH3H+DCIpdjVDFnLIAWlr9d1qBPbd
         +2ipifthbD77iuDBzYzSYSWdhiRLHZU8aQpTjp5nLm8mQB1u/RCTCiv/1QrnQG5WF4OJ
         Yjy1e+fkSVeUQ4O7/kbzgRFlmo4OEA8n3bPjHt/MI+6Zk/3jDlJMl5SQPPirfgz9Af2X
         zzJNcOmsiJeciTebHyvlkz2rIv+4TmsR6Xw7YXrLQtEo5V/pAJ7P6zsnSwJB2nD78V7r
         hKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i9a8xMlvpMMKBA/32qlJ70vyIUZJkR/tLnbrp6TJ5Kg=;
        b=rJEZlQDfufGaurC8lyIFaIzmprDZTuYpDNkl1C+iok+tuhKsxwm0ez+rLA7IZxONbq
         ZQoI1eu+JkRzRqiF5joHI2icPtPHbBkxT2CRSNNBdWXww/eZF+0LVfrAu1kWturtNeN8
         yGKaPzshAUB+/0HjDgU0rwRLJIaHpCGwxFaJA69huySmWL11b+x0i/iItCgo7mqrGy/q
         +QbKSl/bCeXQZIPFMMJKSTY+VY/Xh61i2wx2ofwCzG4iuYdC4P28frUH6EBabLH2MAjk
         MO2bPARHLVORdGuvfLGi8sd3L5OKyTeg3+Q2eCNdje2+RfVr5bM+8Rx+3OUE7n33YY9h
         FYog==
X-Gm-Message-State: AOAM5322pdwlomfgYL4pZrtcUcyLOdZ7geqFobUENLSXSUPxcMkTbwar
        iejdQ5YRj6J6LFIfr6MTc5dIbnnoWtiszVvbKWks6g==
X-Google-Smtp-Source: ABdhPJxMM0M4Paoju71mflpKQf5/YYnUk75zlKaBNv3PAfL1E9l3IxEPnDh44LjCDKTgdBCI3fGoS7NvMI5btzAoxYc=
X-Received: by 2002:ac2:442b:: with SMTP id w11mr2098851lfl.579.1616596100919;
 Wed, 24 Mar 2021 07:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com>
 <20210315171209.GA24883@salvia> <CALHVEJb6dH_RdxvbtLaptN=8-g4QUUtd=+R-p2PrfNBep0XkWA@mail.gmail.com>
 <20210324112426.GA30128@salvia>
In-Reply-To: <20210324112426.GA30128@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Date:   Wed, 24 Mar 2021 15:28:10 +0100
Message-ID: <CALHVEJbV7O2vZ39UHDHYn+mfQ+qpvSk1G0FZm3OMyQFJik8TOw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] conntrack: per-command entries counters
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, 24 Mar 2021 at 12:24, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Mikhail,
>
> On Wed, Mar 17, 2021 at 07:20:55PM +0100, Mikhail Sennikovsky wrote:
> > Hi Pablo,
> >
> > On Mon, 15 Mar 2021 at 18:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > Hi Mikhail,
> > >
> > > On Fri, Jan 29, 2021 at 10:24:47PM +0100, Mikhail Sennikovsky wrote:
> > > > As a multicommand support preparation entry counters need
> > > > to be made per-command as well, e.g. for the case -D and -I
> > > > can be executed in a single batch, and we want to have separate
> > > > counters for them.
> > >
> > > How do you plan to use the counters? -F provides no stats though.
> > Those counters are used to print the number of affected entries for
> > each command "type" executed.
> > I.e. prior to the "--load-file" support it was only possible to have a
> > single command for each conntrack tool invocation,
> > so a global counter used to print the stats message like
> > "conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created."
> > was sufficient.
> >
> > With the --load-file/-R command support it is possible to have
> > multiple command types
> > in a single conntrack tool invocation, e.g. both -I and -D commands as
> > in example below.
> >
> > echo "-D -w 123
> > -I -w 123 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state
> > LISTEN -u SEEN_REPLY -t 50 " | conntrack -R -
> >
> > The per-command counters functionality added here makes it possible to print
> > those stats info for each command "type" separately.
> > So as a result of the above command something the following would be printed:
> >
> > conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created.
> > conntrack v1.4.6 (conntrack-tools): 3 flow entries have been deleted.
> >
> > Following your request to make the changes more granular, I moved this
> > functionality to this separate "preparation" commit.
> >
> > > It should be possible to do some pretty print for stats.
>
> I think it should be possible to do some pretty print, something like:
>
>         conntrack v1.4.6 (conntrack-tools)
>         Line 1-3: 3 flow entries have been created.
>         Line 4: 1 flow entries have been deleted.
>         ...
>
> One possibility is that we skip the pretty print by now, ie. you
> rebase your patch on top of conntrack-tools, get it merged upstream.
> Then incrementally we look at adding the pretty print for stats.
Agreed.

>
> > > There is also the -I and -D cases, which might fail. In that case,
> > > this should probably stop processing on failure?
> >
> > Are you talking about error handling processing ct_cmd entries?
> > The way it is done currently is that each failure would result in
> > exit_error to happen.
> > This logic actually stays unchanged.
>
> So the batch processing stops on the first error, right?
Yes. As I mentioned, this is the easiest thing to do currently, as it
does not require any code changes.
LAter on we could add an option/switch to proceed on failure if
everyone finds it useful.

>
> > > I sent another round of patches based on your that gets things closer
> > > to the batch support.
> >
> > Thanks, I'll have a look into them.
>
> I have pushed them out, any mistake please let me know I'll fix it.
Great!

>
> Thanks.
Thanks as well)
Mikhail
