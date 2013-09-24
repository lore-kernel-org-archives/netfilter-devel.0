From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 2/2] xtables: arp: zeroing chain
 counters
Date: Tue, 24 Sep 2013 13:19:15 +0200
Message-ID: <20130924111915.GB8523@localhost>
References: <1379837936-2813-1-git-send-email-giuseppelng@gmail.com>
 <1379837936-2813-2-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46488 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3IXLTU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Sep 2013 07:19:20 -0400
Content-Disposition: inline
In-Reply-To: <1379837936-2813-2-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 22, 2013 at 10:18:56AM +0200, Giuseppe Longo wrote:
> This small patch permit to reset the chain counters.

Applied with minor change.

> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/xtables-arp.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
> index 4537a58..2f43ce8 100644
> --- a/iptables/xtables-arp.c
> +++ b/iptables/xtables-arp.c
> @@ -1462,9 +1462,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
>  				   options&OPT_NUMERIC,
>  				   /*options&OPT_EXPANDED*/0,
>  				   options&OPT_LINENUMBERS);
> -		/*if (ret)
> -			ret = zero_entries(chain,
> -						options&OPT_VERBOSE, handle);*/
> +		if (ret && (command & CMD_ZERO))
                        ^---------------------^

that seems redundant, we already checked for this above.

Mangled and applied, thanks.
