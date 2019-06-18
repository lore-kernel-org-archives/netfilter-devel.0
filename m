Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF46CC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A92302084D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tt5asJtl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfFRRhJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:37:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40446 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbfFRRhJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:37:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id e8so15144731otl.7
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yt21cD0aFR1Ntr5rL3RHpB/prnSY0diiTT5wqv70LAU=;
        b=tt5asJtlq1D7uuuUla+r86wdt/8NMfnu0cZUB5dAKAtP4oDq0oxee9PGqA4GAx7XqX
         TIQbtvInxA/QMKU6Bky4r8mxNvQA0Hp07EM5YhWISvpvWuddPN3Y+Ytkbg30IpnGpazo
         4gh9dRyWEQYNLOhLAx1RvMP5sh3gKibENDylHk75yDR7FK4cWEkPdR0FW3kOUnG8WeKW
         tyo4BCJSGd/rSGkR61G/cTaaqhizUD+3O50BKfODYNMvJbtxuT64rFE2Rktm0MYfsWxe
         yidV5H7NQXlOxcbUch6wUCwZ/hNSBLGglaPglCwjkXUKKkI+fLpMAT4AjZG1OHoT3S2C
         41vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yt21cD0aFR1Ntr5rL3RHpB/prnSY0diiTT5wqv70LAU=;
        b=YtObpaK8684SPn2NwTGi5Kfgjma98chOGbEzGVGcBCmu28TaYxAuVvjUQahSOZN9TO
         gkrbudAk0mB6QaGAYGClkFUdJYq3ZYaPGosrSZP4zRK3eKWYa4vtKKG4r9Fk2iWxTBO9
         IQJjMPdzTSkiCHZcPWenv+5kZe7rp1wTJ4bEgIxCn08aTlNOFaKXLUlw8PLW6uchpo1/
         FF96/ex42WVJPGLgzXRFcmEBiPwKjbOFlKkOcL3vl25EtGCkQYHS2YrDiJSQKv7F2YLV
         JHeYx4ItNwoIddPTGXP86AcRd5mK4cbBWkiTJ21n3l7ZsqoCciWLql1Z5sSkkU1I4Lhd
         cMaQ==
X-Gm-Message-State: APjAAAVkIrX1ZVtynfXXh22wR6koPzgqPj5nYDplWoh6St+0QmsNcI9K
        431yBo4Ni7OeiSzVEaK4Aq/Aw6swVyFmZAUIp9d2f45C
X-Google-Smtp-Source: APXvYqyVzQsQr1dCKJlMdypk4JsoEK3nRQkV4sgnnDLYiq5IuF/xHrmsM/Lqec9fWO5xq+7AHB95u+me3pJ2upepri0=
X-Received: by 2002:a9d:4f0f:: with SMTP id d15mr6813348otl.52.1560879427657;
 Tue, 18 Jun 2019 10:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190614143144.10482-1-shekhar250198@gmail.com>
 <20190618143106.tgpedjytw74octms@egarver.localdomain> <20190618161607.3oewnnznnzm7tln4@salvia>
 <CAN9XX2rHwLNQT3Doa121u_gTPwCrT0icszdFgJH8ZcWdYfSbVg@mail.gmail.com> <20190618173436.xmrq7ue7746jfatu@salvia>
In-Reply-To: <20190618173436.xmrq7ue7746jfatu@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 18 Jun 2019 23:06:56 +0530
Message-ID: <CAN9XX2pWQY0Rz2cGv7V=v8+g0mUTNGWS4pf0FJwScmrNpC5Kjg@mail.gmail.com>
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to python3
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <eric@garver.life>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 11:04 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Jun 18, 2019 at 10:59:53PM +0530, shekhar sharma wrote:
> > Hi Pablo!
> >
> > On Tue, Jun 18, 2019 at 9:46 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Tue, Jun 18, 2019 at 10:31:06AM -0400, Eric Garver wrote:
> > > > On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> > > > > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> > > > >
> > > > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > > > ---
> > > > > The version hystory of this patch is:
> > > > > v1:conversion to py3 by changing the print statements.
> > > > > v2:add the '__future__' package for compatibility with py2 and py3.
> > > > > v3:solves the 'version' problem in argparse by adding a new argument.
> > > > > v4:uses .format() method to make print statements clearer.
> > > > > v5:updated the shebang and corrected the sequence of import statements.
> > > > > v6:resent the same with small changes
> > > > > v7:resent with small changes
> > >
> > > I apply this patch, then, from the nftables/tests/py/ folder I run:
> > >
> > > # python3 nft-test.py
> > >
> > > I get:
> > >
> > > INFO: Log will be available at /tmp/nftables-test.log
> > > Traceback (most recent call last):
> > >   File "nft-test.py", line 1454, in <module>
> > >     main()
> > >   File "nft-test.py", line 1422, in main
> > >     result = run_test_file(filename, force_all_family_option, specific_file)
> > >   File "nft-test.py", line 1290, in run_test_file
> > >     filename_path)
> > >   File "nft-test.py", line 774, in rule_add
> > >     payload_log = os.tmpfile()
> > > AttributeError: module 'os' has no attribute 'tmpfile'
> >
> > I do not know why this error is occurring but may i suggest
> > you to try the v8 of the netns patch, (as it is a continuation of this patch),
> > if that works, we will know that there is some problem in this patch
> > specifically.
>
> Still the same problem with v8:
>
>     Date:   Mon Jun 17 19:45:58 2019 +0530
>
>     tests: py: add netns feature
>
>     This patch adds the netns feature to the 'nft-test.py' file.

Ok. I am trying to find out why this is happening.

Shekhar
