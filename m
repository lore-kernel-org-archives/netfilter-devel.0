From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 5/7] ipset: Rework the "fake" argument parsing for ipset
 restore.
Date: Mon, 23 Sep 2013 14:17:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309231416540.3776@blackhole.kfki.hu>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379876196-46929-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39005 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab3IWMRr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:17:47 -0400
In-Reply-To: <1379876196-46929-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 22 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This reworks the argument parsing functionality of ipset to handle
> quote-delimited lines in such a way that they are considered to be a
> single argument.
> 
> This commit is necessary for ipset to successfully restore sets that
> have comments.

Patch is applied with the first letter capitalized in the error message.

Best regards,
Jozsef
 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  src/ipset.c | 52 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/src/ipset.c b/src/ipset.c
> index 4f308da..12809c8 100644
> --- a/src/ipset.c
> +++ b/src/ipset.c
> @@ -159,25 +159,57 @@ ipset_print_file(const char *fmt, ...)
>  static void
>  build_argv(char *buffer)
>  {
> -	char *ptr;
> +	char *tmp, *arg;
>  	int i;
> +	bool quoted = false;
>  
>  	/* Reset */
> -	for (i = 1; i < newargc; i++)
> +	for (i = 1; i < newargc; i++) {
> +		if (newargv[i])
> +			free(newargv[i]);
>  		newargv[i] = NULL;
> +	}
>  	newargc = 1;
>  
> -	ptr = strtok(buffer, " \t\r\n");
> -	newargv[newargc++] = ptr;
> -	while ((ptr = strtok(NULL, " \t\r\n")) != NULL) {
> -		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *)))
> -			newargv[newargc++] = ptr;
> -		else {
> +	arg = calloc(strlen(buffer) + 1, sizeof(*buffer));
> +	for (tmp = buffer, i = 0; *tmp; tmp++) {
> +		if ((newargc + 1) == (int)(sizeof(newargv)/sizeof(char *))) {
>  			exit_error(PARAMETER_PROBLEM,
>  				   "Line is too long to parse.");
>  			return;
>  		}
> +		switch (*tmp) {
> +		case '"':
> +			quoted = !quoted;
> +			if (*(tmp+1))
> +				continue;
> +			break;
> +		case ' ':
> +		case '\r':
> +		case '\n':
> +		case '\t':
> +			if (!quoted)
> +				break;
> +			arg[i++] = *tmp;
> +			continue;
> +		default:
> +			arg[i++] = *tmp;
> +			if (*(tmp+1))
> +				continue;
> +			break;
> +		}
> +		if (!*(tmp+1) && quoted) {
> +			exit_error(PARAMETER_PROBLEM, "missing close quote");
> +			return;
> +		}
> +		if (!*arg)
> +			continue;
> +		newargv[newargc] = calloc(strlen(arg) + 1, sizeof(*arg));
> +		ipset_strlcpy(newargv[newargc++], arg, strlen(arg) + 1);
> +		memset(arg, 0, strlen(arg) + 1);
> +		i = 0;
>  	}
> +	free(arg);
>  }
>  
>  /* Main parser function, workhorse */
> @@ -195,7 +227,8 @@ restore(char *argv0)
>  
>  	/* Initialize newargv/newargc */
>  	newargc = 0;
> -	newargv[newargc++] = argv0;
> +	newargv[newargc] = calloc(strlen(argv0) + 1, sizeof(*argv0));
> +	ipset_strlcpy(newargv[newargc++], argv0, strlen(argv0) + 1);
>  	if (filename) {
>  		fd = fopen(filename, "r");
>  		if (!fd) {
> @@ -232,6 +265,7 @@ restore(char *argv0)
>  	if (ret < 0)
>  		handle_error();
>  
> +	free(newargv[0]);
>  	return ret;
>  }
>  
> -- 
> 1.8.3.2
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
