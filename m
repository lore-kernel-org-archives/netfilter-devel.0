From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix missing rules flushing per
 table
Date: Sat, 7 Dec 2013 23:36:37 +0100
Message-ID: <20131207223637.GB4050@localhost>
References: <1386331159-4104-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42127 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab3LGWgm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:36:42 -0500
Content-Disposition: inline
In-Reply-To: <1386331159-4104-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 06, 2013 at 12:59:19PM +0100, Pablo Neira Ayuso wrote:
> This patch allows you to atomically remove all rules stored in
> a table via the NFT_MSG_DELRULE command. You only need to indicate
> the specific table and no chain to flush all rules stored in that
> table.

I'm going to apply this with a minor change.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I already indicated this in october:
> 
> http://patchwork.ozlabs.org/patch/280192/
> 
> but this probably got lost. I'm going to submit to qualify this as fix
> otherwise we won't have sane table flushing in the first nftables release.
> 
>  net/netfilter/nf_tables_api.c |   46 +++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index dcddc49..237b49a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1717,6 +1717,19 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
>  	return -ENOENT;
>  }
>  
> +static int nf_table_delrule_by_chain(struct nft_ctx *ctx)
> +{
> +	struct nft_rule *rule, *tmp;
> +	int err;
> +
> +	list_for_each_entry_safe(rule, tmp, &ctx->chain->rules, list) {

We don't need _safe here, as the rule is deleted in the commit path,
here it is just tagged as scheduled to be removed.

> +		err = nf_tables_delrule_one(ctx, rule);
> +		if (err < 0)
> +			return err;
> +	}
> +	return 0;
> +}
