From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxtables: xtables.c: Use getnameinfo()
Date: Sun, 11 Dec 2016 21:02:26 +0100
Message-ID: <20161211200226.GA11648@salvia>
References: <1481284200-6104-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753592AbcLKUCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 15:02:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8AE7C7FC54
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:02:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77F3CDA85D
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:02:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DC87DA85D
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:02:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481284200-6104-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 09, 2016 at 05:20:00PM +0530, Shyam Saini wrote:
> Use getnameinfo() instead of deprecated gethostbyaddr()
> 
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  libxtables/xtables.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 921dfe9..338e325 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1210,13 +1210,28 @@ const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
>  
>  static const char *ipaddr_to_host(const struct in_addr *addr)
>  {
> -	struct hostent *host;
> +	static char hostname[NI_MAXHOST];
> +	struct sockaddr_in saddr;
> +	int err;
>  
> -	host = gethostbyaddr(addr, sizeof(struct in_addr), AF_INET);
> -	if (host == NULL)
> -		return NULL;
> +	memset(&saddr, 0, sizeof(struct sockaddr_in));
> +	memcpy(&saddr.sin_addr, addr, sizeof(*addr));

You can skip this by perfoming C99 initialization, eg.

        struct sockaddr_in sin = { .sin_family = AF_INET, };
        sin.sin_addr = *addr;

> +	saddr.sin_family = AF_INET;
> +
> +	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in),
> +			              hostname, sizeof(hostname) - 1, NULL, 0, 0);
> +
> +	 if (err != 0) {
> +#ifdef DEBUG
> +		 fprintf(stderr,"IP2Name: %s\n",gai_strerror(err));
> +#endif
> +		 return NULL;
> +	}
>  
> -	return host->h_name;
> +#ifdef DEBUG
> +		fprintf (stderr, "\naddr2host: %s\n", hostname);
> +#endif
> +		return hostname;
>  }
>  
>  static const char *ipaddr_to_network(const struct in_addr *addr)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
