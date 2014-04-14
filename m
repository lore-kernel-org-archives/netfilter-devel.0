From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd PATCH 2/3] add mark event filter
Date: Mon, 14 Apr 2014 14:54:47 +0200
Message-ID: <20140414125447.GB22192@localhost>
References: <20140408102614.GA29462@gmail.com>
 <20140408103218.GC29462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47396 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaDNMyy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:54:54 -0400
Content-Disposition: inline
In-Reply-To: <20140408103218.GC29462@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 07:32:19PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch adds a new configuration variable which is used to limit
> conntrack event to connection of the mark.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  configure.ac                    | 15 +++++++++
>  input/flow/ulogd_inpflow_NFCT.c | 75 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 522c345..7e5f5fc 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -58,6 +58,20 @@ AS_IF([test "x$enable_nfct" = "xyes"], [
>      AC_DEFINE([BUILD_NFCT], [1], [Building nfct module])
>  ])
>  AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
> +AS_IF([test "x$enable_nfct" = "xyes"], [
> +    AC_MSG_CHECKING([for enable mark filter for event])
> +    AC_CACHE_VAL(ac_cv_nfct_filter_mark,
> +    AC_TRY_COMPILE(
> +        [ #include <libnetfilter_conntrack/libnetfilter_conntrack.h>],
> +        [ int i = NFCT_FILTER_MARK; ],
> +        ac_cv_nfct_filter_mark=yes,
> +        ac_cv_nfct_filter_mark=no))
> +    AC_MSG_RESULT($ac_cv_nfct_filter_mark)
> +    AS_IF([test "x$ac_cv_nfct_filter_mark" = "xyes"], [
> +        AC_DEFINE([HAVE_NFCT_FILTER_MARK], [1], [Building nfct mark event filter])
> +    ])
> +])

I don't find a good reason to add a compile time option for this.

Eric?
