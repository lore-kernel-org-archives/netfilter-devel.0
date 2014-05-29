From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 4/4] netfilter: nf_tables: atomic allocation in
 set notifications from rcu callback
Date: Thu, 29 May 2014 18:41:39 +0100
Message-ID: <20140529174138.GA22072@macbook.localnet>
References: <1401356907-6840-1-git-send-email-pablo@netfilter.org>
 <1401356907-6840-5-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56611 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbaE2Rlo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 13:41:44 -0400
Content-Disposition: inline
In-Reply-To: <1401356907-6840-5-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 29, 2014 at 11:48:27AM +0200, Pablo Neira Ayuso wrote:
> Use GFP_ATOMIC allocations when sending removal notifications of
> anonymous sets from rcu callback context. Sleeping in that context
> is illegal.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index dbf8236..043f9a3 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2191,7 +2191,7 @@ nla_put_failure:
>  
>  static int nf_tables_set_notify(const struct nft_ctx *ctx,
>  				const struct nft_set *set,
> -				int event)
> +				int event, int gfp_flags)

Minor improvement: the proper type is gfp_t.
