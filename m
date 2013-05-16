From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 2/6] xtables: destroy list iterator
 relevantly
Date: Thu, 16 May 2013 19:02:23 +0200
Message-ID: <20130516170223.GC3827@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528727-10127-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40585 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3EPRC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 13:02:28 -0400
Content-Disposition: inline
In-Reply-To: <1368528727-10127-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 14, 2013 at 01:52:03PM +0300, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  iptables/nft.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index f5d96bc..574383d 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -1119,6 +1119,7 @@ next:
>  		c = nft_chain_list_iter_next(iter);
>  	}
>  
> +	nft_chain_list_iter_destroy(iter);
>  	nft_chain_list_free(list);
>  
>  	return 1;
> @@ -1248,7 +1249,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table)
>  {
>  	int ret;
>  	struct nft_chain_list *list;
> -	struct nft_chain_list_iter *iter;
> +	struct nft_chain_list_iter *iter = NULL;

By looking at the code, we can skip setting this to NULL.

>  	struct nft_chain *c;
>  
>  	nft_fn = nft_rule_flush;
> @@ -1285,6 +1286,7 @@ next:
>  	}
>  
>  err:
> +	nft_chain_list_iter_destroy(iter);

By moving this before the err: label. I'm going to take over this
patch and give it another spin.
