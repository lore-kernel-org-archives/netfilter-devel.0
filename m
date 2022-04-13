Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6BFC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiDMNQA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 09:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiDMNP7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 09:15:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87A2E5620E
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2022 06:13:34 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:13:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v4 7/7] intervals: support to partial deletion with
 automerge
Message-ID: <YlbMeumfFKKM23ZV@salvia>
References: <20220412144711.93354-1-pablo@netfilter.org>
 <20220412144711.93354-8-pablo@netfilter.org>
 <YlbICmqkYDsWN7NY@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YlbICmqkYDsWN7NY@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 13, 2022 at 02:54:34PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Apr 12, 2022 at 04:47:11PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > diff --git a/src/intervals.c b/src/intervals.c
> > index 16debf9cd4be..65e0531765a6 100644
> > --- a/src/intervals.c
> > +++ b/src/intervals.c
> > @@ -255,6 +255,262 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
> >  	return 0;
> >  }
> >  
> > +static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
> > +{
> > +	struct expr *clone;
> > +
> > +	if (!(prev->flags & EXPR_F_REMOVE)) {
> 
> Does prev->flags ever contain EXPR_F_REMOVE? (See below.)

EXPR_F_REMOVE flag is used to specify that this element represents a
deletion.

The existing list of elements in the kernel is mixed with the list of
elements to be deleted, this list is merge-sorted, then we look for
EXPR_F_REMOVE elements that are asking for removal of elements in the
kernel.

The flag allows me to track objects, whether they are in the kernel
(EXPR_F_KERNEL), they are new (no flag) or they represent an element
that need to be removed from the kernel (EXPR_F_REMOVE).

> > +		if (prev->flags & EXPR_F_KERNEL) {
> > +			clone = expr_clone(prev);
> > +			list_move_tail(&clone->list, &purge->expressions);
> > +		} else {
> > +			list_del(&prev->list);
> > +			expr_free(prev);
> > +		}
> > +	}
> > +}
> > +
> > +static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
> > +			       struct expr *init)
> > +{
> > +	prev->flags &= EXPR_F_KERNEL;
> 
> This looks odd. You're intentionally stripping all flags other than
> EXPR_F_KERNEL (if set)?
> IIUC, you're just dropping EXPR_F_REMOVE if set. If so, explicit
> 'prev->flags &= ~EXPR_F_REMOVE' is more clear, no?
> Maybe it's also irrelevant after all WRT above question.

Yes, this should be prev->flags &= ~EXPR_F_KERNEL, I'll fix it.

This element is moved to the list of elements to be added. This flag
is irrelevant though at this stage, but in case you look at the list
of elements to be added, you should not see EXPR_F_KERNEL there.

> > +	expr_free(prev->key->left);
> > +	prev->key->left = expr_get(i->key->right);
> > +	mpz_add_ui(prev->key->left->value, prev->key->left->value, 1);
> > +	list_move(&prev->list, &init->expressions);
> > +}
> [...]
> > +static int setelem_delete(struct list_head *msgs, struct set *set,
> > +			  struct expr *init, struct expr *purge,
> > +			  struct expr *elems, unsigned int debug_mask)
> > +{
> > +	struct expr *i, *next, *prev = NULL;
> > +	struct range range, prev_range;
> > +	int err = 0;
> > +	mpz_t rop;
> > +
> > +	mpz_init(prev_range.low);
> > +	mpz_init(prev_range.high);
> > +	mpz_init(range.low);
> > +	mpz_init(range.high);
> > +	mpz_init(rop);
> > +
> > +	list_for_each_entry_safe(i, next, &elems->expressions, list) {
> > +		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
> > +			continue;
> > +
> > +		range_expr_value_low(range.low, i);
> > +		range_expr_value_high(range.high, i);
> > +
> > +		if (!prev && i->flags & EXPR_F_REMOVE) {
> > +			expr_error(msgs, i, "element does not exist");
> > +			err = -1;
> > +			goto err;
> > +		}
> > +
> > +		if (!(i->flags & EXPR_F_REMOVE)) {
> > +			prev = i;
> > +			mpz_set(prev_range.low, range.low);
> > +			mpz_set(prev_range.high, range.high);
> > +			continue;
> > +		}
> 
> The loop assigns to 'prev' only if EXPR_F_REMOVE is not set.

Yes, this annotates is a element candidate to be removed.

The list of elements is merged-sorted, coming the element with
EXPR_F_REMOVE before the element that needs to be removed.

> > +		if (mpz_cmp(prev_range.low, range.low) == 0 &&
> > +		    mpz_cmp(prev_range.high, range.high) == 0) {
> > +			if (!(prev->flags & EXPR_F_REMOVE) &&
> > +			    i->flags & EXPR_F_REMOVE) {
> > +				list_move_tail(&prev->list, &purge->expressions);
> > +				list_del(&i->list);
> > +				expr_free(i);
> > +			}
> > +		} else if (set->automerge &&
> > +			   setelem_adjust(set, init, purge, &prev_range, &range, prev, i) < 0) {
> > +			expr_error(msgs, i, "element does not exist");
> > +			err = -1;
> > +			goto err;
> > +		}
> > +		prev = NULL;
> 
> The code above may set EXPR_F_REMOVE in 'prev', but AFAICT 'prev' is not
> revisited within and cleared before next iteration.

Yes, it is intentional. First this annotates the element to be delete,
next iteration should find a similar element with either
EXPR_F_KERNEL (if already in the kernel) or no flag if it was freshly
added in this batch.
