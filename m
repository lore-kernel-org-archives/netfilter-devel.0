From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] ruleset: fix a leak when we use the set lists
Date: Wed, 11 Feb 2015 00:48:15 +0100
Message-ID: <20150210234815.GA4547@salvia>
References: <1423586774-20383-1-git-send-email-alvaroneay@gmail.com>
 <1423586774-20383-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbbBJXpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2015 18:45:13 -0500
Content-Disposition: inline
In-Reply-To: <1423586774-20383-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 10, 2015 at 05:46:14PM +0100, Alvaro Neira Ayuso wrote:
> When we parse the sets in a ruleset, we set up a id. To do that, we use
> a set list. We alloc this set list and we need to free this set list. And we
> don't do that. If we import a ruleset, valgrind shows:

Please, remove this overelaborated description. The valgrind spot is
sufficiente.

More comments below:

> ==18632== 285 (16 direct, 269 indirect) bytes in 1 blocks are definitely lost in
> loss record 6 of 6
> ==18632==    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
> ==18632==    by 0x5043822: nft_set_list_alloc (set.c:977)
> ==18632==    by 0x5045483: nft_ruleset_json_parse (ruleset.c:442)
> ==18632==    by 0x50458BE: nft_ruleset_do_parse (ruleset.c:696)
> ==18632==    by 0x408AEC: do_command (rule.c:1317)
> ==18632==    by 0x406B05: nft_run (main.c:194)
> ==18632==    by 0x40667C: main (main.c:360)
> 
> With this changes, we alloc the set list when we create the nft_parse_ctx and
> free it later.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/ruleset.c |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/src/ruleset.c b/src/ruleset.c
> index 15e84cf..3ce6ccc 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -439,10 +439,6 @@ static int nft_ruleset_json_parse_ruleset(struct nft_parse_ctx *ctx,
>  	json_t *node, *array = ctx->json;
>  	int len, i, ret;
>  
> -	ctx->set_list = nft_set_list_alloc();
> -	if (ctx->set_list == NULL)
> -		return -1;
> -
>  	len = json_array_size(array);
>  	for (i = 0; i < len; i++) {
>  		node = json_array_get(array, i);
> @@ -525,6 +521,10 @@ static int nft_ruleset_json_parse(const void *json,
>  	ctx.cb = cb;
>  	ctx.format = type;
>  
> +	ctx.set_list = nft_set_list_alloc();
> +	if (ctx.set_list == NULL)
> +		return -1;
> +
>  	if (arg != NULL)
>  		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);

If you look in the ruleset.c file, now you add leaks in the error
path of nft_ruleset_json_parse() after this change.

Please, fix leaks all at once.
