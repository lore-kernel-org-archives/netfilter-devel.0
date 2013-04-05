From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Ulogd2 PATCH 3/3] Lower libnetfilter_conntrack requirement to
 0.9.1
Date: Fri, 5 Apr 2013 17:37:03 +0200
Message-ID: <20130405153703.GB32205@localhost>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
 <1365172437-15042-4-git-send-email-victor@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Victor Julien <victor@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33725 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab3DEPhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:37:15 -0400
Content-Disposition: inline
In-Reply-To: <1365172437-15042-4-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 05, 2013 at 04:33:57PM +0200, Victor Julien wrote:
> Build tested, no warnings.
> 
> ---
>  configure.ac |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 5755cf5..b17ecb6 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -59,7 +59,7 @@ AM_CONDITIONAL([BUILD_NFLOG], [test "x$enable_nflog" = "xyes"])
>  AC_ARG_ENABLE(nfct,
>         AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]]),,[enable_nfct=yes])
>  AS_IF([test "x$enable_nfct" = "xyes"], [
> -    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
> +    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.9.1])

There was a fix for Eric Leblond's kernel-space ct filtering, if you
downgrade this, people may come back and report that they are hitting
old bugs.
