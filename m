From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Fri, 26 Jul 2013 16:59:02 +0200
Message-ID: <20130726145902.GA28833@localhost>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
 <1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47081 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab3GZO7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:59:11 -0400
Content-Disposition: inline
In-Reply-To: <1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

On Fri, Jul 26, 2013 at 01:05:17PM +0200, Giuseppe Longo wrote:
[...]
> diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
> index b7cf609..d61b762 100644
> --- a/iptables/xtables-config.c
> +++ b/iptables/xtables-config.c
> @@ -15,6 +15,7 @@
>  #include <stdbool.h>
>  #include <string.h>
>  #include <errno.h>
> +#include <libmnl/libmnl.h>
>  
>  #include "xtables-multi.h"
>  #include "nft.h"
> @@ -35,11 +36,17 @@ int xtables_config_main(int argc, char *argv[])
>  	else
>  		filename = argv[1];
>  
> -	if (nft_init(&h, xtables_ipv4) < 0) {
> -                fprintf(stderr, "Failed to initialize nft: %s\n",
> -			strerror(errno));
> -		return EXIT_FAILURE;
> +	h.nl = mnl_socket_open(NETLINK_NETFILTER);
> +	if (h.nl == NULL) {
> +		perror("mnl_socket_open");
> +		return -1;
>  	}
> +	if (mnl_socket_bind(h.nl, 0, MNL_SOCKET_AUTOPID) < 0) {
> +		perror("mnl_socket_bind");
> +		return -1;
> +	}
> +	h.portid = mnl_socket_get_portid(h.nl);
> +	h.tables = xtables_ipv4;

Hm, why do we need this here?
