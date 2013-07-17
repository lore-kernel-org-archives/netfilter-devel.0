From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH 1/2] nft: Optimize chain listing if
 only one is looked for
Date: Wed, 17 Jul 2013 15:40:04 +0200
Message-ID: <20130717134004.GA7893@localhost>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1374046455-19234-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3GQNkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:40:10 -0400
Content-Disposition: inline
In-Reply-To: <1374046455-19234-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Wed, Jul 17, 2013 at 10:34:14AM +0300, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  iptables/nft.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index f9a88c9..f33faa5 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -2495,6 +2495,9 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
>  		}
>  		__nft_rule_list(h, c, table, rulenum, format, print_firewall);
>  
> +		if (chain && strcmp(chain, chain_name) == 0)
> +			break;
> +
>  		found = true;
>  
>  next:
> @@ -2593,6 +2596,9 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
>  
>  		ret = __nft_rule_list(h, c, table, rulenum,
>  				      counters ? 0 : FMT_NOCOUNTS, list_save);
> +
> +		if (chain && strcmp(chain, chain_name) != 0)

This should be == 0. There's the same checking above __nft_rule_list.

I noticed that we don't need to strcmp(chain, chain_name) again,
checking for chain is sufficient.

Pushed this patch, is based on yours:

http://git.netfilter.org/iptables-nftables/commit/?id=db6d43c979954b1a0e2a3d2d1fa4494c43d921c1

While at it, I also noticed that selective listing per chain with -S
was also broken, fixed here:

http://git.netfilter.org/iptables-nftables/commit/?id=eaa70f580a3e3b7675d75005ab71c00494a3ee6e

Regards.
