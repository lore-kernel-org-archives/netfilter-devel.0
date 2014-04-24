From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-queue] src: PF_BIND/UNBIND is ignored in 3.8 and later
Date: Thu, 24 Apr 2014 12:01:05 +0200
Message-ID: <20140424100105.GA8151@localhost>
References: <1398330071-3463-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36956 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaDXKCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:02:06 -0400
Content-Disposition: inline
In-Reply-To: <1398330071-3463-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 24, 2014 at 11:01:11AM +0200, Florian Westphal wrote:
> There is confusion on what this command actually does and why
> examples commonly PF_UNBIND at startup.
> 
> Since these are obsolete document that its not needed at all
> from 3.8 onwards and remove the unbind from the example program.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> I'll push it later today if noone objets.
> 
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 1f465ad..4e0b227 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -136,17 +136,9 @@ int main(int argc, char *argv[])
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
> -	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
> -
> -	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> -		perror("mnl_socket_send");
> -		exit(EXIT_FAILURE);
> -	}
> -
> +	/* PF_BIND is not needed with kernels 3.8 and later */

My only concern is that people using old kernels won't manage to run
this example, I think there are quite a lot of people running < 3.8,
so we may hit confusion from the other side.

I like the remaining part of the patch, but this part, I would just
leave it with a big fat comment like from here to there you can remove
this code since the NFQNL_CFG_CMD_PF_UNBIND is noop in >= 3.8.
