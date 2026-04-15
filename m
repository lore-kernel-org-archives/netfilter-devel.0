Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B6233CE9A
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776246214; cv=none; b=W6EKh4M+mhRYsbKyqmSZ+zQR6NxsNdOGifDLHZ6pyuxfFCM1E9u7BF6jh5rY2Qe78GdvLZUpgmNt8CE7o7HEbmdDrUpdZl8s6P4qasbDuzUst5NfE95il8fj6T2LMYZgjeajhK+8+jXQlvCioMLAfE/Lvo3vWkYb6/6vMzNOnUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776246214; c=relaxed/simple;
	bh=Ar9lfTUBJXLiwjN0Q2k4dS8SSr2b7rqYKrTeNV5Xlwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGttoNRuvlkjTmb/+rB079B+ua61T907haAN/Z57Gdx3ZhpHi2dDPti57ftshRGpD3sbIKMqoZZ+Ia1Zxch+oq7IOrCJ+tuwAWGMcgkoOoXy9IDbgD2/H9PGmwGmbMBssnJ+XqIfZ5xwUMb2Y9M71PiNa2yW4IRLVsjJw/3X03A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BFOUapi1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BFOUapi1"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3D6F860263;
	Wed, 15 Apr 2026 11:43:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776246210;
	bh=bWibnMuHQaoUcsdM0nQx+LOr2H9TAFWnPn+q7oeVcJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BFOUapi1F6BuZ4jFss6MPk++jr/N8Uk+V+fCZr3lLVLKxsfZv6XXg0Vser7EBEO6K
	 R0g9EUbqiEJcxkw8paE1QpvGmnhC61ukBm/o22ziub5Hpotjf7+Zp3FRpqwnmxxhg8
	 Qk9gUiKdphKvVH6Vt2TZjqo5amWXVOwsxSwPQK50sNaarc3oGOVxA1RlNw/VY+8iMc
	 7eooG3wiO1+Cv+30U+1lntiKOZ8qvT+q5flUFE17Dgsvzc8b2zFDOCQZXuO95tKyo0
	 iFTdSYjMQFq3XugWok7P2tHEObt7Axy8NiZ5MCrGbA3CyabsCu6KmW0E/60P7oX/eU
	 NxGs4PIlzJjIg==
Date: Wed, 15 Apr 2026 11:43:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: netfilter-devel@vger.kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, boqun@kernel.org, urezki@gmail.com,
	rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, fw@strlen.de
Subject: Re: [PATCH nf 1/3] rculist: add list_splice_rcu() for private lists
Message-ID: <ad9dv-rjSUAxCyDp@chamomile>
References: <20260413220415.43221-1-pablo@netfilter.org>
 <25a270bf-0011-4784-9a32-5a62b64a6200@paulmck-laptop>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25a270bf-0011-4784-9a32-5a62b64a6200@paulmck-laptop>

Hi Paul,

Thanks for your review.

On Tue, Apr 14, 2026 at 04:35:57PM -0700, Paul E. McKenney wrote:
> On Tue, Apr 14, 2026 at 12:04:15AM +0200, Pablo Neira Ayuso wrote:
> > This patch adds a helper function, list_splice_rcu(), to safely splice
> > a private (non-RCU-protected) list into an RCU-protected list.
> > 
> > The function ensures that only the pointer visible to RCU readers
> > (prev->next) is updated using rcu_assign_pointer(), while the rest of
> > the list manipulations are performed with regular assignments, as the
> > source list is private and not visible to concurrent RCU readers.
> > 
> > This is useful for moving elements from a private list into a global
> > RCU-protected list, ensuring safe publication for RCU readers.
> > Subsystems with some sort of batching mechanism from userspace can
> > benefit from this new function.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Looks plausible and useful.  Please see some comments inline below.

Thanks, see below.

> > ---
> > @I need this to fix a unsafe list_splice() of a private list to an
> > existing RCU-protected list. This is based on an existing idiom in
> > __list_splice_init_rcu().
> > 
> >  include/linux/rculist.h | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> > 
> > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > index 2abba7552605..3c18c3336459 100644
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -261,6 +261,41 @@ static inline void list_replace_rcu(struct list_head *old,
> >  	old->prev = LIST_POISON2;
> >  }
> >  
> > +/**
> > + * __list_splice_rcu - join a non-RCU list into an existing list.
> > + * @list:	the RCU-protected list to splice
> 
> This is actually not RCU-protected, correct?  Sure, its elements
> (aside from the list header) are RCU-protected upon exit from this
> function, but by then they are in the {@prev,@next} list, not in
> this @list.

Correct, I can fix this.

> > + * @prev:	points to the last element of the existing list
> > + * @next:	points to the first element of the existing list
> > + *
> > + * The list pointed to by @prev and @next can be RCU-read traversed
> > + * concurrently with this function.
> 
> Doesn't this last sentence also need to go into the list_splice_rcu()
> function's kernel-doc header?  But please see below.

OK.

> > + */
> > +static inline void __list_splice_rcu(struct list_head *list,
> > +				     struct list_head *prev,
> > +				     struct list_head *next)
> > +{
> > +	struct list_head *first = list->next;
> > +	struct list_head *last = list->prev;
> > +
> > +	last->next = next;
> > +	rcu_assign_pointer(list_next_rcu(prev), first);
> > +	first->prev = prev;
> > +	next->prev = last;
> 
> Although putting these last two after the rcu_assign_pointer() is safe,
> given that RCU readers do not traverse ->prev pointers, it would be
> better to place them before the rcu_assign_pointer() in order to avoid
> false sharing between this code path and any concurrent RCU readers.

I can do that.

> > +}
> > +
> > +/**
> > + * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
> > + *                   designed for stacks.
> > + * @list:	the non RCU-protected list to splice
> > + * @head:	the place in the existing list to splice the first list into
> 
> Please add something about @head being RCU-protected.

Will do.

> > + */
> > +static inline void list_splice_rcu(struct list_head *list,
> > +				   struct list_head *head)
> > +{
> > +	if (!list_empty(list))
> > +		__list_splice_rcu(list, head, head->next);
> > +}
> 
> I don't understand the purpose of having __list_splice_rcu() split out
> from list_splice_rcu().  If you are planning to add more callers of
> __list_splice_rcu(), you can always do the split when you add the first
> such caller.  In the meantime, why the extra code?

I only have a use-case for list_splice_rcu(), so OK, single function
is fine with.

> Yes, we do have __list_splice_init_rcu(), but that is because it is
> called from both list_splice_init_rcu() and list_splice_tail_init_rcu().

Understood.

I will be posting a v2 asap.

Thanks!

> > +
> >  /**
> >   * __list_splice_init_rcu - join an RCU-protected list into an existing list.
> >   * @list:	the RCU-protected list to splice
> > -- 
> > 2.47.3
> > 
