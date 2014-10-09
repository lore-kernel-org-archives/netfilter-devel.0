From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] build: allow disabling libreadline-support
Date: Thu, 9 Oct 2014 14:26:48 +0200
Message-ID: <20141009122648.GA17919@salvia>
References: <1412200742-5898-1-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39689 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaJIMZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:25:26 -0400
Content-Disposition: inline
In-Reply-To: <1412200742-5898-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Steven,

Thanks for your patch. No major objections to this. Some comments
below:

On Wed, Oct 01, 2014 at 11:59:02PM +0200, Steven Barth wrote:
> This makes nftables a bit more embedded-friendly.
> 
> Signed-off-by: Steven Barth <cyrus@openwrt.org>
> ---
>  configure.ac    | 11 +++++++++--
>  src/Makefile.in |  2 ++
>  src/main.c      |  6 ++++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 3a7647f..a19da5d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -71,8 +71,15 @@ AC_CHECK_LIB([nftnl], [nft_rule_alloc], ,
>  AC_CHECK_LIB([gmp], [__gmpz_init], ,
>  	     AC_MSG_ERROR([No suitable version of libgmp found]))
>  
> -AC_CHECK_LIB([readline], [readline], ,
> -	     AC_MSG_ERROR([No suitable version of libreadline found]))
> +
> +AC_ARG_WITH([libreadline], [AS_HELP_STRING([--without-libreadline],
> +            [Disable libreadline support (no interactive CLI)])], [],
> +            [with_libreadline=yes])

I think, better call this option "without-cli" ?

> +AS_IF([test "x$with_libreadline" != xno], [
> +AC_CHECK_LIB([readline],[readline], , AC_MSG_ERROR([No suitable version of libreadline found]))
> +])
> +AC_SUBST(with_libreadline)
> +
>  
>  # Checks for header files.
>  AC_HEADER_STDC
> diff --git a/src/Makefile.in b/src/Makefile.in
> index 8ac2b46..04107a8 100644
> --- a/src/Makefile.in
> +++ b/src/Makefile.in
> @@ -3,7 +3,9 @@ PROGRAMS		+= nft
>  nft-destdir		:= @sbindir@
>  
>  nft-obj			+= main.o
> +ifeq (@with_libreadline@,yes)
>  nft-obj			+= cli.o
> +endif
>  nft-obj			+= rule.o
>  nft-obj			+= statement.o
>  nft-obj			+= datatype.o
> diff --git a/src/main.c b/src/main.c
> index 2685b0d..de2efe6 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -335,8 +335,14 @@ int main(int argc, char * const *argv)
>  		if (scanner_read_file(scanner, filename, &internal_location) < 0)
>  			goto out;
>  	} else if (interactive) {
> +#ifdef HAVE_LIBREADLINE

Please, add the:

#ifdef HAVE_LIBREADLINE

in cli_init() and cli_exit() in cli.c. It would be good if the cli_init()
returns a negative value, so you spot the error message below.

>  		cli_init(&state);
>  		return 0;
> +#else
> +		fprintf(stderr, "%s: interactive CLI not supported in this build\n",
> +			argv[0]);


> +		exit(NFT_EXIT_FAILURE);
> +#endif
>  	} else {
>  		fprintf(stderr, "%s: no command specified\n", argv[0]);
>  		exit(NFT_EXIT_FAILURE);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
