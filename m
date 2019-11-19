Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5E3C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A5422445
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfKSWMl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:12:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37172 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfKSWMl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:12:41 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXBji-00078k-7D; Tue, 19 Nov 2019 23:12:38 +0100
Date:   Tue, 19 Nov 2019 23:12:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft 2/3] src: Add support for concatenated set ranges
Message-ID: <20191119221238.GF8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <20191119010712.39316-1-sbrivio@redhat.com>
 <20191119010712.39316-3-sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119010712.39316-3-sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 19, 2019 at 02:07:11AM +0100, Stefano Brivio wrote:
[...]
> diff --git a/src/netlink.c b/src/netlink.c
> index 7306e358..b8bfd199 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
[...]
> @@ -199,10 +210,39 @@ static void netlink_gen_concat_data(const struct expr *expr,
>  		memset(data, 0, sizeof(data));
>  		offset = 0;
>  		list_for_each_entry(i, &expr->expressions, list) {
> -			assert(i->etype == EXPR_VALUE);
> -			mpz_export_data(data + offset, i->value, i->byteorder,
> -					div_round_up(i->len, BITS_PER_BYTE));
> -			offset += netlink_padded_len(i->len) / BITS_PER_BYTE;
> +			if (i->etype == EXPR_RANGE) {
> +				const struct expr *e;
> +
> +				if (is_range_end)
> +					e = i->right;
> +				else
> +					e = i->left;
> +
> +				offset += netlink_export_pad(data + offset,
> +							     e->value, e);
> +			} else if (i->etype == EXPR_PREFIX) {
> +				if (is_range_end) {
> +					mpz_t v;
> +
> +					mpz_init_bitmask(v, i->len -
> +							    i->prefix_len);
> +					mpz_add(v, i->prefix->value, v);
> +					offset += netlink_export_pad(data +
> +								     offset,
> +								     v, i);

Given the right-alignment, maybe introduce __netlink_gen_concat_data()
to contain the loop body?

> +					mpz_clear(v);
> +					continue;
> +				}
> +
> +				offset += netlink_export_pad(data + offset,
> +							     i->prefix->value,
> +							     i);
> +			} else {
> +				assert(i->etype == EXPR_VALUE);
> +
> +				offset += netlink_export_pad(data + offset,
> +							     i->value, i);
> +			}
>  		}
>  
>  		memcpy(nld->value, data, len);
> @@ -247,13 +287,14 @@ static void netlink_gen_verdict(const struct expr *expr,
>  	}
>  }
>  
> -void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
> +void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data,
> +		      int end)

s/end/is_range_end/ for consistency?

