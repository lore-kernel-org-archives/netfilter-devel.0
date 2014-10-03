From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nft_masq: fix register/unregister
 notifier on module _init and _exit
Date: Fri, 3 Oct 2014 15:16:18 +0200
Message-ID: <20141003131618.GA3353@salvia>
References: <20141003121335.2864.5519.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36091 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbaJCNPB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:15:01 -0400
Content-Disposition: inline
In-Reply-To: <20141003121335.2864.5519.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 03, 2014 at 02:13:36PM +0200, Arturo Borrero Gonzalez wrote:
> Let's mimic the behaviour of ipt_MASQUERADE and ip6t_MASQUERADE and
> register/unregister the masquerade notifiers on module _init and _exit.
> 
> The configuration previous to this patch may lead to spurious kernel crashes.

Applied, thanks Arturo.

I have slightly rewritten the patch title and description.

And another comment below:

> @@ -73,12 +52,19 @@ static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
>  
>  static int __init nft_masq_ipv4_module_init(void)
>  {
> -	return nft_register_expr(&nft_masq_ipv4_type);
> +	int ret;
> +
> +	ret = nft_register_expr(&nft_masq_ipv4_type);
> +	if (ret == 0)
> +		nf_nat_masquerade_ipv4_register_notifier();

The convention is to check for errors, ie.

        ret = foo();
        if (ret < 0)
                return ret;

        bar();

So the branch path returns the error or goes to error handling part to
undo things that we couldn't finish.
