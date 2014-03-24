From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: fix length of set name
Date: Mon, 24 Mar 2014 15:57:05 +0100
Message-ID: <20140324145704.GA32472@localhost>
References: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
 <1395423541-5098-2-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50439 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaCXO5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:57:11 -0400
Content-Disposition: inline
In-Reply-To: <1395423541-5098-2-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 21, 2014 at 06:39:01PM +0100, Giuseppe Longo wrote:
> This patch permits to copy the last char of the set name
> that's currently excluded.
> 
> nft add table ip test
> nft add chain ip test filter {type filter hook input priority 0 \; }
> nft add set ip test thisnamewith0016 { type ipv4_address\;}
> nft list table ip test
> table ip test {
>         set thisnamewith0016 {
>                 type ipv4_address
>         }
> 
>         chain filter {
>                  type filter hook input priority 0;
>         }
> }
> 
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index adce01e..a0da542 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2018,7 +2018,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
>  		free_page((unsigned long)inuse);
>  	}
>  
> -	snprintf(set->name, sizeof(set->name), name, n);
> +	snprintf(set->name, sizeof(set->name)+1, name, n);

This allows to write up to 16+1 bytes.

>  	list_for_each_entry(i, &ctx->table->sets, list) {
>  		if (!strcmp(set->name, i->name))
>  			return -ENFILE;
> @@ -2399,7 +2399,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
>  	if (set == NULL)
>  		goto err1;
>  
> -	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
> +	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name)+1);

Same thing here, but the name size is just 16 bytes long.
