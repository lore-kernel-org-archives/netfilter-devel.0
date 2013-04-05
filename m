From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Ulogd2 PATCH 1/3] Remove configure check for libmnl, it is not
 used
Date: Fri, 5 Apr 2013 17:34:28 +0200
Message-ID: <20130405153428.GA32205@localhost>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
 <1365172437-15042-2-git-send-email-victor@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Victor Julien <victor@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab3DEPeh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:34:37 -0400
Content-Disposition: inline
In-Reply-To: <1365172437-15042-2-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 05, 2013 at 04:33:55PM +0200, Victor Julien wrote:
> If libmnl is missing configure fails. However, the lib is not used nor
> linked to.
> 
> ---
>  configure.ac |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index c94704b..a439bee 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
>  
>  dnl Check for the right nfnetlink version
>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
> -PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])

input/sum/ulogd_inpflow_NFACCT.c

needs this.
