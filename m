Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B0FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8AC60FE3
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242467AbhJQN6P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:58:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53044 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242336AbhJQN6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 09:58:15 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CAA1663EE1;
        Sun, 17 Oct 2021 15:54:24 +0200 (CEST)
Date:   Sun, 17 Oct 2021 15:55:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v5] build: doc: Allow to specify whether
 to produce man pages, html, neither or both
Message-ID: <YWwrb9lJI7gPIbZv@salvia>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> - configure --help lists non-default documentation options.
>   Looking around the web, this seemed to me to be what most projects do.
>   Listed options are --enable-html-doc & --disable-man-pages.
> - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
>   --enable-html-doc is asserted.
> If html is requested, `make install` installs it in htmldir.

A few comments below.

> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: broken out from 0001-build-doc-Fix-man-pages.patch
> v3: no change (still part of a series)
> v4: remove --without-doxygen since -disable-man-pages does that
> v5: - update .gitignore for clean `git status` after in-tree build
>     - in configure.ac:
>       - ensure all variables are always set (avoid leakage from environment)
>       - provide helpful warning if HTML enabled but dot not found
>  .gitignore             |  5 ++++-
>  configure.ac           | 34 +++++++++++++++++++++++++++-------
>  doxygen/Makefile.am    | 11 ++++++++++-
>  doxygen/doxygen.cfg.in |  3 ++-
>  4 files changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 525628e..ae3e740 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -15,7 +15,10 @@ Makefile.in
>  /libtool
>  /stamp-h1
>  
> -/doxygen.cfg
> +/doxygen/doxygen.cfg
>  /libnetfilter_queue.pc
>  
>  /examples/nf-queue
> +/doxygen/doxyfile.stamp
> +/doxygen/html/
> +/doxygen/man/
> diff --git a/configure.ac b/configure.ac
> index 4721eeb..83959b0 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -13,6 +13,22 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>  dnl kernel style compile messages
>  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
>  
> +AC_ARG_ENABLE([html-doc],
> +	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
> +	      [], [enable_html_doc=no])
> +AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
> +AS_IF([test "$enable_html_doc" = yes],
> +	[AC_SUBST(GEN_HTML, YES)],
> +	[AC_SUBST(GEN_HTML, NO)])

Is this changing defaults in some way? If so, this needs to be
documented in the patch descriptions.
> +
> +AC_ARG_ENABLE([man-pages],
> +	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
> +	      [], [enable_man_pages=yes])
> +AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
> +AS_IF([test "$enable_man_pages" = yes],
> +	[AC_SUBST(GEN_MAN, YES)],
> +	[AC_SUBST(GEN_MAN, NO)])

Why do we need two new toggles for this?

In both cases, doxygen is required to build the manpages, so the point
of the documentation toggle is to allow to build the software in the
absence of doxygen (for example, in a embedded setup).

I'm not ambivalent this is really needed, if it might be useful but an
explaination would be good to have to explain the rationale behind
this update.

Thanks.
