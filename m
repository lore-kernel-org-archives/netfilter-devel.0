Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0DBC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 04:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A766127C
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 04:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhJRE5u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 00:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhJRE5u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 00:57:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FCEC06161C
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 21:55:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t7so370333pgl.9
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 21:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=xLlKGRzaK3whSYxxqpzNzy+0Z0UOcmWjAHX6HEPGMc0=;
        b=GofN0rIQIixrHHZPmE2ltGUPlrt1JJn+5rdZ6N2SNCQbtFM44iS2DdvzaPGa79oZ6z
         J8e+xRLaWNIJXK0RQBVtMykzN4V8CQb4Q5uTPyRf2QAOvE+8lnKnXqRFLa8XuvcFV8+E
         iDTmJUHDV3wwXqaiAi/Sz1q58CSwSYOAZgPjXE2bdW/YM8UYzoYy94L4pec26+wbyU+3
         +FyoMeLDtgwfvpYprPUH21PRRX4tXT5hM1LpYhfzosiwvZvpWrDzBy8AnKrLVtSgbVgb
         JJMJB6Rhbt4IsU9E39ZQlvfXeVTYuSG6ipCH9GZEmHTyDd2nay6plkWnaaHZ8X2+a1tF
         R/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=xLlKGRzaK3whSYxxqpzNzy+0Z0UOcmWjAHX6HEPGMc0=;
        b=K1hqcSq7vBywxgF0yJc/ceyCGOX9dHWwKU5wAvstRsX1SItZG5T/acqB9Zs4jdOEjs
         kWQPM8SuW+XggnUcKAFQ2VxETeaR7RqDpfdSC8tigBHEEowJ4U92sR/0eqr+jMfA74mb
         palNbt7eBNaxKkfeXAn5jyaVEcPlc7wcS8jydVEadIDREkLvb/zLVksaaq3mb7qeDX3p
         RWrD9eZgB+t2cg7y8HwlOo1nXW0Xxutvdya52TgPplm0uMjWWMaXmUcXM+dWo32++Q5t
         s5v17nZH/Tmj+ARJnqCqxUmFBS69LLtY9W2HYP8+leBVp9uDQBVefgT5KlJza9zVet3A
         A7IQ==
X-Gm-Message-State: AOAM533YODHpVyw3wupofwuEI+MqjisLYsNxinc2jVmwxbG3Cf4qAIoV
        HWpJyF1oOMQ3OrpTSN0w4E2eY6aNwgI=
X-Google-Smtp-Source: ABdhPJzfmxfPh9UBy1jCiyjdwrGZ3kWEBLLcb8E94yKdolu6T+aqmax6uVyzYpUYNdp02SWOlLqzqA==
X-Received: by 2002:a05:6a00:1a8e:b0:44c:5f27:e971 with SMTP id e14-20020a056a001a8e00b0044c5f27e971mr27001356pfv.72.1634532939520;
        Sun, 17 Oct 2021 21:55:39 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id bf7sm11520963pjb.14.2021.10.17.21.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 21:55:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 18 Oct 2021 15:55:34 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log v5] build: doc: Allow to specify whether
 to produce man pages, html, neither or both
Message-ID: <YWz+RjShhvgK4TgS@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
 <YWwrb9lJI7gPIbZv@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWwrb9lJI7gPIbZv@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Oct 17, 2021 at 03:55:59PM +0200, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> > - configure --help lists non-default documentation options.
> >   Looking around the web, this seemed to me to be what most projects do.
> >   Listed options are --enable-html-doc & --disable-man-pages.
> > - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
> >   --enable-html-doc is asserted.
> > If html is requested, `make install` installs it in htmldir.
>
> A few comments below.
>
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: broken out from 0001-build-doc-Fix-man-pages.patch
> > v3: no change (still part of a series)
> > v4: remove --without-doxygen since -disable-man-pages does that
> > v5: - update .gitignore for clean `git status` after in-tree build
> >     - in configure.ac:
> >       - ensure all variables are always set (avoid leakage from environment)
> >       - provide helpful warning if HTML enabled but dot not found
> >  .gitignore             |  5 ++++-
> >  configure.ac           | 34 +++++++++++++++++++++++++++-------
> >  doxygen/Makefile.am    | 11 ++++++++++-
> >  doxygen/doxygen.cfg.in |  3 ++-
> >  4 files changed, 43 insertions(+), 10 deletions(-)
> >
> > diff --git a/.gitignore b/.gitignore
> > index 525628e..ae3e740 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -15,7 +15,10 @@ Makefile.in
> >  /libtool
> >  /stamp-h1
> >
> > -/doxygen.cfg
> > +/doxygen/doxygen.cfg
> >  /libnetfilter_queue.pc
> >
> >  /examples/nf-queue
> > +/doxygen/doxyfile.stamp
> > +/doxygen/html/
> > +/doxygen/man/
> > diff --git a/configure.ac b/configure.ac
> > index 4721eeb..83959b0 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -13,6 +13,22 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
> >  dnl kernel style compile messages
> >  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
> >
> > +AC_ARG_ENABLE([html-doc],
> > +	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
> > +	      [], [enable_html_doc=no])
> > +AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
> > +AS_IF([test "$enable_html_doc" = yes],
> > +	[AC_SUBST(GEN_HTML, YES)],
> > +	[AC_SUBST(GEN_HTML, NO)])
>
> Is this changing defaults in some way? If so, this needs to be
> documented in the patch descriptions.
> > +
> > +AC_ARG_ENABLE([man-pages],
> > +	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
> > +	      [], [enable_man_pages=yes])
> > +AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
> > +AS_IF([test "$enable_man_pages" = yes],
> > +	[AC_SUBST(GEN_MAN, YES)],
> > +	[AC_SUBST(GEN_MAN, NO)])
>
> Why do we need two new toggles for this?
>
> In both cases, doxygen is required to build the manpages, so the point
> of the documentation toggle is to allow to build the software in the
> absence of doxygen (for example, in a embedded setup).
>
> I'm not ambivalent this is really needed, if it might be useful but an
> explaination would be good to have to explain the rationale behind
> this update.
>
> Thanks.

v6 has a re-worked commit message which addresses all your points above, or
if it doesn't then please ask for clarification.

I split off the .gitignore changes - they apply by themselves.

Cheers ... Duncan.
