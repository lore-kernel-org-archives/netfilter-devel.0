Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59280C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 14:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiDMO3e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 10:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiDMO3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 10:29:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8824056221
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2022 07:27:12 -0700 (PDT)
Date:   Wed, 13 Apr 2022 16:27:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v4 7/7] intervals: support to partial deletion with
 automerge
Message-ID: <Ylbduy44WgQSI2o9@salvia>
References: <20220412144711.93354-1-pablo@netfilter.org>
 <20220412144711.93354-8-pablo@netfilter.org>
 <YlbICmqkYDsWN7NY@orbyte.nwl.cc>
 <YlbMeumfFKKM23ZV@salvia>
 <YlbYBfBmt3Ahptoc@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YlbYBfBmt3Ahptoc@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 13, 2022 at 04:02:45PM +0200, Phil Sutter wrote:
> On Wed, Apr 13, 2022 at 03:13:30PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Apr 13, 2022 at 02:54:34PM +0200, Phil Sutter wrote:
> [...]
> > > > +static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
> > > > +			       struct expr *init)
> > > > +{
> > > > +	prev->flags &= EXPR_F_KERNEL;
> > > 
> > > This looks odd. You're intentionally stripping all flags other than
> > > EXPR_F_KERNEL (if set)?
> > > IIUC, you're just dropping EXPR_F_REMOVE if set. If so, explicit
> > > 'prev->flags &= ~EXPR_F_REMOVE' is more clear, no?
> > > Maybe it's also irrelevant after all WRT above question.
> > 
> > Yes, this should be prev->flags &= ~EXPR_F_KERNEL, I'll fix it.
> 
> Ah, OK!
> 
> > This element is moved to the list of elements to be added. This flag
> > is irrelevant though at this stage, but in case you look at the list
> > of elements to be added, you should not see EXPR_F_KERNEL there.
> 
> I guess none of the flags are relevant at this point anymore since your
> code cleared them all and apparently passed testing? Or none of the
> relevant ones were set, which is my suspicion with EXPR_F_REMOVE.
> 
> [...]
> > > > +	list_for_each_entry_safe(i, next, &elems->expressions, list) {
> > > > +		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
> > > > +			continue;
> > > > +
> > > > +		range_expr_value_low(range.low, i);
> > > > +		range_expr_value_high(range.high, i);
> > > > +
> > > > +		if (!prev && i->flags & EXPR_F_REMOVE) {
> > > > +			expr_error(msgs, i, "element does not exist");
> > > > +			err = -1;
> > > > +			goto err;
> > > > +		}
> > > > +
> > > > +		if (!(i->flags & EXPR_F_REMOVE)) {
> > > > +			prev = i;
> > > > +			mpz_set(prev_range.low, range.low);
> > > > +			mpz_set(prev_range.high, range.high);
> > > > +			continue;
> > > > +		}
> > > 
> > > The loop assigns to 'prev' only if EXPR_F_REMOVE is not set.
> > 
> > Yes, this annotates is a element candidate to be removed.
> > 
> > The list of elements is merged-sorted, coming the element with
> > EXPR_F_REMOVE before the element that needs to be removed.
> 
> The one with EXPR_F_REMOVE comes *after* the one to be removed, right?

Right, the other way around actually.

> My question again: Is it possible for 'prev' to have EXPR_F_REMOVE set?
> Maybe I miss something, but to me it looks like not although the code
> expects it.

prev never has EXPR_F_REMOVE, so it points to an existing element.
