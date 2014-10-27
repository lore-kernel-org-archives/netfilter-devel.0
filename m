From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/3] netfilter: log: protect nf_log_register against
 double registering
Date: Mon, 27 Oct 2014 23:09:08 +0100
Message-ID: <20141027220908.GB5998@salvia>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
 <dad1a3c1e30a676f3d17244ec74acef4dd0c9ca9.1414155204.git.mleitner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38830 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaJ0WHb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:07:31 -0400
Content-Disposition: inline
In-Reply-To: <dad1a3c1e30a676f3d17244ec74acef4dd0c9ca9.1414155204.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Marcelo,

I just noticed another minor issue that I didn't notice in my previous
review.

On Fri, Oct 24, 2014 at 10:59:50AM -0200, Marcelo Ricardo Leitner wrote:
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index f1409d95f810c689ec70755eb8a85125d291ad47..e7c7439f48db590eba8f7f2eac61fafd9e571389 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -82,10 +82,19 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>  	mutex_lock(&nf_log_mutex);
>  
>  	if (pf == NFPROTO_UNSPEC) {
> +		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
> +			if (nft_log_dereference(loggers[i][logger->type])) {

Given that we're not dereferencing, I think you can use
rcu_access_pointer() instead here.

> +				mutex_unlock(&nf_log_mutex);
> +				return -EEXIST;
> +			}
> +		}
>  		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
>  			rcu_assign_pointer(loggers[i][logger->type], logger);
>  	} else {
> -		/* register at end of list to honor first register win */
> +		if (nft_log_dereference(loggers[pf][logger->type])) {

Same thing here.
