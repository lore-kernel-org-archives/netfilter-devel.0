Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A0EC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 10:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1DA61262
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 10:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhHXKig (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Aug 2021 06:38:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43158 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhHXKie (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 06:38:34 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA9826024F;
        Tue, 24 Aug 2021 12:29:12 +0200 (CEST)
Date:   Tue, 24 Aug 2021 12:30:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v4 2/4] build: doc: can choose what to
 build and install
Message-ID: <20210824103001.GB30322@salvia>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210822041442.8394-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 22, 2021 at 02:14:40PM +1000, Duncan Roe wrote:
> Update doxygen/Makefile.am to build and install man pages and html documentation
> conditionally. Involves configure.ac and doxygen.cfg.in, see below.
> 
> CONFIGURE.AC
> 
> Update `configure --help` to list non-default documentation options, as do most
> packages (i.e. list non-defaults). 3 listed options:
> 1. --enable-html-doc
> 2. --disable-man-pages
> 3. --without-doxygen
> Option 3 overrides 1 & 2: e.g. if you have --without-doxygen but not
> --disable-man-pages you get:
>   WARNING: Doxygen disabled - man pages will not be built
> doxygen is not run if no documentation is requested.
> 
> Configure command                  Installed package size (KB)
> ========= =======                  ========= ======= ==== ====
> ./configure --without-doxygen       176
> ./configure --disable-man-pages     176
> ./configure                         300
> ./configure --enable-html-doc      1460
> ./configure --enable-html-doc\
> 	    --disable-man-pages    1340
> 
> Do some extra re-ordering for clarity. Also for clarity, since this is
> linux-only, re-work test commands to look mode modern.
> 
> DOXYGEN.CFG.IN
> 
> HTML and man page generation are both conditional.
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  configure.ac        | 76 +++++++++++++++++++++++++++++++--------------
>  doxygen.cfg.in      |  3 +-
>  doxygen/Makefile.am | 11 ++++++-
>  3 files changed, 64 insertions(+), 26 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 0fe754c..376d4ff 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -10,9 +10,42 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
>  	tar-pax no-dist-gzip dist-bzip2 1.6])
>  m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>  
> +case "$host" in
> +*-*-linux* | *-*-uclinux*) ;;
> +*) AC_MSG_ERROR([Linux only, dude!]);;
> +esac

This update is unnecessary, please avoid unnecessary changes in your
updates, it makes it harder to review.

>  dnl kernel style compile messages
>  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
>  
> +AC_ARG_WITH([doxygen], [AS_HELP_STRING([--without-doxygen],
> +	    [Don't run doxygen (to create documentation)])],
> +	    [with_doxygen="$withval"], [with_doxygen=yes])
> +
> +AC_ARG_ENABLE([html-doc],
> +	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
> +	      [], [enable_html_doc=no])
> +AS_IF([test "$with_doxygen" = no -a "$enable_html_doc" = yes], [
> +	AC_MSG_WARN([Doxygen disabled - html documentation will not be built])
> +	enable_html_doc=no
> +])
> +AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
> +AS_IF([test "$enable_html_doc" = yes],
> +	[AC_SUBST(GEN_HTML, YES)],
> +	[AC_SUBST(GEN_HTML, NO)])
> +
> +AC_ARG_ENABLE([man-pages],
> +	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
> +	      [], [enable_man_pages=yes])
> +AS_IF([test "$with_doxygen" = no -a "$enable_man_pages" = yes], [
> +	AC_MSG_WARN([Doxygen disabled - man pages will not be built])
> +	enable_man_pages=no
> +])
> +AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
> +AS_IF([test "$enable_man_pages" = yes],
> +	[AC_SUBST(GEN_MAN, YES)],
> +	[AC_SUBST(GEN_MAN, NO)])

Moving this block is also not necessary. Please, don't move code
around while you're updating it, it makes it harder to review.

Thanks.
