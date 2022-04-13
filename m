Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233CFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 12:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiDMM5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 08:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiDMM5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 08:57:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565E1255B3
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2022 05:54:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1necW2-0001CB-6j; Wed, 13 Apr 2022 14:54:34 +0200
Date:   Wed, 13 Apr 2022 14:54:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v4 7/7] intervals: support to partial deletion with
 automerge
Message-ID: <YlbICmqkYDsWN7NY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220412144711.93354-1-pablo@netfilter.org>
 <20220412144711.93354-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412144711.93354-8-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Apr 12, 2022 at 04:47:11PM +0200, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/intervals.c b/src/intervals.c
> index 16debf9cd4be..65e0531765a6 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -255,6 +255,262 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
>  	return 0;
>  }
>  
> +static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
> +{
> +	struct expr *clone;
> +
> +	if (!(prev->flags & EXPR_F_REMOVE)) {

Does prev->flags ever contain EXPR_F_REMOVE? (See below.)

> +		if (prev->flags & EXPR_F_KERNEL) {
> +			clone = expr_clone(prev);
> +			list_move_tail(&clone->list, &purge->expressions);
> +		} else {
> +			list_del(&prev->list);
> +			expr_free(prev);
> +		}
> +	}
> +}
> +
> +static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
> +			       struct expr *init)
> +{
> +	prev->flags &= EXPR_F_KERNEL;

This looks odd. You're intentionally stripping all flags other than
EXPR_F_KERNEL (if set)?
IIUC, you're just dropping EXPR_F_REMOVE if set. If so, explicit
'prev->flags &= ~EXPR_F_REMOVE' is more clear, no?
Maybe it's also irrelevant after all WRT above question.

> +	expr_free(prev->key->left);
> +	prev->key->left = expr_get(i->key->right);
> +	mpz_add_ui(prev->key->left->value, prev->key->left->value, 1);
> +	list_move(&prev->list, &init->expressions);
> +}
[...]
> +static int setelem_delete(struct list_head *msgs, struct set *set,
> +			  struct expr *init, struct expr *purge,
> +			  struct expr *elems, unsigned int debug_mask)
> +{
> +	struct expr *i, *next, *prev = NULL;
> +	struct range range, prev_range;
> +	int err = 0;
> +	mpz_t rop;
> +
> +	mpz_init(prev_range.low);
> +	mpz_init(prev_range.high);
> +	mpz_init(range.low);
> +	mpz_init(range.high);
> +	mpz_init(rop);
> +
> +	list_for_each_entry_safe(i, next, &elems->expressions, list) {
> +		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
> +			continue;
> +
> +		range_expr_value_low(range.low, i);
> +		range_expr_value_high(range.high, i);
> +
> +		if (!prev && i->flags & EXPR_F_REMOVE) {
> +			expr_error(msgs, i, "element does not exist");
> +			err = -1;
> +			goto err;
> +		}
> +
> +		if (!(i->flags & EXPR_F_REMOVE)) {
> +			prev = i;
> +			mpz_set(prev_range.low, range.low);
> +			mpz_set(prev_range.high, range.high);
> +			continue;
> +		}

The loop assigns to 'prev' only if EXPR_F_REMOVE is not set.
> +
> +		if (mpz_cmp(prev_range.low, range.low) == 0 &&
> +		    mpz_cmp(prev_range.high, range.high) == 0) {
> +			if (!(prev->flags & EXPR_F_REMOVE) &&
> +			    i->flags & EXPR_F_REMOVE) {
> +				list_move_tail(&prev->list, &purge->expressions);
> +				list_del(&i->list);
> +				expr_free(i);
> +			}
> +		} else if (set->automerge &&
> +			   setelem_adjust(set, init, purge, &prev_range, &range, prev, i) < 0) {
> +			expr_error(msgs, i, "element does not exist");
> +			err = -1;
> +			goto err;
> +		}
> +		prev = NULL;

The code above may set EXPR_F_REMOVE in 'prev', but AFAICT 'prev' is not
revisited within and cleared before next iteration.

Cheers, Phil
