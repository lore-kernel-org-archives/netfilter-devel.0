Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C911C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0154061376
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhGENQU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENQT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 09:16:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF44BC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 06:13:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 62so10170886pgf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 06:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=xT0xiZ1C0zoRWHj07/Avxy1iAQwJu60CJ2usqSgzx/I=;
        b=qRErriT0tzK/xc0Li54hl8zDuXRMXe4ouTwajylnDjhQNeH1xD3NNmxmAShajEqwrM
         XQJxJo6bE4DjFehNyswkuv+nMDiu5q6R5jqv9g+uEA503//MI2OwB2iiuobN26lIpDJl
         c/lHH8YyfCjyjyarImsI9r+f12rV3WbZ7v5u3ot9fbn4rzVVmtKoTehiYW72+Lu7xYoa
         4tzLXSwHFyEarIiBY3czq7JnjrnDzQnfvXj79exhGqW3bZMIeJuorEwMSquSKGJ+u5Za
         KSQOa90zMIZ8lMsVTyWwmOE1NcfY4Xxh8eWr2MOm3zvqaw5Bn7NIDvmiQbHbI1e8udQx
         /BpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=xT0xiZ1C0zoRWHj07/Avxy1iAQwJu60CJ2usqSgzx/I=;
        b=crchZVgeFGxtjoZy9aKL3SSb/I4wvNxHpwnMNRk4UezCt+dlMLWAzJtfJnL0Eeyx5X
         DRtfvLvfeBPG0S1LNLQjavUUjKQCob2gRFDn3wWddR25hw0CdQFqk4Jv3YDFiRfBEjoB
         67Z94YpqfyzICeupmpEymWFIXGDdhu9XL0BJLqOvHJbOA3Kroh6J5RQ/eq/U4PTfxyLk
         3elD3XyhkM+IjVnmZu3Arqm5rxnzqObW/64jsNJ0UmcSY+Vf6DGph/5zWo0J3qLc3uXg
         rYyI/6WW8DdPJiapHBIvm98r2eRg10b976V34CW21fW0IfBwUHXD6MjTyfbbRprFkW+4
         /04w==
X-Gm-Message-State: AOAM532Kmt5fZQ9ZNWPc7JfMPXWK4uqos43axcFIuUa3IJBFHShO6EvS
        opaPsWKFuYq7cLj6jstkV/Y=
X-Google-Smtp-Source: ABdhPJy7P4nD06u9A646f18oCbEWU18lRnnn2XOdDxgIv6xEF4yTc0JBIQmJ7OOO5ctIDwRIxQUsoQ==
X-Received: by 2002:a63:5d65:: with SMTP id o37mr15768086pgm.79.1625490821521;
        Mon, 05 Jul 2021 06:13:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id bk1sm14340973pjb.51.2021.07.05.06.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:13:40 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 5 Jul 2021 23:13:36 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <YOMFgP6KBQIBoiWo@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <YOJINLIUz9fFAxa2@slk1.local.net>
 <20210705085610.GB16975@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705085610.GB16975@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 05, 2021 at 10:56:10AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 05, 2021 at 09:45:56AM +1000, Duncan Roe wrote:
> > Hi Pablo,
> >
> > Did you follow the email thread
> > https://www.spinics.net/lists/netfilter/msg60278.html?
> >
> > In summary, OP asked:
> > > Good morning! I am using the nf-queue.c example from
> > > libnetfilter_queue repo. In the queue_cb() function, I am trying to
> > > get the conntrack info but this condition is always false.
> > >
> > > if(attr[NFQA_CT])
> > >
> > > I can see the flow in conntrack -L output. Anyone know what I am
> > > missing? Appreciate your help!
> >
> > and Florian replied:
> > > IIRC you need to set NFQA_CFG_F_CONNTRACK in NFQA_CFG_FLAGS when setting
> > > up the queue.  The example only sets F_GSO, so no conntrack info is
> > > added.
> >
> > My question is, where should all this have been documented?
> >
> > `man nfq_set_queue_flags` documents NFQA_CFG_F_CONNTRACK, but
> > nfq_set_queue_flags() is deprecated and OP was not using it.
> >
> > The modern approach is to code
> > > mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(NFQA_CFG_F_GSO));
> >
> > NFQA_CFG_MASK is supplied by a libnetfilter_queue header, while
> > mnl_attr_put_u32() is a libmnl function. What to do?
>
> NFQA_CFG_MASK is supplied by linux/netfilter/nfnetlink_queue.h
>
> The UAPI header is the main reference, it provides the kernel
> definitions for the netlink attributes.
>
> libnetfilter_queue provides a "cache copy" of this header too, that
> is: libnetfilter_queue/linux_nfnetlink_queue.h

Are you saying that the UAPI headers are adequate as documentation of how to use
the system?

If not, where should extra documentation go?

In any case, do we tell the users to use header files in linux/ or
libnetfilter_queue/ (i.e. in the yet-to-be-written SYNOPSIS in man pages)?

Cheers ... Duncan.