>  {
>  	switch (expr->etype) {
>  	case EXPR_VALUE:
>  		return netlink_gen_constant_data(expr, data);
>  	case EXPR_CONCAT:
> -		return netlink_gen_concat_data(expr, data);
> +		return netlink_gen_concat_data(expr, data, end);
>  	case EXPR_VERDICT:
>  		return netlink_gen_verdict(expr, data);
>  	default:
> @@ -712,8 +753,14 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
>  	const struct expr *expr;
>  
>  	list_for_each_entry(expr, &set->expressions, list) {
> -		nlse = alloc_nftnl_setelem(set, expr);
> +		nlse = alloc_nftnl_setelem(set, expr, 0);
>  		nftnl_set_elem_add(nls, nlse);
> +
> +		if (set->set_flags & NFT_SET_SUBKEY) {
> +			nlse = alloc_nftnl_setelem(set, expr, 1);
> +			nftnl_set_elem_add(nls, nlse);
> +		}
> +

Can't we drop 'const' from expr declaration and temporarily set
EXPR_F_INTERVAL_END to carry the is_interval_end bit or does that mess
up set element creation?

What I don't like about your code is how it adds an expression-type
specific parameter to netlink_gen_data which is supposed to be
type-agnostic. Avoiding this would also shrink this patch quite a bit.

[...]
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 3f283256..2b718971 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
[...]
> @@ -3941,7 +3940,24 @@ basic_rhs_expr		:	inclusive_or_rhs_expr
>  			;
>  
>  concat_rhs_expr		:	basic_rhs_expr
> -			|	concat_rhs_expr	DOT	basic_rhs_expr
> +			|	multiton_rhs_expr
> +			|	concat_rhs_expr		DOT	multiton_rhs_expr
> +			{
> +				if ($$->etype != EXPR_CONCAT) {
> +					$$ = concat_expr_alloc(&@$);
> +					compound_expr_add($$, $1);
> +				} else {
> +					struct location rhs[] = {
> +						[1]	= @2,
> +						[2]	= @3,
> +					};
> +					location_update(&$3->location, rhs, 2);
> +					$$ = $1;
> +					$$->location = @$;
> +				}
> +				compound_expr_add($$, $3);
> +			}
> +			|	concat_rhs_expr		DOT	basic_rhs_expr

So this is the fifth copy of the same piece of code. :(

Isn't there a better way to solve that? If not, we could at least
introduce a function compound_expr_alloc_or_add().

[...]
> diff --git a/src/rule.c b/src/rule.c
> index 4abc13c9..377781b1 100644
> --- a/src/rule.c
> +++ b/src/rule.c
[...]
> @@ -1618,15 +1620,15 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
>  
>  static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
>  {
> -	struct handle *h = &cmd->handle;
>  	struct expr *expr = cmd->expr;
> +	struct handle *h = &cmd->handle;

Unrelated change?

>  	struct table *table;
>  	struct set *set;
>  
>  	table = table_lookup(h, &ctx->nft->cache);
>  	set = set_lookup(table, h->set.name);
>  
> -	if (set->flags & NFT_SET_INTERVAL &&
> +	if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY) &&

Maybe introduce set_is_non_concat_range() or something? Maybe even a
macro, it's just about:

| return set->flags & (NFT_SET_INTERVAL | NFT_SET_SUBKEY) == NFT_SET_INTERVAL;

[...]
> diff --git a/src/segtree.c b/src/segtree.c
> index 9f1eecc0..e49576bc 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
[...]
> @@ -823,6 +828,9 @@ static int expr_value_cmp(const void *p1, const void *p2)
>  	struct expr *e2 = *(void * const *)p2;
>  	int ret;
>  
> +	if (expr_value(e1)->etype == EXPR_CONCAT)
> +		return -1;
> +

Funny how misleading expr_value()'s name is. ;)

[...]
> +/* Given start and end elements of a range, check if it can be represented as
> + * a single netmask, and if so, how long, by returning a zero or positive value.
> + */
> +static int range_mask_len(mpz_t start, mpz_t end, unsigned int len)
> +{
> +	unsigned int step = 0, i;
> +	mpz_t base, tmp;
> +	int masks = 0;
> +
> +	mpz_init_set_ui(base, mpz_get_ui(start));
> +
> +	while (mpz_cmp(base, end) <= 0) {
> +		step = 0;
> +		while (!mpz_tstbit(base, step)) {
> +			mpz_init_set_ui(tmp, mpz_get_ui(base));
> +			for (i = 0; i <= step; i++)
> +				mpz_setbit(tmp, i);
> +			if (mpz_cmp(tmp, end) > 0) {
> +				mpz_clear(tmp);
> +				break;
> +			}
> +			mpz_clear(tmp);
> +
> +			step++;
> +
> +			if (step >= len)
> +				goto out;
> +		}
> +
> +		if (masks++)
> +			goto out;
> +
> +		mpz_add_ui(base, base, 1 << step);
> +	}
> +
> +out:
> +	mpz_clear(base);
> +
> +	if (masks > 1)
> +		return -1;
> +	return len - step;
> +}

I don't understand this algorithm. Intuitively, I would just:

| int tmp = len;
| while (start != end && !(start & 1) && (end & 1) && tmp) {
|	start >>= 1;
|	end >>= 1;
|	tmp--;
| }
| return (tmp && start == end) ? len - tmp : -1;

Is that slow when dealing with gmp?

Thanks, Phil
