From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4 v2] evaluate: fix a crash if we specify ether
 type or meta nfproto in reject
Date: Fri, 17 Oct 2014 14:55:38 +0200
Message-ID: <20141017125538.GC3644@salvia>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaJQMy1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:54:27 -0400
Content-Disposition: inline
In-Reply-To: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 17, 2014 at 02:24:34PM +0200, Alvaro Neira Ayuso wrote:
> If we use a rule:
> nft add rule bridge filter input \
> 	ether type ip reject with icmp type host-unreachable
> 
> or this:
> 
> nft add rule inet filter input \
> 	meta nfproto ipv4 reject with icmp type host-unreachable
> 
> we have a segfault because we add a network dependency when we already have
> network context.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
> * Fixed a incorrect refactor when we check the family in bridge
> 
>  src/evaluate.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 83ef749..4b7bda9 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -19,6 +19,7 @@
>  #include <linux/netfilter/nf_tables.h>
>  #include <netinet/ip_icmp.h>
>  #include <netinet/icmp6.h>
> +#include <net/ethernet.h>
>  
>  #include <expression.h>
>  #include <statement.h>
> @@ -1193,6 +1194,8 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
>  		BUG("cannot generate reject dependency for type %d",
>  		    stmt->reject.type);
>  	}
> +	if (payload == NULL)
> +		return 0;

Why this check?

>  	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
>  		return -1;
