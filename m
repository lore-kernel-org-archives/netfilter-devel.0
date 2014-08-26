From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH v2 1/5] netfilter: nf_tables: refactor rule
 deletion helper
Date: Tue, 26 Aug 2014 15:40:03 +0100
Message-ID: <20140826144003.GD23476@acer.localdomain>
References: <20140826140908.3008.13225.stgit@nfdev.cica.es>
 <20140826141152.3008.30259.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaHZOkH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:40:07 -0400
Content-Disposition: inline
In-Reply-To: <20140826141152.3008.30259.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 04:12:22PM +0200, Arturo Borrero Gonzalez wrote:
> This helper function always schedule the rule to be removed in the following
> transaction.
> In follow-up patches, it is interesting to handle separately the logic of rule
> activation/disactivation from the transaction mechanism.
> 
> So, this patch simply splits the original nf_tables_delrule_one() in two
> functions, allowing further control.
> 
> While at it, for the sake of homigeneize the function naming scheme, let's
> rename nf_tables_delrule_one() to nft_delrule().
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: no changes, resending the series.
> 
>  net/netfilter/nf_tables_api.c |   26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index deeb95f..d1535d8 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1868,12 +1868,10 @@ err1:
>  }
>  
>  static int
> -nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
> +nf_tables_delrule_disactivate(struct nft_ctx *ctx, struct nft_rule *rule)

Without any further review so far, this grammatical error has disturbed me for
a while now :) Please don't spread it further, its called deactivate.
