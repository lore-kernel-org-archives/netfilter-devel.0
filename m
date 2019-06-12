Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E24C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 07:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DAA72080A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 07:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oeUu2eff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbfFLHzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 03:55:05 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33266 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfFLHzE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 03:55:04 -0400
Received: by mail-oi1-f196.google.com with SMTP id q186so11013437oia.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 00:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XJ6oMEekNQty6RTP73MtGN2MSTySfGhKawvkeC0Y23A=;
        b=oeUu2eff94mHdtATKVUVdPKjLaq4yUocKCsxALKssRGymf2x2J41p/k98UZ1lATyvy
         4rK7UsvB3hYDVMPU5ecOkcoF5cFgNamOrST1x5wTdb6VTfSsgIfRjMdU5mCHAGxdcth9
         lf8RPTQJa18xpJRTrMpLMTbudMehya/3ZE/125LkW1YL3lh0NVtleavw9ZO0zleTk+XV
         J9VbyzwK/2LSAfzy+7Mxiuolruls+lY3Yy9ZwKBUZCL/ebLMaCyXR4uwql0GMsiml3DE
         29dGwK3wbATQ+7kGjyawj00jY+mvK+V6kEs8DmfUw+UBt8iNqMIceBuMJLOcT8AWC+N7
         KjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XJ6oMEekNQty6RTP73MtGN2MSTySfGhKawvkeC0Y23A=;
        b=tMdVyHO19hkO0nHrK+48ZvAKWZYEaWllZfFjFatqPq482EUkWHflIiDoZ1kI64o8Ws
         p5xpklmVzsy05neN7pDtjtLKO1RovS96z+mxn4fef2fS+lPekuz5hMdhv++mYmsB3Pkf
         uRRqSREoCwBS1km/xAns4c5oiYCmXBDWzmh9ALibkTu6AIj+ObgsW1os2k95swWLa//U
         KpStT3wZwGPQ7oSj+A+TWIuPuc5LF+Sw4LdZlmyn2K5X1Mn09v1fiw0bplxbAwHsr0yJ
         iJgl3UYYpQMmf6A6D/5RU6XtJaDTgYi1JvYSmbpF2sv7uCwSOtqCmHSUJ5/lhEGk9LnC
         WaaQ==
X-Gm-Message-State: APjAAAX9hMf4/bbg9GxmJx13U1lrF9cVDtdYVTBlDGcVBtx6mhFMw8NY
        VYvi7Txum6J5uGS4aav00/3JyAoW+vHWvfuVtuegng==
X-Google-Smtp-Source: APXvYqwqAnUe0v8KbzJIR4KFgSiJZ/lwr4yzyznp6SWegqq5nLViv5pUiMbob60Bcm99nKppbTmKyHd+3LxnPaT1eB8=
X-Received: by 2002:aca:4f4a:: with SMTP id d71mr19005503oib.20.1560326103973;
 Wed, 12 Jun 2019 00:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190609181738.10074-1-shekhar250198@gmail.com> <20190611153935.kwyfchvpngrdfng4@egarver.localdomain>
In-Reply-To: <20190611153935.kwyfchvpngrdfng4@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Wed, 12 Jun 2019 13:24:52 +0530
Message-ID: <CAN9XX2oK1SHDqspu6u_Fp86DB5DQ-UcXrG07gU7gXKy2zdvqzw@mail.gmail.com>
Subject: Re: [PATCH nft v6 1/2]tests: py: conversion to python3
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 11, 2019 at 9:09 PM Eric Garver <eric@garver.life> wrote:
>
> On Sun, Jun 09, 2019 at 11:47:38PM +0530, Shekhar Sharma wrote:
> > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
>
> A couple nits below, but otherwise
>
> Acked-by: Eric Garver <eric@garver.life>
>
> > The version hystory of this patch is:
> > v1:conversion to py3 by changing the print statements.
> > v2:add the '__future__' package for compatibility with py2 and py3.
> > v3:solves the 'version' problem in argparse by adding a new argument.
> > v4:uses .format() method to make print statements clearer.
> > v5:updated the shebang and corrected the sequence of import statements.
> > v6:resent the same with small changes
> >
> >  tests/py/nft-test.py | 42 ++++++++++++++++++++++--------------------
> >  1 file changed, 22 insertions(+), 20 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 09d00dba..4e18ae54 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1,4 +1,4 @@
> > -#!/usr/bin/python2
> > +#!/usr/bin/python
>
> nit: I think this shebang is more correct as it allows virtualenvs
>
>   #!/usr/bin/env python
>
> But we can always call the tests with an explicit interpreter
>
>   # .../my/bin/python ./nft-test.py
>
Sure, I will update it and post the patch.

> >  #
> >  # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
> >  #
> [..]
> > @@ -1358,6 +1359,10 @@ def main():
> >      parser.add_argument('-s', '--schema', action='store_true',
> >                          dest='enable_schema',
> >                          help='verify json input/output against schema')
> > +
>
> nit: This adds a line with a tab, which both git-am and flake8 complain
> about.
>
Will remove it.

> > +    parser.add_argument('-v', '--version', action='version',
> > +                        version='1.0',
> > +                        help='print the version information')
> >
> >      args = parser.parse_args()
> >      global debug_option, need_fix_option, enable_json_option, enable_json_schema
> > @@ -1372,15 +1377,15 @@ def main():
> [..]

Since i have to update and resend the netns patch, i think i will make
changes for these nits in that.
Is it okay? or should i send a separate patch?

Thanks!
Shekhar
