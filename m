From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] ruleset: refactor ruleset element parsing
 function calls to nft_ruleset_*_parse_ruleset()
Date: Thu, 15 Jan 2015 13:11:14 +0100
Message-ID: <20150115121114.GA6473@salvia>
References: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
 <1421070375-1057-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35688 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbbAOMIU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:08:20 -0500
Content-Disposition: inline
In-Reply-To: <1421070375-1057-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 02:46:15PM +0100, Alvaro Neira Ayuso wrote:
> Refactor the parsing ruleset element functions calls in xml/json to do that
> calls in the functions nft_ruleset_*_parse_ruleset. This patch is used in follow
> up patches.

Applied with minor change.

> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/ruleset.c |   59 ++++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 39 insertions(+), 20 deletions(-)
> 
> diff --git a/src/ruleset.c b/src/ruleset.c
> index a397824..6488d72 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -332,6 +332,24 @@ err:
>  
>  #endif

I had to move this endif to cover this new function too, so I don't
get compilation warnings with XML/JSON disabled.

> +static int nft_ruleset_json_parse_ruleset(struct nft_ruleset *rs, json_t *array,
> +					  struct nft_parse_err *err)
> +{
> +	if (nft_ruleset_json_parse_tables(rs, array, err) != 0)
> +		return -1;
> +
> +	if (nft_ruleset_json_parse_chains(rs, array, err) != 0)
> +		return -1;
> +
> +	if (nft_ruleset_json_parse_sets(rs, array, err) != 0)
> +		return -1;
> +
> +	if (nft_ruleset_json_parse_rules(rs, array, err) != 0)
> +		return -1;
> +
> +	return 0;
> +}
