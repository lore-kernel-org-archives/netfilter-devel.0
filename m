Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C650FC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Mar 2022 19:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbiCHTdH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 14:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiCHTdG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 14:33:06 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD60D37A8F
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2022 11:32:04 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 03EC763013;
        Tue,  8 Mar 2022 20:30:09 +0100 (CET)
Date:   Tue, 8 Mar 2022 20:32:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] nfct: Support for non-lazy binding
Message-ID: <YievMLRYJJZ24kNp@salvia>
References: <20220208160100.27527-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220208160100.27527-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 08, 2022 at 05:01:00PM +0100, Phil Sutter wrote:
> For security purposes, distributions might want to pass -Wl,-z,now
> linker flags to all builds, thereby disabling lazy binding globally.
> 
> In the past, nfct relied upon lazy binding: It uses the helper objects'
> parsing functions without but doesn't provide all symbols the objects
> use.
> 
> Add a --disable-lazy configure option to add those missing symbols to
> nfct so it may be used in those environments.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This patch supersedes the previously submitted "Merge nfct tool into
> conntrackd", providing a solution which is a) optional and b) doesn't
> bloat nfct-only use-cases that much.
> ---
>  configure.ac    | 12 ++++++++++--
>  src/Makefile.am |  7 +++++++
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index b12b722a3396d..43baf8244ad64 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -48,6 +48,9 @@ AC_ARG_ENABLE([cttimeout],
>  AC_ARG_ENABLE([systemd],
>          AS_HELP_STRING([--enable-systemd], [Build systemd support]),
>          [enable_systemd="$enableval"], [enable_systemd="no"])
> +AC_ARG_ENABLE([lazy],
> +        AS_HELP_STRING([--disable-lazy], [Disable lazy binding in nfct]),
> +        [enable_lazy="$enableval"], [enable_lazy="yes"])
>  
>  AC_CHECK_HEADER([rpc/rpc_msg.h], [AC_SUBST([LIBTIRPC_CFLAGS],'')], [PKG_CHECK_MODULES([LIBTIRPC], [libtirpc])])
>  
> @@ -78,7 +81,11 @@ AC_CHECK_HEADERS(arpa/inet.h)
>  AC_CHECK_FUNCS(inet_pton)
>  
>  # Let nfct use dlopen() on helper libraries without resolving all symbols.
> -AX_CHECK_LINK_FLAG([-Wl,-z,lazy], [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
> +AS_IF([test "x$enable_lazy" = "xyes"], [
> +	AX_CHECK_LINK_FLAG([-Wl,-z,lazy],
> +			   [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
> +])
> +AM_CONDITIONAL([HAVE_LAZY], [test "x$enable_lazy" = "xyes"])
>  
>  if test ! -z "$libdir"; then
>  	MODULE_DIR="\\\"$libdir/conntrack-tools/\\\""
> @@ -92,4 +99,5 @@ echo "
>  conntrack-tools configuration:
>    userspace conntrack helper support:	${enable_cthelper}
>    conntrack timeout support:		${enable_cttimeout}
> -  systemd support:			${enable_systemd}"
> +  systemd support:			${enable_systemd}
> +  use lazy binding:                     ${enable_lazy}"
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 1d56394698a68..95cff7d528d44 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -18,6 +18,9 @@ nfct_SOURCES = nfct.c
>  if HAVE_CTHELPER
>  nfct_SOURCES += helpers.c			\
>  		nfct-extensions/helper.c
> +if !HAVE_LAZY
> +nfct_SOURCES += expect.c utils.c
> +endif

If the problem are the symbols in these two files, could you just
build them always into nfct? No need for the extra --disable-lazy at
./configure time.

>  endif
>  
>  if HAVE_CTTIMEOUT
> @@ -33,6 +36,10 @@ endif
>  
>  if HAVE_CTHELPER
>  nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
> +if !HAVE_LAZY
> +nfct_LDADD += ${LIBNETFILTER_CONNTRACK_LIBS} \
> +	      ${LIBNETFILTER_QUEUE_LIBS}
> +endif
>  endif
>  
>  nfct_LDFLAGS = -export-dynamic ${LAZY_LDFLAGS}
> -- 
> 2.34.1
> 
