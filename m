Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3449C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 09:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA776023F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 09:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhHaJBH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 05:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbhHaJBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 05:01:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0225CC061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 02:00:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1482101pjr.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 02:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=6ok6hb5C8V11mgA9jjQH7lWRXhkgiVkxNwjZpZJBCr8=;
        b=P9xfXeNXhSaHaZRlEYQgWFMLFtA75IE/W6QAbbwTo7qSwsUicSfkE1EJbLyh8Tipcp
         lE+2zx3xTQ/gZwNQAS/HNL2Xs4dQdMEKsSfKxoAETr0EC+pY+b+gwyo2y7PAOLE2yIBA
         cxgoJLaEulzO16XEMtrQARn4YBpWs3FlaVp/LkYVj5YiG+FcfJig/G4XpAb9Lh9LQg72
         DEV1tF3xj4BwAEsYjjpB4pMSPZER7SRfL3kyQ29g7Ccp/v2Ac8rnlJdLERLKzWqOKRwL
         ichiv+cZ8fVh6kmga2BLLKtLpW0Ke75SC5kZrd2r4EeTyjnwZ5NbhGJmyYz7QpTCsw66
         lHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6ok6hb5C8V11mgA9jjQH7lWRXhkgiVkxNwjZpZJBCr8=;
        b=cFZdR6OSp0KMMiKNnVwPcpy57FU+DojgHGZfGkkdWNICycRlvQeDA7QZCjW7/5jvvj
         yGDCLoFUfwNK+pWzhwKBHWo6G4FnWfLrPANB+XXrWJ0hA7C5aC2VDsKkqNiq8cFnDfkb
         4Ihg5FzsimuwBezGFTlbJlTHJANpYYuBkp3EHNVSMkKJMXPxeyCqsWEduN1rLy/lymEB
         FEXEgtJEU/I7+RqBpCHXpp/gPxnyd1HnFog5lVl6kEJtLLPnf26Gp4CDp0ZCEm/PnJa6
         0z9BnZenWjc29oRP+xewN0/BXZcfatkzBfJ0Rxzg5tWgxUIUlJUPtKVIllgvpxRxeVil
         HwQA==
X-Gm-Message-State: AOAM533GvYICsZCKidhNeMk1jH2xSW9+2iOTHc2U3gEZQIgn2O7JZzcW
        4555oqRJm9gRohrT2nW1Ax1d6M1xrtw=
X-Google-Smtp-Source: ABdhPJzjIIb0EO2yViZ9xG+GDYg3iiRepssyvHx3rCz+/CLwGf1mGmCwna4Ce/oK+nDQZawKLtPJog==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr4205209pjn.1.1630400408097;
        Tue, 31 Aug 2021 02:00:08 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id d17sm16829333pfn.110.2021.08.31.02.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:00:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 31 Aug 2021 19:00:02 +1000
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YS3vksGnGEchZZxq@slk1.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
 <YSw1dN3aO6GeIPWq@slk1.local.net>
 <YSysxcqZ7iSZsPjZ@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VZV92NkT5giBkIZ4"
Content-Disposition: inline
In-Reply-To: <YSysxcqZ7iSZsPjZ@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--VZV92NkT5giBkIZ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 30, 2021 at 11:02:45AM +0100, Jeremy Sowden wrote:
> On 2021-08-30, at 11:33:40 +1000, Duncan Roe wrote:
> > On Mon, Aug 30, 2021 at 02:16:21AM +0200, Pablo Neira Ayuso wrote:
> > > On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> > > > The first four patches contain some miscellaneous improvements,
> > > > then the last two add code to retrieve time-stamps and interface
> > > > names from packets.
> > >
> > > Applied, thanks.
> > >
> > > > Incidentally, I notice that the last release of libnetfilter_log
> > > > was in 2012.  Time for 1.0.2, perhaps?
> > >
> > > I'll prepare for release, thanks for signalling.
> >
> > With man pages?
>
> I was waiting for you and Pablo to finalize the changes to
> libnetfilter_queue with the intention of then looking at porting them to
> libnetfilter_log. :)

The are at least 3 areas which could be worked on in the meantime:
 1. Fix the remaining doxygen warnings (attached)
 2. Insert the SYNOPSIS sections with required #include stmts. I've found that
    to be a bit of a black art e.g. pktb_alloc() doesn't actually need
    libmnl.h but if you leave it out then you need stdint.h which libmnl.h
    drags in. So specify libmnl.h because other functions in the program will
    need it anyway.
 3. The doxygen code will need a bit of "tightening" so man pages look better:
    ensure all functions that return something have a \returns;
    add \sa (see also) where appropriate;
    list possible errno values in an Errors paragraph (or detail the underlying
    system calls that might set errno);
    maybe clarify wording where appropriate.
>
> The most recent Debian release included a -doc package with the HTML
> doc's in it, and the next one will include the test programmes as
> examples, but I think the man-pages need a bit of work first.

Yes the 3 items above should be most of it.
I'm happy to work on them or would you rather?
>
> J.

Cheers ... Duncan.

--VZV92NkT5giBkIZ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blurb1.la"

Fix the following doxygen warnings:
src/libnetfilter_log.c:888: warning: missing title after \defgroup Printing
src/libnetfilter_log.c:216: warning: argument 'log' of command @param is not found in the argument list of nflog_fd(struct nflog_handle *h)
src/libnetfilter_log.c:216: warning: The following parameters of nflog_fd(struct nflog_handle *h) are not documented:
  parameter 'h'
src/libnetfilter_log.c:443: warning: argument 'qh' of command @param is not found in the argument list of nflog_set_mode(struct nflog_g_handle *gh, uint8_t mode, uint32_t range)
src/libnetfilter_log.c:443: warning: The following parameters of nflog_set_mode(struct nflog_g_handle *gh, uint8_t mode, uint32_t range) are not documented:
  parameter 'gh'
src/libnetfilter_log.c:824: warning: The following parameters of nflog_get_gid(struct nflog_data *nfad, uint32_t *gid) are not documented:
  parameter 'gid'
src/libnetfilter_log.c:839: warning: The following parameters of nflog_get_seq(struct nflog_data *nfad, uint32_t *seq) are not documented:
  parameter 'seq'
src/libnetfilter_log.c:856: warning: The following parameters of nflog_get_seq_global(struct nflog_data *nfad, uint32_t *seq) are not documented:
  parameter 'seq'
src/libnetfilter_log.c:809: warning: The following parameters of nflog_get_uid(struct nflog_data *nfad, uint32_t *uid) are not documented:
  parameter 'uid'

--VZV92NkT5giBkIZ4--
