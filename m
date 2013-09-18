From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/6] ipset: Rework the "fake" argument parsing for ipset
 restore.
Date: Wed, 18 Sep 2013 20:22:41 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309182016290.21599@blackhole.kfki.hu>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379423605-22777-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44502 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3IRSWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:22:42 -0400
In-Reply-To: <1379423605-22777-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This reworks the argument parsing functionality of ipset to handle
> quote-delimited lines in such a way that they are considered to be a
> single argument.
> 
> This commit is necessary for ipset to successfully restore sets that
> have comments.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  src/ipset.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/src/ipset.c b/src/ipset.c
> index 4f308da..d9d609c 100644
> --- a/src/ipset.c
> +++ b/src/ipset.c
> @@ -159,20 +159,44 @@ ipset_print_file(const char *fmt, ...)
>  static void
>  build_argv(char *buffer)
>  {
> -	char *ptr;
> +	char *ptr, *tmp;
>  	int i;
>  
>  	/* Reset */
> -	for (i = 1; i < newargc; i++)
> +	for (i = 1; i < newargc; i++) {
> +		if(newargv[i])
> +			free(newargv[i]);
>  		newargv[i] = NULL;
> +	}
>  	newargc = 1;
>  
>  	ptr = strtok(buffer, " \t\r\n");
> -	newargv[newargc++] = ptr;
> +	newargv[newargc] = calloc(strlen(ptr) + 1, sizeof(*ptr));
> +	ipset_strlcpy(newargv[newargc++], ptr, strlen(ptr) + 1);
>  	while ((ptr = strtok(NULL, " \t\r\n")) != NULL) {
> -		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *)))
> -			newargv[newargc++] = ptr;
> -		else {
> +		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *))) {
> +			tmp = newargv[newargc] = calloc(strlen(ptr) + 1,
> +							sizeof(*ptr));
> +			if(*ptr == '"') {
> +				ipset_strlcpy(tmp, ptr + 1, (strlen(ptr) + 1) *
> +					      sizeof(*ptr));
> +				ipset_strlcat(tmp, " ", (strlen(ptr) + 1) *
> +					      sizeof(*ptr));
> +				while((ptr = strtok(NULL, "\"")) != NULL) {
> +					if(*ptr == '\n' || *ptr == '\r')
> +						continue;
> +					tmp = realloc(tmp, (strlen(tmp) +
> +						      strlen(ptr) + 1) *
> +						      sizeof(*ptr));
> +					ipset_strlcat(tmp, ptr, (strlen(tmp) +
> +						      strlen(ptr) + 1) *
> +						      sizeof(*ptr));
> +				}

Why is there the inside while loop? We look for a single closing quote. 
Also, I'd better like to see an error reported if the closing quote is 
missing instead of silently accepting it.

> +			} else
> +				ipset_strlcpy(tmp, ptr, (strlen(ptr) + 1) *
> +					      sizeof(*ptr));
> +			newargv[newargc++] = tmp;
> +		} else {
>  			exit_error(PARAMETER_PROBLEM,
>  				   "Line is too long to parse.");
>  			return;
> @@ -195,7 +219,8 @@ restore(char *argv0)
>  
>  	/* Initialize newargv/newargc */
>  	newargc = 0;
> -	newargv[newargc++] = argv0;
> +	newargv[newargc] = calloc(strlen(argv0) + 1, sizeof(*argv0));
> +	ipset_strlcpy(newargv[newargc++], argv0, strlen(argv0) + 1);
>  	if (filename) {
>  		fd = fopen(filename, "r");
>  		if (!fd) {
> @@ -232,6 +257,7 @@ restore(char *argv0)
>  	if (ret < 0)
>  		handle_error();
>  
> +	free(newargv[0]);
>  	return ret;
>  }
>  
> -- 
> 1.8.3.2

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
